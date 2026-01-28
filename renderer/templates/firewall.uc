{% let rule_c = 0, rule_m = {}; %}

firewall {
    global-options {
        state-policy {
            established {
{% if (firewall.state_policy && firewall.state_policy.established): %}
                action "{{ firewall.state_policy.established }}"
{% else %}
                action "accept"
{% endif %}
            }
            invalid {
{% if (firewall.state_policy && firewall.state_policy.invalid): %}
                action "{{ firewall.state_policy.invalid }}"
{% else %}
                action "drop"
{% endif %}
            }
            related {
{% if (firewall.state_policy && firewall.state_policy.related): %}
                action "{{ firewall.state_policy.related }}"
{% else %}
                action "accept"
{% endif %}
            }
        }
    }
{% if (length(firewall.ipv4_rulesets)): %}
    ipv4 {
    {% for (let ruleset in firewall.ipv4_rulesets): %}
        {% rule_m[ruleset.name] = rule_c; %}
        name rule{{ rule_c++ }} {
        {% if (ruleset.description): %}
            description "{{ ruleset.description }}"
        {% endif %}
        {% if (ruleset.default_action): %}
            default-action "{{ ruleset.default_action }}"
        {% endif %}
        {% if (ruleset.default_log): %}
            default-log
        {% endif %}

        {% for (let rule in ruleset.rules): %}
            rule {{ rule.rule_number }} {
            {% if (rule.disabled): %}
                disable
            {% endif %}
                action "{{ rule.action }}"
            {% if (rule.protocol): %}
                protocol "{{ rule.protocol }}"
            {% endif %}
            {% if (rule.log): %}
                log
            {% endif %}

            {% if (rule.source): %}
                source {
                {% if (rule.source.address): %}
                    address "{{ rule.source.address }}"
                {% endif %}
                {% if (rule.source.port): %}
                    port "{{ rule.source.port }}"
                {% endif %}
                {% if (rule.source.mac_address): %}
                    mac-address "{{ rule.source.mac_address }}"
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
                {% if (rule.source.negate): %}
                    negate
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
                {% if (rule.destination.negate): %}
                    negate
                {% endif %}
                }
            {% endif %}

            {% if (rule.state): %}
                state {
                {% if (rule.state.established): %}
                    established
                {% endif %}
                {% if (rule.state.related): %}
                    related
                {% endif %}
                {% if (rule.state.new): %}
                    new
                {% endif %}
                {% if (rule.state.invalid): %}
                    invalid
                {% endif %}
                }
            {% endif %}

            {% if (rule.icmp): %}
                icmp {
                {% if (rule.icmp.type): %}
                    type-name "{{ rule.icmp.type }}"
                {% endif %}
                {% if (rule.icmp.code): %}
                    code {{ rule.icmp.code }}
                {% endif %}
                }
            {% endif %}

            {% if (rule.tcp): %}
                tcp {
                {% if (rule.tcp.flags): %}
                    flags {
                    {% if (rule.tcp.flags.set && length(rule.tcp.flags.set)): %}
                        set "{{ join(',', rule.tcp.flags.set) }}"
                    {% endif %}
                    {% if (rule.tcp.flags.not_set && length(rule.tcp.flags.not_set)): %}
                        not-set "{{ join(',', rule.tcp.flags.not_set) }}"
                    {% endif %}
                    }
                {% endif %}
                }
            {% endif %}

            {% if (rule.limit): %}
                limit {
                {% if (rule.limit.rate): %}
                    rate "{{ rule.limit.rate }}"
                {% endif %}
                {% if (rule.limit.burst): %}
                    burst {{ rule.limit.burst }}
                {% endif %}
                }
            {% endif %}
            }
        {% endfor %}
        }
    {% endfor %}
    }
{% endif %}
{% if (length(firewall.ipv6_rulesets)): %}
    ipv6 {
    {% for (let ruleset in firewall.ipv6_rulesets): %}
        {% rule_m[ruleset.name] = rule_c; %}
        name rule{{ rule_c++ }} {
        {% if (ruleset.description): %}
            description "{{ ruleset.description }}"
        {% endif %}
        {% if (ruleset.default_action): %}
            default-action "{{ ruleset.default_action }}"
        {% endif %}
        {% if (ruleset.default_log): %}
            default-log
        {% endif %}

        {% for (let rule in ruleset.rules): %}
            rule {{ rule.rule_number }} {
            {% if (rule.disabled): %}
                disable
            {% endif %}
                action "{{ rule.action }}"
            {% if (rule.protocol): %}
                protocol "{{ rule.protocol }}"
            {% endif %}
            {% if (rule.log): %}
                log
            {% endif %}

            {% if (rule.source): %}
                source {
                {% if (rule.source.address): %}
                    address "{{ rule.source.address }}"
                {% endif %}
                {% if (rule.source.port): %}
                    port "{{ rule.source.port }}"
                {% endif %}
                {% if (rule.source.mac_address): %}
                    mac-address "{{ rule.source.mac_address }}"
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
                {% if (rule.source.negate): %}
                    negate
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
                {% if (rule.destination.negate): %}
                    negate
                {% endif %}
                }
            {% endif %}

            {% if (rule.state): %}
                state {
                {% if (rule.state.established): %}
                    established
                {% endif %}
                {% if (rule.state.related): %}
                    related
                {% endif %}
                {% if (rule.state.new): %}
                    new
                {% endif %}
                {% if (rule.state.invalid): %}
                    invalid
                {% endif %}
                }
            {% endif %}

            {% if (rule.icmpv6): %}
                icmpv6 {
                {% if (rule.icmpv6.type): %}
                    type-name "{{ rule.icmpv6.type }}"
                {% endif %}
                {% if (rule.icmpv6.code): %}
                    code {{ rule.icmpv6.code }}
                {% endif %}
                }
            {% endif %}

            {% if (rule.tcp): %}
                tcp {
                {% if (rule.tcp.flags): %}
                    flags {
                    {% if (rule.tcp.flags.set && length(rule.tcp.flags.set)): %}
                        set "{{ join(',', rule.tcp.flags.set) }}"
                    {% endif %}
                    {% if (rule.tcp.flags.not_set && length(rule.tcp.flags.not_set)): %}
                        not-set "{{ join(',', rule.tcp.flags.not_set) }}"
                    {% endif %}
                    }
                {% endif %}
                }
            {% endif %}

            {% if (rule.limit): %}
                limit {
                {% if (rule.limit.rate): %}
                    rate "{{ rule.limit.rate }}"
                {% endif %}
                {% if (rule.limit.burst): %}
                    burst {{ rule.limit.burst }}
                {% endif %}
                }
            {% endif %}
            }
        {% endfor %}
        }
    {% endfor %}
    }
{% endif %}
{% if (length(firewall.zones)): %}
    {% for (let z in firewall.zones): %}
    zone {{ z.name }} {
        {% if (z.local_zone): %}
        local-zone
        {% else %}
        member {
            {% for (let i in z.interfaces): %}
            interface "{{ i }}"        
            {% endfor %}
        }
        {% endif %}

        {% if (length(firewall.zone_policies)): %}
            {% for (let zp in firewall.zone_policies): %}
                {% if (zp.to == z.name): %}
        from {{ zp.from }} {
            firewall {
                name "rule{{ rule_m[zp.ruleset] }}"
            }
        }
                {% endif %}
            {% endfor %}
        {% endif %}

        {% if (z.default_action != "accept"): %}
        default-action "{{ z.default_action }}"
        {% endif %}
    }
    {% endfor %}
{% endif %}
}
