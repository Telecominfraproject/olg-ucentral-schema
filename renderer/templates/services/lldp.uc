    lldp {
{% for (let i in lldp.interfaces): %}
        interface {{ ethernet.get_iface_by_name(i.name) }} {
    {% if (i.mode): %}
            mode "{{ i.mode }}"
    {% endif %}
        }
{% endfor %}
{% if (lldp.management-addresses): %}
    {% for (let addr in lldp.management-addresses): %}
        management-address "{{ addr }}"
    {% endfor %}
{% endif %}
    }
