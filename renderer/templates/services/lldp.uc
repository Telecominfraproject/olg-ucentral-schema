{%%}
    lldp {
{% for (let i in lldp.interfaces): %}
        interface {{ i.name }} {
            mode "{{ i.mode }}"
        }
{% endfor %}
{% if (lldp.management_address): %}
        management-address "{{ lldp.management_address }}"
{% endif %}
    }