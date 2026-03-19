#!/usr/bin/ucode
push(REQUIRE_SEARCH_PATH,
	"/usr/lib/ucode/*.so",
	"/usr/share/ucentral/*.uc");

let schemareader = require("schemareader");
let renderer = require("renderer");
let fs = require("fs");
let ubus = require("ubus").connect();
let vyos = require("vyos.config_prepare");
let vyos_api = require("vyos.https_server_api");
let inputfile = fs.open(ARGV[0], "r");
let inputjson = json(inputfile.read("all"));
inputfile.close();

let custom_config = (split(ARGV[0], ".")[0] != "/etc/ucentral/ucentral");
let error = 0;
let logs = [];

// Helper function to calculate network base address from IP/prefix
function network_base(ip_prefix) {
	let parts = split(ip_prefix, "/");
	if (length(parts) != 2) return null;

	let ip_parts = split(parts[0], ".");
	if (length(ip_parts) != 4) return null;

	let prefix = int(parts[1]);
	if (prefix < 0 || prefix > 32) return null;

	// Convert IP to integer
	let ip_int = 0;
	for (let i = 0; i < 4; i++) {
		let octet = int(ip_parts[i]);
		if (octet < 0 || octet > 255) return null;
		ip_int = (ip_int << 8) | octet;
	}

	// Apply network mask
	let mask = (prefix == 0) ? 0 : ((0xFFFFFFFF << (32 - prefix)) & 0xFFFFFFFF);
	let net_int = ip_int & mask;

	// Convert back to dotted notation
	let result = sprintf("%d.%d.%d.%d/%d",
		(net_int >> 24) & 0xFF,
		(net_int >> 16) & 0xFF,
		(net_int >> 8) & 0xFF,
		net_int & 0xFF,
		prefix);

	return result;
}

function read_json_file(path) {
	if (!fs.stat(path))
		return null;
	let f = fs.open(path, "r");
	let obj = json(f.read("all"));
	f.close();
	return obj;
}

function set_service_state(state) {
	let services = ubus.call('service', 'list');
	for (let service, enable in renderer.services_state()) {
		if (enable != state)
			continue;

		if (enable == 'no-restart')
			if (services[service] && services[service]?.instances[service]?.running) {
				printf("%s is already running\n", service);
				continue;
			}

		printf("%s %s\n", service, enable ? "starting" : "stopping");
		system(sprintf("/etc/init.d/%s %s", service, (enable || enable == 'early') ? "restart" : "stop"));
	}
	system("/etc/init.d/dnsmasq restart");
}

