{% let name_c = 0; %}
{% if (vrrp.groups && length(vrrp.groups)): %}
    vrrp {
    {% for (let g in vrrp.groups): %}
        {% let temp_c = name_c++; %}
        group vrrp_g{{ temp_c }} {
        {% for (let i in g.virtual_addresses): %}
            address {{ i }} {
            }
        {% endfor %}
            interface {{ ethernet.get_iface_by_name(g.interface) }}
        {% if (!g.preempt): %}
            no-preempt
        {% endif %}
            priority {{ g.priority }}
            vrid {{ g.vrid }}
        }
    {% endfor %}
    }
{% endif %}
