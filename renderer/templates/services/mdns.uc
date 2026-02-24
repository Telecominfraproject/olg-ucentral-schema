{% %}
    mdns {
        repeater {
{% for (let i in mdns.interfaces): %}
            interface "{{ i }}"
{% endfor %}
{% for (let a in mdns.allow_services): %}
            allow-service "{{ a }}"
{% endfor %}
        }
    }