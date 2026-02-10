    wan {
{% for (let i in wan.interfaces): %}
        {% /* We might need to implement name conversion here*/ %}
        interface-health {{ i.name }} {
            nexthop "{{ i.health_check.target }}"
    {% if (i.success_count): %}
            success-count {{ i.success_count }}
    {% endif %}
    {% if (i.failure_count): %}
            failure-count {{ i.failure_count }}
    {% endif %}
        }
{% endfor %}
{% for (let r in wan.rules): %}
        rule {{ r.id }} {
            inbound-interface "{{ r.inbound_interface }}"
    {% for (let r_i in r.wan_interfaces): %}
            interface {{ r_i.name }} {
                weight "{{ r_i.weight }}"
            }
    {% endfor %}
        }
{% endfor %}
    }
