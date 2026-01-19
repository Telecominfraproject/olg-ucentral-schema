{%
let range_id = 0, subnet_id = 1;
%}
    dhcp-server {
        {% for (let network in dhcp_server.networks): %}
        shared-network-name {{ network.name }} {
            {% for (let subnet in network.subnets): %}
            subnet {{ subnet.subnet }} {
                lease "{{ subnet.lease_time }}"
                option {
                    default-router "{{ subnet.default_router }}"
                    {% if (subnet.domain_name): %}
                    domain-name "{{ subnet.domain_name }}"
                    {% endif %}
                    {% for (let server in subnet.dns_servers): %}
                    name-server "{{ server }}"
                    {% endfor %}
                }
                {% for (let range in subnet.ranges): %}
                range {{ range_id++ }} {
                    start "{{ range.start }}"
                    stop "{{ range.stop }}"
                }
                {% endfor %}
                subnet-id "{{ subnet_id++ }}"
                {% for (let client in subnet.static_mappings): %}
                static-mapping {{ client.name }} {
                    ip-address "{{ client.ip_address }}"
                    mac "{{ client.mac_address }}"
                }
                {% endfor %}
            }
            {% endfor %}
        }
        {% endfor %}
    }
