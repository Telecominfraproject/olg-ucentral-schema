{%
/*
 * VyOS Configuration - Toplevel Template
 *
 * NOTE: This template is NOT the primary entry point.
 *
 * The renderer automatically discovers and processes domain-specific
 * templates (interfaces.uc, routing.uc, firewall.uc, etc.) and generates
 * separate .vyos files for each domain.
 *
 * This toplevel template can optionally be used for:
 * 1. Generating a combined/monolithic configuration file
 * 2. Adding global header/footer content
 * 3. Custom orchestration if needed
 *
 *
 */

 	let fs = require('fs');

	// reject the config if there is no valid upstream configuration
	if (!state.uuid) {
		state.strict = true;
		error('Configuration must contain a valid UUID. Rejecting whole file');
		return;
	}

	// upstream interface
    let up_i = [];
	for (let i, interface in state.interfaces) {
		if (interface.role != 'upstream')
			continue;
		push(up_i, interface);
	}
	
    if (state.interfaces || state.vpn) {
        include("interfaces.uc", {
			location: '/interfaces',
			ethernet: ethernet,
			interfaces: state.interfaces,
			vpn: state.vpn ? state.vpn : {}
		});
	}
	
	if (state.firewall) {
		include("firewall.uc", {
			u,
			location: '/firewall',
			firewall: state.firewall,
			services: state.services,
			routing: state.routing,
			vpn: state.vpn ? state.vpn : {},
			ethernet: ethernet
		});
	}

	if (state.high_availability) {
		include("high-availability/high-availability.uc", {
			location: '/high_availability',
			ha: state.high_availability,
			ethernet: ethernet
		});
	}

	if (state.load_balancing) {
		include("load-balancing/load-balancing.uc", {
			location: '/load_balancing',
			lb: state.load_balancing,
			ethernet: ethernet
		});
	}
	
	if (state.nat) {
		include("nat.uc", {
			location: '/nat',
			nat: state.nat
		});
	}

	if (!state.pki) {
		state.pki = {};
	}
	include("pki.uc", { location: '/pki', pki: state.pki });

	if (state.routing || length(up_i) || (state.services && state.services.igmp_proxy) ) {
		state.routing = state.routing || {};
		if (state.routing.policies) {
			state.routing.policies = state.routing.policies || [];
			include("policy.uc", {
				location: '/policy',
				policies: state.routing.policies
			});
		}
		state.services = state.services || {};

		include("routing/routing.uc", {
			location: '/routing',
			routing: state.routing,
			upstreams: up_i,
			igmp_proxy: state.services.igmp_proxy
		});
	}

	if (state.qos) {
		include("qos.uc", {
			location: '/qos',
			qos: state.qos
		});
	}

	if (!state.services) {
		state.services = {};
	}
	include("services/service.uc", {
		location: '/services', services: state.services
	});

	if (!state.system) {
		state.system = {};
	}
	include("system/system.uc", {
		location: '/system',
		system: state.system
	});

	if (state.vpn && state.vpn.ipsec) {
		include("vpn/vpn.uc", {
			location: '/vpn',
			vpn: state.vpn
		});
	}
%}

// Warning: Do not remove the following line.
// vyos-config-version: "bgp@6:broadcast-relay@1:cluster@2:config-management@1:conntrack@6:conntrack-sync@2:container@3:dhcp-relay@2:dhcp-server@11:dhcpv6-server@6:dns-dynamic@4:dns-forwarding@4:firewall@20:flow-accounting@3:https@7:ids@2:interfaces@34:ipoe-server@4:ipsec@14:isis@3:l2tp@9:lldp@3:mdns@1:monitoring@2:nat@8:nat66@3:nhrp@1:ntp@3:openconnect@3:openvpn@4:ospf@2:pim@1:policy@9:pppoe-server@11:pptp@5:qos@3:quagga@12:reverse-proxy@3:rip@1:rpki@2:salt@1:snmp@3:ssh@3:sstp@6:system@30:vpp@4:vrf@3:vrrp@4:vyos-accel-ppp@2:wanloadbalance@4:webproxy@2"
// Release version: 1.5-rolling-202601090247
