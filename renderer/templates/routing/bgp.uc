    bgp {
        {% for (let t in bgp.networks): %}
        address-family {
            {{ t.address_family }} {
                network {{ t.network }} {
                }
            }
        }
        {% endfor %}
        {% for (let n in bgp.neighbors): %}
        neighbor {{ n.address }} {
            address-family {
            {% for (let param in n.peer_params): %}
                {{ param.address_family }} {
                }
            {% endfor %}
            }

            {% if (n.passive): %}
            passive
            {% endif %}
            {% if (n.password): %}
            password "{{ n.password }}"
            {% endif %}
            {% if (n.port): %}
            port "{{ n.port }}"
            {% endif %}
            remote-as "{{ n.remote_as }}"
        }
        {% endfor %}
        parameters {
            router-id "{{ bgp.router_id }}"
        }
        system-as "{{ bgp.local_as }}"
    }
