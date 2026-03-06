protocols {
    {% 
    if (routing.static || length(upstreams)) {
        include("static.uc", {
            location: location + '/static',
            upstreams,
            routing
        })
    }
    %}

    {% 
    if (routing.bgp) {
        include("bgp.uc", {
            location: location + '/bgp',
            bgp: routing.bgp
        })
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
    
