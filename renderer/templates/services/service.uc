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
        include("https.uc", { location: location + '/https' });
    %}
}
