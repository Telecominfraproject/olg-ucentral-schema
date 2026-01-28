{%  %}
protocols {
    {% if (routing.static): %}
    static {
        {% if (routing.static.ipv4_rules): %}
            {% for (let rule in routing.static.ipv4_rules): %}
        route {{ rule.destination }} {
                {% if (rule.action == "accept"): %}
            next-hop {{ rule.next_hop }} {
                {% elif (rule.action == "reject"): %}
            reject {
                {% elif (rule.action == "blackhole"): %}
            blackhole {
                {% elif (rule.interface): %}
            interface {{ rule.interface }} {
                {% endif %}
                {% if (rule.distance): %}
                distance "{{ rule.distance }}"
                {% endif %}
            }
        }
            {% endfor %}
        {% endif %}

        {% if (routing.static.ipv6_rules): %}
            {% for (let rule in routing.static.ipv6_rules): %}
        route6 {{ rule.destination }} {
                {% if (rule.action == "accept"): %}
            next-hop {{ rule.next_hop }} {
                {% elif (rule.action == "reject"): %}
            reject {
                {% elif (rule.action == "blackhole"): %}
            blackhole {
                {% elif (rule.interface): %}
            interface {{ rule.interface }} {
                {% endif %}
                {% if (rule.distance): %}
                distance "{{ rule.distance }}"
                {% endif %}
            }
        }
            {% endfor %}
        {% endif %}
    }
    {% endif %}
}
