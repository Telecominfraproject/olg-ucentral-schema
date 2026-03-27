    lldp {
{% for (let i in lldp.interfaces): %}
        interface {{ i.name }} {
    {% if (i.mode): %}
            mode "{{ i.mode }}"
    {% endif %}
        }
{% endfor %}
{% if (lldp.management_address): %}
        management-address "{{ lldp.management_address }}"
{% endif %}
    }
