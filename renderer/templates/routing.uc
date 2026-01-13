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

    {% if (length(routing.policies)): %}
    policy {
        {% for (let policy in routing.policies): %}
            {% if (policy.address_family == "ipv4"): %}
        route {{ policy.name }} {
            {% elif (policy.address_family == "ipv6"): %}
        route6 {{ policy.name }} {
            {% endif %}
            {% if (policy.interface): %}
            interface "{{ policy.interface }}"
            {% endif %}

            {% if (length(policy.rules)): %}
                {% for (let rule in policy.rules): %}
            rule {{ rule.priority }} {
                    {% if (rule.name): %}
                description "{{ rule.name }}"
                    {% endif %}
                    {% if (rule.match): %}
                    {% if (rule.match.protocol): %}
                protocol "{{ rule.match.protocol }}"
                    {% endif %}

                    {% if (rule.match.inbound_interface): %}
                inbound-interface "{{ rule.match.inbound_interface }}"
                    {% endif %}

                    {% if (rule.match.source): %}
                source {
                        {% if (rule.match.source.address): %}
                    address "{{ rule.match.source.address }}"
                        {% endif %}
                        {% if (rule.match.source.port): %}
                    port "{{ rule.match.source.port }}"
                        {% endif %}
                        {% if (rule.match.source.group): %}
                    group {
                        address-group "{{ rule.match.source.group }}"
                    }
                        {% endif %}
                        {% if (rule.match.source.mac_address): %}
                    mac-address "{{ rule.match.source.mac_address }}"
                        {% endif %}
                }
                    {% endif %}

                    {% if (rule.match.destination): %}
                destination {
                        {% if (rule.match.destination.address): %}
                    address "{{ rule.match.destination.address }}"
                        {% endif %}
                        {% if (rule.match.destination.port): %}
                    port "{{ rule.match.destination.port }}"
                        {% endif %}
                        {% if (rule.match.destination.group): %}
                    group {
                        address-group "{{ rule.match.destination.group }}"
                    }
                        {% endif %}
                }
                    {% endif %}

                    {% if (rule.match.conn_mark): %}
                connection-mark "{{ rule.match.conn_mark }}"
                    {% endif %}

                    {% if (rule.match.mark): %}
                mark "{{ rule.match.mark }}"
                    {% endif %}
                    {% endif %}

                    {% if (rule.action): %}
                set {
                        {% if (rule.action.drop): %}
                    action "drop"
                        {% elif (rule.action.next_hop): %}
                    next-hop "{{ rule.action.next_hop }}"
                        {% endif %}
                        {% if (rule.action.set_conn_mark): %}
                    connection-mark "{{ rule.action.set_conn_mark }}"
                        {% endif %}
                        {% if (rule.action.set_mark): %}
                    mark "{{ rule.action.set_mark }}"
                        {% endif %}
                        {% if (rule.action.set_dscp): %}
                    dscp "{{ rule.action.set_dscp }}"
                        {% endif %}
                }
                    {% endif %}
            }
                {% endfor %}
            {% endif %}
        }
        {% endfor %}
    }
    {% endif %}
}
