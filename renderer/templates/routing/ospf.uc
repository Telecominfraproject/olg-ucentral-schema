    ospf {
{% for (let a in ospf.areas): %}
        area {{ a.area_id }} {
    {% if (a.area_type): %}
            area-type {
        {% if (a.area_type != "normal"): %}
                {{ a.area_type }} {
            {% if (a.no_summary): %}
                    no-summary
            {% endif %}
                }
        {% else %}
                normal
        {% endif %}
            }
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
{% if (ospf.redistribute): %}
    {% if (ospf.redistribute.connected): %}
            connected {
            }
    {% endif %}
    {% if (ospf.redistribute.static): %}
            static {
            }
    {% endif %}
    {% if (ospf.redistribute.bgp): %}
            bgp {
            }
    {% endif %}
    {% if (ospf.redistribute.rip): %}
            rip {
            }
    {% endif %}
{% else %}
            connected {
            }
{% endif %}
        }
    }
