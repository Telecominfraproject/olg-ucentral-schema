#!/usr/bin/ucode
//
// VyOS State Reporter for uCentral
// Collects state information from VyOS via REST API and formats it according to ucentral.state schema
//
// Uses VyOS native REST API show commands (show system uptime, show system memory, show interfaces counters)
//

push(REQUIRE_SEARCH_PATH, '/usr/share/ucentral/*.uc', '/usr/share/ucentral/vyos/*.uc');

let fs = require("fs");
let ubus = require("ubus");
let uci = require("uci");

// Load VyOS API library using require (same as renderer/ucentral.uc)
let vyos_api_module = require("vyos.https_server_api");

// Load parser library using require
let parsers_module = require("vyos.parsers");

// Load configuration
let cfgfile = fs.open("/etc/ucentral/ucentral.active", "r");
let cfg = cfgfile ? json(cfgfile.read("all")) : {};
if (cfgfile) cfgfile.close();

let capabfile = fs.open("/etc/ucentral/capabilities.json", "r");
let capab = capabfile ? json(capabfile.read("all")) : {};
if (capabfile) capabfile.close();

let vyos_info_file = fs.open("/etc/ucentral/vyos-info.json", "r");
let vyos_info = vyos_info_file ? json(vyos_info_file.read("all")) : null;
if (vyos_info_file) vyos_info_file.close();

if (!vyos_info || !vyos_info.host || !vyos_info.key) {
	fprintf(stderr, "ERROR: Missing or invalid vyos-info.json\n");
	exit(1);
}

let vyos_host = vyos_info.host;
let vyos_key = vyos_info.key;

// Initialize ubus context
let ctx = ubus.connect();
let cursor = uci.cursor();

// Load state collection configuration
cursor.load("state");
let stats = cursor.get_all("state", "stats") || {};

// Read intervals from active configuration
// Per schema: minimum interval is 60 seconds
let stats_interval = 60;  // Default minimum
let health_interval = 60; // Default minimum

if (type(cfg?.metrics) == "object") {
	if (type(cfg.metrics.statistics) == "object") {
		let interval_val = cfg.metrics.statistics.interval;
		if (type(interval_val) == "int" || type(interval_val) == "number") {
			stats_interval = int(interval_val);
			if (stats_interval < 60) {
				stats_interval = 60;  // Enforce minimum
			}
		}
	}

	if (type(cfg.metrics.health) == "object") {
		let interval_val = cfg.metrics.health.interval;
		if (type(interval_val) == "int" || type(interval_val) == "number") {
			health_interval = int(interval_val);
			if (health_interval < 60) {
				health_interval = 60;  // Enforce minimum
			}
		}
	}
}

// Initialize state structure
let state = {
	version: 1,
	unit: {},
	interfaces: [],
	"link-state": {},
	// Include intervals so daemon can use them for scheduling
	intervals: {
		statistics: stats_interval,
		health: health_interval
	}
};

// Load previous state for delta calculations
let previous = json(fs.readfile('/tmp/vyos-state.json') || '{ "interfaces": {}, "link-state": {} }');

//
// Helper function: Call VyOS REST API and parse JSON response
//
function vyos_api_call(params) {
	let operation = params.op || "show";
	let path = params.path || [];

	let result = vyos_api_module.vyos_api_call(
		{ path: path },
		operation,
		vyos_host,
		vyos_key
	);

	if (!result) {
		// API call failed (null result)
		return null;
	}

	let parsed;
	try {
		parsed = json(result);
	} catch(e) {
		// JSON parse failed
		return null;
	}

	if (!parsed) {
		// Parsed result is null
		return null;
	}

	if (parsed.error) {
		// VyOS API returned an error response
		return null;
	}

	return parsed;
}

// NOTE: calculate_deltas() was removed - logic is now inlined in collect_interfaces()
// and collect_link_state() to avoid nested function calls (uCode limitation)

//
// Helper functions (must be defined before use in uCode)
//

