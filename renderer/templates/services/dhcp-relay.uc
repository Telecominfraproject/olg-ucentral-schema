    dhcp-relay {
        {% for (let iface in dhcp_relay.listen_interfaces): %}
        listen-interface "{{ ethernet.get_iface_by_name(iface) }}"
        {% endfor %}
        {% for (let upstream in dhcp_relay.upstream_interfaces): %}
        upstream-interface "{{ upstream }}"
        {% endfor %}
        {% for (let server in dhcp_relay.servers): %}
        server "{{ server }}"
        {% endfor %}
    }
