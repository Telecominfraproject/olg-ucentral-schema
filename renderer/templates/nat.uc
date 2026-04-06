{% if (nat.source_ipv4 || nat.destination_ipv4): %}
nat {
    {% if (length(nat.source_ipv4)): %}
    source {
        {% for (let rule in nat.source_ipv4): %}
        rule {{ rule.rule_number }} {
            {% if (rule.outbound_interface): %}
            outbound-interface {
                name "{{ rule.outbound_interface }}"
            }
            {% endif %}
            {% if (rule.protocol): %}
            protocol "{{ rule.protocol }}"
            {% endif %}

            {% if (rule.source): %}
            source {
                {% if (rule.source.address): %}
                address "{{ rule.source.address }}"
                {% endif %}
                {% if (rule.source.port): %}
                port "{{ rule.source.port }}"
                {% endif %}
                {% if (rule.source.group): %}
                group {
                    {% if (rule.source.group.address_group): %}
                    address-group "{{ rule.source.group.address_group }}"
                    {% endif %}
                    {% if (rule.source.group.network_group): %}
                    network-group "{{ rule.source.group.network_group }}"
                    {% endif %}
                    {% if (rule.source.group.port_group): %}
                    port-group "{{ rule.source.group.port_group }}"
                    {% endif %}
                }
                {% endif %}
            }
            {% endif %}

            {% if (rule.destination): %}
            destination {
                {% if (rule.destination.address): %}
                address "{{ rule.destination.address }}"
                {% endif %}
                {% if (rule.destination.port): %}
                port "{{ rule.destination.port }}"
                {% endif %}
                {% if (rule.destination.group): %}
                group {
                    {% if (rule.destination.group.address_group): %}
                    address-group "{{ rule.destination.group.address_group }}"
                    {% endif %}
                    {% if (rule.destination.group.network_group): %}
                    network-group "{{ rule.destination.group.network_group }}"
                    {% endif %}
                    {% if (rule.destination.group.port_group): %}
                    port-group "{{ rule.destination.group.port_group }}"
                    {% endif %}
                }
                {% endif %}
            }
            {% endif %}

            {% if (rule.translation): %}
            translation {
                {% if (rule.translation.address): %}
                address "{{ rule.translation.address }}"
                {% endif %}
                {% if (rule.translation.port): %}
                port "{{ rule.translation.port }}"
                {% endif %}
            }
            {% endif %}
        }
        {% endfor %}
    }
    {% endif %}

    {% if (length(nat.destination_ipv4)): %}
    destination {
        {% for (let rule in nat.destination_ipv4): %}
        rule {{ rule.rule_number }} {
            {% if (rule.inbound_interface): %}
            inbound-interface {
                name "{{ rule.inbound_interface }}"
            }
            {% endif %}
            {% if (rule.protocol): %}
            protocol "{{ rule.protocol }}"
            {% endif %}

            {% if (rule.source): %}
            source {
                {% if (rule.source.address): %}
                address "{{ rule.source.address }}"
                {% endif %}
                {% if (rule.source.port): %}
                port "{{ rule.source.port }}"
                {% endif %}
                {% if (rule.source.group): %}
                group {
                    {% if (rule.source.group.address_group): %}
                    address-group "{{ rule.source.group.address_group }}"
                    {% endif %}
                    {% if (rule.source.group.network_group): %}
                    network-group "{{ rule.source.group.network_group }}"
                    {% endif %}
                    {% if (rule.source.group.port_group): %}
                    port-group "{{ rule.source.group.port_group }}"
                    {% endif %}
                }
                {% endif %}
            }
            {% endif %}

            {% if (rule.destination): %}
            destination {
                {% if (rule.destination.address): %}
                address "{{ rule.destination.address }}"
                {% endif %}
                {% if (rule.destination.port): %}
                port "{{ rule.destination.port }}"
                {% endif %}
                {% if (rule.destination.group): %}
                group {
                    {% if (rule.destination.group.address_group): %}
                    address-group "{{ rule.destination.group.address_group }}"
                    {% endif %}
                    {% if (rule.destination.group.network_group): %}
                    network-group "{{ rule.destination.group.network_group }}"
                    {% endif %}
                    {% if (rule.destination.group.port_group): %}
                    port-group "{{ rule.destination.group.port_group }}"
                    {% endif %}
                }
                {% endif %}
            }
            {% endif %}

            {% if (rule.translation): %}
            translation {
                {% if (rule.translation.address): %}
                address "{{ rule.translation.address }}"
                {% endif %}
                {% if (rule.translation.port): %}
                port "{{ rule.translation.port }}"
                {% endif %}
            }
            {% endif %}
        }
        {% endfor %}
    }
    {% endif %}
}
{% endif %}

