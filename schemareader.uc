// Automatically generated from ./ucentral.schema.pretty.json - do not edit!
"use strict";

function matchUcCidr4(value) {
	let m = match(value, /^(auto|[0-9.]+)\/([0-9]+)$/);
	return m ? ((m[1] == "auto" || length(iptoarr(m[1])) == 4) && +m[2] <= 32) : false;
}

function matchUcCidr6(value) {
	let m = match(value, /^(auto|[0-9a-fA-F:.]+)\/([0-9]+)$/);
	return m ? ((m[1] == "auto" || length(iptoarr(m[1])) == 16) && +m[2] <= 128) : false;
}

function matchUcCidr(value) {
	let m = match(value, /^(auto|[0-9a-fA-F:.]+)\/([0-9]+)$/);
	if (!m) return false;
	let l = (m[1] == "auto") ? 16 : length(iptoarr(m[1]));
	return (l > 0 && +m[2] <= (l * 8));
}

function matchUcMac(value) {
	return match(value, /^[0-9a-f][0-9a-f]:[0-9a-f][0-9a-f]:[0-9a-f][0-9a-f]:[0-9a-f][0-9a-f]:[0-9a-f][0-9a-f]:[0-9a-f][0-9a-f]$/i);
}

function matchUcMobility(value) {
	return match(value, /^[0-9a-f][0-9a-f][0-9a-f][0-9a-f]$/i);
}

function matchUcHost(value) {
	if (length(iptoarr(value)) != 0) return true;
	if (length(value) > 255) return false;
	let labels = split(value, ".");
	return (length(filter(labels, label => !match(label, /^([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9-]{0,61}[a-zA-Z0-9])$/))) == 0 && length(labels) > 0);
}

function matchUcTimeout(value) {
	return match(value, /^[0-9]+[smhdw]$/);
}

function matchUcBase64(value) {
	return b64dec(value) != null;
}

function matchUcPortrange(value) {
	let ports = match(value, /^([0-9]|[1-9][0-9]*)(-([0-9]|[1-9][0-9]*))?$/);
	if (!ports) return false;
	let min = +ports[1], max = ports[2] ? +ports[3] : min;
	return (min <= 65535 && max <= 65535 && max >= min);
}

function matchHostname(value) {
	if (length(value) > 255) return false;
	let labels = split(value, ".");
	return (length(filter(labels, label => !match(label, /^([a-zA-Z0-9]{1,2}|[a-zA-Z0-9][a-zA-Z0-9-]{0,61}[a-zA-Z0-9])$/))) == 0 && length(labels) > 0);
}

function matchUcFqdn(value) {
	if (length(value) > 255) return false;
	let labels = split(value, ".");
	return (length(filter(labels, label => !match(label, /^([a-zA-Z0-9]{1,2}|[a-zA-Z0-9][a-zA-Z0-9-]{0,61}[a-zA-Z0-9])$/))) == 0 && length(labels) > 1);
}

function matchUcIp(value) {
	return (length(iptoarr(value)) == 4 || length(iptoarr(value)) == 16);
}

function matchIpv4(value) {
	return (length(iptoarr(value)) == 4);
}

function matchIpv6(value) {
	return (length(iptoarr(value)) == 16);
}

function matchUri(value) {
	if (index(value, "data:") == 0) return true;
	let m = match(value, /^[a-z+-]+:\/\/([^\/]+).*$/);
	if (!m) return false;
	if (length(iptoarr(m[1])) != 0) return true;
	if (length(m[1]) > 255) return false;
	let labels = split(m[1], ".");
	return (length(filter(labels, label => !match(label, /^([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9-]{0,61}[a-zA-Z0-9])$/))) == 0 && length(labels) > 0);
}

