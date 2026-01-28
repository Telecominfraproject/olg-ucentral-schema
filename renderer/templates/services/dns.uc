    dns {
        forwarding {
    {% for (let server in dns.forwarding_servers): %}
            name-server {{ server.address }} {
                {% if (server.port): %}
                port "{{ server.port }}"
                {% endif %}
            }
    {% endfor %}
    {% for (let network in dns.allow_from): %}
            allow-from "{{ network }}"
    {% endfor %}
    {% for (let address in dns.listen_addresses): %}
            listen-address "{{ address }}"
    {% endfor %}
            system
        }
    }
