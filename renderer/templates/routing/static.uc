    static {
        {% for (let up in upstreams): %}
            {% if (up.ipv4 && up.ipv4.addressing == "static"): %}
        route 0.0.0.0/0 {
            next-hop {{ up.ipv4.gateway }} {
            }
        }
            {% endif %}
            {% if (up.ipv6 && up.ipv6.addressing == "static"): %}
        route6 ::/0 {
            next-hop {{ up.ipv6.gateway }} {
            }
        }
            {% endif %}
        {% endfor %}
        {% if (routing.static && routing.static.ipv4_rules): %}
            {% for (let rule in routing.static.ipv4_rules): %}
        route {{ rule.destination }} {
                {% if (rule.interface): %}
            interface {{ rule.interface }} {
                {% elif (rule.action == "accept"): %}
            next-hop {{ rule.next_hop }} {
                {% elif (rule.action == "reject"): %}
            reject {
                {% elif (rule.action == "blackhole"): %}
            blackhole {
                {% endif %}
                {% if (rule.distance): %}
                distance "{{ rule.distance }}"
                {% endif %}
            }
        }
            {% endfor %}
        {% endif %}

        {% if (routing.static && routing.static.ipv6_rules): %}
            {% for (let rule in routing.static.ipv6_rules): %}
        route6 {{ rule.destination }} {
                {% if (rule.interface): %}
            interface {{ rule.interface }} {
                {% elif (rule.action == "accept"): %}
            next-hop {{ rule.next_hop }} {
                {% elif (rule.action == "reject"): %}
            reject {
                {% elif (rule.action == "blackhole"): %}
            blackhole {
                {% endif %}
                {% if (rule.distance): %}
                distance "{{ rule.distance }}"
                {% endif %}
            }
        }
            {% endfor %}
        {% endif %}
    }
