    igmp-proxy {
        interface {{ ethernet.get_iface_by_name(igmp_proxy.upstream_interface) }} {
            {% for (let s in igmp_proxy.alt_subnets): %}
            alt-subnet "{{ s }}"
            {% endfor %}
            role "upstream"
        }
        {% for (let d in igmp_proxy.downstream_interfaces): %}
        interface {{ ethernet.get_iface_by_name(d) }} {
            role "downstream"
        }
        {% endfor %}
    }