// Helper: Parse uptime string like "12m 4s" or "1h 23m" or "2d 5h 30m" into seconds
function parse_uptime_string(uptime_str) {
	let seconds = 0;
	let parts = split(uptime_str, " ");

	for (let part in parts) {
		part = trim(part);
		if (length(part) == 0) continue;

		if (index(part, "d") >= 0) {
			let days = int(replace(part, "d", ""));
			seconds += days * 86400;
		} else if (index(part, "h") >= 0) {
			let hours = int(replace(part, "h", ""));
			seconds += hours * 3600;
		} else if (index(part, "m") >= 0) {
			let minutes = int(replace(part, "m", ""));
			seconds += minutes * 60;
		} else if (index(part, "s") >= 0) {
			seconds += int(replace(part, "s", ""));
		}
	}

	return seconds;
}

// Helper: Parse memory value like "15.64 GB" or "668.07 MB" into bytes
function parse_memory_value(value, unit) {
	let val = +(value);
	unit = uc(unit);

	if (unit == "GB")
		return int(val * 1024 * 1024 * 1024);
	else if (unit == "MB")
		return int(val * 1024 * 1024);
	else if (unit == "KB")
		return int(val * 1024);
	else
		return int(val);
}

// Helper: Parse ISO 8601 timestamp to unix epoch
// Format: "2026-03-05 17:44:55+00:00"
function parse_iso8601_to_epoch(timestamp_str) {
	// Parse: YYYY-MM-DD HH:MM:SS+TZ:TZ
	let m = match(timestamp_str, /^([0-9]{4})-([0-9]{2})-([0-9]{2})\s+([0-9]{2}):([0-9]{2}):([0-9]{2})/);
	if (!m)
		return null;

	let year = int(m[1]);
	let month = int(m[2]);
	let day = int(m[3]);
	let hour = int(m[4]);
	let minute = int(m[5]);
	let second = int(m[6]);

	// Calculate days since epoch (1970-01-01)
	// Simple algorithm: count leap years and days
	let days = 0;

	// Add days for complete years
	for (let y = 1970; y < year; y++) {
		if ((y % 4 == 0 && y % 100 != 0) || (y % 400 == 0))
			days += 366;  // Leap year
		else
			days += 365;
	}

	// Days in each month (non-leap year)
	let days_in_month = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

	// Check if current year is leap year
	let is_leap = ((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0));
	if (is_leap)
		days_in_month[1] = 29;

	// Add days for complete months
	for (let m = 1; m < month; m++)
		days += days_in_month[m - 1];

	// Add remaining days
	days += day - 1;

	// Convert to seconds
	let epoch = days * 86400 + hour * 3600 + minute * 60 + second;

	return sprintf("%d", epoch);
}

//
// Collect system/unit information from VyOS using REST API show commands
//
function collect_unit_info() {
	let unit = {};
	unit.localtime = time();

	// Get uptime and load average via "show system uptime"
	let uptime_result = vyos_api_call({
		op: "show",
		path: ["system", "uptime"]
	});

	if (uptime_result && uptime_result.data) {
		// Parse uptime: "Uptime: 12m 4s" or "Uptime: 1h 23m 45s" or "Uptime: 2d 5h 30m"
		// Use [^\n]+ to stop at newline (not greedy .+ which captures everything)
		let uptime_match = match(uptime_result.data, /Uptime:\s+([^\n]+)/);
		if (uptime_match) {
			unit.uptime = parse_uptime_string(uptime_match[1]);
		} else {
			unit.uptime = 0;
		}

		// Parse load averages: "1  minute:   0.0%"
		// Note: uCode regex doesn't support \d, use [0-9] instead
		let load_lines = split(uptime_result.data, "\n");
		let load = [0.0, 0.0, 0.0];
		for (let line in load_lines) {
			if (index(line, "1  minute:") >= 0) {
				let m = match(line, /([0-9]+\.[0-9]+)%/);
				if (m) load[0] = +(m[1]);
			} else if (index(line, "5  minutes:") >= 0) {
				let m = match(line, /([0-9]+\.[0-9]+)%/);
				if (m) load[1] = +(m[1]);
			} else if (index(line, "15 minutes:") >= 0) {
				let m = match(line, /([0-9]+\.[0-9]+)%/);
				if (m) load[2] = +(m[1]);
			}
		}
		unit.load = load;
	} else {
		unit.uptime = 0;
		unit.load = [0.0, 0.0, 0.0];
	}

	// Get memory info via "show system memory"
	let memory_result = vyos_api_call({
		op: "show",
		path: ["system", "memory"]
	});

	if (memory_result && memory_result.data) {
		// Parse: "Total: 15.64 GB", "Free:  14.98 GB", "Used:  668.07 MB"
		// Note: uCode regex doesn't support \d, use [0-9] instead
		let total_match = match(memory_result.data, /Total:\s+([0-9.]+)\s+(\w+)/);
		let free_match = match(memory_result.data, /Free:\s+([0-9.]+)\s+(\w+)/);
		let used_match = match(memory_result.data, /Used:\s+([0-9.]+)\s+(\w+)/);

		unit.memory = {
			total: total_match ? parse_memory_value(total_match[1], total_match[2]) : 0,
			free: free_match ? parse_memory_value(free_match[1], free_match[2]) : 0,
			available: free_match ? parse_memory_value(free_match[1], free_match[2]) : 0,
			buffered: 0,  // VyOS doesn't report these separately
			cached: 0
		};
	} else {
		unit.memory = {
			total: 0,
			free: 0,
			available: 0,
			buffered: 0,
			cached: 0
		};
	}

	return unit;
}

