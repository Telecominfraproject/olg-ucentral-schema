{% let shaper_c = 0, match_c = 1; %}
{% if (length(policies) || length(qos)): %}
policy {
    {% for (let policy in policies): %}
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
            action "{{ rule.action }}"
                {% endif %}

                {% if (rule.set): %}
            set {
                    {% if (rule.set.conn_mark): %}
                connection-mark "{{ rule.set.conn_mark }}"
                    {% endif %}
                    {% if (rule.set.mark): %}
                mark "{{ rule.set.mark }}"
                    {% endif %}
                    {% if (rule.set.dscp): %}
                dscp "{{ rule.set.dscp }}"
                    {% endif %}
            }
                {% endif %}
        }
            {% endfor %}
        {% endif %}
    }
    {% endfor %}
    {% if (qos && length(qos.shaper)): %}
    {% for (let s in qos.shaper): %}
        {% if (s.direction == "download"): %}
            {% continue; %}
        {% endif %}
        {% if (s.address_family == "ipv4"): %}
    route {{ s.name }} {
        {% elif (s.address_family == "ipv6"): %}
    route6 {{ s.name }} {
        {% endif %}

        {% for (let ing in s.ingress): %}
        interface {{ ethernet.get_iface_by_name(ing) }}
        {% endfor %}

        {% for (let c in s.classes): %}
            {% for (let m in c.match): %}
                {% m.serial = "match_up_" + match_c; m.mark = match_c; match_c++; %}
        rule {{ m.mark }} {
                {% if (m.destination): %}
            destination {
                    {% if (m.destination.address): %}
                address "{{ m.destination.address }}"
                    {% endif %}
                    {% if (m.destination.port): %}
                port "{{ m.destination.port }}"
                    {% endif %}
            }
                {% endif %}

                {% if (m.source): %}
            source {
                    {% if (m.source.address): %}
                address "{{ m.source.address }}"
                    {% endif %}
                    {% if (m.source.port): %}
                port "{{ m.source.port }}"
                    {% endif %}
            }
                {% endif %}

                {% if (m.protocol && m.protocol != "all"): %}
            protocol {{ m.protocol }}
                {% endif %}

            set {
                mark {{ m.mark }}
            }
        }
            {% endfor %}
        {% endfor %}    
    }
    {% endfor%}
    {% endif %}
}
{% endif %}
