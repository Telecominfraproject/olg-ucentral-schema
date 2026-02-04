{% if (vrrp.groups && length(vrrp.groups)): %}
    vrrp {
    {% for (let g in vrrp.groups): %}
        {% let temp_c = name_c++; name_m[g.name] = temp_c; %}
        group vrrp_g{{ temp_c }} {
        {% for (let i in g.virtual_addresses)%}
            address {{ i }} {
            }
        {% endfor %}
            interface {{ g.interface }}
        {% if (!g.preempt): %}
            no-preempt
        {% endif %}
            priority {{ g.priority }}
            vrid {{ g.vrid }}
        }
    {% endfor %}
    }
{% endif %}