//
// Fallback: Collect unit info using text parsing (if helper script fails)
//
// NOTE: collect_unit_info_fallback() was removed - fallback logic is now inline
// in collect_unit_info() to avoid nested function calls (uCode limitation)

//
// Collect interface information from VyOS using REST API show commands
//
function collect_interfaces() {
	let interfaces = [];

	// Get interface counters via "show interfaces counters"
	let counters_result = vyos_api_call({
		op: "show",
		path: ["interfaces", "counters"]
	});

	if (!counters_result || !counters_result.data) {
		printf("WARN: Failed to get interface counters\n");
		return interfaces;
	}

	// Parse table format:
	// Interface    Rx Packets    Rx Bytes    Tx Packets    Tx Bytes    Rx Dropped    Tx Dropped    Rx Errors    Tx Errors
	// -----------  ------------  ----------  ------------  ----------  ------------  ------------  -----------  -----------
	// eth0         530           99371       328           155781      0             0             0            0
	// eth1         622           178859      7             826         0             0             0            0
	// lo           50            12368       50            12368       0             0             0            0

	let lines = split(counters_result.data, "\n");
	let in_data = false;

	for (let line in lines) {
		line = trim(line);
		if (length(line) == 0) continue;

		// Skip header and separator lines
		if (index(line, "Interface") >= 0 || index(line, "---") >= 0) {
			in_data = true;
			continue;
		}

		if (!in_data) continue;

		// Parse data line - split by whitespace
		let fields = split(line, /\s+/);
		if (length(fields) < 9) continue;

		let if_name = fields[0];

		// Skip loopback
		if (if_name == "lo")
			continue;

		let iface = {
			name: if_name,
			location: if_name  // Will be updated with description if available
		};

		// Parse counters
		iface.counters = {
			rx_packets: +(fields[1]),
			rx_bytes: +(fields[2]),
			tx_packets: +(fields[3]),
			tx_bytes: +(fields[4]),
			rx_dropped: +(fields[5]),
			tx_dropped: +(fields[6]),
			rx_errors: +(fields[7]),
			tx_errors: +(fields[8]),
			multicast: 0,  // Not available in counters table
			collisions: 0  // Not available in counters table
		};

		push(interfaces, iface);
	}

	// Get interface details to add IP addresses and descriptions
	let details_result = vyos_api_call({
		op: "show",
		path: ["interfaces"]
	});

	if (details_result && details_result.data) {
		// Parse the interface list to extract IPs and descriptions
		// Format: "eth0         192.168.3.35/24  52:54:00:b1:94:93  default   1500  u/u    WAN"
		let detail_lines = split(details_result.data, "\n");
		let in_data = false;

		for (let line in detail_lines) {
			line = trim(line);
			if (length(line) == 0) continue;

			// Skip header lines
			if (index(line, "Interface") >= 0 || index(line, "---") >= 0) {
				in_data = true;
				continue;
			}

			if (!in_data) continue;

			let fields = split(line, /\s+/);
			if (length(fields) < 2) continue;

			let if_name = fields[0];
			let ip_addr = fields[1];

			// Find the interface in our array and add IP/description
			for (let iface in interfaces) {
				if (iface.name == if_name) {
					// Add IPv4 address if present (not "-")
					if (ip_addr != "-" && index(ip_addr, ":") < 0) {  // IPv4, not IPv6
						iface.ipv4 = { addresses: [ip_addr] };
					}

					// Add description if available (last field)
					if (length(fields) >= 7) {
						iface.location = fields[6];
					}
					break;
				}
			}
		}
	}

	return interfaces;
}

