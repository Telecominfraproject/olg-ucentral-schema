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
            location: location + '/bgp',
            ospf: routing.ospf
        });
    }
    %}

    {% 
    if (routing.rip) {
        include("rip.uc", {
            location: location + '/bgp',
            rip: routing.rip
        });
    }
    %}
    

    {% if (igmp_proxy): %}
    igmp-proxy {
        interface {{ igmp_proxy.upstream_interface }} {
            {% for (let s in igmp_proxy.alt_subnets): %}
            alt-subnet "{{ s }}"
            {% endfor %}
            role "upstream"
        }
        {% for (let d in igmp_proxy.downstream_interfaces): %}
        interface {{ d }} {
            role "downstream"
        }
        {% endfor %}
    }
    {% endif %}
}    
{% endif %}    
