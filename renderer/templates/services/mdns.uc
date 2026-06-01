    mdns {
        repeater {
{% for (let i in mdns.interfaces): %}
            interface "{{ ethernet.get_iface_by_name(i) }}"
{% endfor %}
{% for (let a in mdns.allow_services): %}
            allow-service "{{ a }}"
{% endfor %}
        }
    }
