{% if (length(policies)): %}
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

    {% for (let q in qos): %}
            {% if (policy.address_family == "ipv4"): %}
    route {{ policy.name }} {
        {% elif (policy.address_family == "ipv6"): %}
    route6 {{ policy.name }} {
        {% endif %}

    }
    {% endfor%}
}
{% endif %}
