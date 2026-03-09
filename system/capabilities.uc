#!/usr/bin/ucode
push(REQUIRE_SEARCH_PATH,
	"/usr/lib/ucode/*.so",
	"/usr/share/ucentral/*.uc");

let fs = require("fs");
let vyos_api = require("vyos.https_server_api");

// Read version files (same as AP pattern)
let version = json(fs.readfile('/etc/ucentral/version.json') || '{}');
let schema = json(fs.readfile('/etc/ucentral/schema.json') || '{}');

// Read existing capabilities for fallback (WAN/LAN interface roles)
let old_caps = json(fs.readfile('/etc/ucentral/capabilities.json') || '{}');

// Initialize capabilities with static/fallback values
let capabilities = {
	"secure-rtty": true,
	"compatible": "vyos-olg",
	"model": "VyOS OLG Gateway",
	"platform": "olg",
	"firmware": "VyOS 2025.12.13-0020-rolling",
	"hostname": "vyos",
	"version": {
		"olg": version,
		"schema": schema
	},
	"network": {
		"wan": old_caps?.network?.wan || ["eth0"],
		"lan": old_caps?.network?.lan || ["eth1"]
	},
	"macaddr": {
		"wan": "",
		"lan": ""
	},
	"label_macaddr": "",
	"interfaces": {
		"ethernet": []
	},
	"hardware_offload": {
		"gro": false,
		"gso": false,
		"sg": false,
		"tso": false
	},
	"services": {
		"https_api": false,
		"ssh": false,
		"ntp": false,
		"dns_forwarding": false,
		"dhcp_server": false
	}
};

// Helper function: Call VyOS REST API
function vyos_api_call(params, vyos_host, vyos_key) {
	let operation = params.op || "show";
	let path = params.path || [];

	let result = vyos_api.vyos_api_call(
		{ path: path },
		operation,
		vyos_host,
		vyos_key
	);

	if (!result) {
		return null;
	}

	let parsed;
	try {
		parsed = json(result);
	} catch(e) {
		return null;
	}

	if (!parsed || parsed.error) {
		return null;
	}

	return parsed;
}

// Try to query VyOS for dynamic data
try {
	// Read VyOS connection info
	let vyos_info = json(fs.readfile('/etc/ucentral/vyos-info.json') || '{}');

	if (vyos_info.host && vyos_info.key) {
		// Query VyOS for full configuration in JSON format (for hostname and services)
		let config_response = vyos_api_call(
			{ path: ["configuration", "json"] },
			vyos_info.host,
			vyos_info.key
		);

		if (config_response && config_response.data) {
			// data is a JSON string, parse it again
			let data = json(config_response.data);

			// Extract hostname
			if (data.system && data.system["host-name"]) {
				capabilities.hostname = data.system["host-name"];
			}

			// Extract ethernet interfaces list
			if (data.interfaces && data.interfaces.ethernet) {
				capabilities.interfaces.ethernet = keys(data.interfaces.ethernet);
			}

			// Extract service capabilities
			if (data.service) {
				capabilities.services.https_api = (data.service.https && data.service.https.api) ? true : false;
				capabilities.services.ssh = (data.service.ssh) ? true : false;
				capabilities.services.ntp = (data.service.ntp) ? true : false;
				capabilities.services.dns_forwarding = (data.service.dns && data.service.dns.forwarding) ? true : false;
				capabilities.services.dhcp_server = (data.service["dhcp-server"]) ? true : false;
			}
		}

		// Query VyOS for MAC addresses and hardware offload capabilities
		// Use "show interfaces kernel json" - provides both in a single API call
		let kernel_response = vyos_api_call(
			{ path: ["interfaces", "kernel", "json"] },
			vyos_info.host,
			vyos_info.key
		);

		if (kernel_response && kernel_response.data) {
			// Parse the JSON data (it's a JSON string inside data field)
			let kernel_data;
			try {
				kernel_data = json(kernel_response.data);
			} catch(e) {
				kernel_data = null;
			}

			if (kernel_data && type(kernel_data) == "array" && length(kernel_data) > 0) {
				let wan_if = capabilities.network.wan[0] || "eth0";
				let lan_if = capabilities.network.lan[0] || "eth1";

				for (let iface in kernel_data) {
					// Only process physical ethernet interfaces
					// Skip VLANs (info_kind: "vlan"), bridges (info_kind: "bridge"), etc.
					if (iface.link_type != "ether")
						continue;
					if (iface.linkinfo && iface.linkinfo.info_kind)
						continue;

					let if_name = iface.ifname;

					// Extract MAC addresses
					if (iface.address) {
						if (if_name == wan_if) {
							capabilities.macaddr.wan = iface.address;
							capabilities.label_macaddr = iface.address;
						} else if (if_name == lan_if) {
							capabilities.macaddr.lan = iface.address;
						}
					}

					// Extract hardware offload capabilities (check WAN interface)
					if (if_name == wan_if) {
						// Non-zero max_size values indicate feature is supported
						if (iface.gro_max_size && iface.gro_max_size > 0) {
							capabilities.hardware_offload.gro = true;
						}
						if (iface.gso_max_size && iface.gso_max_size > 0) {
							capabilities.hardware_offload.gso = true;
						}
						if (iface.tso_max_size && iface.tso_max_size > 0) {
							capabilities.hardware_offload.tso = true;
							// TSO requires scatter-gather support
							capabilities.hardware_offload.sg = true;
						}
					}
				}
			}
		}
	}
} catch (e) {
	// If VyOS API fails, use fallback values (already initialized)
	warn("Failed to query VyOS API, using fallback values: " + e + "\n");
}

// Write capabilities to file
fs.writefile('/etc/ucentral/capabilities.json', capabilities);
