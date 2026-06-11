    static {
    {% if (has_default || length(dhcp_iface)): %}
        route 0.0.0.0/0 {
        {% for (let f in dhcp_iface): %}
            dhcp-interface "{{ ethernet.get_iface_by_name(f) }}"
        {% endfor %}
        {% for (let up in upstreams): %}
            {% if (up.ipv4 && up.ipv4.addressing == "static"): %}
            next-hop {{ up.ipv4.gateway }} {
            }
            {% endif %}
        {% endfor %}
        }
        route6 ::/0 {
        {% for (let up in upstreams): %}
            {% if (up.ipv6 && up.ipv6.addressing == "static"): %}
            next-hop {{ up.ipv6.gateway }} {
            }
            {% endif %}
        {% endfor %}
        }
    {% endif %}

    {% if (wireguard && length(wireguard.interfaces)): %}
        {% for (let i in wireguard.interfaces): %}
            {% let iface_tmp = ethernet.get_iface_by_name(i.name); %}
            {% if (i.hosts && length(i.hosts)): %}
                {% for (let p in i.hosts): %}
                    {% for (let ip in p.ipaddr): %}
        route {{ ip }} {
            interface {{ iface_tmp }} {

            }
        }
                    {% endfor %}
                {% endfor %}
            {% endif %}
        {% endfor %}
    {% endif %}
        {% if (routing.static && routing.static.ipv4_rules): %}
            {% for (let rule in routing.static.ipv4_rules): %}
        route {{ rule.destination }} {
                {% for (let p in rule.routes): %}
                    {% if (p.action == "interface"): %}
            {{ p.action }} {{ ethernet.get_iface_by_name(p.interface) }} {
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