{% if (nat.source_ipv6 || nat.destination_ipv6): %}
nat66 {
    {% if (length(nat.source_ipv6)): %}
    source {
        {% for (let rule in nat.source_ipv6): %}
        rule {{ rule.rule_number }} {
            {% if (rule.outbound_interface): %}
            outbound-interface "{{ rule.outbound_interface }}"
            {% endif %}
            {% if (rule.protocol): %}
            protocol "{{ rule.protocol }}"
            {% endif %}

            {% if (rule.source): %}
            source {
                {% if (rule.source.prefix): %}
                prefix "{{ rule.source.prefix }}"
                {% endif %}
                {% if (rule.source.port): %}
                port "{{ rule.source.port }}"
                {% endif %}
                {% if (rule.source.group): %}
                group {
                    {% if (rule.source.group.address_group): %}
                    address-group "{{ rule.source.group.address_group }}"
                    {% endif %}
                    {% if (rule.source.group.network_group): %}
                    network-group "{{ rule.source.group.network_group }}"
                    {% endif %}
                    {% if (rule.source.group.port_group): %}
                    port-group "{{ rule.source.group.port_group }}"
                    {% endif %}
                }
                {% endif %}
            }
            {% endif %}

            {% if (rule.destination): %}
            destination {
                {% if (rule.destination.prefix): %}
                prefix "{{ rule.destination.prefix }}"
                {% endif %}
                {% if (rule.destination.port): %}
                port "{{ rule.destination.port }}"
                {% endif %}
                {% if (rule.destination.group): %}
                group {
                    {% if (rule.destination.group.address_group): %}
                    address-group "{{ rule.destination.group.address_group }}"
                    {% endif %}
                    {% if (rule.destination.group.network_group): %}
                    network-group "{{ rule.destination.group.network_group }}"
                    {% endif %}
                    {% if (rule.destination.group.port_group): %}
                    port-group "{{ rule.destination.group.port_group }}"
                    {% endif %}
                }
                {% endif %}
            }
            {% endif %}

            {% if (rule.translation): %}
            translation {
                {% if (rule.translation.prefix): %}
                prefix "{{ rule.translation.prefix }}"
                {% endif %}
                {% if (rule.translation.port): %}
                port "{{ rule.translation.port }}"
                {% endif %}
            }
            {% endif %}
        }
        {% endfor %}
    }
    {% endif %}

    {% if (length(nat.destination_ipv6)): %}
    destination {
        {% for (let rule in nat.destination_ipv6): %}
        rule {{ rule.rule_number }} {
            {% if (rule.inbound_interface): %}
            inbound-interface "{{ rule.inbound_interface }}"
            {% endif %}
            {% if (rule.protocol): %}
            protocol "{{ rule.protocol }}"
            {% endif %}

            {% if (rule.source): %}
            source {
                {% if (rule.source.prefix): %}
                prefix "{{ rule.source.prefix }}"
                {% endif %}
                {% if (rule.source.port): %}
                port "{{ rule.source.port }}"
                {% endif %}
                {% if (rule.source.group): %}
                group {
                    {% if (rule.source.group.address_group): %}
                    address-group "{{ rule.source.group.address_group }}"
                    {% endif %}
                    {% if (rule.source.group.network_group): %}
                    network-group "{{ rule.source.group.network_group }}"
                    {% endif %}
                    {% if (rule.source.group.port_group): %}
                    port-group "{{ rule.source.group.port_group }}"
                    {% endif %}
                }
                {% endif %}
            }
            {% endif %}

            {% if (rule.destination): %}
            destination {
                {% if (rule.destination.prefix): %}
                prefix "{{ rule.destination.prefix }}"
                {% endif %}
                {% if (rule.destination.port): %}
                port "{{ rule.destination.port }}"
                {% endif %}
                {% if (rule.destination.group): %}
                group {
                    {% if (rule.destination.group.address_group): %}
                    address-group "{{ rule.destination.group.address_group }}"
                    {% endif %}
                    {% if (rule.destination.group.network_group): %}
                    network-group "{{ rule.destination.group.network_group }}"
                    {% endif %}
                    {% if (rule.destination.group.port_group): %}
                    port-group "{{ rule.destination.group.port_group }}"
                    {% endif %}
                }
                {% endif %}
            }
            {% endif %}

            {% if (rule.translation): %}
            translation {
                {% if (rule.translation.prefix): %}
                prefix "{{ rule.translation.prefix }}"
                {% endif %}
                {% if (rule.translation.port): %}
                port "{{ rule.translation.port }}"
                {% endif %}
            }
            {% endif %}
        }
        {% endfor %}
    }
    {% endif %}
}
{% endif %}

{% if (length(nat.nat64)): %}
nat64 {
    source {
        {% for (let rule in nat.nat64): %}
        rule {{ rule.rule_number }} {
            {% if (rule.source): %}
            source {
                {% if (rule.source.prefix): %}
                prefix "{{ rule.source.prefix }}"
                {% endif %}
            }
            {% endif %}

            {% if (rule.translation): %}
            translation {
                {% if (rule.translation.ipv6_prefix): %}
                pool "{{ rule.translation.ipv6_prefix }}"
                {% endif %}
                {% if (rule.translation.ipv4_pool): %}
                pool {
                    {% if (rule.translation.ipv4_pool.address): %}
                    address "{{ rule.translation.ipv4_pool.address }}"
                    {% endif %}
                    {% if (rule.translation.ipv4_pool.port_range): %}
                    port "{{ rule.translation.ipv4_pool.port_range }}"
                    {% endif %}
                }
                {% endif %}
            }
            {% endif %}
        }
        {% endfor %}
    }
}
{% endif %}
