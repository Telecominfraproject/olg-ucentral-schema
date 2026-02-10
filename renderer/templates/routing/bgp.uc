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
                {{ n.peer_params }} {
                }
            }
            {% if (n.passive): %}
            passive
            {% endif %}
            {% if (n.password): %}
            password "{{ n.password }}"
            {% endif %}
            port "{{ n.port }}"
            remote-as "{{ n.remote_as }}"
        }
        {% endfor %}
        parameters {
            router-id "{{ bgp.router_id }}"
        }
        system-as "{{ bgp.local_as }}"
    }