//
// Enrich interfaces with DHCP server lease data
//
function enrich_dhcp_leases(interfaces) {
	// Get DHCP server leases
	let leases_result = vyos_api_call({
		op: "show",
		path: ["dhcp", "server", "leases", "state", "all"]
	});

	if (!leases_result || !leases_result.data) {
		return;  // DHCP server might not be configured
	}

	// Parse DHCP lease table
	// IP Address      MAC address        State    Lease start                Lease expiration           Remaining    Pool         Hostname      Origin
	// 192.168.100.20  c0:c9:89:67:02:f0  active   2026-03-05 16:02:21+00:00  2026-03-05 22:02:21+00:00  5:51:26      LAN-VLAN100  c0c9896702f0  local

	let lines = split(leases_result.data, "\n");
	let in_data = false;
	let leases_by_pool = {};

	for (let line in lines) {
		line = trim(line);
		if (length(line) == 0) continue;

		// Skip header lines
		if (index(line, "IP Address") >= 0 || index(line, "---") >= 0) {
			in_data = true;
			continue;
		}

		if (!in_data) continue;

		// Parse lease line
		let fields = split(line, /\s+/);
		if (length(fields) < 9) continue;

		let ip = fields[0];
		let mac = fields[1];
		let state = fields[2];
		let lease_start = fields[3] + " " + fields[4];  // Date + time
		let pool = fields[8];
		let hostname = (length(fields) > 9) ? fields[9] : "";

		// Only include active leases
		if (state != "active")
			continue;

		// Parse lease start to unix timestamp
		// Format: 2026-03-05 16:02:21+00:00
		let assigned_timestamp = parse_iso8601_to_epoch(lease_start);

		let lease = {
			address: ip,
			mac: mac,
			hostname: hostname,
			assigned: assigned_timestamp || lease_start  // Use epoch time, fallback to string if parse fails
		};

		if (!leases_by_pool[pool])
			leases_by_pool[pool] = [];

		push(leases_by_pool[pool], lease);
	}

	// Map pool names to interface names
	// LAN-VLAN100 -> eth1.100, LAN-VLAN101 -> eth1.101, Guest -> eth1.1000
	let pool_to_interface = {};
	for (let pool_name, leases in leases_by_pool) {
		// Extract VLAN ID from pool name like "LAN-VLAN100" or use known mappings
		let vlan_match = match(pool_name, /VLAN([0-9]+)/);
		if (vlan_match) {
			let vlan_id = vlan_match[1];
			pool_to_interface[pool_name] = "eth1." + vlan_id;
		} else if (pool_name == "Guest") {
			pool_to_interface[pool_name] = "eth1.1000";
		}
	}

	// Add leases to matching interfaces
	for (let iface in interfaces) {
		for (let pool_name, if_name in pool_to_interface) {
			if (iface.name == if_name) {
				if (!iface.ipv4)
					iface.ipv4 = {};
				iface.ipv4.leases = leases_by_pool[pool_name];
				break;
			}
		}
	}
}

