service {
    {%
        if (services.dhcp_relay) {
			include("dhcp-relay.uc", { location: location + '/dhcp_relay', dhcp_relay: services.dhcp_relay });
        }
        if (services.dhcp_server) {
            include("dhcp-server.uc", { location: location + '/dhcp_server', dhcp_server: services.dhcp_server });
        }
        if (services.dns) {
            include("dns.uc", { location: location + '/dns', dns: services.dns });
        }
        if (services.snmp) {
            include("snmp.uc", { location: location + '/snmp', snmp: services.snmp });
        }
        if (services.ntp) {
            include("ntp.uc", { location: location + '/ntp', ntp: services.ntp });
        }
        if (services.lldp) {
            include("lldp.uc", { location: location + '/lldp', lldp: services.lldp });
        }
        if (services.mdns) {
            include("mdns.uc", { location: location + '/mdns', mdns: services.mdns });
        }
        if (services.pppoe_server) {
            include("pppoe-server.uc", {
                location: location + '/pppoe_server',
                ethernet,
                pppoe: services.pppoe_server
            });
        }
        if (services.tftp_server) {
            include("tftp-server.uc", { location: location + '/tftp_server', tftp: services.tftp_server });
        }
        if (services.web_proxy) {
            include("web-proxy.uc", { location: location + '/web_proxy', wbp: services.web_proxy });
        }
        include("https.uc", { location: location + '/https' });
    %}
}
