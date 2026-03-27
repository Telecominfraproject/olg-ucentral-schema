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