//
// Enrich WAN interface with DHCP client lease data
//
function enrich_wan_dhcp(interfaces) {
	// Get DHCP client leases
	let client_result = vyos_api_call({
		op: "show",
		path: ["dhcp", "client", "leases"]
	});

	if (!client_result || !client_result.data) {
		return;  // No DHCP client configured
	}

	// Parse DHCP client output
	// Interface    br0
	// IP address   192.168.3.58                  [Active]
	// DHCP Server  192.168.3.1
	// Name Server  192.168.3.1
	// Lease Time   3600

	let data = client_result.data;

	// Extract interface name
	let if_match = match(data, /Interface\s+(\S+)/);
	if (!if_match)
		return;

	let if_name = if_match[1];

	// Extract DHCP server
	let dhcp_server = null;
	let server_match = match(data, /DHCP Server\s+(\S+)/);
	if (server_match)
		dhcp_server = server_match[1];

	// Extract Name Server (DNS)
	let dns_servers = [];
	let dns_match = match(data, /Name Server\s+(\S+)/);
	if (dns_match)
		push(dns_servers, dns_match[1]);

	// Extract Lease Time
	let leasetime = null;
	let lease_match = match(data, /Lease Time\s+([0-9]+)/);
	if (lease_match)
		leasetime = +(lease_match[1]);

	// Find the interface and add DHCP info
	for (let iface in interfaces) {
		if (iface.name == if_name) {
			if (!iface.ipv4)
				iface.ipv4 = {};

			if (dhcp_server)
				iface.ipv4.dhcp_server = dhcp_server;
			if (leasetime)
				iface.ipv4.leasetime = leasetime;
			if (length(dns_servers) > 0)
				iface.dns_servers = dns_servers;

			break;
		}
	}
}