function instantiateUnit(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseName(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "name")) {
			obj.name = parseName(location + "/name", value["name"], errors);
		}

		function parseHostname(location, value, errors) {
			if (type(value) == "string") {
				if (!matchHostname(value))
					push(errors, [ location, "must be a valid hostname" ]);

			}

			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "hostname")) {
			obj.hostname = parseHostname(location + "/hostname", value["hostname"], errors);
		}

		function parseLocation(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "location")) {
			obj.location = parseLocation(location + "/location", value["location"], errors);
		}

		function parseTimezone(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "timezone")) {
			obj.timezone = parseTimezone(location + "/timezone", value["timezone"], errors);
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateGlobals(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseRouterId(location, value, errors) {
			if (type(value) == "string") {
				if (!matchIpv4(value))
					push(errors, [ location, "must be a valid IPv4 address" ]);

			}

			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "router-id")) {
			obj.router_id = parseRouterId(location + "/router-id", value["router-id"], errors);
		}

		function parseDomainName(location, value, errors) {
			if (type(value) == "string") {
				if (!matchHostname(value))
					push(errors, [ location, "must be a valid hostname" ]);

			}

			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "domain-name")) {
			obj.domain_name = parseDomainName(location + "/domain-name", value["domain-name"], errors);
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateInterfaceEthernet(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseSpeed(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			if (!(value in [ "auto", "10", "100", "1000", "2500", "10000" ]))
				push(errors, [ location, "must be one of \"auto\", \"10\", \"100\", \"1000\", \"2500\" or \"10000\"" ]);

			return value;
		}

		if (exists(value, "speed")) {
			obj.speed = parseSpeed(location + "/speed", value["speed"], errors);
		}
		else {
			obj.speed = "auto";
		}

		function parseDuplex(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			if (!(value in [ "auto", "full", "half" ]))
				push(errors, [ location, "must be one of \"auto\", \"full\" or \"half\"" ]);

			return value;
		}

		if (exists(value, "duplex")) {
			obj.duplex = parseDuplex(location + "/duplex", value["duplex"], errors);
		}
		else {
			obj.duplex = "auto";
		}

		function parseVlanTag(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			if (!(value in [ "tagged", "un-tagged", "auto" ]))
				push(errors, [ location, "must be one of \"tagged\", \"un-tagged\" or \"auto\"" ]);

			return value;
		}

		if (exists(value, "vlan-tag")) {
			obj.vlan_tag = parseVlanTag(location + "/vlan-tag", value["vlan-tag"], errors);
		}
		else {
			obj.vlan_tag = "auto";
		}

		function parseProxyArp(location, value, errors) {
			if (type(value) == "object") {
				let obj = {};

				function parseEnable(location, value, errors) {
					if (type(value) != "bool")
						push(errors, [ location, "must be of type boolean" ]);

					return value;
				}

				if (exists(value, "enable")) {
					obj.enable = parseEnable(location + "/enable", value["enable"], errors);
				}
				else {
					obj.enable = false;
				}

				return obj;
			}

			if (type(value) != "object")
				push(errors, [ location, "must be of type object" ]);

			return value;
		}

		if (exists(value, "proxy-arp")) {
			obj.proxy_arp = parseProxyArp(location + "/proxy-arp", value["proxy-arp"], errors);
		}

		function parseArpFilter(location, value, errors) {
			if (type(value) == "object") {
				let obj = {};

				function parseEnable(location, value, errors) {
					if (type(value) != "bool")
						push(errors, [ location, "must be of type boolean" ]);

					return value;
				}

				if (exists(value, "enable")) {
					obj.enable = parseEnable(location + "/enable", value["enable"], errors);
				}
				else {
					obj.enable = true;
				}

				return obj;
			}

			if (type(value) != "object")
				push(errors, [ location, "must be of type object" ]);

			return value;
		}

		if (exists(value, "arp-filter")) {
			obj.arp_filter = parseArpFilter(location + "/arp-filter", value["arp-filter"], errors);
		}

		function parseForwarding(location, value, errors) {
			if (type(value) == "object") {
				let obj = {};

				function parseEnable(location, value, errors) {
					if (type(value) != "bool")
						push(errors, [ location, "must be of type boolean" ]);

					return value;
				}

				if (exists(value, "enable")) {
					obj.enable = parseEnable(location + "/enable", value["enable"], errors);
				}
				else {
					obj.enable = true;
				}

				return obj;
			}

			if (type(value) != "object")
				push(errors, [ location, "must be of type object" ]);

			return value;
		}

		if (exists(value, "forwarding")) {
			obj.forwarding = parseForwarding(location + "/forwarding", value["forwarding"], errors);
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateInterfaceIpv4(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseAddressing(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			if (!(value in [ "static", "dhcp", "none" ]))
				push(errors, [ location, "must be one of \"static\", \"dhcp\" or \"none\"" ]);

			return value;
		}

		if (exists(value, "addressing")) {
			obj.addressing = parseAddressing(location + "/addressing", value["addressing"], errors);
		}

		function parseAddress(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "string") {
						if (!matchUcCidr4(value))
							push(errors, [ location, "must be a valid IPv4 CIDR" ]);

					}

					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "address")) {
			obj.address = parseAddress(location + "/address", value["address"], errors);
		}

		function parseGateway(location, value, errors) {
			if (type(value) == "string") {
				if (!matchIpv4(value))
					push(errors, [ location, "must be a valid IPv4 address" ]);

			}

			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "gateway")) {
			obj.gateway = parseGateway(location + "/gateway", value["gateway"], errors);
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateInterfaceIpv6(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseAddressing(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			if (!(value in [ "static", "slaac", "eui64", "dhcpv6", "none" ]))
				push(errors, [ location, "must be one of \"static\", \"slaac\", \"eui64\", \"dhcpv6\" or \"none\"" ]);

			return value;
		}

		if (exists(value, "addressing")) {
			obj.addressing = parseAddressing(location + "/addressing", value["addressing"], errors);
		}

		function parseAddress(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "string") {
						if (!matchUcCidr6(value))
							push(errors, [ location, "must be a valid IPv6 CIDR" ]);

					}

					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "address")) {
			obj.address = parseAddress(location + "/address", value["address"], errors);
		}

		function parseGateway(location, value, errors) {
			if (type(value) == "string") {
				if (!matchIpv6(value))
					push(errors, [ location, "must be a valid IPv6 address" ]);

			}

			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "gateway")) {
			obj.gateway = parseGateway(location + "/gateway", value["gateway"], errors);
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateInterfaceVlan(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseId(location, value, errors) {
			if (type(value) in [ "int", "double" ]) {
				if (value > 4094)
					push(errors, [ location, "must be lower than or equal to 4094" ]);

				if (value < 1)
					push(errors, [ location, "must be bigger than or equal to 1" ]);

			}

			if (type(value) != "int")
				push(errors, [ location, "must be of type integer" ]);

			return value;
		}

		if (exists(value, "id")) {
			obj.id = parseId(location + "/id", value["id"], errors);
		}

		function parseProto(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			if (!(value in [ "802.1ad", "802.1q" ]))
				push(errors, [ location, "must be one of \"802.1ad\" or \"802.1q\"" ]);

			return value;
		}

		if (exists(value, "proto")) {
			obj.proto = parseProto(location + "/proto", value["proto"], errors);
		}
		else {
			obj.proto = "802.1q";
		}

		function parseRole(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			if (!(value in [ "upstream", "downstream", "local" ]))
				push(errors, [ location, "must be one of \"upstream\", \"downstream\" or \"local\"" ]);

			return value;
		}

		if (exists(value, "role")) {
			obj.role = parseRole(location + "/role", value["role"], errors);
		}

		function parseEnabled(location, value, errors) {
			if (type(value) != "bool")
				push(errors, [ location, "must be of type boolean" ]);

			return value;
		}

		if (exists(value, "enabled")) {
			obj.enabled = parseEnabled(location + "/enabled", value["enabled"], errors);
		}
		else {
			obj.enabled = true;
		}

		function parseMacAddress(location, value, errors) {
			if (type(value) == "string") {
				if (!matchUcMac(value))
					push(errors, [ location, "must be a valid MAC address" ]);

			}

			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "mac-address")) {
			obj.mac_address = parseMacAddress(location + "/mac-address", value["mac-address"], errors);
		}

		function parseMtu(location, value, errors) {
			if (type(value) in [ "int", "double" ]) {
				if (value > 9000)
					push(errors, [ location, "must be lower than or equal to 9000" ]);

				if (value < 68)
					push(errors, [ location, "must be bigger than or equal to 68" ]);

			}

			if (type(value) != "int")
				push(errors, [ location, "must be of type integer" ]);

			return value;
		}

		if (exists(value, "mtu")) {
			obj.mtu = parseMtu(location + "/mtu", value["mtu"], errors);
		}

		function parseName(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "name")) {
			obj.name = parseName(location + "/name", value["name"], errors);
		}

		if (exists(value, "ipv4")) {
			obj.ipv4 = instantiateInterfaceIpv4(location + "/ipv4", value["ipv4"], errors);
		}

		if (exists(value, "ipv6")) {
			obj.ipv6 = instantiateInterfaceIpv6(location + "/ipv6", value["ipv6"], errors);
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateInterfaceBridge(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseMembers(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "members")) {
			obj.members = parseMembers(location + "/members", value["members"], errors);
		}

		function parseStp(location, value, errors) {
			if (type(value) != "bool")
				push(errors, [ location, "must be of type boolean" ]);

			return value;
		}

		if (exists(value, "stp")) {
			obj.stp = parseStp(location + "/stp", value["stp"], errors);
		}
		else {
			obj.stp = false;
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateInterfacePppoe(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseSourceInterface(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "source-interface")) {
			obj.source_interface = parseSourceInterface(location + "/source-interface", value["source-interface"], errors);
		}
		else {
			push(errors, [ location, "is required" ]);
		}

		function parseUsername(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "username")) {
			obj.username = parseUsername(location + "/username", value["username"], errors);
		}

		function parsePassword(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "password")) {
			obj.password = parsePassword(location + "/password", value["password"], errors);
		}
		else {
			push(errors, [ location, "is required" ]);
		}

		function parseDefaultRoute(location, value, errors) {
			if (type(value) != "bool")
				push(errors, [ location, "must be of type boolean" ]);

			return value;
		}

		if (exists(value, "default-route")) {
			obj.default_route = parseDefaultRoute(location + "/default-route", value["default-route"], errors);
		}
		else {
			obj.default_route = true;
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateInterface(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseName(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "name")) {
			obj.name = parseName(location + "/name", value["name"], errors);
		}

		function parseType(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			if (!(value in [ "ethernet", "bridge", "loopback", "pppoe", "dummy" ]))
				push(errors, [ location, "must be one of \"ethernet\", \"bridge\", \"loopback\", \"pppoe\" or \"dummy\"" ]);

			return value;
		}

		if (exists(value, "type")) {
			obj.type = parseType(location + "/type", value["type"], errors);
		}
		else {
			obj.type = "ethernet";
		}

		function parseRole(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			if (!(value in [ "upstream", "downstream", "local" ]))
				push(errors, [ location, "must be one of \"upstream\", \"downstream\" or \"local\"" ]);

			return value;
		}

		if (exists(value, "role")) {
			obj.role = parseRole(location + "/role", value["role"], errors);
		}

		function parseEnabled(location, value, errors) {
			if (type(value) != "bool")
				push(errors, [ location, "must be of type boolean" ]);

			return value;
		}

		if (exists(value, "enabled")) {
			obj.enabled = parseEnabled(location + "/enabled", value["enabled"], errors);
		}
		else {
			obj.enabled = true;
		}

		function parseMacAddress(location, value, errors) {
			if (type(value) == "string") {
				if (!matchUcMac(value))
					push(errors, [ location, "must be a valid MAC address" ]);

			}

			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "mac-address")) {
			obj.mac_address = parseMacAddress(location + "/mac-address", value["mac-address"], errors);
		}

		function parseMtu(location, value, errors) {
			if (type(value) in [ "int", "double" ]) {
				if (value > 9000)
					push(errors, [ location, "must be lower than or equal to 9000" ]);

				if (value < 68)
					push(errors, [ location, "must be bigger than or equal to 68" ]);

			}

			if (type(value) != "int")
				push(errors, [ location, "must be of type integer" ]);

			return value;
		}

		if (exists(value, "mtu")) {
			obj.mtu = parseMtu(location + "/mtu", value["mtu"], errors);
		}

		if (exists(value, "ethernet")) {
			obj.ethernet = instantiateInterfaceEthernet(location + "/ethernet", value["ethernet"], errors);
		}

		function parseVlan(location, value, errors) {
			if (type(value) == "array") {
				return map(value, (item, i) => instantiateInterfaceVlan(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "vlan")) {
			obj.vlan = parseVlan(location + "/vlan", value["vlan"], errors);
		}

		if (exists(value, "bridge")) {
			obj.bridge = instantiateInterfaceBridge(location + "/bridge", value["bridge"], errors);
		}

		if (exists(value, "pppoe")) {
			obj.pppoe = instantiateInterfacePppoe(location + "/pppoe", value["pppoe"], errors);
		}

		if (exists(value, "ipv4")) {
			obj.ipv4 = instantiateInterfaceIpv4(location + "/ipv4", value["ipv4"], errors);
		}

		if (exists(value, "ipv6")) {
			obj.ipv6 = instantiateInterfaceIpv6(location + "/ipv6", value["ipv6"], errors);
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateRoutingStaticIpv4(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseDestination(location, value, errors) {
			if (type(value) == "string") {
				if (!matchUcCidr4(value))
					push(errors, [ location, "must be a valid IPv4 CIDR" ]);

			}

			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "destination")) {
			obj.destination = parseDestination(location + "/destination", value["destination"], errors);
		}
		else {
			push(errors, [ location, "is required" ]);
		}

		function parseNextHop(location, value, errors) {
			if (type(value) == "string") {
				if (!matchIpv4(value))
					push(errors, [ location, "must be a valid IPv4 address" ]);

			}

			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "next-hop")) {
			obj.next_hop = parseNextHop(location + "/next-hop", value["next-hop"], errors);
		}
		else {
			push(errors, [ location, "is required" ]);
		}

		function parseInterface(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "interface")) {
			obj.interface = parseInterface(location + "/interface", value["interface"], errors);
		}

		function parseDistance(location, value, errors) {
			if (type(value) in [ "int", "double" ]) {
				if (value > 255)
					push(errors, [ location, "must be lower than or equal to 255" ]);

				if (value < 1)
					push(errors, [ location, "must be bigger than or equal to 1" ]);

			}

			if (type(value) != "int")
				push(errors, [ location, "must be of type integer" ]);

			return value;
		}

		if (exists(value, "distance")) {
			obj.distance = parseDistance(location + "/distance", value["distance"], errors);
		}
		else {
			obj.distance = 1;
		}

		function parseAction(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			if (!(value in [ "accept", "reject", "blackhole" ]))
				push(errors, [ location, "must be one of \"accept\", \"reject\" or \"blackhole\"" ]);

			return value;
		}

		if (exists(value, "action")) {
			obj.action = parseAction(location + "/action", value["action"], errors);
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateRoutingStaticIpv6(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseDestination(location, value, errors) {
			if (type(value) == "string") {
				if (!matchUcCidr6(value))
					push(errors, [ location, "must be a valid IPv6 CIDR" ]);

			}

			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "destination")) {
			obj.destination = parseDestination(location + "/destination", value["destination"], errors);
		}
		else {
			push(errors, [ location, "is required" ]);
		}

		function parseNextHop(location, value, errors) {
			if (type(value) == "string") {
				if (!matchIpv6(value))
					push(errors, [ location, "must be a valid IPv6 address" ]);

			}

			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "next-hop")) {
			obj.next_hop = parseNextHop(location + "/next-hop", value["next-hop"], errors);
		}
		else {
			push(errors, [ location, "is required" ]);
		}

		function parseInterface(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "interface")) {
			obj.interface = parseInterface(location + "/interface", value["interface"], errors);
		}

		function parseDistance(location, value, errors) {
			if (type(value) in [ "int", "double" ]) {
				if (value > 255)
					push(errors, [ location, "must be lower than or equal to 255" ]);

				if (value < 1)
					push(errors, [ location, "must be bigger than or equal to 1" ]);

			}

			if (type(value) != "int")
				push(errors, [ location, "must be of type integer" ]);

			return value;
		}

		if (exists(value, "distance")) {
			obj.distance = parseDistance(location + "/distance", value["distance"], errors);
		}
		else {
			obj.distance = 1;
		}

		function parseAction(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			if (!(value in [ "accept", "reject", "blackhole" ]))
				push(errors, [ location, "must be one of \"accept\", \"reject\" or \"blackhole\"" ]);

			return value;
		}

		if (exists(value, "action")) {
			obj.action = parseAction(location + "/action", value["action"], errors);
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateRoutingPolicy(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseName(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "name")) {
			obj.name = parseName(location + "/name", value["name"], errors);
		}

		function parseInterface(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "interface")) {
			obj.interface = parseInterface(location + "/interface", value["interface"], errors);
		}

		function parseAddressFamily(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			if (!(value in [ "ipv4", "ipv6" ]))
				push(errors, [ location, "must be one of \"ipv4\" or \"ipv6\"" ]);

			return value;
		}

		if (exists(value, "address-family")) {
			obj.address_family = parseAddressFamily(location + "/address-family", value["address-family"], errors);
		}

		function parseRules(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseName(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "name")) {
							obj.name = parseName(location + "/name", value["name"], errors);
						}

						function parsePriority(location, value, errors) {
							if (type(value) in [ "int", "double" ]) {
								if (value > 65535)
									push(errors, [ location, "must be lower than or equal to 65535" ]);

								if (value < 1)
									push(errors, [ location, "must be bigger than or equal to 1" ]);

							}

							if (type(value) != "int")
								push(errors, [ location, "must be of type integer" ]);

							return value;
						}

						if (exists(value, "priority")) {
							obj.priority = parsePriority(location + "/priority", value["priority"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						function parseSource(location, value, errors) {
							if (type(value) == "object") {
								let obj = {};

								function parseAddress(location, value, errors) {
									if (type(value) == "string") {
										if (!matchUcCidr(value))
											push(errors, [ location, "must be a valid IPv4 or IPv6 CIDR" ]);

									}

									if (type(value) != "string")
										push(errors, [ location, "must be of type string" ]);

									return value;
								}

								if (exists(value, "address")) {
									obj.address = parseAddress(location + "/address", value["address"], errors);
								}

								function parsePort(location, value, errors) {
									if (type(value) == "string") {
										if (!matchUcPortrange(value))
											push(errors, [ location, "must be a valid network port range" ]);

									}

									if (type(value) != "int" && type(value) != "string")
										push(errors, [ location, "must be of type integer or string" ]);

									return value;
								}

								if (exists(value, "port")) {
									obj.port = parsePort(location + "/port", value["port"], errors);
								}

								function parseGroup(location, value, errors) {
									if (type(value) != "string")
										push(errors, [ location, "must be of type string" ]);

									return value;
								}

								if (exists(value, "group")) {
									obj.group = parseGroup(location + "/group", value["group"], errors);
								}

								function parseMacAddress(location, value, errors) {
									if (type(value) == "string") {
										if (!matchUcMac(value))
											push(errors, [ location, "must be a valid MAC address" ]);

									}

									if (type(value) != "string")
										push(errors, [ location, "must be of type string" ]);

									return value;
								}

								if (exists(value, "mac-address")) {
									obj.mac_address = parseMacAddress(location + "/mac-address", value["mac-address"], errors);
								}

								return obj;
							}

							if (type(value) != "object")
								push(errors, [ location, "must be of type object" ]);

							return value;
						}

						if (exists(value, "source")) {
							obj.source = parseSource(location + "/source", value["source"], errors);
						}

						function parseDestination(location, value, errors) {
							if (type(value) == "object") {
								let obj = {};

								function parseAddress(location, value, errors) {
									if (type(value) == "string") {
										if (!matchUcCidr(value))
											push(errors, [ location, "must be a valid IPv4 or IPv6 CIDR" ]);

									}

									if (type(value) != "string")
										push(errors, [ location, "must be of type string" ]);

									return value;
								}

								if (exists(value, "address")) {
									obj.address = parseAddress(location + "/address", value["address"], errors);
								}

								function parsePort(location, value, errors) {
									if (type(value) == "string") {
										if (!matchUcPortrange(value))
											push(errors, [ location, "must be a valid network port range" ]);

									}

									if (type(value) != "int" && type(value) != "string")
										push(errors, [ location, "must be of type integer or string" ]);

									return value;
								}

								if (exists(value, "port")) {
									obj.port = parsePort(location + "/port", value["port"], errors);
								}

								function parseGroup(location, value, errors) {
									if (type(value) != "string")
										push(errors, [ location, "must be of type string" ]);

									return value;
								}

								if (exists(value, "group")) {
									obj.group = parseGroup(location + "/group", value["group"], errors);
								}

								return obj;
							}

							if (type(value) != "object")
								push(errors, [ location, "must be of type object" ]);

							return value;
						}

						if (exists(value, "destination")) {
							obj.destination = parseDestination(location + "/destination", value["destination"], errors);
						}

						function parseProtocol(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "protocol")) {
							obj.protocol = parseProtocol(location + "/protocol", value["protocol"], errors);
						}

						function parseConnMark(location, value, errors) {
							if (type(value) in [ "int", "double" ]) {
								if (value > 2147483647)
									push(errors, [ location, "must be lower than or equal to 2147483647" ]);

								if (value < 1)
									push(errors, [ location, "must be bigger than or equal to 1" ]);

							}

							if (type(value) != "int")
								push(errors, [ location, "must be of type integer" ]);

							return value;
						}

						if (exists(value, "conn-mark")) {
							obj.conn_mark = parseConnMark(location + "/conn-mark", value["conn-mark"], errors);
						}

						function parseMark(location, value, errors) {
							if (type(value) == "object") {
								let obj = {};

								function parseStart(location, value, errors) {
									if (type(value) in [ "int", "double" ]) {
										if (value > 2147483647)
											push(errors, [ location, "must be lower than or equal to 2147483647" ]);

										if (value < 1)
											push(errors, [ location, "must be bigger than or equal to 1" ]);

									}

									if (type(value) != "int")
										push(errors, [ location, "must be of type integer" ]);

									return value;
								}

								if (exists(value, "start")) {
									obj.start = parseStart(location + "/start", value["start"], errors);
								}

								function parseEnd(location, value, errors) {
									if (type(value) in [ "int", "double" ]) {
										if (value > 2147483647)
											push(errors, [ location, "must be lower than or equal to 2147483647" ]);

										if (value < 1)
											push(errors, [ location, "must be bigger than or equal to 1" ]);

									}

									if (type(value) != "int")
										push(errors, [ location, "must be of type integer" ]);

									return value;
								}

								if (exists(value, "end")) {
									obj.end = parseEnd(location + "/end", value["end"], errors);
								}

								return obj;
							}

							if (type(value) != "object")
								push(errors, [ location, "must be of type object" ]);

							return value;
						}

						if (exists(value, "mark")) {
							obj.mark = parseMark(location + "/mark", value["mark"], errors);
						}

						function parseInboundInterface(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "inbound-interface")) {
							obj.inbound_interface = parseInboundInterface(location + "/inbound-interface", value["inbound-interface"], errors);
						}

						function parseAction(location, value, errors) {
							if (type(value) == "object") {
								let obj = {};

								function parseDrop(location, value, errors) {
									if (type(value) != "bool")
										push(errors, [ location, "must be of type boolean" ]);

									return value;
								}

								if (exists(value, "drop")) {
									obj.drop = parseDrop(location + "/drop", value["drop"], errors);
								}
								else {
									obj.drop = false;
								}

								function parseNextHop(location, value, errors) {
									if (type(value) == "string") {
										if (!matchUcIp(value))
											push(errors, [ location, "must be a valid IPv4 or IPv6 address" ]);

									}

									if (type(value) != "string")
										push(errors, [ location, "must be of type string" ]);

									return value;
								}

								if (exists(value, "next-hop")) {
									obj.next_hop = parseNextHop(location + "/next-hop", value["next-hop"], errors);
								}

								function parseSetConnMark(location, value, errors) {
									if (type(value) in [ "int", "double" ]) {
										if (value > 2147483647)
											push(errors, [ location, "must be lower than or equal to 2147483647" ]);

										if (value < 1)
											push(errors, [ location, "must be bigger than or equal to 1" ]);

									}

									if (type(value) != "int")
										push(errors, [ location, "must be of type integer" ]);

									return value;
								}

								if (exists(value, "set-conn-mark")) {
									obj.set_conn_mark = parseSetConnMark(location + "/set-conn-mark", value["set-conn-mark"], errors);
								}

								function parseSetMark(location, value, errors) {
									if (type(value) in [ "int", "double" ]) {
										if (value > 2147483647)
											push(errors, [ location, "must be lower than or equal to 2147483647" ]);

										if (value < 1)
											push(errors, [ location, "must be bigger than or equal to 1" ]);

									}

									if (type(value) != "int")
										push(errors, [ location, "must be of type integer" ]);

									return value;
								}

								if (exists(value, "set-mark")) {
									obj.set_mark = parseSetMark(location + "/set-mark", value["set-mark"], errors);
								}

								function parseSetDscp(location, value, errors) {
									if (type(value) in [ "int", "double" ]) {
										if (value > 63)
											push(errors, [ location, "must be lower than or equal to 63" ]);

										if (value < 0)
											push(errors, [ location, "must be bigger than or equal to 0" ]);

									}

									if (type(value) != "int")
										push(errors, [ location, "must be of type integer" ]);

									return value;
								}

								if (exists(value, "set-dscp")) {
									obj.set_dscp = parseSetDscp(location + "/set-dscp", value["set-dscp"], errors);
								}

								return obj;
							}

							if (type(value) != "object")
								push(errors, [ location, "must be of type object" ]);

							return value;
						}

						if (exists(value, "action")) {
							obj.action = parseAction(location + "/action", value["action"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "rules")) {
			obj.rules = parseRules(location + "/rules", value["rules"], errors);
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateRoutingBgp(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseLocalAs(location, value, errors) {
			if (type(value) in [ "int", "double" ]) {
				if (value > 4294967295)
					push(errors, [ location, "must be lower than or equal to 4294967295" ]);

				if (value < 1)
					push(errors, [ location, "must be bigger than or equal to 1" ]);

			}

			if (type(value) != "int")
				push(errors, [ location, "must be of type integer" ]);

			return value;
		}

		if (exists(value, "local-as")) {
			obj.local_as = parseLocalAs(location + "/local-as", value["local-as"], errors);
		}
		else {
			push(errors, [ location, "is required" ]);
		}

		function parseRouterId(location, value, errors) {
			if (type(value) == "string") {
				if (!matchIpv4(value))
					push(errors, [ location, "must be a valid IPv4 address" ]);

			}

			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "router-id")) {
			obj.router_id = parseRouterId(location + "/router-id", value["router-id"], errors);
		}

		function parseNeighbors(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseAddress(location, value, errors) {
							if (type(value) == "string") {
								if (!matchUcIp(value))
									push(errors, [ location, "must be a valid IPv4 or IPv6 address" ]);

							}

							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "address")) {
							obj.address = parseAddress(location + "/address", value["address"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						function parsePort(location, value, errors) {
							if (type(value) in [ "int", "double" ]) {
								if (value > 65535)
									push(errors, [ location, "must be lower than or equal to 65535" ]);

								if (value < 1)
									push(errors, [ location, "must be bigger than or equal to 1" ]);

							}

							if (type(value) != "int")
								push(errors, [ location, "must be of type integer" ]);

							return value;
						}

						if (exists(value, "port")) {
							obj.port = parsePort(location + "/port", value["port"], errors);
						}

						function parseRemoteAs(location, value, errors) {
							if (type(value) in [ "int", "double" ]) {
								if (value > 4294967295)
									push(errors, [ location, "must be lower than or equal to 4294967295" ]);

								if (value < 1)
									push(errors, [ location, "must be bigger than or equal to 1" ]);

							}

							if (type(value) != "int")
								push(errors, [ location, "must be of type integer" ]);

							return value;
						}

						if (exists(value, "remote-as")) {
							obj.remote_as = parseRemoteAs(location + "/remote-as", value["remote-as"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						function parseUpdateSource(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "update-source")) {
							obj.update_source = parseUpdateSource(location + "/update-source", value["update-source"], errors);
						}

						function parsePassive(location, value, errors) {
							if (type(value) != "bool")
								push(errors, [ location, "must be of type boolean" ]);

							return value;
						}

						if (exists(value, "passive")) {
							obj.passive = parsePassive(location + "/passive", value["passive"], errors);
						}
						else {
							obj.passive = false;
						}

						function parseAdvertisementInterval(location, value, errors) {
							if (type(value) in [ "int", "double" ]) {
								if (value > 600)
									push(errors, [ location, "must be lower than or equal to 600" ]);

								if (value < 0)
									push(errors, [ location, "must be bigger than or equal to 0" ]);

							}

							if (type(value) != "int")
								push(errors, [ location, "must be of type integer" ]);

							return value;
						}

						if (exists(value, "advertisement-interval")) {
							obj.advertisement_interval = parseAdvertisementInterval(location + "/advertisement-interval", value["advertisement-interval"], errors);
						}
						else {
							obj.advertisement_interval = 30;
						}

						function parseEbgpMultihop(location, value, errors) {
							if (type(value) in [ "int", "double" ]) {
								if (value < 1)
									push(errors, [ location, "must be bigger than or equal to 1" ]);

							}

							if (type(value) != "int")
								push(errors, [ location, "must be of type integer" ]);

							return value;
						}

						if (exists(value, "ebgp-multihop")) {
							obj.ebgp_multihop = parseEbgpMultihop(location + "/ebgp-multihop", value["ebgp-multihop"], errors);
						}

						function parsePassword(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "password")) {
							obj.password = parsePassword(location + "/password", value["password"], errors);
						}

						function parsePeerParams(location, value, errors) {
							if (type(value) == "array") {
								function parseItem(location, value, errors) {
									if (type(value) == "object") {
										let obj = {};

										function parseAddressFamily(location, value, errors) {
											if (type(value) != "string")
												push(errors, [ location, "must be of type string" ]);

											if (!(value in [ "ipv4-unicast", "ipv6-unicast", "ipv4-multicast", "ipv6-multicast" ]))
												push(errors, [ location, "must be one of \"ipv4-unicast\", \"ipv6-unicast\", \"ipv4-multicast\" or \"ipv6-multicast\"" ]);

											return value;
										}

										if (exists(value, "address-family")) {
											obj.address_family = parseAddressFamily(location + "/address-family", value["address-family"], errors);
										}
										else {
											push(errors, [ location, "is required" ]);
										}

										function parseNexthopSelf(location, value, errors) {
											if (type(value) != "bool")
												push(errors, [ location, "must be of type boolean" ]);

											return value;
										}

										if (exists(value, "nexthop-self")) {
											obj.nexthop_self = parseNexthopSelf(location + "/nexthop-self", value["nexthop-self"], errors);
										}
										else {
											obj.nexthop_self = false;
										}

										function parseSoftReconfig(location, value, errors) {
											if (type(value) != "bool")
												push(errors, [ location, "must be of type boolean" ]);

											return value;
										}

										if (exists(value, "soft-reconfig")) {
											obj.soft_reconfig = parseSoftReconfig(location + "/soft-reconfig", value["soft-reconfig"], errors);
										}
										else {
											obj.soft_reconfig = false;
										}

										function parseDefaultOriginate(location, value, errors) {
											if (type(value) != "bool")
												push(errors, [ location, "must be of type boolean" ]);

											return value;
										}

										if (exists(value, "default-originate")) {
											obj.default_originate = parseDefaultOriginate(location + "/default-originate", value["default-originate"], errors);
										}
										else {
											obj.default_originate = false;
										}

										return obj;
									}

									if (type(value) != "object")
										push(errors, [ location, "must be of type object" ]);

									return value;
								}

								return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
							}

							if (type(value) != "array")
								push(errors, [ location, "must be of type array" ]);

							return value;
						}

						if (exists(value, "peer-params")) {
							obj.peer_params = parsePeerParams(location + "/peer-params", value["peer-params"], errors);
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "neighbors")) {
			obj.neighbors = parseNeighbors(location + "/neighbors", value["neighbors"], errors);
		}

		function parseNetworks(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseAddressFamily(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							if (!(value in [ "ipv4-unicast", "ipv6-unicast", "ipv4-multicast", "ipv6-multicast" ]))
								push(errors, [ location, "must be one of \"ipv4-unicast\", \"ipv6-unicast\", \"ipv4-multicast\" or \"ipv6-multicast\"" ]);

							return value;
						}

						if (exists(value, "address-family")) {
							obj.address_family = parseAddressFamily(location + "/address-family", value["address-family"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						function parseNetwork(location, value, errors) {
							if (type(value) == "string") {
								if (!matchUcCidr(value))
									push(errors, [ location, "must be a valid IPv4 or IPv6 CIDR" ]);

							}

							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "network")) {
							obj.network = parseNetwork(location + "/network", value["network"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "networks")) {
			obj.networks = parseNetworks(location + "/networks", value["networks"], errors);
		}

		function parseRedistribute(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseAddressFamily(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							if (!(value in [ "ipv4-unicast", "ipv6-unicast", "ipv4-multicast", "ipv6-multicast" ]))
								push(errors, [ location, "must be one of \"ipv4-unicast\", \"ipv6-unicast\", \"ipv4-multicast\" or \"ipv6-multicast\"" ]);

							return value;
						}

						if (exists(value, "address-family")) {
							obj.address_family = parseAddressFamily(location + "/address-family", value["address-family"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						function parseConnected(location, value, errors) {
							if (type(value) != "bool")
								push(errors, [ location, "must be of type boolean" ]);

							return value;
						}

						if (exists(value, "connected")) {
							obj.connected = parseConnected(location + "/connected", value["connected"], errors);
						}
						else {
							obj.connected = false;
						}

						function parseKernel(location, value, errors) {
							if (type(value) != "bool")
								push(errors, [ location, "must be of type boolean" ]);

							return value;
						}

						if (exists(value, "kernel")) {
							obj.kernel = parseKernel(location + "/kernel", value["kernel"], errors);
						}
						else {
							obj.kernel = false;
						}

						function parseOspf(location, value, errors) {
							if (type(value) != "bool")
								push(errors, [ location, "must be of type boolean" ]);

							return value;
						}

						if (exists(value, "ospf")) {
							obj.ospf = parseOspf(location + "/ospf", value["ospf"], errors);
						}
						else {
							obj.ospf = false;
						}

						function parseRip(location, value, errors) {
							if (type(value) != "bool")
								push(errors, [ location, "must be of type boolean" ]);

							return value;
						}

						if (exists(value, "rip")) {
							obj.rip = parseRip(location + "/rip", value["rip"], errors);
						}
						else {
							obj.rip = false;
						}

						function parseStatic(location, value, errors) {
							if (type(value) != "bool")
								push(errors, [ location, "must be of type boolean" ]);

							return value;
						}

						if (exists(value, "static")) {
							obj.static = parseStatic(location + "/static", value["static"], errors);
						}
						else {
							obj.static = false;
						}

						function parseTable(location, value, errors) {
							if (type(value) != "bool")
								push(errors, [ location, "must be of type boolean" ]);

							return value;
						}

						if (exists(value, "table")) {
							obj.table = parseTable(location + "/table", value["table"], errors);
						}
						else {
							obj.table = false;
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "redistribute")) {
			obj.redistribute = parseRedistribute(location + "/redistribute", value["redistribute"], errors);
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateRoutingOspf(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseRouterId(location, value, errors) {
			if (type(value) == "string") {
				if (!matchIpv4(value))
					push(errors, [ location, "must be a valid IPv4 address" ]);

			}

			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "router-id")) {
			obj.router_id = parseRouterId(location + "/router-id", value["router-id"], errors);
		}
		else {
			push(errors, [ location, "is required" ]);
		}

		function parseDefaultRouteOptions(location, value, errors) {
			if (type(value) == "object") {
				let obj = {};

				function parseAlwaysAdvertise(location, value, errors) {
					if (type(value) != "bool")
						push(errors, [ location, "must be of type boolean" ]);

					return value;
				}

				if (exists(value, "always-advertise")) {
					obj.always_advertise = parseAlwaysAdvertise(location + "/always-advertise", value["always-advertise"], errors);
				}
				else {
					obj.always_advertise = false;
				}

				function parseMetricValue(location, value, errors) {
					if (type(value) != "int")
						push(errors, [ location, "must be of type integer" ]);

					return value;
				}

				if (exists(value, "metric-value")) {
					obj.metric_value = parseMetricValue(location + "/metric-value", value["metric-value"], errors);
				}

				function parseMetricType(location, value, errors) {
					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					if (!(value in [ "E1", "E2" ]))
						push(errors, [ location, "must be one of \"E1\" or \"E2\"" ]);

					return value;
				}

				if (exists(value, "metric-type")) {
					obj.metric_type = parseMetricType(location + "/metric-type", value["metric-type"], errors);
				}
				else {
					obj.metric_type = "E2";
				}

				return obj;
			}

			if (type(value) != "object")
				push(errors, [ location, "must be of type object" ]);

			return value;
		}

		if (exists(value, "default-route-options")) {
			obj.default_route_options = parseDefaultRouteOptions(location + "/default-route-options", value["default-route-options"], errors);
		}

		function parseAreas(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseAreaId(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "area-id")) {
							obj.area_id = parseAreaId(location + "/area-id", value["area-id"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						function parseAreaType(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							if (!(value in [ "normal", "stub", "nssa" ]))
								push(errors, [ location, "must be one of \"normal\", \"stub\" or \"nssa\"" ]);

							return value;
						}

						if (exists(value, "area-type")) {
							obj.area_type = parseAreaType(location + "/area-type", value["area-type"], errors);
						}
						else {
							obj.area_type = "normal";
						}

						function parseNoSummary(location, value, errors) {
							if (type(value) != "bool")
								push(errors, [ location, "must be of type boolean" ]);

							return value;
						}

						if (exists(value, "no-summary")) {
							obj.no_summary = parseNoSummary(location + "/no-summary", value["no-summary"], errors);
						}
						else {
							obj.no_summary = false;
						}

						function parseNetworks(location, value, errors) {
							if (type(value) == "array") {
								function parseItem(location, value, errors) {
									if (type(value) == "string") {
										if (!matchUcCidr4(value))
											push(errors, [ location, "must be a valid IPv4 CIDR" ]);

									}

									if (type(value) != "string")
										push(errors, [ location, "must be of type string" ]);

									return value;
								}

								return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
							}

							if (type(value) != "array")
								push(errors, [ location, "must be of type array" ]);

							return value;
						}

						if (exists(value, "networks")) {
							obj.networks = parseNetworks(location + "/networks", value["networks"], errors);
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "areas")) {
			obj.areas = parseAreas(location + "/areas", value["areas"], errors);
		}

		function parseInterfaces(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseName(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "name")) {
							obj.name = parseName(location + "/name", value["name"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						function parseArea(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "area")) {
							obj.area = parseArea(location + "/area", value["area"], errors);
						}

						function parseCost(location, value, errors) {
							if (type(value) in [ "int", "double" ]) {
								if (value > 65535)
									push(errors, [ location, "must be lower than or equal to 65535" ]);

								if (value < 1)
									push(errors, [ location, "must be bigger than or equal to 1" ]);

							}

							if (type(value) != "int")
								push(errors, [ location, "must be of type integer" ]);

							return value;
						}

						if (exists(value, "cost")) {
							obj.cost = parseCost(location + "/cost", value["cost"], errors);
						}

						function parsePassive(location, value, errors) {
							if (type(value) != "bool")
								push(errors, [ location, "must be of type boolean" ]);

							return value;
						}

						if (exists(value, "passive")) {
							obj.passive = parsePassive(location + "/passive", value["passive"], errors);
						}
						else {
							obj.passive = false;
						}

						function parseNetworkType(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							if (!(value in [ "broadcast", "point-to-point", "non-broadcast", "point-to-multipoint" ]))
								push(errors, [ location, "must be one of \"broadcast\", \"point-to-point\", \"non-broadcast\" or \"point-to-multipoint\"" ]);

							return value;
						}

						if (exists(value, "network-type")) {
							obj.network_type = parseNetworkType(location + "/network-type", value["network-type"], errors);
						}

						function parsePriority(location, value, errors) {
							if (type(value) in [ "int", "double" ]) {
								if (value > 255)
									push(errors, [ location, "must be lower than or equal to 255" ]);

								if (value < 0)
									push(errors, [ location, "must be bigger than or equal to 0" ]);

							}

							if (type(value) != "int")
								push(errors, [ location, "must be of type integer" ]);

							return value;
						}

						if (exists(value, "priority")) {
							obj.priority = parsePriority(location + "/priority", value["priority"], errors);
						}
						else {
							obj.priority = 1;
						}

						function parseAuthentication(location, value, errors) {
							if (type(value) == "object") {
								let obj = {};

								function parseType(location, value, errors) {
									if (type(value) != "string")
										push(errors, [ location, "must be of type string" ]);

									if (!(value in [ "plaintext", "md5" ]))
										push(errors, [ location, "must be one of \"plaintext\" or \"md5\"" ]);

									return value;
								}

								if (exists(value, "type")) {
									obj.type = parseType(location + "/type", value["type"], errors);
								}

								function parsePassword(location, value, errors) {
									if (type(value) != "string")
										push(errors, [ location, "must be of type string" ]);

									return value;
								}

								if (exists(value, "password")) {
									obj.password = parsePassword(location + "/password", value["password"], errors);
								}

								function parseKeyId(location, value, errors) {
									if (type(value) in [ "int", "double" ]) {
										if (value > 255)
											push(errors, [ location, "must be lower than or equal to 255" ]);

										if (value < 1)
											push(errors, [ location, "must be bigger than or equal to 1" ]);

									}

									if (type(value) != "int")
										push(errors, [ location, "must be of type integer" ]);

									return value;
								}

								if (exists(value, "key-id")) {
									obj.key_id = parseKeyId(location + "/key-id", value["key-id"], errors);
								}

								return obj;
							}

							if (type(value) != "object")
								push(errors, [ location, "must be of type object" ]);

							return value;
						}

						if (exists(value, "authentication")) {
							obj.authentication = parseAuthentication(location + "/authentication", value["authentication"], errors);
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "interfaces")) {
			obj.interfaces = parseInterfaces(location + "/interfaces", value["interfaces"], errors);
		}

		function parseRedistribute(location, value, errors) {
			if (type(value) == "object") {
				let obj = {};

				function parseConnected(location, value, errors) {
					if (type(value) != "bool")
						push(errors, [ location, "must be of type boolean" ]);

					return value;
				}

				if (exists(value, "connected")) {
					obj.connected = parseConnected(location + "/connected", value["connected"], errors);
				}
				else {
					obj.connected = false;
				}

				function parseStatic(location, value, errors) {
					if (type(value) != "bool")
						push(errors, [ location, "must be of type boolean" ]);

					return value;
				}

				if (exists(value, "static")) {
					obj.static = parseStatic(location + "/static", value["static"], errors);
				}
				else {
					obj.static = false;
				}

				function parseBgp(location, value, errors) {
					if (type(value) != "bool")
						push(errors, [ location, "must be of type boolean" ]);

					return value;
				}

				if (exists(value, "bgp")) {
					obj.bgp = parseBgp(location + "/bgp", value["bgp"], errors);
				}
				else {
					obj.bgp = false;
				}

				return obj;
			}

			if (type(value) != "object")
				push(errors, [ location, "must be of type object" ]);

			return value;
		}

		if (exists(value, "redistribute")) {
			obj.redistribute = parseRedistribute(location + "/redistribute", value["redistribute"], errors);
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateRoutingOspfv3(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseAreas(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseAreaId(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "area-id")) {
							obj.area_id = parseAreaId(location + "/area-id", value["area-id"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						function parseAreaType(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							if (!(value in [ "normal", "stub", "nssa" ]))
								push(errors, [ location, "must be one of \"normal\", \"stub\" or \"nssa\"" ]);

							return value;
						}

						if (exists(value, "area-type")) {
							obj.area_type = parseAreaType(location + "/area-type", value["area-type"], errors);
						}
						else {
							obj.area_type = "normal";
						}

						function parseNoSummary(location, value, errors) {
							if (type(value) != "bool")
								push(errors, [ location, "must be of type boolean" ]);

							return value;
						}

						if (exists(value, "no-summary")) {
							obj.no_summary = parseNoSummary(location + "/no-summary", value["no-summary"], errors);
						}
						else {
							obj.no_summary = false;
						}

						function parseNetworks(location, value, errors) {
							if (type(value) == "array") {
								function parseItem(location, value, errors) {
									if (type(value) == "string") {
										if (!matchUcCidr6(value))
											push(errors, [ location, "must be a valid IPv6 CIDR" ]);

									}

									if (type(value) != "string")
										push(errors, [ location, "must be of type string" ]);

									return value;
								}

								return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
							}

							if (type(value) != "array")
								push(errors, [ location, "must be of type array" ]);

							return value;
						}

						if (exists(value, "networks")) {
							obj.networks = parseNetworks(location + "/networks", value["networks"], errors);
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "areas")) {
			obj.areas = parseAreas(location + "/areas", value["areas"], errors);
		}

		function parseInterfaces(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseName(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "name")) {
							obj.name = parseName(location + "/name", value["name"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						function parseArea(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "area")) {
							obj.area = parseArea(location + "/area", value["area"], errors);
						}

						function parseCost(location, value, errors) {
							if (type(value) in [ "int", "double" ]) {
								if (value > 65535)
									push(errors, [ location, "must be lower than or equal to 65535" ]);

								if (value < 1)
									push(errors, [ location, "must be bigger than or equal to 1" ]);

							}

							if (type(value) != "int")
								push(errors, [ location, "must be of type integer" ]);

							return value;
						}

						if (exists(value, "cost")) {
							obj.cost = parseCost(location + "/cost", value["cost"], errors);
						}

						function parsePassive(location, value, errors) {
							if (type(value) != "bool")
								push(errors, [ location, "must be of type boolean" ]);

							return value;
						}

						if (exists(value, "passive")) {
							obj.passive = parsePassive(location + "/passive", value["passive"], errors);
						}
						else {
							obj.passive = false;
						}

						function parseNetworkType(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							if (!(value in [ "broadcast", "point-to-point", "non-broadcast", "point-to-multipoint" ]))
								push(errors, [ location, "must be one of \"broadcast\", \"point-to-point\", \"non-broadcast\" or \"point-to-multipoint\"" ]);

							return value;
						}

						if (exists(value, "network-type")) {
							obj.network_type = parseNetworkType(location + "/network-type", value["network-type"], errors);
						}

						function parsePriority(location, value, errors) {
							if (type(value) in [ "int", "double" ]) {
								if (value > 255)
									push(errors, [ location, "must be lower than or equal to 255" ]);

								if (value < 0)
									push(errors, [ location, "must be bigger than or equal to 0" ]);

							}

							if (type(value) != "int")
								push(errors, [ location, "must be of type integer" ]);

							return value;
						}

						if (exists(value, "priority")) {
							obj.priority = parsePriority(location + "/priority", value["priority"], errors);
						}
						else {
							obj.priority = 1;
						}

						function parseAuthentication(location, value, errors) {
							if (type(value) == "object") {
								let obj = {};

								function parseType(location, value, errors) {
									if (type(value) != "string")
										push(errors, [ location, "must be of type string" ]);

									if (!(value in [ "plaintext", "md5" ]))
										push(errors, [ location, "must be one of \"plaintext\" or \"md5\"" ]);

									return value;
								}

								if (exists(value, "type")) {
									obj.type = parseType(location + "/type", value["type"], errors);
								}

								function parsePassword(location, value, errors) {
									if (type(value) != "string")
										push(errors, [ location, "must be of type string" ]);

									return value;
								}

								if (exists(value, "password")) {
									obj.password = parsePassword(location + "/password", value["password"], errors);
								}

								function parseKeyId(location, value, errors) {
									if (type(value) in [ "int", "double" ]) {
										if (value > 255)
											push(errors, [ location, "must be lower than or equal to 255" ]);

										if (value < 1)
											push(errors, [ location, "must be bigger than or equal to 1" ]);

									}

									if (type(value) != "int")
										push(errors, [ location, "must be of type integer" ]);

									return value;
								}

								if (exists(value, "key-id")) {
									obj.key_id = parseKeyId(location + "/key-id", value["key-id"], errors);
								}

								return obj;
							}

							if (type(value) != "object")
								push(errors, [ location, "must be of type object" ]);

							return value;
						}

						if (exists(value, "authentication")) {
							obj.authentication = parseAuthentication(location + "/authentication", value["authentication"], errors);
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "interfaces")) {
			obj.interfaces = parseInterfaces(location + "/interfaces", value["interfaces"], errors);
		}

		function parseRedistribute(location, value, errors) {
			if (type(value) == "object") {
				let obj = {};

				function parseConnected(location, value, errors) {
					if (type(value) != "bool")
						push(errors, [ location, "must be of type boolean" ]);

					return value;
				}

				if (exists(value, "connected")) {
					obj.connected = parseConnected(location + "/connected", value["connected"], errors);
				}
				else {
					obj.connected = false;
				}

				function parseStatic(location, value, errors) {
					if (type(value) != "bool")
						push(errors, [ location, "must be of type boolean" ]);

					return value;
				}

				if (exists(value, "static")) {
					obj.static = parseStatic(location + "/static", value["static"], errors);
				}
				else {
					obj.static = false;
				}

				function parseBgp(location, value, errors) {
					if (type(value) != "bool")
						push(errors, [ location, "must be of type boolean" ]);

					return value;
				}

				if (exists(value, "bgp")) {
					obj.bgp = parseBgp(location + "/bgp", value["bgp"], errors);
				}
				else {
					obj.bgp = false;
				}

				return obj;
			}

			if (type(value) != "object")
				push(errors, [ location, "must be of type object" ]);

			return value;
		}

		if (exists(value, "redistribute")) {
			obj.redistribute = parseRedistribute(location + "/redistribute", value["redistribute"], errors);
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateRoutingRip(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseVersion(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			if (!(value in [ "1", "2" ]))
				push(errors, [ location, "must be one of \"1\" or \"2\"" ]);

			return value;
		}

		if (exists(value, "version")) {
			obj.version = parseVersion(location + "/version", value["version"], errors);
		}
		else {
			obj.version = "2";
		}

		function parseNetworks(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "string") {
						if (!matchUcCidr4(value))
							push(errors, [ location, "must be a valid IPv4 CIDR" ]);

					}

					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "networks")) {
			obj.networks = parseNetworks(location + "/networks", value["networks"], errors);
		}

		function parseInterfaces(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseName(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "name")) {
							obj.name = parseName(location + "/name", value["name"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						function parsePassive(location, value, errors) {
							if (type(value) != "bool")
								push(errors, [ location, "must be of type boolean" ]);

							return value;
						}

						if (exists(value, "passive")) {
							obj.passive = parsePassive(location + "/passive", value["passive"], errors);
						}
						else {
							obj.passive = false;
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "interfaces")) {
			obj.interfaces = parseInterfaces(location + "/interfaces", value["interfaces"], errors);
		}

		function parseNeighbors(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "string") {
						if (!matchIpv4(value))
							push(errors, [ location, "must be a valid IPv4 address" ]);

					}

					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "neighbors")) {
			obj.neighbors = parseNeighbors(location + "/neighbors", value["neighbors"], errors);
		}

		function parseRedistribute(location, value, errors) {
			if (type(value) == "object") {
				let obj = {};

				function parseConnected(location, value, errors) {
					if (type(value) != "bool")
						push(errors, [ location, "must be of type boolean" ]);

					return value;
				}

				if (exists(value, "connected")) {
					obj.connected = parseConnected(location + "/connected", value["connected"], errors);
				}
				else {
					obj.connected = false;
				}

				function parseStatic(location, value, errors) {
					if (type(value) != "bool")
						push(errors, [ location, "must be of type boolean" ]);

					return value;
				}

				if (exists(value, "static")) {
					obj.static = parseStatic(location + "/static", value["static"], errors);
				}
				else {
					obj.static = false;
				}

				function parseBabel(location, value, errors) {
					if (type(value) != "bool")
						push(errors, [ location, "must be of type boolean" ]);

					return value;
				}

				if (exists(value, "babel")) {
					obj.babel = parseBabel(location + "/babel", value["babel"], errors);
				}
				else {
					obj.babel = false;
				}

				function parseBgp(location, value, errors) {
					if (type(value) != "bool")
						push(errors, [ location, "must be of type boolean" ]);

					return value;
				}

				if (exists(value, "bgp")) {
					obj.bgp = parseBgp(location + "/bgp", value["bgp"], errors);
				}
				else {
					obj.bgp = false;
				}

				function parseIsis(location, value, errors) {
					if (type(value) != "bool")
						push(errors, [ location, "must be of type boolean" ]);

					return value;
				}

				if (exists(value, "isis")) {
					obj.isis = parseIsis(location + "/isis", value["isis"], errors);
				}
				else {
					obj.isis = false;
				}

				function parseKernel(location, value, errors) {
					if (type(value) != "bool")
						push(errors, [ location, "must be of type boolean" ]);

					return value;
				}

				if (exists(value, "kernel")) {
					obj.kernel = parseKernel(location + "/kernel", value["kernel"], errors);
				}
				else {
					obj.kernel = false;
				}

				function parseNhrp(location, value, errors) {
					if (type(value) != "bool")
						push(errors, [ location, "must be of type boolean" ]);

					return value;
				}

				if (exists(value, "nhrp")) {
					obj.nhrp = parseNhrp(location + "/nhrp", value["nhrp"], errors);
				}
				else {
					obj.nhrp = false;
				}

				function parseOspf(location, value, errors) {
					if (type(value) != "bool")
						push(errors, [ location, "must be of type boolean" ]);

					return value;
				}

				if (exists(value, "ospf")) {
					obj.ospf = parseOspf(location + "/ospf", value["ospf"], errors);
				}
				else {
					obj.ospf = false;
				}

				return obj;
			}

			if (type(value) != "object")
				push(errors, [ location, "must be of type object" ]);

			return value;
		}

		if (exists(value, "redistribute")) {
			obj.redistribute = parseRedistribute(location + "/redistribute", value["redistribute"], errors);
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateRoutingRipng(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseNetworks(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "string") {
						if (!matchUcCidr6(value))
							push(errors, [ location, "must be a valid IPv6 CIDR" ]);

					}

					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "networks")) {
			obj.networks = parseNetworks(location + "/networks", value["networks"], errors);
		}

		function parseInterfaces(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseName(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "name")) {
							obj.name = parseName(location + "/name", value["name"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						function parsePassive(location, value, errors) {
							if (type(value) != "bool")
								push(errors, [ location, "must be of type boolean" ]);

							return value;
						}

						if (exists(value, "passive")) {
							obj.passive = parsePassive(location + "/passive", value["passive"], errors);
						}
						else {
							obj.passive = false;
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "interfaces")) {
			obj.interfaces = parseInterfaces(location + "/interfaces", value["interfaces"], errors);
		}

		function parseRedistribute(location, value, errors) {
			if (type(value) == "object") {
				let obj = {};

				function parseConnected(location, value, errors) {
					if (type(value) != "bool")
						push(errors, [ location, "must be of type boolean" ]);

					return value;
				}

				if (exists(value, "connected")) {
					obj.connected = parseConnected(location + "/connected", value["connected"], errors);
				}
				else {
					obj.connected = false;
				}

				function parseStatic(location, value, errors) {
					if (type(value) != "bool")
						push(errors, [ location, "must be of type boolean" ]);

					return value;
				}

				if (exists(value, "static")) {
					obj.static = parseStatic(location + "/static", value["static"], errors);
				}
				else {
					obj.static = false;
				}

				function parseBabel(location, value, errors) {
					if (type(value) != "bool")
						push(errors, [ location, "must be of type boolean" ]);

					return value;
				}

				if (exists(value, "babel")) {
					obj.babel = parseBabel(location + "/babel", value["babel"], errors);
				}
				else {
					obj.babel = false;
				}

				function parseBgp(location, value, errors) {
					if (type(value) != "bool")
						push(errors, [ location, "must be of type boolean" ]);

					return value;
				}

				if (exists(value, "bgp")) {
					obj.bgp = parseBgp(location + "/bgp", value["bgp"], errors);
				}
				else {
					obj.bgp = false;
				}

				function parseIsis(location, value, errors) {
					if (type(value) != "bool")
						push(errors, [ location, "must be of type boolean" ]);

					return value;
				}

				if (exists(value, "isis")) {
					obj.isis = parseIsis(location + "/isis", value["isis"], errors);
				}
				else {
					obj.isis = false;
				}

				function parseKernel(location, value, errors) {
					if (type(value) != "bool")
						push(errors, [ location, "must be of type boolean" ]);

					return value;
				}

				if (exists(value, "kernel")) {
					obj.kernel = parseKernel(location + "/kernel", value["kernel"], errors);
				}
				else {
					obj.kernel = false;
				}

				function parseNhrp(location, value, errors) {
					if (type(value) != "bool")
						push(errors, [ location, "must be of type boolean" ]);

					return value;
				}

				if (exists(value, "nhrp")) {
					obj.nhrp = parseNhrp(location + "/nhrp", value["nhrp"], errors);
				}
				else {
					obj.nhrp = false;
				}

				function parseOspf(location, value, errors) {
					if (type(value) != "bool")
						push(errors, [ location, "must be of type boolean" ]);

					return value;
				}

				if (exists(value, "ospf")) {
					obj.ospf = parseOspf(location + "/ospf", value["ospf"], errors);
				}
				else {
					obj.ospf = false;
				}

				return obj;
			}

			if (type(value) != "object")
				push(errors, [ location, "must be of type object" ]);

			return value;
		}

		if (exists(value, "redistribute")) {
			obj.redistribute = parseRedistribute(location + "/redistribute", value["redistribute"], errors);
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateRouting(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseStatic(location, value, errors) {
			if (type(value) == "object") {
				let obj = {};

				function parseIpv4Rules(location, value, errors) {
					if (type(value) == "array") {
						return map(value, (item, i) => instantiateRoutingStaticIpv4(location + "/" + i, item, errors));
					}

					if (type(value) != "array")
						push(errors, [ location, "must be of type array" ]);

					return value;
				}

				if (exists(value, "ipv4-rules")) {
					obj.ipv4_rules = parseIpv4Rules(location + "/ipv4-rules", value["ipv4-rules"], errors);
				}

				function parseIpv6Rules(location, value, errors) {
					if (type(value) == "array") {
						return map(value, (item, i) => instantiateRoutingStaticIpv6(location + "/" + i, item, errors));
					}

					if (type(value) != "array")
						push(errors, [ location, "must be of type array" ]);

					return value;
				}

				if (exists(value, "ipv6-rules")) {
					obj.ipv6_rules = parseIpv6Rules(location + "/ipv6-rules", value["ipv6-rules"], errors);
				}

				return obj;
			}

			if (type(value) != "object")
				push(errors, [ location, "must be of type object" ]);

			return value;
		}

		if (exists(value, "static")) {
			obj.static = parseStatic(location + "/static", value["static"], errors);
		}

		function parsePolicies(location, value, errors) {
			if (type(value) == "array") {
				return map(value, (item, i) => instantiateRoutingPolicy(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "policies")) {
			obj.policies = parsePolicies(location + "/policies", value["policies"], errors);
		}

		if (exists(value, "bgp")) {
			obj.bgp = instantiateRoutingBgp(location + "/bgp", value["bgp"], errors);
		}

		if (exists(value, "ospf")) {
			obj.ospf = instantiateRoutingOspf(location + "/ospf", value["ospf"], errors);
		}

		if (exists(value, "ospfv3")) {
			obj.ospfv3 = instantiateRoutingOspfv3(location + "/ospfv3", value["ospfv3"], errors);
		}

		if (exists(value, "rip")) {
			obj.rip = instantiateRoutingRip(location + "/rip", value["rip"], errors);
		}

		if (exists(value, "ripng")) {
			obj.ripng = instantiateRoutingRipng(location + "/ripng", value["ripng"], errors);
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateFirewallGroups(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseIpv4AddressGroups(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseName(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "name")) {
							obj.name = parseName(location + "/name", value["name"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						function parseMembers(location, value, errors) {
							if (type(value) == "array") {
								function parseItem(location, value, errors) {
									if (type(value) == "string") {
										if (!matchUcCidr4(value))
											push(errors, [ location, "must be a valid IPv4 CIDR" ]);

									}

									if (type(value) != "string")
										push(errors, [ location, "must be of type string" ]);

									return value;
								}

								return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
							}

							if (type(value) != "array")
								push(errors, [ location, "must be of type array" ]);

							return value;
						}

						if (exists(value, "members")) {
							obj.members = parseMembers(location + "/members", value["members"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "ipv4-address-groups")) {
			obj.ipv4_address_groups = parseIpv4AddressGroups(location + "/ipv4-address-groups", value["ipv4-address-groups"], errors);
		}

		function parseIpv6AddressGroups(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseName(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "name")) {
							obj.name = parseName(location + "/name", value["name"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						function parseMembers(location, value, errors) {
							if (type(value) == "array") {
								function parseItem(location, value, errors) {
									if (type(value) == "string") {
										if (!matchUcCidr6(value))
											push(errors, [ location, "must be a valid IPv6 CIDR" ]);

									}

									if (type(value) != "string")
										push(errors, [ location, "must be of type string" ]);

									return value;
								}

								return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
							}

							if (type(value) != "array")
								push(errors, [ location, "must be of type array" ]);

							return value;
						}

						if (exists(value, "members")) {
							obj.members = parseMembers(location + "/members", value["members"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "ipv6-address-groups")) {
			obj.ipv6_address_groups = parseIpv6AddressGroups(location + "/ipv6-address-groups", value["ipv6-address-groups"], errors);
		}

		function parsePortGroups(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseName(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "name")) {
							obj.name = parseName(location + "/name", value["name"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						function parseMembers(location, value, errors) {
							if (type(value) == "array") {
								function parseItem(location, value, errors) {
									if (type(value) != "int" && type(value) != "string")
										push(errors, [ location, "must be of type integer or string" ]);

									return value;
								}

								return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
							}

							if (type(value) != "array")
								push(errors, [ location, "must be of type array" ]);

							return value;
						}

						if (exists(value, "members")) {
							obj.members = parseMembers(location + "/members", value["members"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "port-groups")) {
			obj.port_groups = parsePortGroups(location + "/port-groups", value["port-groups"], errors);
		}

		function parseMacGroups(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseName(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "name")) {
							obj.name = parseName(location + "/name", value["name"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						function parseDescription(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "description")) {
							obj.description = parseDescription(location + "/description", value["description"], errors);
						}

						function parseMembers(location, value, errors) {
							if (type(value) == "array") {
								function parseItem(location, value, errors) {
									if (type(value) == "string") {
										if (!matchUcMac(value))
											push(errors, [ location, "must be a valid MAC address" ]);

									}

									if (type(value) != "string")
										push(errors, [ location, "must be of type string" ]);

									return value;
								}

								return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
							}

							if (type(value) != "array")
								push(errors, [ location, "must be of type array" ]);

							return value;
						}

						if (exists(value, "members")) {
							obj.members = parseMembers(location + "/members", value["members"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "mac-groups")) {
			obj.mac_groups = parseMacGroups(location + "/mac-groups", value["mac-groups"], errors);
		}

		function parseDomainGroups(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseName(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "name")) {
							obj.name = parseName(location + "/name", value["name"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						function parseDescription(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "description")) {
							obj.description = parseDescription(location + "/description", value["description"], errors);
						}

						function parseMembers(location, value, errors) {
							if (type(value) == "array") {
								function parseItem(location, value, errors) {
									if (type(value) == "string") {
										if (!matchHostname(value))
											push(errors, [ location, "must be a valid hostname" ]);

									}

									if (type(value) != "string")
										push(errors, [ location, "must be of type string" ]);

									return value;
								}

								return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
							}

							if (type(value) != "array")
								push(errors, [ location, "must be of type array" ]);

							return value;
						}

						if (exists(value, "members")) {
							obj.members = parseMembers(location + "/members", value["members"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "domain-groups")) {
			obj.domain_groups = parseDomainGroups(location + "/domain-groups", value["domain-groups"], errors);
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateFirewallRuleIpv4(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseRuleNumber(location, value, errors) {
			if (type(value) in [ "int", "double" ]) {
				if (value > 65535)
					push(errors, [ location, "must be lower than or equal to 65535" ]);

				if (value < 1)
					push(errors, [ location, "must be bigger than or equal to 1" ]);

			}

			if (type(value) != "int")
				push(errors, [ location, "must be of type integer" ]);

			return value;
		}

		if (exists(value, "rule-number")) {
			obj.rule_number = parseRuleNumber(location + "/rule-number", value["rule-number"], errors);
		}
		else {
			push(errors, [ location, "is required" ]);
		}

		function parseDisabled(location, value, errors) {
			if (type(value) != "bool")
				push(errors, [ location, "must be of type boolean" ]);

			return value;
		}

		if (exists(value, "disabled")) {
			obj.disabled = parseDisabled(location + "/disabled", value["disabled"], errors);
		}
		else {
			obj.disabled = false;
		}

		function parseAction(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			if (!(value in [ "accept", "drop", "reject" ]))
				push(errors, [ location, "must be one of \"accept\", \"drop\" or \"reject\"" ]);

			return value;
		}

		if (exists(value, "action")) {
			obj.action = parseAction(location + "/action", value["action"], errors);
		}
		else {
			push(errors, [ location, "is required" ]);
		}

		function parseProtocol(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "protocol")) {
			obj.protocol = parseProtocol(location + "/protocol", value["protocol"], errors);
		}

		function parseSource(location, value, errors) {
			if (type(value) == "object") {
				let obj = {};

				function parseAddress(location, value, errors) {
					if (type(value) == "string") {
						if (!matchUcCidr4(value))
							push(errors, [ location, "must be a valid IPv4 CIDR" ]);

					}

					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				if (exists(value, "address")) {
					obj.address = parseAddress(location + "/address", value["address"], errors);
				}

				function parsePort(location, value, errors) {
					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				if (exists(value, "port")) {
					obj.port = parsePort(location + "/port", value["port"], errors);
				}

				function parseMacAddress(location, value, errors) {
					if (type(value) == "string") {
						if (!matchUcMac(value))
							push(errors, [ location, "must be a valid MAC address" ]);

					}

					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				if (exists(value, "mac-address")) {
					obj.mac_address = parseMacAddress(location + "/mac-address", value["mac-address"], errors);
				}

				function parseGroup(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseAddressGroup(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "address-group")) {
							obj.address_group = parseAddressGroup(location + "/address-group", value["address-group"], errors);
						}

						function parsePortGroup(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "port-group")) {
							obj.port_group = parsePortGroup(location + "/port-group", value["port-group"], errors);
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				if (exists(value, "group")) {
					obj.group = parseGroup(location + "/group", value["group"], errors);
				}

				function parseNegate(location, value, errors) {
					if (type(value) != "bool")
						push(errors, [ location, "must be of type boolean" ]);

					return value;
				}

				if (exists(value, "negate")) {
					obj.negate = parseNegate(location + "/negate", value["negate"], errors);
				}
				else {
					obj.negate = false;
				}

				return obj;
			}

			if (type(value) != "object")
				push(errors, [ location, "must be of type object" ]);

			return value;
		}

		if (exists(value, "source")) {
			obj.source = parseSource(location + "/source", value["source"], errors);
		}

		function parseDestination(location, value, errors) {
			if (type(value) == "object") {
				let obj = {};

				function parseAddress(location, value, errors) {
					if (type(value) == "string") {
						if (!matchUcCidr4(value))
							push(errors, [ location, "must be a valid IPv4 CIDR" ]);

					}

					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				if (exists(value, "address")) {
					obj.address = parseAddress(location + "/address", value["address"], errors);
				}

				function parsePort(location, value, errors) {
					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				if (exists(value, "port")) {
					obj.port = parsePort(location + "/port", value["port"], errors);
				}

				function parseGroup(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseAddressGroup(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "address-group")) {
							obj.address_group = parseAddressGroup(location + "/address-group", value["address-group"], errors);
						}

						function parsePortGroup(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "port-group")) {
							obj.port_group = parsePortGroup(location + "/port-group", value["port-group"], errors);
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				if (exists(value, "group")) {
					obj.group = parseGroup(location + "/group", value["group"], errors);
				}

				function parseNegate(location, value, errors) {
					if (type(value) != "bool")
						push(errors, [ location, "must be of type boolean" ]);

					return value;
				}

				if (exists(value, "negate")) {
					obj.negate = parseNegate(location + "/negate", value["negate"], errors);
				}
				else {
					obj.negate = false;
				}

				return obj;
			}

			if (type(value) != "object")
				push(errors, [ location, "must be of type object" ]);

			return value;
		}

		if (exists(value, "destination")) {
			obj.destination = parseDestination(location + "/destination", value["destination"], errors);
		}

		function parseState(location, value, errors) {
			if (type(value) == "object") {
				let obj = {};

				function parseEstablished(location, value, errors) {
					if (type(value) != "bool")
						push(errors, [ location, "must be of type boolean" ]);

					return value;
				}

				if (exists(value, "established")) {
					obj.established = parseEstablished(location + "/established", value["established"], errors);
				}

				function parseRelated(location, value, errors) {
					if (type(value) != "bool")
						push(errors, [ location, "must be of type boolean" ]);

					return value;
				}

				if (exists(value, "related")) {
					obj.related = parseRelated(location + "/related", value["related"], errors);
				}

				function parseNew(location, value, errors) {
					if (type(value) != "bool")
						push(errors, [ location, "must be of type boolean" ]);

					return value;
				}

				if (exists(value, "new")) {
					obj.new = parseNew(location + "/new", value["new"], errors);
				}

				function parseInvalid(location, value, errors) {
					if (type(value) != "bool")
						push(errors, [ location, "must be of type boolean" ]);

					return value;
				}

				if (exists(value, "invalid")) {
					obj.invalid = parseInvalid(location + "/invalid", value["invalid"], errors);
				}

				return obj;
			}

			if (type(value) != "object")
				push(errors, [ location, "must be of type object" ]);

			return value;
		}

		if (exists(value, "state")) {
			obj.state = parseState(location + "/state", value["state"], errors);
		}

		function parseIcmp(location, value, errors) {
			if (type(value) == "object") {
				let obj = {};

				function parseType(location, value, errors) {
					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				if (exists(value, "type")) {
					obj.type = parseType(location + "/type", value["type"], errors);
				}

				function parseCode(location, value, errors) {
					if (type(value) != "int")
						push(errors, [ location, "must be of type integer" ]);

					return value;
				}

				if (exists(value, "code")) {
					obj.code = parseCode(location + "/code", value["code"], errors);
				}

				return obj;
			}

			if (type(value) != "object")
				push(errors, [ location, "must be of type object" ]);

			return value;
		}

		if (exists(value, "icmp")) {
			obj.icmp = parseIcmp(location + "/icmp", value["icmp"], errors);
		}

		function parseTcp(location, value, errors) {
			if (type(value) == "object") {
				let obj = {};

				function parseFlags(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseSet(location, value, errors) {
							if (type(value) == "array") {
								function parseItem(location, value, errors) {
									if (type(value) != "string")
										push(errors, [ location, "must be of type string" ]);

									if (!(value in [ "syn", "ack", "fin", "rst", "urg", "psh" ]))
										push(errors, [ location, "must be one of \"syn\", \"ack\", \"fin\", \"rst\", \"urg\" or \"psh\"" ]);

									return value;
								}

								return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
							}

							if (type(value) != "array")
								push(errors, [ location, "must be of type array" ]);

							return value;
						}

						if (exists(value, "set")) {
							obj.set = parseSet(location + "/set", value["set"], errors);
						}

						function parseNotSet(location, value, errors) {
							if (type(value) == "array") {
								function parseItem(location, value, errors) {
									if (type(value) != "string")
										push(errors, [ location, "must be of type string" ]);

									if (!(value in [ "syn", "ack", "fin", "rst", "urg", "psh" ]))
										push(errors, [ location, "must be one of \"syn\", \"ack\", \"fin\", \"rst\", \"urg\" or \"psh\"" ]);

									return value;
								}

								return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
							}

							if (type(value) != "array")
								push(errors, [ location, "must be of type array" ]);

							return value;
						}

						if (exists(value, "not-set")) {
							obj.not_set = parseNotSet(location + "/not-set", value["not-set"], errors);
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				if (exists(value, "flags")) {
					obj.flags = parseFlags(location + "/flags", value["flags"], errors);
				}

				return obj;
			}

			if (type(value) != "object")
				push(errors, [ location, "must be of type object" ]);

			return value;
		}

		if (exists(value, "tcp")) {
			obj.tcp = parseTcp(location + "/tcp", value["tcp"], errors);
		}

		function parseLimit(location, value, errors) {
			if (type(value) == "object") {
				let obj = {};

				function parseRate(location, value, errors) {
					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				if (exists(value, "rate")) {
					obj.rate = parseRate(location + "/rate", value["rate"], errors);
				}

				function parseBurst(location, value, errors) {
					if (type(value) != "int")
						push(errors, [ location, "must be of type integer" ]);

					return value;
				}

				if (exists(value, "burst")) {
					obj.burst = parseBurst(location + "/burst", value["burst"], errors);
				}

				return obj;
			}

			if (type(value) != "object")
				push(errors, [ location, "must be of type object" ]);

			return value;
		}

		if (exists(value, "limit")) {
			obj.limit = parseLimit(location + "/limit", value["limit"], errors);
		}

		function parseLog(location, value, errors) {
			if (type(value) != "bool")
				push(errors, [ location, "must be of type boolean" ]);

			return value;
		}

		if (exists(value, "log")) {
			obj.log = parseLog(location + "/log", value["log"], errors);
		}
		else {
			obj.log = false;
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateFirewallRulesetIpv4(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseName(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "name")) {
			obj.name = parseName(location + "/name", value["name"], errors);
		}
		else {
			push(errors, [ location, "is required" ]);
		}

		function parseDescription(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "description")) {
			obj.description = parseDescription(location + "/description", value["description"], errors);
		}

		function parseDefaultAction(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			if (!(value in [ "accept", "drop", "reject" ]))
				push(errors, [ location, "must be one of \"accept\", \"drop\" or \"reject\"" ]);

			return value;
		}

		if (exists(value, "default-action")) {
			obj.default_action = parseDefaultAction(location + "/default-action", value["default-action"], errors);
		}
		else {
			obj.default_action = "drop";
		}

		function parseDefaultLog(location, value, errors) {
			if (type(value) != "bool")
				push(errors, [ location, "must be of type boolean" ]);

			return value;
		}

		if (exists(value, "default-log")) {
			obj.default_log = parseDefaultLog(location + "/default-log", value["default-log"], errors);
		}
		else {
			obj.default_log = false;
		}

		function parseRules(location, value, errors) {
			if (type(value) == "array") {
				return map(value, (item, i) => instantiateFirewallRuleIpv4(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "rules")) {
			obj.rules = parseRules(location + "/rules", value["rules"], errors);
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateFirewallRuleIpv6(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseRuleNumber(location, value, errors) {
			if (type(value) in [ "int", "double" ]) {
				if (value > 65535)
					push(errors, [ location, "must be lower than or equal to 65535" ]);

				if (value < 1)
					push(errors, [ location, "must be bigger than or equal to 1" ]);

			}

			if (type(value) != "int")
				push(errors, [ location, "must be of type integer" ]);

			return value;
		}

		if (exists(value, "rule-number")) {
			obj.rule_number = parseRuleNumber(location + "/rule-number", value["rule-number"], errors);
		}
		else {
			push(errors, [ location, "is required" ]);
		}

		function parseDisabled(location, value, errors) {
			if (type(value) != "bool")
				push(errors, [ location, "must be of type boolean" ]);

			return value;
		}

		if (exists(value, "disabled")) {
			obj.disabled = parseDisabled(location + "/disabled", value["disabled"], errors);
		}
		else {
			obj.disabled = false;
		}

		function parseAction(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			if (!(value in [ "accept", "drop", "reject" ]))
				push(errors, [ location, "must be one of \"accept\", \"drop\" or \"reject\"" ]);

			return value;
		}

		if (exists(value, "action")) {
			obj.action = parseAction(location + "/action", value["action"], errors);
		}
		else {
			push(errors, [ location, "is required" ]);
		}

		function parseProtocol(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "protocol")) {
			obj.protocol = parseProtocol(location + "/protocol", value["protocol"], errors);
		}

		function parseSource(location, value, errors) {
			if (type(value) == "object") {
				let obj = {};

				function parseAddress(location, value, errors) {
					if (type(value) == "string") {
						if (!matchUcCidr6(value))
							push(errors, [ location, "must be a valid IPv6 CIDR" ]);

					}

					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				if (exists(value, "address")) {
					obj.address = parseAddress(location + "/address", value["address"], errors);
				}

				function parsePort(location, value, errors) {
					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				if (exists(value, "port")) {
					obj.port = parsePort(location + "/port", value["port"], errors);
				}

				function parseMacAddress(location, value, errors) {
					if (type(value) == "string") {
						if (!matchUcMac(value))
							push(errors, [ location, "must be a valid MAC address" ]);

					}

					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				if (exists(value, "mac-address")) {
					obj.mac_address = parseMacAddress(location + "/mac-address", value["mac-address"], errors);
				}

				function parseGroup(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseAddressGroup(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "address-group")) {
							obj.address_group = parseAddressGroup(location + "/address-group", value["address-group"], errors);
						}

						function parsePortGroup(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "port-group")) {
							obj.port_group = parsePortGroup(location + "/port-group", value["port-group"], errors);
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				if (exists(value, "group")) {
					obj.group = parseGroup(location + "/group", value["group"], errors);
				}

				function parseNegate(location, value, errors) {
					if (type(value) != "bool")
						push(errors, [ location, "must be of type boolean" ]);

					return value;
				}

				if (exists(value, "negate")) {
					obj.negate = parseNegate(location + "/negate", value["negate"], errors);
				}
				else {
					obj.negate = false;
				}

				return obj;
			}

			if (type(value) != "object")
				push(errors, [ location, "must be of type object" ]);

			return value;
		}

		if (exists(value, "source")) {
			obj.source = parseSource(location + "/source", value["source"], errors);
		}

		function parseDestination(location, value, errors) {
			if (type(value) == "object") {
				let obj = {};

				function parseAddress(location, value, errors) {
					if (type(value) == "string") {
						if (!matchUcCidr6(value))
							push(errors, [ location, "must be a valid IPv6 CIDR" ]);

					}

					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				if (exists(value, "address")) {
					obj.address = parseAddress(location + "/address", value["address"], errors);
				}

				function parsePort(location, value, errors) {
					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				if (exists(value, "port")) {
					obj.port = parsePort(location + "/port", value["port"], errors);
				}

				function parseGroup(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseAddressGroup(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "address-group")) {
							obj.address_group = parseAddressGroup(location + "/address-group", value["address-group"], errors);
						}

						function parsePortGroup(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "port-group")) {
							obj.port_group = parsePortGroup(location + "/port-group", value["port-group"], errors);
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				if (exists(value, "group")) {
					obj.group = parseGroup(location + "/group", value["group"], errors);
				}

				function parseNegate(location, value, errors) {
					if (type(value) != "bool")
						push(errors, [ location, "must be of type boolean" ]);

					return value;
				}

				if (exists(value, "negate")) {
					obj.negate = parseNegate(location + "/negate", value["negate"], errors);
				}
				else {
					obj.negate = false;
				}

				return obj;
			}

			if (type(value) != "object")
				push(errors, [ location, "must be of type object" ]);

			return value;
		}

		if (exists(value, "destination")) {
			obj.destination = parseDestination(location + "/destination", value["destination"], errors);
		}

		function parseState(location, value, errors) {
			if (type(value) == "object") {
				let obj = {};

				function parseEstablished(location, value, errors) {
					if (type(value) != "bool")
						push(errors, [ location, "must be of type boolean" ]);

					return value;
				}

				if (exists(value, "established")) {
					obj.established = parseEstablished(location + "/established", value["established"], errors);
				}

				function parseRelated(location, value, errors) {
					if (type(value) != "bool")
						push(errors, [ location, "must be of type boolean" ]);

					return value;
				}

				if (exists(value, "related")) {
					obj.related = parseRelated(location + "/related", value["related"], errors);
				}

				function parseNew(location, value, errors) {
					if (type(value) != "bool")
						push(errors, [ location, "must be of type boolean" ]);

					return value;
				}

				if (exists(value, "new")) {
					obj.new = parseNew(location + "/new", value["new"], errors);
				}

				function parseInvalid(location, value, errors) {
					if (type(value) != "bool")
						push(errors, [ location, "must be of type boolean" ]);

					return value;
				}

				if (exists(value, "invalid")) {
					obj.invalid = parseInvalid(location + "/invalid", value["invalid"], errors);
				}

				return obj;
			}

			if (type(value) != "object")
				push(errors, [ location, "must be of type object" ]);

			return value;
		}

		if (exists(value, "state")) {
			obj.state = parseState(location + "/state", value["state"], errors);
		}

		function parseIcmpv6(location, value, errors) {
			if (type(value) == "object") {
				let obj = {};

				function parseType(location, value, errors) {
					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				if (exists(value, "type")) {
					obj.type = parseType(location + "/type", value["type"], errors);
				}

				function parseCode(location, value, errors) {
					if (type(value) != "int")
						push(errors, [ location, "must be of type integer" ]);

					return value;
				}

				if (exists(value, "code")) {
					obj.code = parseCode(location + "/code", value["code"], errors);
				}

				return obj;
			}

			if (type(value) != "object")
				push(errors, [ location, "must be of type object" ]);

			return value;
		}

		if (exists(value, "icmpv6")) {
			obj.icmpv6 = parseIcmpv6(location + "/icmpv6", value["icmpv6"], errors);
		}

		function parseTcp(location, value, errors) {
			if (type(value) == "object") {
				let obj = {};

				function parseFlags(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseSet(location, value, errors) {
							if (type(value) == "array") {
								function parseItem(location, value, errors) {
									if (type(value) != "string")
										push(errors, [ location, "must be of type string" ]);

									if (!(value in [ "syn", "ack", "fin", "rst", "urg", "psh" ]))
										push(errors, [ location, "must be one of \"syn\", \"ack\", \"fin\", \"rst\", \"urg\" or \"psh\"" ]);

									return value;
								}

								return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
							}

							if (type(value) != "array")
								push(errors, [ location, "must be of type array" ]);

							return value;
						}

						if (exists(value, "set")) {
							obj.set = parseSet(location + "/set", value["set"], errors);
						}

						function parseNotSet(location, value, errors) {
							if (type(value) == "array") {
								function parseItem(location, value, errors) {
									if (type(value) != "string")
										push(errors, [ location, "must be of type string" ]);

									if (!(value in [ "syn", "ack", "fin", "rst", "urg", "psh" ]))
										push(errors, [ location, "must be one of \"syn\", \"ack\", \"fin\", \"rst\", \"urg\" or \"psh\"" ]);

									return value;
								}

								return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
							}

							if (type(value) != "array")
								push(errors, [ location, "must be of type array" ]);

							return value;
						}

						if (exists(value, "not-set")) {
							obj.not_set = parseNotSet(location + "/not-set", value["not-set"], errors);
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				if (exists(value, "flags")) {
					obj.flags = parseFlags(location + "/flags", value["flags"], errors);
				}

				return obj;
			}

			if (type(value) != "object")
				push(errors, [ location, "must be of type object" ]);

			return value;
		}

		if (exists(value, "tcp")) {
			obj.tcp = parseTcp(location + "/tcp", value["tcp"], errors);
		}

		function parseLimit(location, value, errors) {
			if (type(value) == "object") {
				let obj = {};

				function parseRate(location, value, errors) {
					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				if (exists(value, "rate")) {
					obj.rate = parseRate(location + "/rate", value["rate"], errors);
				}

				function parseBurst(location, value, errors) {
					if (type(value) != "int")
						push(errors, [ location, "must be of type integer" ]);

					return value;
				}

				if (exists(value, "burst")) {
					obj.burst = parseBurst(location + "/burst", value["burst"], errors);
				}

				return obj;
			}

			if (type(value) != "object")
				push(errors, [ location, "must be of type object" ]);

			return value;
		}

		if (exists(value, "limit")) {
			obj.limit = parseLimit(location + "/limit", value["limit"], errors);
		}

		function parseLog(location, value, errors) {
			if (type(value) != "bool")
				push(errors, [ location, "must be of type boolean" ]);

			return value;
		}

		if (exists(value, "log")) {
			obj.log = parseLog(location + "/log", value["log"], errors);
		}
		else {
			obj.log = false;
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateFirewallRulesetIpv6(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseName(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "name")) {
			obj.name = parseName(location + "/name", value["name"], errors);
		}
		else {
			push(errors, [ location, "is required" ]);
		}

		function parseDescription(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "description")) {
			obj.description = parseDescription(location + "/description", value["description"], errors);
		}

		function parseDefaultAction(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			if (!(value in [ "accept", "drop", "reject" ]))
				push(errors, [ location, "must be one of \"accept\", \"drop\" or \"reject\"" ]);

			return value;
		}

		if (exists(value, "default-action")) {
			obj.default_action = parseDefaultAction(location + "/default-action", value["default-action"], errors);
		}
		else {
			obj.default_action = "drop";
		}

		function parseDefaultLog(location, value, errors) {
			if (type(value) != "bool")
				push(errors, [ location, "must be of type boolean" ]);

			return value;
		}

		if (exists(value, "default-log")) {
			obj.default_log = parseDefaultLog(location + "/default-log", value["default-log"], errors);
		}
		else {
			obj.default_log = false;
		}

		function parseRules(location, value, errors) {
			if (type(value) == "array") {
				return map(value, (item, i) => instantiateFirewallRuleIpv6(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "rules")) {
			obj.rules = parseRules(location + "/rules", value["rules"], errors);
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateFirewallRuleBridge(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseRuleNumber(location, value, errors) {
			if (type(value) in [ "int", "double" ]) {
				if (value > 65535)
					push(errors, [ location, "must be lower than or equal to 65535" ]);

				if (value < 1)
					push(errors, [ location, "must be bigger than or equal to 1" ]);

			}

			if (type(value) != "int")
				push(errors, [ location, "must be of type integer" ]);

			return value;
		}

		if (exists(value, "rule-number")) {
			obj.rule_number = parseRuleNumber(location + "/rule-number", value["rule-number"], errors);
		}
		else {
			push(errors, [ location, "is required" ]);
		}

		function parseDisabled(location, value, errors) {
			if (type(value) != "bool")
				push(errors, [ location, "must be of type boolean" ]);

			return value;
		}

		if (exists(value, "disabled")) {
			obj.disabled = parseDisabled(location + "/disabled", value["disabled"], errors);
		}
		else {
			obj.disabled = false;
		}

		function parseAction(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			if (!(value in [ "accept", "drop" ]))
				push(errors, [ location, "must be one of \"accept\" or \"drop\"" ]);

			return value;
		}

		if (exists(value, "action")) {
			obj.action = parseAction(location + "/action", value["action"], errors);
		}
		else {
			push(errors, [ location, "is required" ]);
		}

		function parseSource(location, value, errors) {
			if (type(value) == "object") {
				let obj = {};

				function parseMacAddress(location, value, errors) {
					if (type(value) == "string") {
						if (!matchUcMac(value))
							push(errors, [ location, "must be a valid MAC address" ]);

					}

					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				if (exists(value, "mac-address")) {
					obj.mac_address = parseMacAddress(location + "/mac-address", value["mac-address"], errors);
				}

				function parseMacGroup(location, value, errors) {
					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				if (exists(value, "mac-group")) {
					obj.mac_group = parseMacGroup(location + "/mac-group", value["mac-group"], errors);
				}

				function parseNegate(location, value, errors) {
					if (type(value) != "bool")
						push(errors, [ location, "must be of type boolean" ]);

					return value;
				}

				if (exists(value, "negate")) {
					obj.negate = parseNegate(location + "/negate", value["negate"], errors);
				}
				else {
					obj.negate = false;
				}

				return obj;
			}

			if (type(value) != "object")
				push(errors, [ location, "must be of type object" ]);

			return value;
		}

		if (exists(value, "source")) {
			obj.source = parseSource(location + "/source", value["source"], errors);
		}

		function parseDestination(location, value, errors) {
			if (type(value) == "object") {
				let obj = {};

				function parseMacAddress(location, value, errors) {
					if (type(value) == "string") {
						if (!matchUcMac(value))
							push(errors, [ location, "must be a valid MAC address" ]);

					}

					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				if (exists(value, "mac-address")) {
					obj.mac_address = parseMacAddress(location + "/mac-address", value["mac-address"], errors);
				}

				function parseMacGroup(location, value, errors) {
					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				if (exists(value, "mac-group")) {
					obj.mac_group = parseMacGroup(location + "/mac-group", value["mac-group"], errors);
				}

				function parseNegate(location, value, errors) {
					if (type(value) != "bool")
						push(errors, [ location, "must be of type boolean" ]);

					return value;
				}

				if (exists(value, "negate")) {
					obj.negate = parseNegate(location + "/negate", value["negate"], errors);
				}
				else {
					obj.negate = false;
				}

				return obj;
			}

			if (type(value) != "object")
				push(errors, [ location, "must be of type object" ]);

			return value;
		}

		if (exists(value, "destination")) {
			obj.destination = parseDestination(location + "/destination", value["destination"], errors);
		}

		function parseVlan(location, value, errors) {
			if (type(value) == "object") {
				let obj = {};

				function parseId(location, value, errors) {
					if (type(value) in [ "int", "double" ]) {
						if (value > 4094)
							push(errors, [ location, "must be lower than or equal to 4094" ]);

						if (value < 1)
							push(errors, [ location, "must be bigger than or equal to 1" ]);

					}

					if (type(value) != "int")
						push(errors, [ location, "must be of type integer" ]);

					return value;
				}

				if (exists(value, "id")) {
					obj.id = parseId(location + "/id", value["id"], errors);
				}

				function parsePriority(location, value, errors) {
					if (type(value) in [ "int", "double" ]) {
						if (value > 7)
							push(errors, [ location, "must be lower than or equal to 7" ]);

						if (value < 0)
							push(errors, [ location, "must be bigger than or equal to 0" ]);

					}

					if (type(value) != "int")
						push(errors, [ location, "must be of type integer" ]);

					return value;
				}

				if (exists(value, "priority")) {
					obj.priority = parsePriority(location + "/priority", value["priority"], errors);
				}

				return obj;
			}

			if (type(value) != "object")
				push(errors, [ location, "must be of type object" ]);

			return value;
		}

		if (exists(value, "vlan")) {
			obj.vlan = parseVlan(location + "/vlan", value["vlan"], errors);
		}

		function parseEthertype(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "ethertype")) {
			obj.ethertype = parseEthertype(location + "/ethertype", value["ethertype"], errors);
		}

		function parseInboundInterface(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "inbound-interface")) {
			obj.inbound_interface = parseInboundInterface(location + "/inbound-interface", value["inbound-interface"], errors);
		}

		function parseOutboundInterface(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "outbound-interface")) {
			obj.outbound_interface = parseOutboundInterface(location + "/outbound-interface", value["outbound-interface"], errors);
		}

		function parseLog(location, value, errors) {
			if (type(value) != "bool")
				push(errors, [ location, "must be of type boolean" ]);

			return value;
		}

		if (exists(value, "log")) {
			obj.log = parseLog(location + "/log", value["log"], errors);
		}
		else {
			obj.log = false;
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateFirewallRulesetBridge(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseName(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "name")) {
			obj.name = parseName(location + "/name", value["name"], errors);
		}
		else {
			push(errors, [ location, "is required" ]);
		}

		function parseDefaultAction(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			if (!(value in [ "accept", "drop" ]))
				push(errors, [ location, "must be one of \"accept\" or \"drop\"" ]);

			return value;
		}

		if (exists(value, "default-action")) {
			obj.default_action = parseDefaultAction(location + "/default-action", value["default-action"], errors);
		}
		else {
			obj.default_action = "drop";
		}

		function parseDefaultLog(location, value, errors) {
			if (type(value) != "bool")
				push(errors, [ location, "must be of type boolean" ]);

			return value;
		}

		if (exists(value, "default-log")) {
			obj.default_log = parseDefaultLog(location + "/default-log", value["default-log"], errors);
		}
		else {
			obj.default_log = false;
		}

		function parseRules(location, value, errors) {
			if (type(value) == "array") {
				return map(value, (item, i) => instantiateFirewallRuleBridge(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "rules")) {
			obj.rules = parseRules(location + "/rules", value["rules"], errors);
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateFirewallZone(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseName(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "name")) {
			obj.name = parseName(location + "/name", value["name"], errors);
		}
		else {
			push(errors, [ location, "is required" ]);
		}

		function parseDefaultAction(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			if (!(value in [ "accept", "drop", "reject" ]))
				push(errors, [ location, "must be one of \"accept\", \"drop\" or \"reject\"" ]);

			return value;
		}

		if (exists(value, "default-action")) {
			obj.default_action = parseDefaultAction(location + "/default-action", value["default-action"], errors);
		}
		else {
			obj.default_action = "drop";
		}

		function parseInterfaces(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "interfaces")) {
			obj.interfaces = parseInterfaces(location + "/interfaces", value["interfaces"], errors);
		}

		function parseLocalZone(location, value, errors) {
			if (type(value) != "bool")
				push(errors, [ location, "must be of type boolean" ]);

			return value;
		}

		if (exists(value, "local-zone")) {
			obj.local_zone = parseLocalZone(location + "/local-zone", value["local-zone"], errors);
		}
		else {
			obj.local_zone = false;
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateFirewallZonePolicy(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseFrom(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "from")) {
			obj.from = parseFrom(location + "/from", value["from"], errors);
		}
		else {
			push(errors, [ location, "is required" ]);
		}

		function parseTo(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "to")) {
			obj.to = parseTo(location + "/to", value["to"], errors);
		}
		else {
			push(errors, [ location, "is required" ]);
		}

		function parseRuleset(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "ruleset")) {
			obj.ruleset = parseRuleset(location + "/ruleset", value["ruleset"], errors);
		}
		else {
			push(errors, [ location, "is required" ]);
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateFirewall(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseStatePolicy(location, value, errors) {
			if (type(value) == "object") {
				let obj = {};

				function parseEstablished(location, value, errors) {
					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					if (!(value in [ "accept", "drop" ]))
						push(errors, [ location, "must be one of \"accept\" or \"drop\"" ]);

					return value;
				}

				if (exists(value, "established")) {
					obj.established = parseEstablished(location + "/established", value["established"], errors);
				}
				else {
					obj.established = "accept";
				}

				function parseRelated(location, value, errors) {
					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					if (!(value in [ "accept", "drop" ]))
						push(errors, [ location, "must be one of \"accept\" or \"drop\"" ]);

					return value;
				}

				if (exists(value, "related")) {
					obj.related = parseRelated(location + "/related", value["related"], errors);
				}
				else {
					obj.related = "accept";
				}

				function parseInvalid(location, value, errors) {
					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					if (!(value in [ "accept", "drop" ]))
						push(errors, [ location, "must be one of \"accept\" or \"drop\"" ]);

					return value;
				}

				if (exists(value, "invalid")) {
					obj.invalid = parseInvalid(location + "/invalid", value["invalid"], errors);
				}
				else {
					obj.invalid = "drop";
				}

				return obj;
			}

			if (type(value) != "object")
				push(errors, [ location, "must be of type object" ]);

			return value;
		}

		if (exists(value, "state-policy")) {
			obj.state_policy = parseStatePolicy(location + "/state-policy", value["state-policy"], errors);
		}

		function parseGroups(location, value, errors) {
			if (type(value) == "array") {
				return map(value, (item, i) => instantiateFirewallGroups(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "groups")) {
			obj.groups = parseGroups(location + "/groups", value["groups"], errors);
		}

		function parseIpv4Rulesets(location, value, errors) {
			if (type(value) == "array") {
				return map(value, (item, i) => instantiateFirewallRulesetIpv4(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "ipv4-rulesets")) {
			obj.ipv4_rulesets = parseIpv4Rulesets(location + "/ipv4-rulesets", value["ipv4-rulesets"], errors);
		}

		function parseIpv6Rulesets(location, value, errors) {
			if (type(value) == "array") {
				return map(value, (item, i) => instantiateFirewallRulesetIpv6(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "ipv6-rulesets")) {
			obj.ipv6_rulesets = parseIpv6Rulesets(location + "/ipv6-rulesets", value["ipv6-rulesets"], errors);
		}

		function parseBridgeRulesets(location, value, errors) {
			if (type(value) == "array") {
				return map(value, (item, i) => instantiateFirewallRulesetBridge(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "bridge-rulesets")) {
			obj.bridge_rulesets = parseBridgeRulesets(location + "/bridge-rulesets", value["bridge-rulesets"], errors);
		}

		function parseZones(location, value, errors) {
			if (type(value) == "array") {
				return map(value, (item, i) => instantiateFirewallZone(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "zones")) {
			obj.zones = parseZones(location + "/zones", value["zones"], errors);
		}

		function parseZonePolicies(location, value, errors) {
			if (type(value) == "array") {
				return map(value, (item, i) => instantiateFirewallZonePolicy(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "zone-policies")) {
			obj.zone_policies = parseZonePolicies(location + "/zone-policies", value["zone-policies"], errors);
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateNatSourceIpv4(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseRuleNumber(location, value, errors) {
			if (type(value) in [ "int", "double" ]) {
				if (value < 1)
					push(errors, [ location, "must be bigger than or equal to 1" ]);

			}

			if (type(value) != "int")
				push(errors, [ location, "must be of type integer" ]);

			return value;
		}

		if (exists(value, "rule-number")) {
			obj.rule_number = parseRuleNumber(location + "/rule-number", value["rule-number"], errors);
		}
		else {
			push(errors, [ location, "is required" ]);
		}

		function parseOutboundInterface(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "outbound-interface")) {
			obj.outbound_interface = parseOutboundInterface(location + "/outbound-interface", value["outbound-interface"], errors);
		}

		function parseProtocol(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "protocol")) {
			obj.protocol = parseProtocol(location + "/protocol", value["protocol"], errors);
		}

		function parseSource(location, value, errors) {
			if (type(value) == "object") {
				let obj = {};

				function parseAddress(location, value, errors) {
					if (type(value) == "string") {
						if (!matchUcCidr4(value))
							push(errors, [ location, "must be a valid IPv4 CIDR" ]);

					}

					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				if (exists(value, "address")) {
					obj.address = parseAddress(location + "/address", value["address"], errors);
				}

				function parsePort(location, value, errors) {
					if (type(value) == "string") {
						if (!matchUcPortrange(value))
							push(errors, [ location, "must be a valid network port range" ]);

					}

					if (type(value) != "int" && type(value) != "string")
						push(errors, [ location, "must be of type integer or string" ]);

					return value;
				}

				if (exists(value, "port")) {
					obj.port = parsePort(location + "/port", value["port"], errors);
				}

				function parseGroup(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseAddressGroup(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "address-group")) {
							obj.address_group = parseAddressGroup(location + "/address-group", value["address-group"], errors);
						}

						function parseNetworkGroup(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "network-group")) {
							obj.network_group = parseNetworkGroup(location + "/network-group", value["network-group"], errors);
						}

						function parsePortGroup(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "port-group")) {
							obj.port_group = parsePortGroup(location + "/port-group", value["port-group"], errors);
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				if (exists(value, "group")) {
					obj.group = parseGroup(location + "/group", value["group"], errors);
				}

				return obj;
			}

			if (type(value) != "object")
				push(errors, [ location, "must be of type object" ]);

			return value;
		}

		if (exists(value, "source")) {
			obj.source = parseSource(location + "/source", value["source"], errors);
		}

		function parseDestination(location, value, errors) {
			if (type(value) == "object") {
				let obj = {};

				function parseAddress(location, value, errors) {
					if (type(value) == "string") {
						if (!matchUcCidr4(value))
							push(errors, [ location, "must be a valid IPv4 CIDR" ]);

					}

					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				if (exists(value, "address")) {
					obj.address = parseAddress(location + "/address", value["address"], errors);
				}

				function parsePort(location, value, errors) {
					if (type(value) == "string") {
						if (!matchUcPortrange(value))
							push(errors, [ location, "must be a valid network port range" ]);

					}

					if (type(value) != "int" && type(value) != "string")
						push(errors, [ location, "must be of type integer or string" ]);

					return value;
				}

				if (exists(value, "port")) {
					obj.port = parsePort(location + "/port", value["port"], errors);
				}

				function parseGroup(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseAddressGroup(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "address-group")) {
							obj.address_group = parseAddressGroup(location + "/address-group", value["address-group"], errors);
						}

						function parseNetworkGroup(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "network-group")) {
							obj.network_group = parseNetworkGroup(location + "/network-group", value["network-group"], errors);
						}

						function parsePortGroup(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "port-group")) {
							obj.port_group = parsePortGroup(location + "/port-group", value["port-group"], errors);
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				if (exists(value, "group")) {
					obj.group = parseGroup(location + "/group", value["group"], errors);
				}

				return obj;
			}

			if (type(value) != "object")
				push(errors, [ location, "must be of type object" ]);

			return value;
		}

		if (exists(value, "destination")) {
			obj.destination = parseDestination(location + "/destination", value["destination"], errors);
		}

		function parseTranslation(location, value, errors) {
			if (type(value) == "object") {
				let obj = {};

				function parseAddress(location, value, errors) {
					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				if (exists(value, "address")) {
					obj.address = parseAddress(location + "/address", value["address"], errors);
				}

				function parsePort(location, value, errors) {
					if (type(value) == "string") {
						if (!matchUcPortrange(value))
							push(errors, [ location, "must be a valid network port range" ]);

					}

					if (type(value) != "int" && type(value) != "string")
						push(errors, [ location, "must be of type integer or string" ]);

					return value;
				}

				if (exists(value, "port")) {
					obj.port = parsePort(location + "/port", value["port"], errors);
				}

				return obj;
			}

			if (type(value) != "object")
				push(errors, [ location, "must be of type object" ]);

			return value;
		}

		if (exists(value, "translation")) {
			obj.translation = parseTranslation(location + "/translation", value["translation"], errors);
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateNatDestinationIpv4(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseRuleNumber(location, value, errors) {
			if (type(value) in [ "int", "double" ]) {
				if (value < 1)
					push(errors, [ location, "must be bigger than or equal to 1" ]);

			}

			if (type(value) != "int")
				push(errors, [ location, "must be of type integer" ]);

			return value;
		}

		if (exists(value, "rule-number")) {
			obj.rule_number = parseRuleNumber(location + "/rule-number", value["rule-number"], errors);
		}
		else {
			push(errors, [ location, "is required" ]);
		}

		function parseInboundInterface(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "inbound-interface")) {
			obj.inbound_interface = parseInboundInterface(location + "/inbound-interface", value["inbound-interface"], errors);
		}

		function parseProtocol(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "protocol")) {
			obj.protocol = parseProtocol(location + "/protocol", value["protocol"], errors);
		}

		function parseSource(location, value, errors) {
			if (type(value) == "object") {
				let obj = {};

				function parseAddress(location, value, errors) {
					if (type(value) == "string") {
						if (!matchUcCidr4(value))
							push(errors, [ location, "must be a valid IPv4 CIDR" ]);

					}

					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				if (exists(value, "address")) {
					obj.address = parseAddress(location + "/address", value["address"], errors);
				}

				function parsePort(location, value, errors) {
					if (type(value) == "string") {
						if (!matchUcPortrange(value))
							push(errors, [ location, "must be a valid network port range" ]);

					}

					if (type(value) != "int" && type(value) != "string")
						push(errors, [ location, "must be of type integer or string" ]);

					return value;
				}

				if (exists(value, "port")) {
					obj.port = parsePort(location + "/port", value["port"], errors);
				}

				function parseGroup(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseAddressGroup(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "address-group")) {
							obj.address_group = parseAddressGroup(location + "/address-group", value["address-group"], errors);
						}

						function parseNetworkGroup(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "network-group")) {
							obj.network_group = parseNetworkGroup(location + "/network-group", value["network-group"], errors);
						}

						function parsePortGroup(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "port-group")) {
							obj.port_group = parsePortGroup(location + "/port-group", value["port-group"], errors);
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				if (exists(value, "group")) {
					obj.group = parseGroup(location + "/group", value["group"], errors);
				}

				return obj;
			}

			if (type(value) != "object")
				push(errors, [ location, "must be of type object" ]);

			return value;
		}

		if (exists(value, "source")) {
			obj.source = parseSource(location + "/source", value["source"], errors);
		}

		function parseDestination(location, value, errors) {
			if (type(value) == "object") {
				let obj = {};

				function parseAddress(location, value, errors) {
					if (type(value) == "string") {
						if (!matchUcCidr4(value))
							push(errors, [ location, "must be a valid IPv4 CIDR" ]);

					}

					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				if (exists(value, "address")) {
					obj.address = parseAddress(location + "/address", value["address"], errors);
				}

				function parsePort(location, value, errors) {
					if (type(value) == "string") {
						if (!matchUcPortrange(value))
							push(errors, [ location, "must be a valid network port range" ]);

					}

					if (type(value) != "int" && type(value) != "string")
						push(errors, [ location, "must be of type integer or string" ]);

					return value;
				}

				if (exists(value, "port")) {
					obj.port = parsePort(location + "/port", value["port"], errors);
				}

				function parseGroup(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseAddressGroup(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "address-group")) {
							obj.address_group = parseAddressGroup(location + "/address-group", value["address-group"], errors);
						}

						function parseNetworkGroup(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "network-group")) {
							obj.network_group = parseNetworkGroup(location + "/network-group", value["network-group"], errors);
						}

						function parsePortGroup(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "port-group")) {
							obj.port_group = parsePortGroup(location + "/port-group", value["port-group"], errors);
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				if (exists(value, "group")) {
					obj.group = parseGroup(location + "/group", value["group"], errors);
				}

				return obj;
			}

			if (type(value) != "object")
				push(errors, [ location, "must be of type object" ]);

			return value;
		}

		if (exists(value, "destination")) {
			obj.destination = parseDestination(location + "/destination", value["destination"], errors);
		}

		function parseTranslation(location, value, errors) {
			if (type(value) == "object") {
				let obj = {};

				function parseAddress(location, value, errors) {
					if (type(value) == "string") {
						if (!matchIpv4(value))
							push(errors, [ location, "must be a valid IPv4 address" ]);

					}

					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				if (exists(value, "address")) {
					obj.address = parseAddress(location + "/address", value["address"], errors);
				}

				function parsePort(location, value, errors) {
					if (type(value) == "string") {
						if (!matchUcPortrange(value))
							push(errors, [ location, "must be a valid network port range" ]);

					}

					if (type(value) != "int" && type(value) != "string")
						push(errors, [ location, "must be of type integer or string" ]);

					return value;
				}

				if (exists(value, "port")) {
					obj.port = parsePort(location + "/port", value["port"], errors);
				}

				return obj;
			}

			if (type(value) != "object")
				push(errors, [ location, "must be of type object" ]);

			return value;
		}

		if (exists(value, "translation")) {
			obj.translation = parseTranslation(location + "/translation", value["translation"], errors);
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateNatSourceIpv6(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseRuleNumber(location, value, errors) {
			if (type(value) in [ "int", "double" ]) {
				if (value < 1)
					push(errors, [ location, "must be bigger than or equal to 1" ]);

			}

			if (type(value) != "int")
				push(errors, [ location, "must be of type integer" ]);

			return value;
		}

		if (exists(value, "rule-number")) {
			obj.rule_number = parseRuleNumber(location + "/rule-number", value["rule-number"], errors);
		}
		else {
			push(errors, [ location, "is required" ]);
		}

		function parseOutboundInterface(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "outbound-interface")) {
			obj.outbound_interface = parseOutboundInterface(location + "/outbound-interface", value["outbound-interface"], errors);
		}

		function parseProtocol(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "protocol")) {
			obj.protocol = parseProtocol(location + "/protocol", value["protocol"], errors);
		}

		function parseSource(location, value, errors) {
			if (type(value) == "object") {
				let obj = {};

				function parsePrefix(location, value, errors) {
					if (type(value) == "string") {
						if (!matchUcCidr6(value))
							push(errors, [ location, "must be a valid IPv6 CIDR" ]);

					}

					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				if (exists(value, "prefix")) {
					obj.prefix = parsePrefix(location + "/prefix", value["prefix"], errors);
				}

				function parsePort(location, value, errors) {
					if (type(value) == "string") {
						if (!matchUcPortrange(value))
							push(errors, [ location, "must be a valid network port range" ]);

					}

					if (type(value) != "int" && type(value) != "string")
						push(errors, [ location, "must be of type integer or string" ]);

					return value;
				}

				if (exists(value, "port")) {
					obj.port = parsePort(location + "/port", value["port"], errors);
				}

				function parseGroup(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseAddressGroup(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "address-group")) {
							obj.address_group = parseAddressGroup(location + "/address-group", value["address-group"], errors);
						}

						function parseNetworkGroup(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "network-group")) {
							obj.network_group = parseNetworkGroup(location + "/network-group", value["network-group"], errors);
						}

						function parsePortGroup(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "port-group")) {
							obj.port_group = parsePortGroup(location + "/port-group", value["port-group"], errors);
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				if (exists(value, "group")) {
					obj.group = parseGroup(location + "/group", value["group"], errors);
				}

				return obj;
			}

			if (type(value) != "object")
				push(errors, [ location, "must be of type object" ]);

			return value;
		}

		if (exists(value, "source")) {
			obj.source = parseSource(location + "/source", value["source"], errors);
		}

		function parseDestination(location, value, errors) {
			if (type(value) == "object") {
				let obj = {};

				function parsePrefix(location, value, errors) {
					if (type(value) == "string") {
						if (!matchUcCidr6(value))
							push(errors, [ location, "must be a valid IPv6 CIDR" ]);

					}

					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				if (exists(value, "prefix")) {
					obj.prefix = parsePrefix(location + "/prefix", value["prefix"], errors);
				}

				function parsePort(location, value, errors) {
					if (type(value) == "string") {
						if (!matchUcPortrange(value))
							push(errors, [ location, "must be a valid network port range" ]);

					}

					if (type(value) != "int" && type(value) != "string")
						push(errors, [ location, "must be of type integer or string" ]);

					return value;
				}

				if (exists(value, "port")) {
					obj.port = parsePort(location + "/port", value["port"], errors);
				}

				function parseGroup(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseAddressGroup(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "address-group")) {
							obj.address_group = parseAddressGroup(location + "/address-group", value["address-group"], errors);
						}

						function parseNetworkGroup(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "network-group")) {
							obj.network_group = parseNetworkGroup(location + "/network-group", value["network-group"], errors);
						}

						function parsePortGroup(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "port-group")) {
							obj.port_group = parsePortGroup(location + "/port-group", value["port-group"], errors);
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				if (exists(value, "group")) {
					obj.group = parseGroup(location + "/group", value["group"], errors);
				}

				return obj;
			}

			if (type(value) != "object")
				push(errors, [ location, "must be of type object" ]);

			return value;
		}

		if (exists(value, "destination")) {
			obj.destination = parseDestination(location + "/destination", value["destination"], errors);
		}

		function parseTranslation(location, value, errors) {
			if (type(value) == "object") {
				let obj = {};

				function parsePrefix(location, value, errors) {
					if (type(value) == "string") {
						if (!matchUcCidr6(value))
							push(errors, [ location, "must be a valid IPv6 CIDR" ]);

					}

					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				if (exists(value, "prefix")) {
					obj.prefix = parsePrefix(location + "/prefix", value["prefix"], errors);
				}

				function parsePort(location, value, errors) {
					if (type(value) == "string") {
						if (!matchUcPortrange(value))
							push(errors, [ location, "must be a valid network port range" ]);

					}

					if (type(value) != "int" && type(value) != "string")
						push(errors, [ location, "must be of type integer or string" ]);

					return value;
				}

				if (exists(value, "port")) {
					obj.port = parsePort(location + "/port", value["port"], errors);
				}

				return obj;
			}

			if (type(value) != "object")
				push(errors, [ location, "must be of type object" ]);

			return value;
		}

		if (exists(value, "translation")) {
			obj.translation = parseTranslation(location + "/translation", value["translation"], errors);
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateNatDestinationIpv6(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseRuleNumber(location, value, errors) {
			if (type(value) in [ "int", "double" ]) {
				if (value < 1)
					push(errors, [ location, "must be bigger than or equal to 1" ]);

			}

			if (type(value) != "int")
				push(errors, [ location, "must be of type integer" ]);

			return value;
		}

		if (exists(value, "rule-number")) {
			obj.rule_number = parseRuleNumber(location + "/rule-number", value["rule-number"], errors);
		}
		else {
			push(errors, [ location, "is required" ]);
		}

		function parseInboundInterface(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "inbound-interface")) {
			obj.inbound_interface = parseInboundInterface(location + "/inbound-interface", value["inbound-interface"], errors);
		}

		function parseProtocol(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "protocol")) {
			obj.protocol = parseProtocol(location + "/protocol", value["protocol"], errors);
		}

		function parseSource(location, value, errors) {
			if (type(value) == "object") {
				let obj = {};

				function parsePrefix(location, value, errors) {
					if (type(value) == "string") {
						if (!matchUcCidr6(value))
							push(errors, [ location, "must be a valid IPv6 CIDR" ]);

					}

					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				if (exists(value, "prefix")) {
					obj.prefix = parsePrefix(location + "/prefix", value["prefix"], errors);
				}

				function parsePort(location, value, errors) {
					if (type(value) == "string") {
						if (!matchUcPortrange(value))
							push(errors, [ location, "must be a valid network port range" ]);

					}

					if (type(value) != "int" && type(value) != "string")
						push(errors, [ location, "must be of type integer or string" ]);

					return value;
				}

				if (exists(value, "port")) {
					obj.port = parsePort(location + "/port", value["port"], errors);
				}

				function parseGroup(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseAddressGroup(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "address-group")) {
							obj.address_group = parseAddressGroup(location + "/address-group", value["address-group"], errors);
						}

						function parseNetworkGroup(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "network-group")) {
							obj.network_group = parseNetworkGroup(location + "/network-group", value["network-group"], errors);
						}

						function parsePortGroup(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "port-group")) {
							obj.port_group = parsePortGroup(location + "/port-group", value["port-group"], errors);
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				if (exists(value, "group")) {
					obj.group = parseGroup(location + "/group", value["group"], errors);
				}

				return obj;
			}

			if (type(value) != "object")
				push(errors, [ location, "must be of type object" ]);

			return value;
		}

		if (exists(value, "source")) {
			obj.source = parseSource(location + "/source", value["source"], errors);
		}

		function parseDestination(location, value, errors) {
			if (type(value) == "object") {
				let obj = {};

				function parsePrefix(location, value, errors) {
					if (type(value) == "string") {
						if (!matchUcCidr6(value))
							push(errors, [ location, "must be a valid IPv6 CIDR" ]);

					}

					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				if (exists(value, "prefix")) {
					obj.prefix = parsePrefix(location + "/prefix", value["prefix"], errors);
				}

				function parsePort(location, value, errors) {
					if (type(value) == "string") {
						if (!matchUcPortrange(value))
							push(errors, [ location, "must be a valid network port range" ]);

					}

					if (type(value) != "int" && type(value) != "string")
						push(errors, [ location, "must be of type integer or string" ]);

					return value;
				}

				if (exists(value, "port")) {
					obj.port = parsePort(location + "/port", value["port"], errors);
				}

				function parseGroup(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseAddressGroup(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "address-group")) {
							obj.address_group = parseAddressGroup(location + "/address-group", value["address-group"], errors);
						}

						function parseNetworkGroup(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "network-group")) {
							obj.network_group = parseNetworkGroup(location + "/network-group", value["network-group"], errors);
						}

						function parsePortGroup(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "port-group")) {
							obj.port_group = parsePortGroup(location + "/port-group", value["port-group"], errors);
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				if (exists(value, "group")) {
					obj.group = parseGroup(location + "/group", value["group"], errors);
				}

				return obj;
			}

			if (type(value) != "object")
				push(errors, [ location, "must be of type object" ]);

			return value;
		}

		if (exists(value, "destination")) {
			obj.destination = parseDestination(location + "/destination", value["destination"], errors);
		}

		function parseTranslation(location, value, errors) {
			if (type(value) == "object") {
				let obj = {};

				function parsePrefix(location, value, errors) {
					if (type(value) == "string") {
						if (!matchUcCidr6(value))
							push(errors, [ location, "must be a valid IPv6 CIDR" ]);

					}

					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				if (exists(value, "prefix")) {
					obj.prefix = parsePrefix(location + "/prefix", value["prefix"], errors);
				}

				function parsePort(location, value, errors) {
					if (type(value) == "string") {
						if (!matchUcPortrange(value))
							push(errors, [ location, "must be a valid network port range" ]);

					}

					if (type(value) != "int" && type(value) != "string")
						push(errors, [ location, "must be of type integer or string" ]);

					return value;
				}

				if (exists(value, "port")) {
					obj.port = parsePort(location + "/port", value["port"], errors);
				}

				return obj;
			}

			if (type(value) != "object")
				push(errors, [ location, "must be of type object" ]);

			return value;
		}

		if (exists(value, "translation")) {
			obj.translation = parseTranslation(location + "/translation", value["translation"], errors);
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateNatNat64(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseRuleNumber(location, value, errors) {
			if (type(value) in [ "int", "double" ]) {
				if (value < 1)
					push(errors, [ location, "must be bigger than or equal to 1" ]);

			}

			if (type(value) != "int")
				push(errors, [ location, "must be of type integer" ]);

			return value;
		}

		if (exists(value, "rule-number")) {
			obj.rule_number = parseRuleNumber(location + "/rule-number", value["rule-number"], errors);
		}
		else {
			push(errors, [ location, "is required" ]);
		}

		function parseSource(location, value, errors) {
			if (type(value) == "object") {
				let obj = {};

				function parsePrefix(location, value, errors) {
					if (type(value) == "string") {
						if (!matchUcCidr6(value))
							push(errors, [ location, "must be a valid IPv6 CIDR" ]);

					}

					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				if (exists(value, "prefix")) {
					obj.prefix = parsePrefix(location + "/prefix", value["prefix"], errors);
				}

				return obj;
			}

			if (type(value) != "object")
				push(errors, [ location, "must be of type object" ]);

			return value;
		}

		if (exists(value, "source")) {
			obj.source = parseSource(location + "/source", value["source"], errors);
		}

		function parseTranslation(location, value, errors) {
			if (type(value) == "object") {
				let obj = {};

				function parseIpv6Prefix(location, value, errors) {
					if (type(value) == "string") {
						if (!matchUcCidr6(value))
							push(errors, [ location, "must be a valid IPv6 CIDR" ]);

					}

					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				if (exists(value, "ipv6-prefix")) {
					obj.ipv6_prefix = parseIpv6Prefix(location + "/ipv6-prefix", value["ipv6-prefix"], errors);
				}
				else {
					obj.ipv6_prefix = "64:ff9b::/96";
				}

				function parseIpv4Pool(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseAddress(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "address")) {
							obj.address = parseAddress(location + "/address", value["address"], errors);
						}

						function parsePortRange(location, value, errors) {
							if (type(value) == "string") {
								if (!matchUcPortrange(value))
									push(errors, [ location, "must be a valid network port range" ]);

							}

							if (type(value) != "int" && type(value) != "string")
								push(errors, [ location, "must be of type integer or string" ]);

							return value;
						}

						if (exists(value, "port-range")) {
							obj.port_range = parsePortRange(location + "/port-range", value["port-range"], errors);
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				if (exists(value, "ipv4-pool")) {
					obj.ipv4_pool = parseIpv4Pool(location + "/ipv4-pool", value["ipv4-pool"], errors);
				}

				return obj;
			}

			if (type(value) != "object")
				push(errors, [ location, "must be of type object" ]);

			return value;
		}

		if (exists(value, "translation")) {
			obj.translation = parseTranslation(location + "/translation", value["translation"], errors);
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateNat(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseSourceIpv4(location, value, errors) {
			if (type(value) == "array") {
				return map(value, (item, i) => instantiateNatSourceIpv4(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "source-ipv4")) {
			obj.source_ipv4 = parseSourceIpv4(location + "/source-ipv4", value["source-ipv4"], errors);
		}

		function parseDestinationIpv4(location, value, errors) {
			if (type(value) == "array") {
				return map(value, (item, i) => instantiateNatDestinationIpv4(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "destination-ipv4")) {
			obj.destination_ipv4 = parseDestinationIpv4(location + "/destination-ipv4", value["destination-ipv4"], errors);
		}

		function parseSourceIpv6(location, value, errors) {
			if (type(value) == "array") {
				return map(value, (item, i) => instantiateNatSourceIpv6(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "source-ipv6")) {
			obj.source_ipv6 = parseSourceIpv6(location + "/source-ipv6", value["source-ipv6"], errors);
		}

		function parseDestinationIpv6(location, value, errors) {
			if (type(value) == "array") {
				return map(value, (item, i) => instantiateNatDestinationIpv6(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "destination-ipv6")) {
			obj.destination_ipv6 = parseDestinationIpv6(location + "/destination-ipv6", value["destination-ipv6"], errors);
		}

		function parseNat64(location, value, errors) {
			if (type(value) == "array") {
				return map(value, (item, i) => instantiateNatNat64(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "nat64")) {
			obj.nat64 = parseNat64(location + "/nat64", value["nat64"], errors);
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiatePki(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseCaCerts(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseName(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "name")) {
							obj.name = parseName(location + "/name", value["name"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						function parseCertificate(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "certificate")) {
							obj.certificate = parseCertificate(location + "/certificate", value["certificate"], errors);
						}

						function parsePrivateKey(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "private-key")) {
							obj.private_key = parsePrivateKey(location + "/private-key", value["private-key"], errors);
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "ca-certs")) {
			obj.ca_certs = parseCaCerts(location + "/ca-certs", value["ca-certs"], errors);
		}

		function parseCerts(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseName(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "name")) {
							obj.name = parseName(location + "/name", value["name"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						function parseCertificate(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "certificate")) {
							obj.certificate = parseCertificate(location + "/certificate", value["certificate"], errors);
						}

						function parsePrivateKey(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "private-key")) {
							obj.private_key = parsePrivateKey(location + "/private-key", value["private-key"], errors);
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "certs")) {
			obj.certs = parseCerts(location + "/certs", value["certs"], errors);
		}

		function parseDh(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseName(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "name")) {
							obj.name = parseName(location + "/name", value["name"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						function parseParameter(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "parameter")) {
							obj.parameter = parseParameter(location + "/parameter", value["parameter"], errors);
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "dh")) {
			obj.dh = parseDh(location + "/dh", value["dh"], errors);
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateVpnIpsec(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseInterface(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "interface")) {
			obj.interface = parseInterface(location + "/interface", value["interface"], errors);
		}
		else {
			push(errors, [ location, "is required" ]);
		}

		function parseIkeGroups(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseName(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "name")) {
							obj.name = parseName(location + "/name", value["name"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						function parseKeyExchange(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							if (!(value in [ "ikev1", "ikev2" ]))
								push(errors, [ location, "must be one of \"ikev1\" or \"ikev2\"" ]);

							return value;
						}

						if (exists(value, "key-exchange")) {
							obj.key_exchange = parseKeyExchange(location + "/key-exchange", value["key-exchange"], errors);
						}
						else {
							obj.key_exchange = "ikev2";
						}

						function parseLifetime(location, value, errors) {
							if (type(value) != "int")
								push(errors, [ location, "must be of type integer" ]);

							return value;
						}

						if (exists(value, "lifetime")) {
							obj.lifetime = parseLifetime(location + "/lifetime", value["lifetime"], errors);
						}
						else {
							obj.lifetime = 28800;
						}

						function parseProposal(location, value, errors) {
							if (type(value) == "object") {
								let obj = {};

								function parseEncryption(location, value, errors) {
									if (type(value) != "string")
										push(errors, [ location, "must be of type string" ]);

									if (!(value in [ "aes128", "aes256", "aes128gcm", "aes256gcm", "3des" ]))
										push(errors, [ location, "must be one of \"aes128\", \"aes256\", \"aes128gcm\", \"aes256gcm\" or \"3des\"" ]);

									return value;
								}

								if (exists(value, "encryption")) {
									obj.encryption = parseEncryption(location + "/encryption", value["encryption"], errors);
								}
								else {
									push(errors, [ location, "is required" ]);
								}

								function parseHash(location, value, errors) {
									if (type(value) != "string")
										push(errors, [ location, "must be of type string" ]);

									if (!(value in [ "sha1", "sha256", "sha384", "sha512" ]))
										push(errors, [ location, "must be one of \"sha1\", \"sha256\", \"sha384\" or \"sha512\"" ]);

									return value;
								}

								if (exists(value, "hash")) {
									obj.hash = parseHash(location + "/hash", value["hash"], errors);
								}
								else {
									push(errors, [ location, "is required" ]);
								}

								function parseDhGroup(location, value, errors) {
									if (type(value) != "int")
										push(errors, [ location, "must be of type integer" ]);

									if (!(value in [ 2, 14, 15, 16, 19, 20, 21 ]))
										push(errors, [ location, "must be one of 2, 14, 15, 16, 19, 20 or 21" ]);

									return value;
								}

								if (exists(value, "dh-group")) {
									obj.dh_group = parseDhGroup(location + "/dh-group", value["dh-group"], errors);
								}
								else {
									push(errors, [ location, "is required" ]);
								}

								return obj;
							}

							if (type(value) != "object")
								push(errors, [ location, "must be of type object" ]);

							return value;
						}

						if (exists(value, "proposal")) {
							obj.proposal = parseProposal(location + "/proposal", value["proposal"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						function parseDeadPeerDetection(location, value, errors) {
							if (type(value) == "object") {
								let obj = {};

								function parseAction(location, value, errors) {
									if (type(value) != "string")
										push(errors, [ location, "must be of type string" ]);

									if (!(value in [ "restart", "clear", "hold", "none" ]))
										push(errors, [ location, "must be one of \"restart\", \"clear\", \"hold\" or \"none\"" ]);

									return value;
								}

								if (exists(value, "action")) {
									obj.action = parseAction(location + "/action", value["action"], errors);
								}

								function parseInterval(location, value, errors) {
									if (type(value) != "int")
										push(errors, [ location, "must be of type integer" ]);

									return value;
								}

								if (exists(value, "interval")) {
									obj.interval = parseInterval(location + "/interval", value["interval"], errors);
								}
								else {
									obj.interval = 30;
								}

								function parseTimeout(location, value, errors) {
									if (type(value) != "int")
										push(errors, [ location, "must be of type integer" ]);

									return value;
								}

								if (exists(value, "timeout")) {
									obj.timeout = parseTimeout(location + "/timeout", value["timeout"], errors);
								}
								else {
									obj.timeout = 120;
								}

								return obj;
							}

							if (type(value) != "object")
								push(errors, [ location, "must be of type object" ]);

							return value;
						}

						if (exists(value, "dead-peer-detection")) {
							obj.dead_peer_detection = parseDeadPeerDetection(location + "/dead-peer-detection", value["dead-peer-detection"], errors);
						}

						function parseCloseAction(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							if (!(value in [ "none", "start", "hold" ]))
								push(errors, [ location, "must be one of \"none\", \"start\" or \"hold\"" ]);

							return value;
						}

						if (exists(value, "close-action")) {
							obj.close_action = parseCloseAction(location + "/close-action", value["close-action"], errors);
						}
						else {
							obj.close_action = "none";
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "ike-groups")) {
			obj.ike_groups = parseIkeGroups(location + "/ike-groups", value["ike-groups"], errors);
		}
		else {
			push(errors, [ location, "is required" ]);
		}

		function parseEspGroups(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseName(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "name")) {
							obj.name = parseName(location + "/name", value["name"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						function parseLifetime(location, value, errors) {
							if (type(value) != "int")
								push(errors, [ location, "must be of type integer" ]);

							return value;
						}

						if (exists(value, "lifetime")) {
							obj.lifetime = parseLifetime(location + "/lifetime", value["lifetime"], errors);
						}
						else {
							obj.lifetime = 3600;
						}

						function parseMode(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							if (!(value in [ "tunnel", "transport" ]))
								push(errors, [ location, "must be one of \"tunnel\" or \"transport\"" ]);

							return value;
						}

						if (exists(value, "mode")) {
							obj.mode = parseMode(location + "/mode", value["mode"], errors);
						}
						else {
							obj.mode = "tunnel";
						}

						function parsePfs(location, value, errors) {
							if (type(value) != "bool")
								push(errors, [ location, "must be of type boolean" ]);

							return value;
						}

						if (exists(value, "pfs")) {
							obj.pfs = parsePfs(location + "/pfs", value["pfs"], errors);
						}
						else {
							obj.pfs = true;
						}

						function parseProposal(location, value, errors) {
							if (type(value) == "object") {
								let obj = {};

								function parseEncryption(location, value, errors) {
									if (type(value) != "string")
										push(errors, [ location, "must be of type string" ]);

									if (!(value in [ "aes128", "aes256", "aes128gcm", "aes256gcm", "3des" ]))
										push(errors, [ location, "must be one of \"aes128\", \"aes256\", \"aes128gcm\", \"aes256gcm\" or \"3des\"" ]);

									return value;
								}

								if (exists(value, "encryption")) {
									obj.encryption = parseEncryption(location + "/encryption", value["encryption"], errors);
								}
								else {
									push(errors, [ location, "is required" ]);
								}

								function parseHash(location, value, errors) {
									if (type(value) != "string")
										push(errors, [ location, "must be of type string" ]);

									if (!(value in [ "sha1", "sha256", "sha384", "sha512" ]))
										push(errors, [ location, "must be one of \"sha1\", \"sha256\", \"sha384\" or \"sha512\"" ]);

									return value;
								}

								if (exists(value, "hash")) {
									obj.hash = parseHash(location + "/hash", value["hash"], errors);
								}
								else {
									push(errors, [ location, "is required" ]);
								}

								return obj;
							}

							if (type(value) != "object")
								push(errors, [ location, "must be of type object" ]);

							return value;
						}

						if (exists(value, "proposal")) {
							obj.proposal = parseProposal(location + "/proposal", value["proposal"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "esp-groups")) {
			obj.esp_groups = parseEspGroups(location + "/esp-groups", value["esp-groups"], errors);
		}
		else {
			push(errors, [ location, "is required" ]);
		}

		function parseAuthentication(location, value, errors) {
			if (type(value) == "object") {
				let obj = {};

				function parseId(location, value, errors) {
					if (type(value) == "array") {
						function parseItem(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
					}

					if (type(value) != "array")
						push(errors, [ location, "must be of type array" ]);

					return value;
				}

				if (exists(value, "id")) {
					obj.id = parseId(location + "/id", value["id"], errors);
				}
				else {
					push(errors, [ location, "is required" ]);
				}

				function parseSecret(location, value, errors) {
					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				if (exists(value, "secret")) {
					obj.secret = parseSecret(location + "/secret", value["secret"], errors);
				}
				else {
					push(errors, [ location, "is required" ]);
				}

				return obj;
			}

			if (type(value) != "object")
				push(errors, [ location, "must be of type object" ]);

			return value;
		}

		if (exists(value, "authentication")) {
			obj.authentication = parseAuthentication(location + "/authentication", value["authentication"], errors);
		}
		else {
			push(errors, [ location, "is required" ]);
		}

		function parsePeers(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseName(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "name")) {
							obj.name = parseName(location + "/name", value["name"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						function parseLocalAddress(location, value, errors) {
							if (type(value) == "string") {
								if (!matchIpv4(value))
									push(errors, [ location, "must be a valid IPv4 address" ]);

							}

							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "local-address")) {
							obj.local_address = parseLocalAddress(location + "/local-address", value["local-address"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						function parseRemoteAddress(location, value, errors) {
							if (type(value) == "string") {
								if (!matchIpv4(value))
									push(errors, [ location, "must be a valid IPv4 address" ]);

							}

							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "remote-address")) {
							obj.remote_address = parseRemoteAddress(location + "/remote-address", value["remote-address"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						function parseLocalId(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "local-id")) {
							obj.local_id = parseLocalId(location + "/local-id", value["local-id"], errors);
						}

						function parseRemoteId(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "remote-id")) {
							obj.remote_id = parseRemoteId(location + "/remote-id", value["remote-id"], errors);
						}

						function parseIkeGroup(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "ike-group")) {
							obj.ike_group = parseIkeGroup(location + "/ike-group", value["ike-group"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						function parseEspGroup(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "esp-group")) {
							obj.esp_group = parseEspGroup(location + "/esp-group", value["esp-group"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						function parseConnectionType(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							if (!(value in [ "initiate", "none", "trap" ]))
								push(errors, [ location, "must be one of \"initiate\", \"none\" or \"trap\"" ]);

							return value;
						}

						if (exists(value, "connection-type")) {
							obj.connection_type = parseConnectionType(location + "/connection-type", value["connection-type"], errors);
						}
						else {
							obj.connection_type = "none";
						}

						function parseTunnels(location, value, errors) {
							if (type(value) == "array") {
								function parseItem(location, value, errors) {
									if (type(value) == "object") {
										let obj = {};

										function parseLocalPrefix(location, value, errors) {
											if (type(value) == "string") {
												if (!matchUcCidr4(value))
													push(errors, [ location, "must be a valid IPv4 CIDR" ]);

											}

											if (type(value) != "string")
												push(errors, [ location, "must be of type string" ]);

											return value;
										}

										if (exists(value, "local-prefix")) {
											obj.local_prefix = parseLocalPrefix(location + "/local-prefix", value["local-prefix"], errors);
										}
										else {
											push(errors, [ location, "is required" ]);
										}

										function parseRemotePrefix(location, value, errors) {
											if (type(value) == "string") {
												if (!matchUcCidr4(value))
													push(errors, [ location, "must be a valid IPv4 CIDR" ]);

											}

											if (type(value) != "string")
												push(errors, [ location, "must be of type string" ]);

											return value;
										}

										if (exists(value, "remote-prefix")) {
											obj.remote_prefix = parseRemotePrefix(location + "/remote-prefix", value["remote-prefix"], errors);
										}
										else {
											push(errors, [ location, "is required" ]);
										}

										return obj;
									}

									if (type(value) != "object")
										push(errors, [ location, "must be of type object" ]);

									return value;
								}

								return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
							}

							if (type(value) != "array")
								push(errors, [ location, "must be of type array" ]);

							return value;
						}

						if (exists(value, "tunnels")) {
							obj.tunnels = parseTunnels(location + "/tunnels", value["tunnels"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "peers")) {
			obj.peers = parsePeers(location + "/peers", value["peers"], errors);
		}
		else {
			push(errors, [ location, "is required" ]);
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateVpnOpenvpn(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseServers(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseName(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "name")) {
							obj.name = parseName(location + "/name", value["name"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						function parseMode(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							if (!(value in [ "site-to-site", "server" ]))
								push(errors, [ location, "must be one of \"site-to-site\" or \"server\"" ]);

							return value;
						}

						if (exists(value, "mode")) {
							obj.mode = parseMode(location + "/mode", value["mode"], errors);
						}

						function parsePersistentTunnel(location, value, errors) {
							if (type(value) != "bool")
								push(errors, [ location, "must be of type boolean" ]);

							return value;
						}

						if (exists(value, "persistent-tunnel")) {
							obj.persistent_tunnel = parsePersistentTunnel(location + "/persistent-tunnel", value["persistent-tunnel"], errors);
						}
						else {
							obj.persistent_tunnel = false;
						}

						function parseProtocol(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							if (!(value in [ "udp", "tcp" ]))
								push(errors, [ location, "must be one of \"udp\" or \"tcp\"" ]);

							return value;
						}

						if (exists(value, "protocol")) {
							obj.protocol = parseProtocol(location + "/protocol", value["protocol"], errors);
						}
						else {
							obj.protocol = "udp";
						}

						function parseAddress(location, value, errors) {
							if (type(value) == "string") {
								if (!matchUcIp(value))
									push(errors, [ location, "must be a valid IPv4 or IPv6 address" ]);

							}

							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "address")) {
							obj.address = parseAddress(location + "/address", value["address"], errors);
						}

						function parsePort(location, value, errors) {
							if (type(value) in [ "int", "double" ]) {
								if (value > 65535)
									push(errors, [ location, "must be lower than or equal to 65535" ]);

							}

							if (type(value) != "int")
								push(errors, [ location, "must be of type integer" ]);

							return value;
						}

						if (exists(value, "port")) {
							obj.port = parsePort(location + "/port", value["port"], errors);
						}
						else {
							obj.port = 1194;
						}

						function parseSubnet(location, value, errors) {
							if (type(value) == "string") {
								if (!matchUcCidr(value))
									push(errors, [ location, "must be a valid IPv4 or IPv6 CIDR" ]);

							}

							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "subnet")) {
							obj.subnet = parseSubnet(location + "/subnet", value["subnet"], errors);
						}

						function parseEncryption(location, value, errors) {
							if (type(value) == "object") {
								let obj = {};

								function parseCipher(location, value, errors) {
									if (type(value) != "string")
										push(errors, [ location, "must be of type string" ]);

									if (!(value in [ "none", "3des", "aes128", "aes128gcm", "aes192", "aes192gcm", "aes256", "aes256gcm" ]))
										push(errors, [ location, "must be one of \"none\", \"3des\", \"aes128\", \"aes128gcm\", \"aes192\", \"aes192gcm\", \"aes256\" or \"aes256gcm\"" ]);

									return value;
								}

								if (exists(value, "cipher")) {
									obj.cipher = parseCipher(location + "/cipher", value["cipher"], errors);
								}

								function parseDataCiphers(location, value, errors) {
									if (type(value) == "array") {
										function parseItem(location, value, errors) {
											if (type(value) != "string")
												push(errors, [ location, "must be of type string" ]);

											if (!(value in [ "none", "3des", "aes128", "aes128gcm", "aes192", "aes192gcm", "aes256", "aes256gcm" ]))
												push(errors, [ location, "must be one of \"none\", \"3des\", \"aes128\", \"aes128gcm\", \"aes192\", \"aes192gcm\", \"aes256\" or \"aes256gcm\"" ]);

											return value;
										}

										return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
									}

									if (type(value) != "array")
										push(errors, [ location, "must be of type array" ]);

									return value;
								}

								if (exists(value, "data-ciphers")) {
									obj.data_ciphers = parseDataCiphers(location + "/data-ciphers", value["data-ciphers"], errors);
								}

								return obj;
							}

							if (type(value) != "object")
								push(errors, [ location, "must be of type object" ]);

							return value;
						}

						if (exists(value, "encryption")) {
							obj.encryption = parseEncryption(location + "/encryption", value["encryption"], errors);
						}

						function parseHash(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							if (!(value in [ "md5", "sha1", "sha256", "sha384", "sha512" ]))
								push(errors, [ location, "must be one of \"md5\", \"sha1\", \"sha256\", \"sha384\" or \"sha512\"" ]);

							return value;
						}

						if (exists(value, "hash")) {
							obj.hash = parseHash(location + "/hash", value["hash"], errors);
						}

						function parseTls(location, value, errors) {
							if (type(value) == "object") {
								let obj = {};

								function parseCaCert(location, value, errors) {
									if (type(value) != "string")
										push(errors, [ location, "must be of type string" ]);

									return value;
								}

								if (exists(value, "ca-cert")) {
									obj.ca_cert = parseCaCert(location + "/ca-cert", value["ca-cert"], errors);
								}

								function parseCert(location, value, errors) {
									if (type(value) != "string")
										push(errors, [ location, "must be of type string" ]);

									return value;
								}

								if (exists(value, "cert")) {
									obj.cert = parseCert(location + "/cert", value["cert"], errors);
								}

								function parseDh(location, value, errors) {
									if (type(value) != "string")
										push(errors, [ location, "must be of type string" ]);

									return value;
								}

								if (exists(value, "dh")) {
									obj.dh = parseDh(location + "/dh", value["dh"], errors);
								}

								return obj;
							}

							if (type(value) != "object")
								push(errors, [ location, "must be of type object" ]);

							return value;
						}

						if (exists(value, "tls")) {
							obj.tls = parseTls(location + "/tls", value["tls"], errors);
						}

						function parseTopology(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							if (!(value in [ "subnet", "point-to-point" ]))
								push(errors, [ location, "must be one of \"subnet\" or \"point-to-point\"" ]);

							return value;
						}

						if (exists(value, "topology")) {
							obj.topology = parseTopology(location + "/topology", value["topology"], errors);
						}

						function parseDomain(location, value, errors) {
							if (type(value) == "string") {
								if (!matchHostname(value))
									push(errors, [ location, "must be a valid hostname" ]);

							}

							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "domain")) {
							obj.domain = parseDomain(location + "/domain", value["domain"], errors);
						}

						function parseMaxConnections(location, value, errors) {
							if (type(value) in [ "int", "double" ]) {
								if (value > 4096)
									push(errors, [ location, "must be lower than or equal to 4096" ]);

								if (value < 1)
									push(errors, [ location, "must be bigger than or equal to 1" ]);

							}

							if (type(value) != "int")
								push(errors, [ location, "must be of type integer" ]);

							return value;
						}

						if (exists(value, "max-connections")) {
							obj.max_connections = parseMaxConnections(location + "/max-connections", value["max-connections"], errors);
						}

						function parseNameServer(location, value, errors) {
							if (type(value) == "string") {
								if (!matchUcIp(value))
									push(errors, [ location, "must be a valid IPv4 or IPv6 address" ]);

							}

							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "name-server")) {
							obj.name_server = parseNameServer(location + "/name-server", value["name-server"], errors);
						}

						function parseClients(location, value, errors) {
							if (type(value) == "array") {
								function parseItem(location, value, errors) {
									if (type(value) == "object") {
										let obj = {};

										function parseAddress(location, value, errors) {
											if (type(value) == "string") {
												if (!matchUcIp(value))
													push(errors, [ location, "must be a valid IPv4 or IPv6 address" ]);

											}

											if (type(value) != "string")
												push(errors, [ location, "must be of type string" ]);

											return value;
										}

										if (exists(value, "address")) {
											obj.address = parseAddress(location + "/address", value["address"], errors);
										}

										function parseSubnet(location, value, errors) {
											if (type(value) == "string") {
												if (!matchUcCidr(value))
													push(errors, [ location, "must be a valid IPv4 or IPv6 CIDR" ]);

											}

											if (type(value) != "string")
												push(errors, [ location, "must be of type string" ]);

											return value;
										}

										if (exists(value, "subnet")) {
											obj.subnet = parseSubnet(location + "/subnet", value["subnet"], errors);
										}

										function parseCert(location, value, errors) {
											if (type(value) != "string")
												push(errors, [ location, "must be of type string" ]);

											return value;
										}

										if (exists(value, "cert")) {
											obj.cert = parseCert(location + "/cert", value["cert"], errors);
										}

										return obj;
									}

									if (type(value) != "object")
										push(errors, [ location, "must be of type object" ]);

									return value;
								}

								return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
							}

							if (type(value) != "array")
								push(errors, [ location, "must be of type array" ]);

							return value;
						}

						if (exists(value, "clients")) {
							obj.clients = parseClients(location + "/clients", value["clients"], errors);
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "servers")) {
			obj.servers = parseServers(location + "/servers", value["servers"], errors);
		}

		function parseClients(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseName(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "name")) {
							obj.name = parseName(location + "/name", value["name"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						function parseInterface(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "interface")) {
							obj.interface = parseInterface(location + "/interface", value["interface"], errors);
						}

						function parseAuthentication(location, value, errors) {
							if (type(value) == "object") {
								let obj = {};

								function parseUsername(location, value, errors) {
									if (type(value) != "string")
										push(errors, [ location, "must be of type string" ]);

									return value;
								}

								if (exists(value, "username")) {
									obj.username = parseUsername(location + "/username", value["username"], errors);
								}

								function parsePassword(location, value, errors) {
									if (type(value) != "string")
										push(errors, [ location, "must be of type string" ]);

									return value;
								}

								if (exists(value, "password")) {
									obj.password = parsePassword(location + "/password", value["password"], errors);
								}

								return obj;
							}

							if (type(value) != "object")
								push(errors, [ location, "must be of type object" ]);

							return value;
						}

						if (exists(value, "authentication")) {
							obj.authentication = parseAuthentication(location + "/authentication", value["authentication"], errors);
						}

						function parseMode(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							if (!(value in [ "site-to-site", "client" ]))
								push(errors, [ location, "must be one of \"site-to-site\" or \"client\"" ]);

							return value;
						}

						if (exists(value, "mode")) {
							obj.mode = parseMode(location + "/mode", value["mode"], errors);
						}

						function parseEncryption(location, value, errors) {
							if (type(value) == "object") {
								let obj = {};

								function parseCipher(location, value, errors) {
									if (type(value) != "string")
										push(errors, [ location, "must be of type string" ]);

									if (!(value in [ "none", "3des", "aes128", "aes128gcm", "aes192", "aes192gcm", "aes256", "aes256gcm" ]))
										push(errors, [ location, "must be one of \"none\", \"3des\", \"aes128\", \"aes128gcm\", \"aes192\", \"aes192gcm\", \"aes256\" or \"aes256gcm\"" ]);

									return value;
								}

								if (exists(value, "cipher")) {
									obj.cipher = parseCipher(location + "/cipher", value["cipher"], errors);
								}

								function parseDataCiphers(location, value, errors) {
									if (type(value) == "array") {
										function parseItem(location, value, errors) {
											if (type(value) != "string")
												push(errors, [ location, "must be of type string" ]);

											if (!(value in [ "none", "3des", "aes128", "aes128gcm", "aes192", "aes192gcm", "aes256", "aes256gcm" ]))
												push(errors, [ location, "must be one of \"none\", \"3des\", \"aes128\", \"aes128gcm\", \"aes192\", \"aes192gcm\", \"aes256\" or \"aes256gcm\"" ]);

											return value;
										}

										return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
									}

									if (type(value) != "array")
										push(errors, [ location, "must be of type array" ]);

									return value;
								}

								if (exists(value, "data-ciphers")) {
									obj.data_ciphers = parseDataCiphers(location + "/data-ciphers", value["data-ciphers"], errors);
								}

								return obj;
							}

							if (type(value) != "object")
								push(errors, [ location, "must be of type object" ]);

							return value;
						}

						if (exists(value, "encryption")) {
							obj.encryption = parseEncryption(location + "/encryption", value["encryption"], errors);
						}

						function parseHash(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							if (!(value in [ "md5", "sha1", "sha256", "sha384", "sha512" ]))
								push(errors, [ location, "must be one of \"md5\", \"sha1\", \"sha256\", \"sha384\" or \"sha512\"" ]);

							return value;
						}

						if (exists(value, "hash")) {
							obj.hash = parseHash(location + "/hash", value["hash"], errors);
						}

						function parsePersistentTunnel(location, value, errors) {
							if (type(value) != "bool")
								push(errors, [ location, "must be of type boolean" ]);

							return value;
						}

						if (exists(value, "persistent-tunnel")) {
							obj.persistent_tunnel = parsePersistentTunnel(location + "/persistent-tunnel", value["persistent-tunnel"], errors);
						}
						else {
							obj.persistent_tunnel = false;
						}

						function parsePersistKey(location, value, errors) {
							if (type(value) != "bool")
								push(errors, [ location, "must be of type boolean" ]);

							return value;
						}

						if (exists(value, "persist-key")) {
							obj.persist_key = parsePersistKey(location + "/persist-key", value["persist-key"], errors);
						}
						else {
							obj.persist_key = false;
						}

						function parseRemoteHost(location, value, errors) {
							if (type(value) == "string") {
								if (!matchUcIp(value))
									push(errors, [ location, "must be a valid IPv4 or IPv6 address" ]);

							}

							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "remote-host")) {
							obj.remote_host = parseRemoteHost(location + "/remote-host", value["remote-host"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						function parseRemotePort(location, value, errors) {
							if (type(value) in [ "int", "double" ]) {
								if (value > 65535)
									push(errors, [ location, "must be lower than or equal to 65535" ]);

							}

							if (type(value) != "int")
								push(errors, [ location, "must be of type integer" ]);

							return value;
						}

						if (exists(value, "remote-port")) {
							obj.remote_port = parseRemotePort(location + "/remote-port", value["remote-port"], errors);
						}
						else {
							obj.remote_port = 1194;
						}

						function parseProtocol(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							if (!(value in [ "udp", "tcp" ]))
								push(errors, [ location, "must be one of \"udp\" or \"tcp\"" ]);

							return value;
						}

						if (exists(value, "protocol")) {
							obj.protocol = parseProtocol(location + "/protocol", value["protocol"], errors);
						}
						else {
							obj.protocol = "udp";
						}

						function parseTls(location, value, errors) {
							if (type(value) == "object") {
								let obj = {};

								function parseCaCert(location, value, errors) {
									if (type(value) != "string")
										push(errors, [ location, "must be of type string" ]);

									return value;
								}

								if (exists(value, "ca-cert")) {
									obj.ca_cert = parseCaCert(location + "/ca-cert", value["ca-cert"], errors);
								}

								function parseCert(location, value, errors) {
									if (type(value) != "string")
										push(errors, [ location, "must be of type string" ]);

									return value;
								}

								if (exists(value, "cert")) {
									obj.cert = parseCert(location + "/cert", value["cert"], errors);
								}

								function parsePrivateKey(location, value, errors) {
									if (type(value) != "string")
										push(errors, [ location, "must be of type string" ]);

									return value;
								}

								if (exists(value, "private-key")) {
									obj.private_key = parsePrivateKey(location + "/private-key", value["private-key"], errors);
								}

								return obj;
							}

							if (type(value) != "object")
								push(errors, [ location, "must be of type object" ]);

							return value;
						}

						if (exists(value, "tls")) {
							obj.tls = parseTls(location + "/tls", value["tls"], errors);
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "clients")) {
			obj.clients = parseClients(location + "/clients", value["clients"], errors);
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateVpnWireguard(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseInterfaces(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseName(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "name")) {
							obj.name = parseName(location + "/name", value["name"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						function parsePrivateKey(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "private-key")) {
							obj.private_key = parsePrivateKey(location + "/private-key", value["private-key"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						function parseAddress(location, value, errors) {
							if (type(value) == "string") {
								if (!matchUcIp(value))
									push(errors, [ location, "must be a valid IPv4 or IPv6 address" ]);

							}

							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "address")) {
							obj.address = parseAddress(location + "/address", value["address"], errors);
						}

						function parsePort(location, value, errors) {
							if (type(value) != "int")
								push(errors, [ location, "must be of type integer" ]);

							return value;
						}

						if (exists(value, "port")) {
							obj.port = parsePort(location + "/port", value["port"], errors);
						}

						function parsePeers(location, value, errors) {
							if (type(value) == "array") {
								function parseItem(location, value, errors) {
									if (type(value) == "object") {
										let obj = {};

										function parseName(location, value, errors) {
											if (type(value) != "string")
												push(errors, [ location, "must be of type string" ]);

											return value;
										}

										if (exists(value, "name")) {
											obj.name = parseName(location + "/name", value["name"], errors);
										}
										else {
											push(errors, [ location, "is required" ]);
										}

										function parsePublicKey(location, value, errors) {
											if (type(value) != "string")
												push(errors, [ location, "must be of type string" ]);

											return value;
										}

										if (exists(value, "public-key")) {
											obj.public_key = parsePublicKey(location + "/public-key", value["public-key"], errors);
										}
										else {
											push(errors, [ location, "is required" ]);
										}

										function parseAllowedIps(location, value, errors) {
											if (type(value) == "array") {
												function parseItem(location, value, errors) {
													if (type(value) == "string") {
														if (!matchUcCidr(value))
															push(errors, [ location, "must be a valid IPv4 or IPv6 CIDR" ]);

													}

													if (type(value) != "string")
														push(errors, [ location, "must be of type string" ]);

													return value;
												}

												return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
											}

											if (type(value) != "array")
												push(errors, [ location, "must be of type array" ]);

											return value;
										}

										if (exists(value, "allowed-ips")) {
											obj.allowed_ips = parseAllowedIps(location + "/allowed-ips", value["allowed-ips"], errors);
										}
										else {
											push(errors, [ location, "is required" ]);
										}

										function parseEndpoint(location, value, errors) {
											if (type(value) == "object") {
												let obj = {};

												function parseAddress(location, value, errors) {
													if (type(value) == "string") {
														if (!matchUcIp(value))
															push(errors, [ location, "must be a valid IPv4 or IPv6 address" ]);

													}

													if (type(value) != "string")
														push(errors, [ location, "must be of type string" ]);

													return value;
												}

												if (exists(value, "address")) {
													obj.address = parseAddress(location + "/address", value["address"], errors);
												}
												else {
													push(errors, [ location, "is required" ]);
												}

												function parsePort(location, value, errors) {
													if (type(value) in [ "int", "double" ]) {
														if (value > 65535)
															push(errors, [ location, "must be lower than or equal to 65535" ]);

													}

													if (type(value) != "int")
														push(errors, [ location, "must be of type integer" ]);

													return value;
												}

												if (exists(value, "port")) {
													obj.port = parsePort(location + "/port", value["port"], errors);
												}
												else {
													obj.port = 51820;
												}

												return obj;
											}

											if (type(value) != "object")
												push(errors, [ location, "must be of type object" ]);

											return value;
										}

										if (exists(value, "endpoint")) {
											obj.endpoint = parseEndpoint(location + "/endpoint", value["endpoint"], errors);
										}

										function parsePersistentKeepalive(location, value, errors) {
											if (type(value) != "int")
												push(errors, [ location, "must be of type integer" ]);

											return value;
										}

										if (exists(value, "persistent-keepalive")) {
											obj.persistent_keepalive = parsePersistentKeepalive(location + "/persistent-keepalive", value["persistent-keepalive"], errors);
										}

										return obj;
									}

									if (type(value) != "object")
										push(errors, [ location, "must be of type object" ]);

									return value;
								}

								return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
							}

							if (type(value) != "array")
								push(errors, [ location, "must be of type array" ]);

							return value;
						}

						if (exists(value, "peers")) {
							obj.peers = parsePeers(location + "/peers", value["peers"], errors);
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "interfaces")) {
			obj.interfaces = parseInterfaces(location + "/interfaces", value["interfaces"], errors);
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateVpn(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		if (exists(value, "ipsec")) {
			obj.ipsec = instantiateVpnIpsec(location + "/ipsec", value["ipsec"], errors);
		}

		if (exists(value, "openvpn")) {
			obj.openvpn = instantiateVpnOpenvpn(location + "/openvpn", value["openvpn"], errors);
		}

		if (exists(value, "wireguard")) {
			obj.wireguard = instantiateVpnWireguard(location + "/wireguard", value["wireguard"], errors);
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateHighAvailabilityVrrp(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseGroups(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseName(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "name")) {
							obj.name = parseName(location + "/name", value["name"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						function parseVirtualAddresses(location, value, errors) {
							if (type(value) == "array") {
								function parseItem(location, value, errors) {
									if (type(value) != "string")
										push(errors, [ location, "must be of type string" ]);

									return value;
								}

								return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
							}

							if (type(value) != "array")
								push(errors, [ location, "must be of type array" ]);

							return value;
						}

						if (exists(value, "virtual-addresses")) {
							obj.virtual_addresses = parseVirtualAddresses(location + "/virtual-addresses", value["virtual-addresses"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						function parsePriority(location, value, errors) {
							if (type(value) in [ "int", "double" ]) {
								if (value > 255)
									push(errors, [ location, "must be lower than or equal to 255" ]);

								if (value < 1)
									push(errors, [ location, "must be bigger than or equal to 1" ]);

							}

							if (type(value) != "int")
								push(errors, [ location, "must be of type integer" ]);

							return value;
						}

						if (exists(value, "priority")) {
							obj.priority = parsePriority(location + "/priority", value["priority"], errors);
						}
						else {
							obj.priority = 100;
						}

						function parseInterface(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "interface")) {
							obj.interface = parseInterface(location + "/interface", value["interface"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						function parseVrid(location, value, errors) {
							if (type(value) in [ "int", "double" ]) {
								if (value > 255)
									push(errors, [ location, "must be lower than or equal to 255" ]);

								if (value < 1)
									push(errors, [ location, "must be bigger than or equal to 1" ]);

							}

							if (type(value) != "int")
								push(errors, [ location, "must be of type integer" ]);

							return value;
						}

						if (exists(value, "vrid")) {
							obj.vrid = parseVrid(location + "/vrid", value["vrid"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						function parsePreempt(location, value, errors) {
							if (type(value) != "bool")
								push(errors, [ location, "must be of type boolean" ]);

							return value;
						}

						if (exists(value, "preempt")) {
							obj.preempt = parsePreempt(location + "/preempt", value["preempt"], errors);
						}
						else {
							obj.preempt = true;
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "groups")) {
			obj.groups = parseGroups(location + "/groups", value["groups"], errors);
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateHighAvailabilityLoadBalancing(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseInterfaces(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseName(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "name")) {
							obj.name = parseName(location + "/name", value["name"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						function parseWeight(location, value, errors) {
							if (type(value) != "int")
								push(errors, [ location, "must be of type integer" ]);

							return value;
						}

						if (exists(value, "weight")) {
							obj.weight = parseWeight(location + "/weight", value["weight"], errors);
						}
						else {
							obj.weight = 1;
						}

						function parseFailoverOnly(location, value, errors) {
							if (type(value) != "bool")
								push(errors, [ location, "must be of type boolean" ]);

							return value;
						}

						if (exists(value, "failover-only")) {
							obj.failover_only = parseFailoverOnly(location + "/failover-only", value["failover-only"], errors);
						}
						else {
							obj.failover_only = false;
						}

						function parseHealthCheck(location, value, errors) {
							if (type(value) == "object") {
								let obj = {};

								function parseTarget(location, value, errors) {
									if (type(value) != "string")
										push(errors, [ location, "must be of type string" ]);

									return value;
								}

								if (exists(value, "target")) {
									obj.target = parseTarget(location + "/target", value["target"], errors);
								}

								function parseInterval(location, value, errors) {
									if (type(value) != "int")
										push(errors, [ location, "must be of type integer" ]);

									return value;
								}

								if (exists(value, "interval")) {
									obj.interval = parseInterval(location + "/interval", value["interval"], errors);
								}
								else {
									obj.interval = 5;
								}

								return obj;
							}

							if (type(value) != "object")
								push(errors, [ location, "must be of type object" ]);

							return value;
						}

						if (exists(value, "health-check")) {
							obj.health_check = parseHealthCheck(location + "/health-check", value["health-check"], errors);
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "interfaces")) {
			obj.interfaces = parseInterfaces(location + "/interfaces", value["interfaces"], errors);
		}

		function parseRules(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseId(location, value, errors) {
							if (type(value) in [ "int", "double" ]) {
								if (value > 9999)
									push(errors, [ location, "must be lower than or equal to 9999" ]);

								if (value < 1)
									push(errors, [ location, "must be bigger than or equal to 1" ]);

							}

							if (type(value) != "int")
								push(errors, [ location, "must be of type integer" ]);

							return value;
						}

						if (exists(value, "id")) {
							obj.id = parseId(location + "/id", value["id"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						function parseSource(location, value, errors) {
							if (type(value) == "string") {
								if (!matchUcCidr(value))
									push(errors, [ location, "must be a valid IPv4 or IPv6 CIDR" ]);

							}

							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "source")) {
							obj.source = parseSource(location + "/source", value["source"], errors);
						}

						function parseDestination(location, value, errors) {
							if (type(value) == "string") {
								if (!matchUcCidr(value))
									push(errors, [ location, "must be a valid IPv4 or IPv6 CIDR" ]);

							}

							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "destination")) {
							obj.destination = parseDestination(location + "/destination", value["destination"], errors);
						}

						function parseInboundInterface(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "inbound-interface")) {
							obj.inbound_interface = parseInboundInterface(location + "/inbound-interface", value["inbound-interface"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						function parseWanInterfaces(location, value, errors) {
							if (type(value) == "array") {
								function parseItem(location, value, errors) {
									if (type(value) != "string")
										push(errors, [ location, "must be of type string" ]);

									return value;
								}

								return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
							}

							if (type(value) != "array")
								push(errors, [ location, "must be of type array" ]);

							return value;
						}

						if (exists(value, "wan-interfaces")) {
							obj.wan_interfaces = parseWanInterfaces(location + "/wan-interfaces", value["wan-interfaces"], errors);
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "rules")) {
			obj.rules = parseRules(location + "/rules", value["rules"], errors);
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateHighAvailability(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		if (exists(value, "vrrp")) {
			obj.vrrp = instantiateHighAvailabilityVrrp(location + "/vrrp", value["vrrp"], errors);
		}

		if (exists(value, "load-balancing")) {
			obj.load_balancing = instantiateHighAvailabilityLoadBalancing(location + "/load-balancing", value["load-balancing"], errors);
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateServiceDhcpServer(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseNetworks(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseName(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "name")) {
							obj.name = parseName(location + "/name", value["name"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						function parseSubnets(location, value, errors) {
							if (type(value) == "array") {
								function parseItem(location, value, errors) {
									if (type(value) == "object") {
										let obj = {};

										function parseSubnet(location, value, errors) {
											if (type(value) == "string") {
												if (!matchUcCidr4(value))
													push(errors, [ location, "must be a valid IPv4 CIDR" ]);

											}

											if (type(value) != "string")
												push(errors, [ location, "must be of type string" ]);

											return value;
										}

										if (exists(value, "subnet")) {
											obj.subnet = parseSubnet(location + "/subnet", value["subnet"], errors);
										}
										else {
											push(errors, [ location, "is required" ]);
										}

										function parseDefaultRouter(location, value, errors) {
											if (type(value) == "string") {
												if (!matchIpv4(value))
													push(errors, [ location, "must be a valid IPv4 address" ]);

											}

											if (type(value) != "string")
												push(errors, [ location, "must be of type string" ]);

											return value;
										}

										if (exists(value, "default-router")) {
											obj.default_router = parseDefaultRouter(location + "/default-router", value["default-router"], errors);
										}

										function parseDnsServers(location, value, errors) {
											if (type(value) == "array") {
												function parseItem(location, value, errors) {
													if (type(value) == "string") {
														if (!matchIpv4(value))
															push(errors, [ location, "must be a valid IPv4 address" ]);

													}

													if (type(value) != "string")
														push(errors, [ location, "must be of type string" ]);

													return value;
												}

												return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
											}

											if (type(value) != "array")
												push(errors, [ location, "must be of type array" ]);

											return value;
										}

										if (exists(value, "dns-servers")) {
											obj.dns_servers = parseDnsServers(location + "/dns-servers", value["dns-servers"], errors);
										}

										function parseDomainName(location, value, errors) {
											if (type(value) != "string")
												push(errors, [ location, "must be of type string" ]);

											return value;
										}

										if (exists(value, "domain-name")) {
											obj.domain_name = parseDomainName(location + "/domain-name", value["domain-name"], errors);
										}

										function parseLeaseTime(location, value, errors) {
											if (type(value) != "int")
												push(errors, [ location, "must be of type integer" ]);

											return value;
										}

										if (exists(value, "lease-time")) {
											obj.lease_time = parseLeaseTime(location + "/lease-time", value["lease-time"], errors);
										}
										else {
											obj.lease_time = 86400;
										}

										function parseRanges(location, value, errors) {
											if (type(value) == "array") {
												function parseItem(location, value, errors) {
													if (type(value) == "object") {
														let obj = {};

														function parseStart(location, value, errors) {
															if (type(value) == "string") {
																if (!matchIpv4(value))
																	push(errors, [ location, "must be a valid IPv4 address" ]);

															}

															if (type(value) != "string")
																push(errors, [ location, "must be of type string" ]);

															return value;
														}

														if (exists(value, "start")) {
															obj.start = parseStart(location + "/start", value["start"], errors);
														}
														else {
															push(errors, [ location, "is required" ]);
														}

														function parseStop(location, value, errors) {
															if (type(value) == "string") {
																if (!matchIpv4(value))
																	push(errors, [ location, "must be a valid IPv4 address" ]);

															}

															if (type(value) != "string")
																push(errors, [ location, "must be of type string" ]);

															return value;
														}

														if (exists(value, "stop")) {
															obj.stop = parseStop(location + "/stop", value["stop"], errors);
														}
														else {
															push(errors, [ location, "is required" ]);
														}

														return obj;
													}

													if (type(value) != "object")
														push(errors, [ location, "must be of type object" ]);

													return value;
												}

												return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
											}

											if (type(value) != "array")
												push(errors, [ location, "must be of type array" ]);

											return value;
										}

										if (exists(value, "ranges")) {
											obj.ranges = parseRanges(location + "/ranges", value["ranges"], errors);
										}

										function parseStaticMappings(location, value, errors) {
											if (type(value) == "array") {
												function parseItem(location, value, errors) {
													if (type(value) == "object") {
														let obj = {};

														function parseName(location, value, errors) {
															if (type(value) != "string")
																push(errors, [ location, "must be of type string" ]);

															return value;
														}

														if (exists(value, "name")) {
															obj.name = parseName(location + "/name", value["name"], errors);
														}

														function parseMacAddress(location, value, errors) {
															if (type(value) == "string") {
																if (!matchUcMac(value))
																	push(errors, [ location, "must be a valid MAC address" ]);

															}

															if (type(value) != "string")
																push(errors, [ location, "must be of type string" ]);

															return value;
														}

														if (exists(value, "mac-address")) {
															obj.mac_address = parseMacAddress(location + "/mac-address", value["mac-address"], errors);
														}

														function parseIpAddress(location, value, errors) {
															if (type(value) == "string") {
																if (!matchIpv4(value))
																	push(errors, [ location, "must be a valid IPv4 address" ]);

															}

															if (type(value) != "string")
																push(errors, [ location, "must be of type string" ]);

															return value;
														}

														if (exists(value, "ip-address")) {
															obj.ip_address = parseIpAddress(location + "/ip-address", value["ip-address"], errors);
														}

														return obj;
													}

													if (type(value) != "object")
														push(errors, [ location, "must be of type object" ]);

													return value;
												}

												return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
											}

											if (type(value) != "array")
												push(errors, [ location, "must be of type array" ]);

											return value;
										}

										if (exists(value, "static-mappings")) {
											obj.static_mappings = parseStaticMappings(location + "/static-mappings", value["static-mappings"], errors);
										}

										return obj;
									}

									if (type(value) != "object")
										push(errors, [ location, "must be of type object" ]);

									return value;
								}

								return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
							}

							if (type(value) != "array")
								push(errors, [ location, "must be of type array" ]);

							return value;
						}

						if (exists(value, "subnets")) {
							obj.subnets = parseSubnets(location + "/subnets", value["subnets"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "networks")) {
			obj.networks = parseNetworks(location + "/networks", value["networks"], errors);
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateServiceDhcpRelay(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseListenInterfaces(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "listen-interfaces")) {
			obj.listen_interfaces = parseListenInterfaces(location + "/listen-interfaces", value["listen-interfaces"], errors);
		}

		function parseUpstreamInterfaces(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "upstream-interfaces")) {
			obj.upstream_interfaces = parseUpstreamInterfaces(location + "/upstream-interfaces", value["upstream-interfaces"], errors);
		}

		function parseServers(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "string") {
						if (!matchIpv4(value))
							push(errors, [ location, "must be a valid IPv4 address" ]);

					}

					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "servers")) {
			obj.servers = parseServers(location + "/servers", value["servers"], errors);
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateServiceDns(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseDomains(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "domains")) {
			obj.domains = parseDomains(location + "/domains", value["domains"], errors);
		}

		function parseForwardingServers(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseAddress(location, value, errors) {
							if (type(value) == "string") {
								if (!matchUcIp(value))
									push(errors, [ location, "must be a valid IPv4 or IPv6 address" ]);

							}

							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "address")) {
							obj.address = parseAddress(location + "/address", value["address"], errors);
						}

						function parsePort(location, value, errors) {
							if (type(value) in [ "int", "double" ]) {
								if (value > 65535)
									push(errors, [ location, "must be lower than or equal to 65535" ]);

							}

							if (type(value) != "int")
								push(errors, [ location, "must be of type integer" ]);

							return value;
						}

						if (exists(value, "port")) {
							obj.port = parsePort(location + "/port", value["port"], errors);
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "forwarding-servers")) {
			obj.forwarding_servers = parseForwardingServers(location + "/forwarding-servers", value["forwarding-servers"], errors);
		}

		function parseAllowFrom(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "string") {
						if (!matchUcCidr(value))
							push(errors, [ location, "must be a valid IPv4 or IPv6 CIDR" ]);

					}

					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "allow-from")) {
			obj.allow_from = parseAllowFrom(location + "/allow-from", value["allow-from"], errors);
		}

		function parseListenAddresses(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "string") {
						if (!matchUcIp(value))
							push(errors, [ location, "must be a valid IPv4 or IPv6 address" ]);

					}

					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "listen-addresses")) {
			obj.listen_addresses = parseListenAddresses(location + "/listen-addresses", value["listen-addresses"], errors);
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateServiceNtp(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseServers(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseAddress(location, value, errors) {
							if (type(value) == "string") {
								if (!matchUcHost(value))
									push(errors, [ location, "must be a valid hostname or IP address" ]);

							}

							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "address")) {
							obj.address = parseAddress(location + "/address", value["address"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						function parseNoSelect(location, value, errors) {
							if (type(value) != "bool")
								push(errors, [ location, "must be of type boolean" ]);

							return value;
						}

						if (exists(value, "no-select")) {
							obj.no_select = parseNoSelect(location + "/no-select", value["no-select"], errors);
						}
						else {
							obj.no_select = false;
						}

						function parseNts(location, value, errors) {
							if (type(value) != "bool")
								push(errors, [ location, "must be of type boolean" ]);

							return value;
						}

						if (exists(value, "nts")) {
							obj.nts = parseNts(location + "/nts", value["nts"], errors);
						}
						else {
							obj.nts = false;
						}

						function parsePool(location, value, errors) {
							if (type(value) != "bool")
								push(errors, [ location, "must be of type boolean" ]);

							return value;
						}

						if (exists(value, "pool")) {
							obj.pool = parsePool(location + "/pool", value["pool"], errors);
						}
						else {
							obj.pool = false;
						}

						function parsePrefer(location, value, errors) {
							if (type(value) != "bool")
								push(errors, [ location, "must be of type boolean" ]);

							return value;
						}

						if (exists(value, "prefer")) {
							obj.prefer = parsePrefer(location + "/prefer", value["prefer"], errors);
						}
						else {
							obj.prefer = false;
						}

						function parsePtp(location, value, errors) {
							if (type(value) != "bool")
								push(errors, [ location, "must be of type boolean" ]);

							return value;
						}

						if (exists(value, "ptp")) {
							obj.ptp = parsePtp(location + "/ptp", value["ptp"], errors);
						}
						else {
							obj.ptp = false;
						}

						function parseInterleave(location, value, errors) {
							if (type(value) != "bool")
								push(errors, [ location, "must be of type boolean" ]);

							return value;
						}

						if (exists(value, "interleave")) {
							obj.interleave = parseInterleave(location + "/interleave", value["interleave"], errors);
						}
						else {
							obj.interleave = false;
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "servers")) {
			obj.servers = parseServers(location + "/servers", value["servers"], errors);
		}

		function parseListenIpv4Address(location, value, errors) {
			if (type(value) == "string") {
				if (!matchIpv4(value))
					push(errors, [ location, "must be a valid IPv4 address" ]);

			}

			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "listen-ipv4-address")) {
			obj.listen_ipv4_address = parseListenIpv4Address(location + "/listen-ipv4-address", value["listen-ipv4-address"], errors);
		}

		function parseListenIpv6Address(location, value, errors) {
			if (type(value) == "string") {
				if (!matchIpv6(value))
					push(errors, [ location, "must be a valid IPv6 address" ]);

			}

			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "listen-ipv6-address")) {
			obj.listen_ipv6_address = parseListenIpv6Address(location + "/listen-ipv6-address", value["listen-ipv6-address"], errors);
		}

		function parseAllowClients(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "string") {
						if (!matchUcIp(value))
							push(errors, [ location, "must be a valid IPv4 or IPv6 address" ]);

					}

					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "allow-clients")) {
			obj.allow_clients = parseAllowClients(location + "/allow-clients", value["allow-clients"], errors);
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateServiceLldp(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseInterfaces(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "interfaces")) {
			obj.interfaces = parseInterfaces(location + "/interfaces", value["interfaces"], errors);
		}

		function parseManagementAddresses(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "string") {
						if (!matchUcIp(value))
							push(errors, [ location, "must be a valid IPv4 or IPv6 address" ]);

					}

					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "management-addresses")) {
			obj.management_addresses = parseManagementAddresses(location + "/management-addresses", value["management-addresses"], errors);
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateServiceMdns(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseInterfaces(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "interfaces")) {
			obj.interfaces = parseInterfaces(location + "/interfaces", value["interfaces"], errors);
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateServicePppoeServer(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseDescription(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "description")) {
			obj.description = parseDescription(location + "/description", value["description"], errors);
		}

		function parseAuthMode(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			if (!(value in [ "radius", "local", "noauth" ]))
				push(errors, [ location, "must be one of \"radius\", \"local\" or \"noauth\"" ]);

			return value;
		}

		if (exists(value, "auth-mode")) {
			obj.auth_mode = parseAuthMode(location + "/auth-mode", value["auth-mode"], errors);
		}
		else {
			push(errors, [ location, "is required" ]);
		}

		function parseInterface(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "interface")) {
			obj.interface = parseInterface(location + "/interface", value["interface"], errors);
		}

		function parseClientIpPool(location, value, errors) {
			if (type(value) == "object") {
				let obj = {};

				function parseStart(location, value, errors) {
					if (type(value) == "string") {
						if (!matchIpv4(value))
							push(errors, [ location, "must be a valid IPv4 address" ]);

					}

					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				if (exists(value, "start")) {
					obj.start = parseStart(location + "/start", value["start"], errors);
				}

				function parseStop(location, value, errors) {
					if (type(value) == "string") {
						if (!matchIpv4(value))
							push(errors, [ location, "must be a valid IPv4 address" ]);

					}

					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				if (exists(value, "stop")) {
					obj.stop = parseStop(location + "/stop", value["stop"], errors);
				}

				return obj;
			}

			if (type(value) != "object")
				push(errors, [ location, "must be of type object" ]);

			return value;
		}

		if (exists(value, "client-ip-pool")) {
			obj.client_ip_pool = parseClientIpPool(location + "/client-ip-pool", value["client-ip-pool"], errors);
		}

		function parseWinsServers(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "string") {
						if (!matchUcIp(value))
							push(errors, [ location, "must be a valid IPv4 or IPv6 address" ]);

					}

					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "wins-servers")) {
			obj.wins_servers = parseWinsServers(location + "/wins-servers", value["wins-servers"], errors);
		}

		function parseServiceNames(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "service-names")) {
			obj.service_names = parseServiceNames(location + "/service-names", value["service-names"], errors);
		}

		function parseMtu(location, value, errors) {
			if (type(value) != "int")
				push(errors, [ location, "must be of type integer" ]);

			return value;
		}

		if (exists(value, "mtu")) {
			obj.mtu = parseMtu(location + "/mtu", value["mtu"], errors);
		}
		else {
			obj.mtu = 1492;
		}

		function parseLocal(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseUser(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "user")) {
							obj.user = parseUser(location + "/user", value["user"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						function parsePassword(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "password")) {
							obj.password = parsePassword(location + "/password", value["password"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "local")) {
			obj.local = parseLocal(location + "/local", value["local"], errors);
		}

		function parseRadius(location, value, errors) {
			if (type(value) == "object") {
				let obj = {};

				function parseAddress(location, value, errors) {
					if (type(value) == "string") {
						if (!matchUcIp(value))
							push(errors, [ location, "must be a valid IPv4 or IPv6 address" ]);

					}

					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				if (exists(value, "address")) {
					obj.address = parseAddress(location + "/address", value["address"], errors);
				}

				function parsePort(location, value, errors) {
					if (type(value) in [ "int", "double" ]) {
						if (value > 65535)
							push(errors, [ location, "must be lower than or equal to 65535" ]);

					}

					if (type(value) != "int")
						push(errors, [ location, "must be of type integer" ]);

					return value;
				}

				if (exists(value, "port")) {
					obj.port = parsePort(location + "/port", value["port"], errors);
				}

				return obj;
			}

			if (type(value) != "object")
				push(errors, [ location, "must be of type object" ]);

			return value;
		}

		if (exists(value, "radius")) {
			obj.radius = parseRadius(location + "/radius", value["radius"], errors);
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateServiceWebProxy(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseDefaultPort(location, value, errors) {
			if (type(value) != "int")
				push(errors, [ location, "must be of type integer" ]);

			return value;
		}

		if (exists(value, "default-port")) {
			obj.default_port = parseDefaultPort(location + "/default-port", value["default-port"], errors);
		}
		else {
			obj.default_port = 3128;
		}

		function parseServers(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseIp(location, value, errors) {
							if (type(value) == "string") {
								if (!matchUcIp(value))
									push(errors, [ location, "must be a valid IPv4 or IPv6 address" ]);

							}

							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "ip")) {
							obj.ip = parseIp(location + "/ip", value["ip"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						function parsePort(location, value, errors) {
							if (type(value) in [ "int", "double" ]) {
								if (value > 65535)
									push(errors, [ location, "must be lower than or equal to 65535" ]);

							}

							if (type(value) != "int")
								push(errors, [ location, "must be of type integer" ]);

							return value;
						}

						if (exists(value, "port")) {
							obj.port = parsePort(location + "/port", value["port"], errors);
						}

						function parseTransparentProxy(location, value, errors) {
							if (type(value) != "bool")
								push(errors, [ location, "must be of type boolean" ]);

							return value;
						}

						if (exists(value, "transparent-proxy")) {
							obj.transparent_proxy = parseTransparentProxy(location + "/transparent-proxy", value["transparent-proxy"], errors);
						}
						else {
							obj.transparent_proxy = true;
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "servers")) {
			obj.servers = parseServers(location + "/servers", value["servers"], errors);
		}

		function parseCacheSize(location, value, errors) {
			if (type(value) != "int")
				push(errors, [ location, "must be of type integer" ]);

			return value;
		}

		if (exists(value, "cache-size")) {
			obj.cache_size = parseCacheSize(location + "/cache-size", value["cache-size"], errors);
		}
		else {
			obj.cache_size = 100;
		}

		function parseBlockDomains(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "string") {
						if (!matchHostname(value))
							push(errors, [ location, "must be a valid hostname" ]);

					}

					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "block-domains")) {
			obj.block_domains = parseBlockDomains(location + "/block-domains", value["block-domains"], errors);
		}

		function parseNonCacheDomains(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "string") {
						if (!matchHostname(value))
							push(errors, [ location, "must be a valid hostname" ]);

					}

					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "non-cache-domains")) {
			obj.non_cache_domains = parseNonCacheDomains(location + "/non-cache-domains", value["non-cache-domains"], errors);
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateServiceTftpServer(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseDirectory(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "directory")) {
			obj.directory = parseDirectory(location + "/directory", value["directory"], errors);
		}
		else {
			push(errors, [ location, "is required" ]);
		}

		function parseListenAddress(location, value, errors) {
			if (type(value) == "string") {
				if (!matchUcIp(value))
					push(errors, [ location, "must be a valid IPv4 or IPv6 address" ]);

			}

			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "listen-address")) {
			obj.listen_address = parseListenAddress(location + "/listen-address", value["listen-address"], errors);
		}

		function parseAllowUpload(location, value, errors) {
			if (type(value) != "bool")
				push(errors, [ location, "must be of type boolean" ]);

			return value;
		}

		if (exists(value, "allow-upload")) {
			obj.allow_upload = parseAllowUpload(location + "/allow-upload", value["allow-upload"], errors);
		}
		else {
			obj.allow_upload = false;
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateServiceIgmpProxy(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseUpstreamInterface(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "upstream-interface")) {
			obj.upstream_interface = parseUpstreamInterface(location + "/upstream-interface", value["upstream-interface"], errors);
		}

		function parseDownstreamInterfaces(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "downstream-interfaces")) {
			obj.downstream_interfaces = parseDownstreamInterfaces(location + "/downstream-interfaces", value["downstream-interfaces"], errors);
		}

		function parseAltSubnets(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "string") {
						if (!matchUcCidr4(value))
							push(errors, [ location, "must be a valid IPv4 CIDR" ]);

					}

					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "alt-subnets")) {
			obj.alt_subnets = parseAltSubnets(location + "/alt-subnets", value["alt-subnets"], errors);
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateServiceTrafficPolicy(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseShaper(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseName(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "name")) {
							obj.name = parseName(location + "/name", value["name"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						function parseBandwidth(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "bandwidth")) {
							obj.bandwidth = parseBandwidth(location + "/bandwidth", value["bandwidth"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						function parseClasses(location, value, errors) {
							if (type(value) == "array") {
								function parseItem(location, value, errors) {
									if (type(value) == "object") {
										let obj = {};

										function parseId(location, value, errors) {
											if (type(value) in [ "int", "double" ]) {
												if (value > 4095)
													push(errors, [ location, "must be lower than or equal to 4095" ]);

												if (value < 2)
													push(errors, [ location, "must be bigger than or equal to 2" ]);

											}

											if (type(value) != "int")
												push(errors, [ location, "must be of type integer" ]);

											return value;
										}

										if (exists(value, "id")) {
											obj.id = parseId(location + "/id", value["id"], errors);
										}
										else {
											push(errors, [ location, "is required" ]);
										}

										function parseBandwidth(location, value, errors) {
											if (type(value) != "string")
												push(errors, [ location, "must be of type string" ]);

											return value;
										}

										if (exists(value, "bandwidth")) {
											obj.bandwidth = parseBandwidth(location + "/bandwidth", value["bandwidth"], errors);
										}
										else {
											push(errors, [ location, "is required" ]);
										}

										function parseBurst(location, value, errors) {
											if (type(value) != "string")
												push(errors, [ location, "must be of type string" ]);

											return value;
										}

										if (exists(value, "burst")) {
											obj.burst = parseBurst(location + "/burst", value["burst"], errors);
										}

										function parseCeiling(location, value, errors) {
											if (type(value) != "string")
												push(errors, [ location, "must be of type string" ]);

											return value;
										}

										if (exists(value, "ceiling")) {
											obj.ceiling = parseCeiling(location + "/ceiling", value["ceiling"], errors);
										}

										function parsePriority(location, value, errors) {
											if (type(value) in [ "int", "double" ]) {
												if (value > 7)
													push(errors, [ location, "must be lower than or equal to 7" ]);

												if (value < 0)
													push(errors, [ location, "must be bigger than or equal to 0" ]);

											}

											if (type(value) != "int")
												push(errors, [ location, "must be of type integer" ]);

											return value;
										}

										if (exists(value, "priority")) {
											obj.priority = parsePriority(location + "/priority", value["priority"], errors);
										}
										else {
											obj.priority = 0;
										}

										function parseQueueType(location, value, errors) {
											if (type(value) != "string")
												push(errors, [ location, "must be of type string" ]);

											if (!(value in [ "fq-codel", "fair-queue", "drop-tail" ]))
												push(errors, [ location, "must be one of \"fq-codel\", \"fair-queue\" or \"drop-tail\"" ]);

											return value;
										}

										if (exists(value, "queue-type")) {
											obj.queue_type = parseQueueType(location + "/queue-type", value["queue-type"], errors);
										}
										else {
											obj.queue_type = "fq-codel";
										}

										return obj;
									}

									if (type(value) != "object")
										push(errors, [ location, "must be of type object" ]);

									return value;
								}

								return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
							}

							if (type(value) != "array")
								push(errors, [ location, "must be of type array" ]);

							return value;
						}

						if (exists(value, "classes")) {
							obj.classes = parseClasses(location + "/classes", value["classes"], errors);
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "shaper")) {
			obj.shaper = parseShaper(location + "/shaper", value["shaper"], errors);
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateServiceSnmpv3(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseListenAddresses(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "string") {
						if (!matchUcIp(value))
							push(errors, [ location, "must be a valid IPv4 or IPv6 address" ]);

					}

					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "listen-addresses")) {
			obj.listen_addresses = parseListenAddresses(location + "/listen-addresses", value["listen-addresses"], errors);
		}

		function parseLocation(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "location")) {
			obj.location = parseLocation(location + "/location", value["location"], errors);
		}

		function parseEngineId(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			return value;
		}

		if (exists(value, "engine-id")) {
			obj.engine_id = parseEngineId(location + "/engine-id", value["engine-id"], errors);
		}

		function parseGroups(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseName(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "name")) {
							obj.name = parseName(location + "/name", value["name"], errors);
						}

						function parseMode(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							if (!(value in [ "ro", "rw" ]))
								push(errors, [ location, "must be one of \"ro\" or \"rw\"" ]);

							return value;
						}

						if (exists(value, "mode")) {
							obj.mode = parseMode(location + "/mode", value["mode"], errors);
						}
						else {
							obj.mode = "ro";
						}

						function parseView(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "view")) {
							obj.view = parseView(location + "/view", value["view"], errors);
						}
						else {
							obj.view = "default";
						}

						function parseOid(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "oid")) {
							obj.oid = parseOid(location + "/oid", value["oid"], errors);
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "groups")) {
			obj.groups = parseGroups(location + "/groups", value["groups"], errors);
		}

		function parseUsers(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseName(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "name")) {
							obj.name = parseName(location + "/name", value["name"], errors);
						}

						function parseGroup(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "group")) {
							obj.group = parseGroup(location + "/group", value["group"], errors);
						}

						function parseAuth(location, value, errors) {
							if (type(value) == "object") {
								let obj = {};

								function parseEncrypted(location, value, errors) {
									if (type(value) != "bool")
										push(errors, [ location, "must be of type boolean" ]);

									return value;
								}

								if (exists(value, "encrypted")) {
									obj.encrypted = parseEncrypted(location + "/encrypted", value["encrypted"], errors);
								}
								else {
									obj.encrypted = false;
								}

								function parsePassword(location, value, errors) {
									if (type(value) != "string")
										push(errors, [ location, "must be of type string" ]);

									return value;
								}

								if (exists(value, "password")) {
									obj.password = parsePassword(location + "/password", value["password"], errors);
								}

								function parseHashAlgo(location, value, errors) {
									if (type(value) != "string")
										push(errors, [ location, "must be of type string" ]);

									if (!(value in [ "md5", "sha" ]))
										push(errors, [ location, "must be one of \"md5\" or \"sha\"" ]);

									return value;
								}

								if (exists(value, "hash-algo")) {
									obj.hash_algo = parseHashAlgo(location + "/hash-algo", value["hash-algo"], errors);
								}
								else {
									obj.hash_algo = "md5";
								}

								return obj;
							}

							if (type(value) != "object")
								push(errors, [ location, "must be of type object" ]);

							return value;
						}

						if (exists(value, "auth")) {
							obj.auth = parseAuth(location + "/auth", value["auth"], errors);
						}

						function parsePrivacy(location, value, errors) {
							if (type(value) == "object") {
								let obj = {};

								function parseEncrypted(location, value, errors) {
									if (type(value) != "bool")
										push(errors, [ location, "must be of type boolean" ]);

									return value;
								}

								if (exists(value, "encrypted")) {
									obj.encrypted = parseEncrypted(location + "/encrypted", value["encrypted"], errors);
								}
								else {
									obj.encrypted = false;
								}

								function parsePassword(location, value, errors) {
									if (type(value) != "string")
										push(errors, [ location, "must be of type string" ]);

									return value;
								}

								if (exists(value, "password")) {
									obj.password = parsePassword(location + "/password", value["password"], errors);
								}

								function parseHashAlgo(location, value, errors) {
									if (type(value) != "string")
										push(errors, [ location, "must be of type string" ]);

									if (!(value in [ "aes", "des" ]))
										push(errors, [ location, "must be one of \"aes\" or \"des\"" ]);

									return value;
								}

								if (exists(value, "hash-algo")) {
									obj.hash_algo = parseHashAlgo(location + "/hash-algo", value["hash-algo"], errors);
								}
								else {
									obj.hash_algo = "des";
								}

								return obj;
							}

							if (type(value) != "object")
								push(errors, [ location, "must be of type object" ]);

							return value;
						}

						if (exists(value, "privacy")) {
							obj.privacy = parsePrivacy(location + "/privacy", value["privacy"], errors);
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "users")) {
			obj.users = parseUsers(location + "/users", value["users"], errors);
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateServiceSyslog(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseMarker(location, value, errors) {
			if (type(value) == "object") {
				let obj = {};

				function parseEnable(location, value, errors) {
					if (type(value) != "bool")
						push(errors, [ location, "must be of type boolean" ]);

					return value;
				}

				if (exists(value, "enable")) {
					obj.enable = parseEnable(location + "/enable", value["enable"], errors);
				}
				else {
					obj.enable = true;
				}

				function parseInterval(location, value, errors) {
					if (type(value) in [ "int", "double" ]) {
						if (value < 1)
							push(errors, [ location, "must be bigger than or equal to 1" ]);

					}

					if (type(value) != "int")
						push(errors, [ location, "must be of type integer" ]);

					return value;
				}

				if (exists(value, "interval")) {
					obj.interval = parseInterval(location + "/interval", value["interval"], errors);
				}
				else {
					obj.interval = 1200;
				}

				return obj;
			}

			if (type(value) != "object")
				push(errors, [ location, "must be of type object" ]);

			return value;
		}

		if (exists(value, "marker")) {
			obj.marker = parseMarker(location + "/marker", value["marker"], errors);
		}

		function parsePreserveFqdn(location, value, errors) {
			if (type(value) != "bool")
				push(errors, [ location, "must be of type boolean" ]);

			return value;
		}

		if (exists(value, "preserve-fqdn")) {
			obj.preserve_fqdn = parsePreserveFqdn(location + "/preserve-fqdn", value["preserve-fqdn"], errors);
		}
		else {
			obj.preserve_fqdn = false;
		}

		function parseRemoteHosts(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseAddress(location, value, errors) {
							if (type(value) == "string") {
								if (!matchUcIp(value))
									push(errors, [ location, "must be a valid IPv4 or IPv6 address" ]);

							}

							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "address")) {
							obj.address = parseAddress(location + "/address", value["address"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						function parsePort(location, value, errors) {
							if (type(value) in [ "int", "double" ]) {
								if (value > 65535)
									push(errors, [ location, "must be lower than or equal to 65535" ]);

							}

							if (type(value) != "int")
								push(errors, [ location, "must be of type integer" ]);

							return value;
						}

						if (exists(value, "port")) {
							obj.port = parsePort(location + "/port", value["port"], errors);
						}
						else {
							obj.port = 514;
						}

						function parseProtocol(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							if (!(value in [ "udp", "tcp" ]))
								push(errors, [ location, "must be one of \"udp\" or \"tcp\"" ]);

							return value;
						}

						if (exists(value, "protocol")) {
							obj.protocol = parseProtocol(location + "/protocol", value["protocol"], errors);
						}
						else {
							obj.protocol = "udp";
						}

						function parseFacility(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							if (!(value in [ "all", "kern", "user", "mail", "daemon", "auth", "syslog", "lpr", "news", "uucp", "cron", "security", "ftp", "ntp", "logaudit", "logalert", "clock", "local0", "local1", "local2", "local3", "local4", "local5", "local6", "local7" ]))
								push(errors, [ location, "must be one of \"all\", \"kern\", \"user\", \"mail\", \"daemon\", \"auth\", \"syslog\", \"lpr\", \"news\", \"uucp\", \"cron\", \"security\", \"ftp\", \"ntp\", \"logaudit\", \"logalert\", \"clock\", \"local0\", \"local1\", \"local2\", \"local3\", \"local4\", \"local5\", \"local6\" or \"local7\"" ]);

							return value;
						}

						if (exists(value, "facility")) {
							obj.facility = parseFacility(location + "/facility", value["facility"], errors);
						}
						else {
							obj.facility = "daemon";
						}

						function parseSeverity(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							if (!(value in [ "emerg", "alert", "crit", "err", "warning", "notice", "info", "debug" ]))
								push(errors, [ location, "must be one of \"emerg\", \"alert\", \"crit\", \"err\", \"warning\", \"notice\", \"info\" or \"debug\"" ]);

							return value;
						}

						if (exists(value, "severity")) {
							obj.severity = parseSeverity(location + "/severity", value["severity"], errors);
						}
						else {
							obj.severity = "info";
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "remote-hosts")) {
			obj.remote_hosts = parseRemoteHosts(location + "/remote-hosts", value["remote-hosts"], errors);
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateServiceNetflow(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseVersion(location, value, errors) {
			if (type(value) != "string")
				push(errors, [ location, "must be of type string" ]);

			if (!(value in [ "5", "9", "10" ]))
				push(errors, [ location, "must be one of \"5\", \"9\" or \"10\"" ]);

			return value;
		}

		if (exists(value, "version")) {
			obj.version = parseVersion(location + "/version", value["version"], errors);
		}
		else {
			obj.version = "9";
		}

		function parseInterfaces(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "interfaces")) {
			obj.interfaces = parseInterfaces(location + "/interfaces", value["interfaces"], errors);
		}

		function parseServers(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseAddress(location, value, errors) {
							if (type(value) == "string") {
								if (!matchUcIp(value))
									push(errors, [ location, "must be a valid IPv4 or IPv6 address" ]);

							}

							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "address")) {
							obj.address = parseAddress(location + "/address", value["address"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						function parsePort(location, value, errors) {
							if (type(value) in [ "int", "double" ]) {
								if (value > 65535)
									push(errors, [ location, "must be lower than or equal to 65535" ]);

							}

							if (type(value) != "int")
								push(errors, [ location, "must be of type integer" ]);

							return value;
						}

						if (exists(value, "port")) {
							obj.port = parsePort(location + "/port", value["port"], errors);
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "servers")) {
			obj.servers = parseServers(location + "/servers", value["servers"], errors);
		}

		function parseEngineId(location, value, errors) {
			if (type(value) in [ "int", "double" ]) {
				if (value > 255)
					push(errors, [ location, "must be lower than or equal to 255" ]);

				if (value < 0)
					push(errors, [ location, "must be bigger than or equal to 0" ]);

			}

			if (type(value) != "int")
				push(errors, [ location, "must be of type integer" ]);

			return value;
		}

		if (exists(value, "engine-id")) {
			obj.engine_id = parseEngineId(location + "/engine-id", value["engine-id"], errors);
		}

		function parseSamplingRate(location, value, errors) {
			if (type(value) != "int")
				push(errors, [ location, "must be of type integer" ]);

			return value;
		}

		if (exists(value, "sampling-rate")) {
			obj.sampling_rate = parseSamplingRate(location + "/sampling-rate", value["sampling-rate"], errors);
		}
		else {
			obj.sampling_rate = 1;
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateServiceSflow(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseAgent(location, value, errors) {
			if (type(value) == "object") {
				let obj = {};

				function parseAddress(location, value, errors) {
					if (type(value) == "string") {
						if (!matchUcIp(value))
							push(errors, [ location, "must be a valid IPv4 or IPv6 address" ]);

					}

					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				if (exists(value, "address")) {
					obj.address = parseAddress(location + "/address", value["address"], errors);
				}
				else {
					push(errors, [ location, "is required" ]);
				}

				function parseInterface(location, value, errors) {
					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				if (exists(value, "interface")) {
					obj.interface = parseInterface(location + "/interface", value["interface"], errors);
				}

				return obj;
			}

			if (type(value) != "object")
				push(errors, [ location, "must be of type object" ]);

			return value;
		}

		if (exists(value, "agent")) {
			obj.agent = parseAgent(location + "/agent", value["agent"], errors);
		}

		function parseInterfaces(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) != "string")
						push(errors, [ location, "must be of type string" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "interfaces")) {
			obj.interfaces = parseInterfaces(location + "/interfaces", value["interfaces"], errors);
		}

		function parseSamplingRate(location, value, errors) {
			if (type(value) != "int")
				push(errors, [ location, "must be of type integer" ]);

			return value;
		}

		if (exists(value, "sampling-rate")) {
			obj.sampling_rate = parseSamplingRate(location + "/sampling-rate", value["sampling-rate"], errors);
		}
		else {
			obj.sampling_rate = 1000;
		}

		function parseServers(location, value, errors) {
			if (type(value) == "array") {
				function parseItem(location, value, errors) {
					if (type(value) == "object") {
						let obj = {};

						function parseAddress(location, value, errors) {
							if (type(value) == "string") {
								if (!matchUcIp(value))
									push(errors, [ location, "must be a valid IPv4 or IPv6 address" ]);

							}

							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							return value;
						}

						if (exists(value, "address")) {
							obj.address = parseAddress(location + "/address", value["address"], errors);
						}
						else {
							push(errors, [ location, "is required" ]);
						}

						function parsePort(location, value, errors) {
							if (type(value) in [ "int", "double" ]) {
								if (value > 65535)
									push(errors, [ location, "must be lower than or equal to 65535" ]);

							}

							if (type(value) != "int")
								push(errors, [ location, "must be of type integer" ]);

							return value;
						}

						if (exists(value, "port")) {
							obj.port = parsePort(location + "/port", value["port"], errors);
						}
						else {
							obj.port = 6343;
						}

						return obj;
					}

					if (type(value) != "object")
						push(errors, [ location, "must be of type object" ]);

					return value;
				}

				return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "servers")) {
			obj.servers = parseServers(location + "/servers", value["servers"], errors);
		}

		function parseSampleEgress(location, value, errors) {
			if (type(value) != "bool")
				push(errors, [ location, "must be of type boolean" ]);

			return value;
		}

		if (exists(value, "sample-egress")) {
			obj.sample_egress = parseSampleEgress(location + "/sample-egress", value["sample-egress"], errors);
		}
		else {
			obj.sample_egress = false;
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateService(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		if (exists(value, "dhcp-server")) {
			obj.dhcp_server = instantiateServiceDhcpServer(location + "/dhcp-server", value["dhcp-server"], errors);
		}

		if (exists(value, "dhcp-relay")) {
			obj.dhcp_relay = instantiateServiceDhcpRelay(location + "/dhcp-relay", value["dhcp-relay"], errors);
		}

		if (exists(value, "dns")) {
			obj.dns = instantiateServiceDns(location + "/dns", value["dns"], errors);
		}

		if (exists(value, "ntp")) {
			obj.ntp = instantiateServiceNtp(location + "/ntp", value["ntp"], errors);
		}

		if (exists(value, "lldp")) {
			obj.lldp = instantiateServiceLldp(location + "/lldp", value["lldp"], errors);
		}

		if (exists(value, "mdns")) {
			obj.mdns = instantiateServiceMdns(location + "/mdns", value["mdns"], errors);
		}

		if (exists(value, "pppoe-server")) {
			obj.pppoe_server = instantiateServicePppoeServer(location + "/pppoe-server", value["pppoe-server"], errors);
		}

		if (exists(value, "web-proxy")) {
			obj.web_proxy = instantiateServiceWebProxy(location + "/web-proxy", value["web-proxy"], errors);
		}

		if (exists(value, "tftp-server")) {
			obj.tftp_server = instantiateServiceTftpServer(location + "/tftp-server", value["tftp-server"], errors);
		}

		if (exists(value, "igmp-proxy")) {
			obj.igmp_proxy = instantiateServiceIgmpProxy(location + "/igmp-proxy", value["igmp-proxy"], errors);
		}

		if (exists(value, "traffic-policy")) {
			obj.traffic_policy = instantiateServiceTrafficPolicy(location + "/traffic-policy", value["traffic-policy"], errors);
		}

		if (exists(value, "snmp")) {
			obj.snmp = instantiateServiceSnmpv3(location + "/snmp", value["snmp"], errors);
		}

		if (exists(value, "syslog")) {
			obj.syslog = instantiateServiceSyslog(location + "/syslog", value["syslog"], errors);
		}

		if (exists(value, "netflow")) {
			obj.netflow = instantiateServiceNetflow(location + "/netflow", value["netflow"], errors);
		}

		if (exists(value, "sflow")) {
			obj.sflow = instantiateServiceSflow(location + "/sflow", value["sflow"], errors);
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function instantiateMetrics(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseStatistics(location, value, errors) {
			if (type(value) == "object") {
				let obj = {};

				function parseInterval(location, value, errors) {
					if (type(value) in [ "int", "double" ]) {
						if (value < 60)
							push(errors, [ location, "must be bigger than or equal to 60" ]);

					}

					if (type(value) != "int")
						push(errors, [ location, "must be of type integer" ]);

					return value;
				}

				if (exists(value, "interval")) {
					obj.interval = parseInterval(location + "/interval", value["interval"], errors);
				}

				function parseTypes(location, value, errors) {
					if (type(value) == "array") {
						function parseItem(location, value, errors) {
							if (type(value) != "string")
								push(errors, [ location, "must be of type string" ]);

							if (!(value in [ "interfaces", "routes", "arp", "conntrack", "dhcp-leases" ]))
								push(errors, [ location, "must be one of \"interfaces\", \"routes\", \"arp\", \"conntrack\" or \"dhcp-leases\"" ]);

							return value;
						}

						return map(value, (item, i) => parseItem(location + "/" + i, item, errors));
					}

					if (type(value) != "array")
						push(errors, [ location, "must be of type array" ]);

					return value;
				}

				if (exists(value, "types")) {
					obj.types = parseTypes(location + "/types", value["types"], errors);
				}

				return obj;
			}

			if (type(value) != "object")
				push(errors, [ location, "must be of type object" ]);

			return value;
		}

		if (exists(value, "statistics")) {
			obj.statistics = parseStatistics(location + "/statistics", value["statistics"], errors);
		}

		function parseHealth(location, value, errors) {
			if (type(value) == "object") {
				let obj = {};

				function parseInterval(location, value, errors) {
					if (type(value) in [ "int", "double" ]) {
						if (value < 60)
							push(errors, [ location, "must be bigger than or equal to 60" ]);

					}

					if (type(value) != "int")
						push(errors, [ location, "must be of type integer" ]);

					return value;
				}

				if (exists(value, "interval")) {
					obj.interval = parseInterval(location + "/interval", value["interval"], errors);
				}

				return obj;
			}

			if (type(value) != "object")
				push(errors, [ location, "must be of type object" ]);

			return value;
		}

		if (exists(value, "health")) {
			obj.health = parseHealth(location + "/health", value["health"], errors);
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

function newUCentralState(location, value, errors) {
	if (type(value) == "object") {
		let obj = {};

		function parseUuid(location, value, errors) {
			if (type(value) != "int")
				push(errors, [ location, "must be of type integer" ]);

			return value;
		}

		if (exists(value, "uuid")) {
			obj.uuid = parseUuid(location + "/uuid", value["uuid"], errors);
		}

		if (exists(value, "unit")) {
			obj.unit = instantiateUnit(location + "/unit", value["unit"], errors);
		}

		if (exists(value, "globals")) {
			obj.globals = instantiateGlobals(location + "/globals", value["globals"], errors);
		}

		function parseInterfaces(location, value, errors) {
			if (type(value) == "array") {
				return map(value, (item, i) => instantiateInterface(location + "/" + i, item, errors));
			}

			if (type(value) != "array")
				push(errors, [ location, "must be of type array" ]);

			return value;
		}

		if (exists(value, "interfaces")) {
			obj.interfaces = parseInterfaces(location + "/interfaces", value["interfaces"], errors);
		}

		if (exists(value, "routing")) {
			obj.routing = instantiateRouting(location + "/routing", value["routing"], errors);
		}

		if (exists(value, "firewall")) {
			obj.firewall = instantiateFirewall(location + "/firewall", value["firewall"], errors);
		}

		if (exists(value, "nat")) {
			obj.nat = instantiateNat(location + "/nat", value["nat"], errors);
		}

		if (exists(value, "pki")) {
			obj.pki = instantiatePki(location + "/pki", value["pki"], errors);
		}

		if (exists(value, "vpn")) {
			obj.vpn = instantiateVpn(location + "/vpn", value["vpn"], errors);
		}

		if (exists(value, "high-availability")) {
			obj.high_availability = instantiateHighAvailability(location + "/high-availability", value["high-availability"], errors);
		}

		if (exists(value, "services")) {
			obj.services = instantiateService(location + "/services", value["services"], errors);
		}

		if (exists(value, "metrics")) {
			obj.metrics = instantiateMetrics(location + "/metrics", value["metrics"], errors);
		}

		return obj;
	}

	if (type(value) != "object")
		push(errors, [ location, "must be of type object" ]);

	return value;
}

return {
	validate: (value, errors) => {
		let err = [];
		let res = newUCentralState("", value, err);
		if (errors) push(errors, ...map(err, e => "[E] (In " + e[0] + ") Value " + e[1]));
		return length(err) ? null : res;
	}
};
