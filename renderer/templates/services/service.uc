service {
    {%
        if (services.dhcp_relay) {
			include("dhcp-relay.uc", { location: location + '/dhcp_relay', dhcp_relay: services.dhcp_relay });
        }
        if (services.dhcp_server) {
            include("dhcp-server.uc", { location: location + '/dhcp_server', dhcp_server: services.dhcp_server });
        }
        if (services.dns_forwarding) {
            include("dns-forwarding.uc", { location: location + '/dns_forwarding', dns_forwarding: services.dns_forwarding });
        }
    %}
}