//
// Collect link-state information for physical ethernet ports
//
function collect_link_state(interface_roles) {
	let link_state = {
		upstream: {},
		downstream: {}
	};

	// Get list of ethernet interfaces from VyOS
	let interfaces_result = vyos_api_call({
		op: "show",
		path: ["interfaces"]
	});

	if (!interfaces_result || !interfaces_result.data) {
		printf("WARN: Failed to get interfaces for link-state\n");
		return link_state;
	}

	// Parse interface table to find ethernet interfaces
	let lines = split(interfaces_result.data, "\n");
	let eth_interfaces = [];

	for (let line in lines) {
		line = trim(line);
		if (length(line) == 0 || index(line, "Interface") >= 0 || index(line, "---") >= 0 || index(line, "Codes:") >= 0)
			continue;

		let fields = split(line, /\s+/);
		if (length(fields) < 1)
			continue;

		let if_name = fields[0];

		// Only process physical ethernet interfaces (not VLANs, bridges, lo)
		if (index(if_name, "eth") == 0 && index(if_name, ".") < 0) {
			push(eth_interfaces, if_name);
		}
	}

	// Get all ethernet interface details in one API call (more efficient)
	let eth_detail_result = vyos_api_call({
		op: "show",
		path: ["interfaces", "ethernet", "detail"]
	});

	if (!eth_detail_result || !eth_detail_result.data) {
		printf("WARN: Failed to get ethernet interface details\n");
		return link_state;
	}

	// Split the output into per-interface blocks
	// Each interface starts with "ethX:" at the beginning of a line
	let blocks = split(eth_detail_result.data, /\neth/);

	// Parse each interface block
	for (let i, block in blocks) {
		// First block might be empty or not start with eth
		if (i == 0 && index(block, "eth") != 0)
			continue;

		// Add "eth" back to the beginning (except first block which might already have it)
		if (i > 0)
			block = "eth" + block;

		block = trim(block);
		if (length(block) == 0)
			continue;

		// Extract interface name from first line "eth0: <BROADCAST..."
		let name_match = match(block, /^(eth[0-9]+):/);
		if (!name_match)
			continue;

		let if_name = name_match[1];

		// Skip VLAN sub-interfaces (eth1.100, etc)
		if (index(if_name, ".") >= 0)
			continue;

		let role_info = interface_roles[if_name];
		let role = role_info?.role || "unknown";

		// Skip if we don't know the role
		if (role == "unknown")
			continue;

		let link_info = {};

		// Parse link state from "state UP" or "state DOWN"
		if (index(block, "state UP") >= 0) {
			link_info.carrier = 1;
		} else if (index(block, "state DOWN") >= 0) {
			link_info.carrier = 0;
		}

		// Parse MAC address from "link/ether 52:54:00:05:81:d5"
		let mac_match = match(block, /link\/ether\s+([0-9a-f:]+)/);
		if (mac_match) {
			link_info.mac = mac_match[1];
		}

		// Parse counters from RX/TX lines
		// RX:    bytes  packets  errors  dropped  overrun       mcast
		//      2518678    13319       0        0        0           0
		let rx_match = match(block, /RX:\s+bytes\s+packets.*\n\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)/);
		let tx_match = match(block, /TX:\s+bytes\s+packets.*\n\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)/);

		if (rx_match && tx_match) {
			let counters = {
				rx_bytes: +(rx_match[1]),
				rx_packets: +(rx_match[2]),
				rx_errors: +(rx_match[3]),
				rx_dropped: +(rx_match[4]),
				multicast: +(rx_match[6]),
				tx_bytes: +(tx_match[1]),
				tx_packets: +(tx_match[2]),
				tx_errors: +(tx_match[3]),
				tx_dropped: +(tx_match[4]),
				collisions: +(tx_match[6])
			};

			link_info.counters = counters;

			// Calculate delta counters from previous state
			let prev_link = previous["link-state"] && previous["link-state"][role] && previous["link-state"][role][if_name];
			if (prev_link && prev_link.counters) {
				let deltas = {};
				for (let key in ["rx_packets", "tx_packets", "rx_bytes", "tx_bytes", "rx_errors", "tx_errors", "rx_dropped", "tx_dropped", "multicast", "collisions"]) {
					let curr = counters[key] || 0;
					let prev = prev_link.counters[key] || 0;
					let delta = curr - prev;

					// Handle counter wraps (assume counter wrapped if negative)
					if (delta < 0) {
						delta = curr;
					}

					deltas[key] = delta;
				}
				link_info.delta_counters = deltas;
			}
		}

		// Get physical layer info (speed/duplex) for this interface
		let physical_result = vyos_api_call({
			op: "show",
			path: ["interfaces", "ethernet", if_name, "physical"]
		});

		if (physical_result && physical_result.data) {
			let physical = physical_result.data;

			// Parse speed: "Speed: 1000Mb/s" - only set if we get a valid number
			let speed_match = match(physical, /Speed:\s+([0-9]+)Mb\/s/);
			if (speed_match) {
				link_info.speed = +(speed_match[1]);
			}

			// Parse duplex: "Duplex: Full" or "Duplex: Half" - only set if valid
			let duplex_match = match(physical, /Duplex:\s+(\w+)/);
			if (duplex_match) {
				let duplex_val = lc(duplex_match[1]);
				if (duplex_val == "full" || duplex_val == "half") {
					link_info.duplex = duplex_val;
				}
			}
		}

		// Map to upstream/downstream by role
		let port_label = role_info?.description || if_name;

		if (role == "upstream") {
			link_state.upstream[port_label] = link_info;
		} else if (role == "downstream") {
			link_state.downstream[port_label] = link_info;
		}
	}

	return link_state;
}

//
// Collect LLDP neighbor information
//
function collect_lldp_peers() {
	let lldp_peers = {
		upstream: {},
		downstream: {}
	};

	let lldp_data = vyos_api_call({
		op: "show",
		path: ["lldp", "neighbors", "detail"]
	});

	if (!lldp_data || !lldp_data.data) {
		// LLDP might not be configured - this is OK
		return lldp_peers;
	}

	// Parse LLDP neighbor data (text format)
	// TODO: Implementation depends on VyOS LLDP output format

	return lldp_peers;
}