try {
	let caps = read_json_file("/etc/ucentral/capabilities.json") || {};
	let platform = caps.platform ?? "";

	if (platform == "olg") {
		let args_path = "/etc/ucentral/vyos-info.json";
		let args = read_json_file(args_path) || {};

		let host = (ARGV.length > 2 && ARGV[2] != "-") ? ARGV[2] : (args.host ?? null);
		let key  = (ARGV.length > 3 && ARGV[3] != "-") ? ARGV[3] : (args.key  ?? null);

		if (!host || !key) {
			print("Missing op/host/key. Provide them in /etc/ucentral/vyos-info.json or pass '-' placeholders and ensure file exists.\n");
			exit(1);
		}

		let state = schemareader.validate(inputjson, logs);

		if (!state) {
			error = 2;
		} else {
			let op_arg = {};
			let vyos_config_payload = vyos.vyos_render(state);
			op_arg.string = vyos_config_payload;

			let op = "load";
			let rc = vyos_api.vyos_api_call(op_arg, op, host, key);

			if (rc != '') rc = json(rc);

			if (rc != '' && rc.success == false)
				error = 1;

			// WORKAROUND: VyOS /config-file load doesn't persist NAT rules to config.boot
			// We need to explicitly set NAT rules via /configure endpoint and save
			if (!error) {
				// Extract NAT rules from state (replicate nat.uc logic)
				let snat_rules = [];

				if (type(state.nat) == "object" &&
				    type(state.nat.snat) == "object" &&
				    type(state.nat.snat.rules) == "array") {
					snat_rules = state.nat.snat.rules;
				}
				// Auto-generate NAT masquerade rules for downstream interfaces if no explicit config
				else if (type(state.interfaces) == "array") {
					// First, check if we have an upstream interface (WAN)
					let has_upstream = false;
					let upstream_bridge = "br0";  // Default upstream bridge name

					for (let iface in state.interfaces) {
						if (iface.role == "upstream") {
							has_upstream = true;
							break;
						}
					}

					// Only auto-generate if we have an upstream interface
					if (has_upstream) {
						let rule_id = 100;

						for (let iface in state.interfaces) {
							// Auto-generate NAT for downstream interfaces with IPv4 addressing
							if (iface.role == "downstream" &&
							    type(iface.ipv4) == "object" &&
							    type(iface.ipv4.subnet) == "string") {

								// Convert interface IP to network base (e.g., "10.0.0.1/24" -> "10.0.0.0/24")
								let subnet = network_base(iface.ipv4.subnet);

								if (subnet) {
									// Create masquerade rule for this downstream network (match nat.uc structure)
									push(snat_rules, {
										rule_id: rule_id++,
										out_interface: { name: upstream_bridge },
										source: { address: subnet },
										translation: { address: "masquerade" }
									});
								}
							}
						}
					}
				}

				// Apply NAT rules via /configure endpoint if we have any
				if (length(snat_rules) > 0) {
					// First, delete all existing NAT source rules
					let del_arg = { path: ["nat", "source"] };
					let del_rc = vyos_api.vyos_api_call(del_arg, "delete", host, key);

					// Set each NAT rule individually
					// IMPORTANT: VyOS validates rules as we build them, so order matters!
					// Must set translation FIRST, then outbound-interface, then source
					for (let rule in snat_rules) {
						let rule_id = rule.rule_id;
						let out_if = rule.out_interface?.name;
						let src_addr = rule.source?.address;
						let trans = rule.translation?.address;

						printf("Setting NAT rule %d: out_if=%s, src=%s, trans=%s\n",
						       rule_id, out_if, src_addr, trans);

						// Step 1: Set translation address FIRST (VyOS requires this)
						let set_arg = {
							path: ["nat", "source", "rule", "" + rule_id, "translation", "address"],
							value: trans
						};
						let resp = vyos_api.vyos_api_call(set_arg, "set", host, key);
						let result = resp ? json(resp) : null;
						if (result?.success != true) {
							printf("ERROR: Failed to set translation address: %s\n", result?.error || resp);
						}

						// Step 2: Set outbound interface name
						set_arg = {
							path: ["nat", "source", "rule", "" + rule_id, "outbound-interface", "name"],
							value: out_if
						};
						resp = vyos_api.vyos_api_call(set_arg, "set", host, key);
						result = resp ? json(resp) : null;
						if (result?.success != true) {
							printf("ERROR: Failed to set outbound-interface: %s\n", result?.error || resp);
						}

						// Step 3: Set source address
						set_arg = {
							path: ["nat", "source", "rule", "" + rule_id, "source", "address"],
							value: src_addr
						};
						resp = vyos_api.vyos_api_call(set_arg, "set", host, key);
						result = resp ? json(resp) : null;
						if (result?.success != true) {
							printf("ERROR: Failed to set source address: %s\n", result?.error || resp);
						}
					}

					// NOTE: VyOS /configure endpoint auto-applies changes (no explicit commit needed)
					// But we must save to config.boot for persistence across VyOS reboots
					printf("✓ NAT rules applied via /configure endpoint\n");

					// Save to config.boot using /config-file save
					let save_rc = vyos_api.vyos_api_call({}, "save", host, key);
					let save_result = save_rc ? json(save_rc) : null;
					if (save_result?.success == true) {
						printf("✓ NAT config saved to config.boot\n");
					} else {
						printf("WARNING: Failed to save NAT config: %s\n", save_result?.error || save_rc || "No response");
					}
				}
			}

			// Update UCI state config with intervals from uCentral config
			let uci = require("uci").cursor();
			let stats_interval = state.metrics?.statistics?.interval || 60;
			let health_interval = state.metrics?.health?.interval || 60;

			// Enforce 60-second minimum per schema
			if (stats_interval < 60) stats_interval = 60;
			if (health_interval < 60) health_interval = 60;

			uci.set("state", "stats", "stats");
			uci.set("state", "stats", "interval", "" + stats_interval);
			uci.set("state", "health", "health");
			uci.set("state", "health", "interval", "" + health_interval);
			uci.commit("state");

			// Restart state daemon so it reads the new intervals from UCI
			// Use killall since /etc/init.d restart doesn't work in this context
			// procd will automatically restart it
			system('killall ucentral-state');

			// Update symlink for successful applications (error 0 or 1)
			if (!custom_config) {
				// Prevent symlink loop: don't create symlink if source is the symlink itself
				if (ARGV[0] != '/etc/ucentral/ucentral.active') {
					fs.unlink('/etc/ucentral/ucentral.active');
					fs.symlink(ARGV[0], '/etc/ucentral/ucentral.active');
				}

				// Clean up old config files, keeping only the 5 most recent
				let cfgs = [];
				for (let k, v in fs.lsdir('/etc/ucentral/'))
					if (wildcard(v, 'ucentral.cfg.1*', true))
						push(cfgs, v);

				cfgs = sort(cfgs);
				while (length(cfgs) >= 5) {
					fs.unlink('/etc/ucentral/' + cfgs[0]);
					shift(cfgs);
				}
			}
		}

	} else {
		for (let cmd in [
			'rm -rf /tmp/ucentral',
			'mkdir /tmp/ucentral',
			'rm /tmp/dnsmasq.conf',
			'/etc/init.d/spotfilter stop',
			'touch /tmp/dnsmasq.conf'
		])
			system(cmd);

		let state = schemareader.validate(inputjson, logs);
		let batch = state ? renderer.render(state, logs) : "";

		if (state?.strict && length(logs)) {
			push(logs, 'Rejecting config due to strict-mode validation');
			state = null;
		}

		fs.stdout.write("Log messages:\n" + join("\n", logs) + "\n\n");

		if (state) {
			fs.stdout.write("UCI batch output:\n" + batch + "\n");

			let outputjson = fs.open("/tmp/ucentral.uci", "w");
			outputjson.write(batch);
			outputjson.close();

			for (let cmd in [
				'rm -rf /tmp/config-shadow',
				'cp -r /etc/config-shadow /tmp',
				'/usr/share/ucentral/wifi_detect.sh'
			])
				system(cmd);

			let apply = fs.popen("/sbin/uci -c /tmp/config-shadow batch", "w");
			apply.write(batch);
			apply.close();

			renderer.write_files(logs);

			set_service_state(false);

			for (let cmd in [
				'uci -c /tmp/config-shadow commit',
				'cp /tmp/config-shadow/* /etc/config/',
				'rm -rf /tmp/config-shadow',
				'sync'
			])
				system(cmd);

			set_service_state('early');

			ubus.call('state', 'reload');

			for (let cmd in [
				'reload_config',
				'/etc/init.d/ratelimit reload',
				'/etc/init.d/dnsmasq restart',
				'/etc/init.d/ucentral-state restart'
			])
				system(cmd);

			if (!custom_config) {
				// Prevent symlink loop: don't create symlink if source is the symlink itself
				if (ARGV[0] != '/etc/ucentral/ucentral.active') {
					fs.unlink('/etc/ucentral/ucentral.active');
					fs.symlink(ARGV[0], '/etc/ucentral/ucentral.active');
				}

				// Clean up old config files, keeping only the 5 most recent
				let cfgs = [];
				for (let k, v in fs.lsdir('/etc/ucentral/'))
					if (wildcard(v, 'ucentral.cfg.1*', true))
						push(cfgs, v);

				cfgs = sort(cfgs);
				while (length(cfgs) >= 5) {
					fs.unlink('/etc/ucentral/' + cfgs[0]);
					shift(cfgs);
				}
			}

			set_service_state(true);
			set_service_state('no-restart');
			ubus.call('mpsk', 'flush');
		} else {
			error = 1;
		}

		if (!length(batch) || !state)
			error = 2;
		else if (length(logs))
			error = 1;
	}
}
catch (e) {
	error = 2;
	warn("Fatal error while generating config: ", e, "\n", e.stacktrace[0].context, "\n");
}

if (inputjson.uuid && inputjson.uuid > 1 && !custom_config) {
	let text = [ 'Success', 'Rejects', 'Failed' ];
	let status = {
		error,
		text: text[error] || "Failed",
	};

	if (length(logs))
		status.rejected = logs;

	ubus.call("ucentral", "result", {
		uuid: inputjson.uuid || 0,
		id: +ARGV[1] || 0,
		status,
	});

	if (error > 1)
		exit(1);
}
