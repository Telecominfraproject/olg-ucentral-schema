    ospf {
{% for (let a in ospf.areas): %}
        area {{ a.area_id }} {
    {% if (a.area_type): %}
            {{ a.area_type }}
    {% endif %}
    {% for (let n in a.networks): %}
            network "{{ n }}"
    {% endfor %}
        }
{% endfor %}
        parameters {
            router-id "{{ ospf.router_id }}"
        }
        redistribute {
            connected {
            }
        }
    }