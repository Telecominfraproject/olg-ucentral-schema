{%
let has_static_upstream = false;
if (length(upstreams)) {
    for (let up in upstreams) {
        if ((up.ipv4 && up.ipv4.addressing == "static") || 
            (up.ipv6 && up.ipv6.addressing == "static")) {
            has_static_upstream = true;
            break;
        }
    }
}
%}
{% if (routing || has_static_upstream || igmp_proxy): %}
protocols {
    {% 
    if (routing.static || has_static_upstream) {
        include("static.uc", {
            location: location + '/static',
            upstreams,
            routing
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
            igmp_proxy
        });
    }
    %}
}
{% endif %}    
