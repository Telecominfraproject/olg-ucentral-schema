#!/usr/bin/ucode
push(REQUIRE_SEARCH_PATH,
	"/usr/lib/ucode/*.so",
	"/usr/share/ucentral/*.uc");

"use strict";

let fs   = require("fs");

function read_json(path) {
	let f = fs.open(path, "r");
	if (!f) return {};
	let data = json(f.read("all"));
	f.close();
	return data || {};
}

function run_cmd(cmd) {
	let f = fs.popen(cmd);
	if (!f) return null;
	let out = trim(f.read("all"));
	f.close();
	return length(out) ? out : null;
}

let board = read_json("/etc/board.json");
if (!board?.model?.id) {
	warn("capabilities: /etc/board.json missing or invalid\n");
	exit(1);
}

let capa = {
	"secure-rtty":    true,
	"default-config": true,
	"compress_cmd":   true
};

// Step 2: restrictions
let restrictions_f = fs.open("/etc/ucentral/restrictions.json", "r");
if (restrictions_f) {
	capa.restrictions = json(restrictions_f.read("all")) || {};
	restrictions_f.close();
	let dev = run_cmd("fw_printenv developer 2>/dev/null");
	capa.developer = (dev == "developer=1");
}

// Step 3: version / schema
let version = read_json("/etc/ucentral/version.json");
let schema  = read_json("/etc/ucentral/schema.json");
let vvendor = read_json("/etc/ucentral/version.vendor.json");
let svendor = read_json("/etc/ucentral/schema.vendor.json");

if (length(vvendor)) version.vendor = vvendor;
if (length(svendor)) schema.vendor  = svendor;

capa.version = { olg: version, schema };

// Step 5: country codes
let wifi_board = board?.wifi;
if (wifi_board?.country) {
	let codes = filter(split(wifi_board.country, " "), c => length(c));
	capa.country_codes = codes;

	// Step 6: resolve effective country
	let effective;
	if (fs.stat("/tmp/squashfs")) {
		effective = run_cmd("fw_printenv -n country 2>/dev/null");
		if (!effective && length(codes)) {
			run_cmd(sprintf("fw_setenv country %s", codes[0]));
			effective = codes[0];
		}
	} else {
		let persist = "/certificates/ucentral.defaults";
		let pf = fs.open(persist, "r");
		if (pf) {
			let pd = json(pf.read("all"));
			pf.close();
			effective = pd?.country;
		}
		if (!effective && length(codes)) {
			effective = codes[0];
			let pw = fs.open(persist, "w");
			if (pw) { pw.write(sprintf('{"country":"%s"}', effective)); pw.close(); }
		}
	}
	effective = effective || codes[0];
	let df = fs.open("/etc/ucentral/ucentral.defaults", "w");
	if (df) { df.write(sprintf('{"country":"%s"}', effective)); df.close(); }
	capa.country = effective;
}

// Step 8: compatible / model
capa.compatible = replace(board.model.id, ",", "_");
capa.model      = board.model.name;

// Step 9: platform
if (board.bridge && board.bridge.name == "switch")
	capa.platform = "switch";
else if (length(wifi))
	capa.platform = "ap";
else
	capa.platform = "olg";

// Step 10: switch topology
let switch_ports = {};
if (board.switch) {
	capa.switch = [];
	for (let sw_name, sw in board.switch) {
		push(capa.switch, { name: sw_name, enable: sw.enable, reset: sw.reset });

		let cpu_port = null;
		for (let p in sw.ports)
			if (p.device) { cpu_port = p; break; }
		if (!cpu_port) continue;

		let sp = { name: sw_name, port: cpu_port.num, lan: [], wan: [] };
		for (let p in sw.ports) {
			if (p.device) continue;
			if (p.role == "lan")       push(sp.lan, p.num);
			else if (p.role == "wan")  push(sp.wan, p.num);
		}
		switch_ports[cpu_port.device] = sp;
	}
	capa.switch_ports = switch_ports;
}

function swconfig_ports(netdev, role) {
	let sp = switch_ports[netdev];
	if (!sp) return [netdev];
	let nums = (role == "wan") ? sp.wan : sp.lan;
	return map(nums, n => netdev + ":" + n);
}

// Step 11: network map
if (board.network) {
	capa.network = {};
	let macs = {};

	for (let k, v in board.network) {
		if (v.ports)
			capa.network[k] = v.ports;
		else if (v.device)
			capa.network[k] = swconfig_ports(v.device, k);
		else if (v.ifname)
			capa.network[k] = filter(split(trim(v.ifname), " "), x => length(x));

		if (v.macaddr)
			macs[k] = v.macaddr;
	}

	if (length(macs))
		capa.macaddr = macs;

	// Step 11b: named port alias map consumed by select-ports resolution
	let ports = {};
	for (let idx, dev in (capa.network.lan || []))
		ports["LAN" + (idx + 1)] = { netdev: dev, role: "downstream" };
	for (let idx, dev in (capa.network.wan || []))
		ports["WAN" + (idx + 1)] = { netdev: dev, role: "upstream" };
	if (length(ports))
		capa.ports = ports;
}

// Step 12: label MAC
if (board?.system?.label_macaddr)
	capa.label_macaddr = board.system.label_macaddr;

// Step 15: write output
let out = fs.open("/etc/ucentral/capabilities.json", "w");
if (!out) {
	warn("capabilities: cannot write /etc/ucentral/capabilities.json\n");
	exit(1);
}
out.write(capa);
out.close();
