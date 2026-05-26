{%%}
    pppoe-server {
        access-concentrator "PPPoE-Server"
        authentication {
{% if (pppoe.local): %}
    {% for (let u in pppoe.local): %}
            local-users {
                username {{ u.user }} {
                    password "{{ u.password }}"
                }
            }
    {% endfor %}
{% endif %}
            mode "{{ pppoe.auth_mode }}"
        }
        client-ip-pool {{ pppoe.client_ip_pool.name }} {
            range "{{ pppoe.client_ip_pool.range }}"
        }
        default-pool "{{ pppoe.client_ip_pool.name }}"
{% if (pppoe.gateway_address): %}
        gateway-address "{{ pppoe.gateway_address }}"
{% endif %}
{% for (let i in pppoe.interfaces): %}
        interface {{ ethernet.get_iface_by_name(i) }} {
        }
{% endfor %}
    }
