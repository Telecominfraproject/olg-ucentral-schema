{%
let has_static_upstream = false, dhcp_iface = null;
if (length(upstreams)) {
    for (let up in upstreams) {
        if ((up.ipv4 && up.ipv4.addressing == "static") || 
            (up.ipv6 && up.ipv6.addressing == "static")) {
            has_static_upstream = true;
            break;
        }
    }
    for (let up in upstreams) {
        if (!dhcp_iface) {
            // first match, set to dhcp_iface
            if (up.ipv4 && up.ipv4.addressing == "dhcp") {
                dhcp_iface = up.name;
            }
        }
        else {
            // second match, dual wan mode, disable dhcp-iface 
            if (up.ipv4 && up.ipv4.addressing == "dhcp") {
                dhcp_iface = null;
            }
        }
    }
}
%}
{% if (
    routing.static || routing.bgp || routing.ospf || routing.rip || 
    has_static_upstream || igmp_proxy || dhcp_iface ||
    (wireguard && length(wireguard.interfaces))): %}
protocols {
    {% 
    if (routing.static || has_static_upstream || dhcp_iface || 
        (wireguard && length(wireguard.interfaces))) {
        include("static.uc", {
            location: location + '/static',
            has_default: has_static_upstream,
            upstreams,
            routing,
            wireguard,
            dhcp_iface,
            ethernet,
        });
    }
    %}

    {% 
    if (routing.bgp) {
        include("bgp.uc", {
            location: location + '/bgp',
            bgp: routing.bgp
        });
    }
    %}

    {% 
    if (routing.ospf) {
        include("ospf.uc", {
            location: location + '/ospf',
            ospf: routing.ospf
        });
    }
    %}

    {% 
    if (routing.rip) {
        include("rip.uc", {
            location: location + '/rip',
            rip: routing.rip
        });
    }
    %}
    

    {%
    if (igmp_proxy) {
        include("igmp_proxy.uc", {
            location: location + '/igmp_proxy',
            igmp_proxy,
            ethernet
        });
    }
    %}
}
{% endif %}    
