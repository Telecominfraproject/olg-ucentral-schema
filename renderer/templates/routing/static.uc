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
                {% for (let p in rule.routes): %}
                    {% if (p.action == "interface"): %}
            {{ p.action }} {{ p.interface }} {
                    {% elif (p.action == "next-hop"): %}
            {{ p.action }} {{ p.next_hop }} {
                    {% elif (p.action == "reject"): %}
            {{ p.action }} {
                    {% elif (p.action == "blackhole"): %}
            {{ p.action }} {
                    {% endif %}
                    {% if (p.distance): %}
                distance "{{ p.distance }}"
                    {% endif %}
            }
                {% endfor %}
        }
            {% endfor %}
        {% endif %}

        {% if (routing.static && routing.static.ipv6_rules): %}
            {% for (let rule in routing.static.ipv6_rules): %}
        route6 {{ rule.destination }} {
                {% for (let p in rule.routes): %}
                    {% if (p.action == "interface"): %}
            {{ p.action }} {{ p.interface }} {
                    {% elif (p.action == "next-hop"): %}
            {{ p.action }} {{ p.next_hop }} {
                    {% elif (p.action == "reject"): %}
            {{ p.action }} {
                    {% elif (p.action == "blackhole"): %}
            {{ p.action }} {
                    {% endif %}
                    {% if (p.distance): %}
                distance "{{ p.distance }}"
                    {% endif %}
            }
                {% endfor %}
        }
            {% endfor %}
        {% endif %}
    }