//
// Collect client information (DHCP leases + ARP table + NAT sessions)
//
function collect_clients() {
	let clients_by_mac = {};

	// Get DHCP server leases (text output - needs parsing)
	let dhcp_response = vyos_api_call({
		op: "show",
		path: ["dhcp", "server", "leases"]
	});

	if (dhcp_response && dhcp_response.data) {
		let dhcp_leases = parsers_module.parse_dhcp_leases(dhcp_response.data);

		for (let lease in dhcp_leases) {
			let mac = lc(lease.mac);  // Normalize to lowercase

			if (!clients_by_mac[mac])
				clients_by_mac[mac] = {};

			clients_by_mac[mac].ip = lease.ip;
			clients_by_mac[mac].hostname = (lease.hostname != "-") ? lease.hostname : null;
			clients_by_mac[mac].pool = lease.pool;
			clients_by_mac[mac].dhcp_state = lease.state;
		}
	}

	// Get ARP table for additional discovery (text output)
	let arp_response = vyos_api_call({
		op: "show",
		path: ["arp"]
	});

	if (arp_response && arp_response.data) {
		let arp_entries = parsers_module.parse_arp_table(arp_response.data);

		for (let entry in arp_entries) {
			let mac = lc(entry.mac);

			if (!clients_by_mac[mac])
				clients_by_mac[mac] = {};

			// If we don't have IP from DHCP, use ARP
			if (!clients_by_mac[mac].ip)
				clients_by_mac[mac].ip = entry.ip;

			clients_by_mac[mac].interface = entry.interface;
			clients_by_mac[mac].arp_state = entry.state;
		}
	}

	// Get NAT translations to identify active clients (text output)
	let nat_response = vyos_api_call({
		op: "show",
		path: ["nat", "source", "translations"]
	});

	if (nat_response && nat_response.data) {
		let nat_sessions = parsers_module.parse_nat_translations(nat_response.data);

		// Mark clients as active if they have recent NAT sessions
		let active_ips = {};
		for (let session in nat_sessions) {
			active_ips[session.source_ip] = true;
		}

		// Tag clients with active connections
		for (let mac, client in clients_by_mac) {
			if (active_ips[client.ip]) {
				client.active = true;
			}
		}
	}

	return clients_by_mac;
}

//
// Main execution
//

// Call helper script once and cache the result
let system_stats_response = vyos_api_call({
	op: "show",
	path: ["system", "stats"]
});

let system_stats_data = null;
if (system_stats_response && system_stats_response.data) {
	try {
		system_stats_data = json(system_stats_response.data);
	} catch(e) {
		printf("ERROR: Failed to parse system stats JSON\n");
	}
}

// Get interface roles from config
let config_response = vyos_api_call({
	op: "showConfig",
	path: ["interfaces"]
});

let interface_config = config_response?.data || {};
let interface_roles = parsers_module.get_interface_roles_from_config({ interfaces: interface_config });

// Collect all state information
state.unit = collect_unit_info();  // Uses VyOS REST API show commands
state.interfaces = collect_interfaces();  // Uses VyOS REST API show commands

// Enrich interfaces with DHCP data
enrich_dhcp_leases(state.interfaces);
enrich_wan_dhcp(state.interfaces);

state["link-state"] = collect_link_state(interface_roles);  // Uses VyOS REST API show commands

// Optional: LLDP peers (if enabled in stats config)
if (index(stats.types || [], 'lldp') >= 0) {
	state["lldp-peers"] = collect_lldp_peers();
}

// Optional: Client tracking
// NOTE: Client data is collected but not yet integrated into the state schema
// Uncomment when ready to test client reporting
// let clients = collect_clients();

// Save current state for next delta calculation
let state_snapshot = {
	interfaces: {},
	"link-state": state["link-state"]
};

// Build interface lookup for next iteration
for (let iface in state.interfaces) {
	state_snapshot.interfaces[iface.name] = {
		counters: iface.counters
	};
}

fs.writefile('/tmp/vyos-state.json', state_snapshot);

// Output state to stdout (for debugging)
printf("%.J\n", state);

// Build final message with serial and UUID
let msg = {
	uuid: cfg.uuid || 1,
	serial: cursor.get("ucentral", "config", "serial"),
	state: state
};

// Send to ucentral client via ubus
if (ctx) {
	try {
		ctx.call("ucentral", "stats", msg);
	} catch(e) {
		printf("WARN: Failed to send stats via ubus\n");
	}

	// Also save to file for daemon to read
	let f = fs.open("/tmp/ucentral.state", "w");
	if (f) {
		f.write(sprintf("%.J\n", msg));
		f.close();
	}
}
