{% let rule_c = 0, rule_m = {}; %}

firewall {
    global-options {
        state-policy {
            established {
                action accept
            }
            related {
                action accept
            }
            invalid {
                action reject
            }
        }
        apply-to-bridged-traffic {
            accept-invalid {
                ethernet-type arp
{% if (services.dhcp_server || services.dhcp_relay): %}
                ethernet-type dhcp
{% endif %}
{% if (services.pppoe_server): %}
                ethernet-type pppoe
{% endif %}
                ethernet-type 802.1q
                ethernet-type 802.1ad
            }
        }
    }
    group {
        port-group LAN_SERVICE_GROUP {
{% if (services): %}
    {% if (services.ssh && services.ssh.expose_lan): %}
            port "22"
    {% endif %}
    {% if (services.dns): %}
            port "53"
    {% endif %}
    {% if (services.dhcp_server || services.dhcp_relay): %}
            port "67"
            port "68"
    {% endif %}
    {% if (services.tftp_server): %}
            port "69"
    {% endif %}
    {% if (services.ntp): %}
            port "123"
    {% endif %}
    {% if (services.snmp): %}
            port "161"
            port "162"
    {% endif %}
    {% if (services.web_proxy): %}
        {% if (services.web_proxy.servers): %}
            {% for (let s in services.web_proxy.servers): %}
                {% if (s.port): %}
            port "{{ s.port }}"
                {% endif %}
                {% if (s.transparent_proxy): %}
            port "80"
                {% endif %}
            {% endfor %}
        {% endif %}
            port "3128"
    {% endif %}
    {% if (services.mdns): %}
            port "5353"
    {% endif %}
{% endif %}
{% if (routing): %}
    {% if (routing.bgp): %}
            port "179"
    {% endif %}
    {% if (routing.rip): %}
            port "520"
    {% endif %}
{% endif %}
        }
        port-group WAN_SERVICE_GROUP {
            port 1883
{% if (services): %}
    {% if (services.ssh && services.ssh.expose_wan): %}
            port "22"
    {% endif %}
    {% if (services.snmp): %}
            port "161"
            port "162"
    {% endif %}
    {% if (services.mdns): %}
            port "5353"
    {% endif %}
{% endif %}
{% if (routing): %}
    {% if (routing.bgp): %}
            port "179"
    {% endif %}
    {% if (routing.rip): %}
            port "520"
    {% endif %}
{% endif %}
{% if (state.vpn && length(state.vpn)): %}
    {% if (vpn.wireguard): %}
        {% for (let i in vpn.wireguard.interfaces): %}
            {% if (i.port): %}
            port "{{ i.peer_port }}"
            {% else %}
            port "51820"
            {% endif %}
        {% endfor %}
    {% endif %}
    {% if (vpn.openvpn): %}
        {% for (let ov in vpn.openvpn.interfaces): %}
            {% if (ov.mode == "server"): %}
            port "{{ ov.server.listen_port }}"
            {% endif %}
        {% endfor %}
    {% endif %}
    {% if (vpn.ipsec && length(vpn.ipsec)): %}
            port 500
            port 4500
    {% endif %}
{% endif %}
        }
        port-group WAN_LAN_FORWARDING_GROUP {
{% if (nat && nat.destination_ipv4): %}
    {% for (let rule in nat.destination_ipv4): %}
        {% if (rule.translation && rule.translation.port): %}
            port "{{ rule.translation.port }}"
        {% endif %}
    {% endfor %}
{% endif %}
        }
    }
    ipv4 {
{% if (length(firewall.ipv4_rulesets)): %}
    {% for (let ruleset in firewall.ipv4_rulesets): %}
        {% rule_m[ruleset.name] = rule_c; %}
        name rule{{ rule_c++ }} {
        {% if (ruleset.name): %}
            description {{ ruleset.name }}
        {% endif %}
        {% if (ruleset.default_action): %}
            default-action {{ ruleset.default_action }}
        {% endif %}
        {% if (ruleset.default_log): %}
            default-log
        {% endif %}

        {% for (let rule in ruleset.rules): %}
            rule {{ rule.rule_number }} {
            {% if (rule.disabled): %}
                disable
            {% endif %}
                action {{ rule.action }}
            {% if (rule.protocol): %}
                protocol {{ rule.protocol }}
            {% endif %}
            {% if (rule.log): %}
                log
            {% endif %}

            {% if (rule.source): %}
                source {
                {% if (rule.source.address): %}
                    address {{ rule.source.address }}
                {% endif %}
                {% if (rule.source.port): %}
                    port {{ rule.source.port }}
                {% endif %}
                {% if (rule.source.mac_address): %}
                    mac-address {{ rule.source.mac_address }}
                {% endif %}
                {% if (rule.source.group): %}
                    group {
                    {% if (rule.source.group.address_group): %}
                        address-group {{ rule.source.group.address_group }}
                    {% endif %}
                    {% if (rule.source.group.network_group): %}
                        network-group {{ rule.source.group.network_group }}
                    {% endif %}
                    {% if (rule.source.group.port_group): %}
                        port-group {{ rule.source.group.port_group }}
                    {% endif %}
                    }
                {% endif %}
                }
            {% endif %}

            {% if (rule.destination): %}
                destination {
                {% if (rule.destination.address): %}
                    address {{ rule.destination.address }}
                {% endif %}
                {% if (rule.destination.port): %}
                    port {{ rule.destination.port }}
                {% endif %}
                {% if (rule.destination.group): %}
                    group {
                    {% if (rule.destination.group.address_group): %}
                        address-group {{ rule.destination.group.address_group }}
                    {% endif %}
                    {% if (rule.destination.group.network_group): %}
                        network-group {{ rule.destination.group.network_group }}
                    {% endif %}
                    {% if (rule.destination.group.port_group): %}
                        port-group {{ rule.destination.group.port_group }}
                    {% endif %}
                    }
                {% endif %}
                }
            {% endif %}

            {% if (rule.icmp): %}
                icmp {
                {% if (rule.icmp.type): %}
                    type-name {{ rule.icmp.type }}
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
                        set {{ join(',', rule.tcp.flags.set) }}
                    {% endif %}
                    {% if (rule.tcp.flags.not_set && length(rule.tcp.flags.not_set)): %}
                        not-set {{ join(',', rule.tcp.flags.not_set) }}
                    {% endif %}
                    }
                {% endif %}
                }
            {% endif %}

            {% if (rule.limit): %}
                limit {
                {% if (rule.limit.rate): %}
                    rate {{ rule.limit.rate }}
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
{% endif %}
    }
{% if (length(firewall.ipv6_rulesets)): %}
    ipv6 {
    {% for (let ruleset in firewall.ipv6_rulesets): %}
        {% rule_m[ruleset.name] = rule_c; %}
        name rule{{ rule_c++ }} {
        {% if (ruleset.description): %}
            description {{ ruleset.description }}
        {% endif %}
        {% if (ruleset.default_action): %}
            default-action {{ ruleset.default_action }}
        {% endif %}
        {% if (ruleset.default_log): %}
            default-log
        {% endif %}

        {% for (let rule in ruleset.rules): %}
            rule {{ rule.rule_number }} {
            {% if (rule.disabled): %}
                disable
            {% endif %}
                action {{ rule.action }}
            {% if (rule.protocol): %}
                protocol {{ rule.protocol }}
            {% endif %}
            {% if (rule.log): %}
                log
            {% endif %}

            {% if (rule.source): %}
                source {
                {% if (rule.source.address): %}
                    address {{ rule.source.address }}
                {% endif %}
                {% if (rule.source.port): %}
                    port {{ rule.source.port }}
                {% endif %}
                {% if (rule.source.mac_address): %}
                    mac-address {{ rule.source.mac_address }}
                {% endif %}
                {% if (rule.source.group): %}
                    group {
                    {% if (rule.source.group.address_group): %}
                        address-group {{ rule.source.group.address_group }}
                    {% endif %}
                    {% if (rule.source.group.network_group): %}
                        network-group {{ rule.source.group.network_group }}
                    {% endif %}
                    {% if (rule.source.group.port_group): %}
                        port-group {{ rule.source.group.port_group }}
                    {% endif %}
                    }
                {% endif %}
                }
            {% endif %}

            {% if (rule.destination): %}
                destination {
                {% if (rule.destination.address): %}
                    address {{ rule.destination.address }}
                {% endif %}
                {% if (rule.destination.port): %}
                    port {{ rule.destination.port }}
                {% endif %}
                {% if (rule.destination.group): %}
                    group {
                    {% if (rule.destination.group.address_group): %}
                        address-group {{ rule.destination.group.address_group }}
                    {% endif %}
                    {% if (rule.destination.group.network_group): %}
                        network-group {{ rule.destination.group.network_group }}
                    {% endif %}
                    {% if (rule.destination.group.port_group): %}
                        port-group {{ rule.destination.group.port_group }}
                    {% endif %}
                    }
                {% endif %}
                }
            {% endif %}

            {% if (rule.icmpv6): %}
                icmpv6 {
                {% if (rule.icmpv6.type): %}
                    type-name {{ rule.icmpv6.type }}
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
                        set {{ join(',', rule.tcp.flags.set) }}
                    {% endif %}
                    {% if (rule.tcp.flags.not_set && length(rule.tcp.flags.not_set)): %}
                        not-set {{ join(',', rule.tcp.flags.not_set) }}
                    {% endif %}
                    }
                {% endif %}
                }
            {% endif %}

            {% if (rule.limit): %}
                limit {
                {% if (rule.limit.rate): %}
                    rate {{ rule.limit.rate }}
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
{% if (length(firewall.bridge_rulesets)): %}
    bridge {
    {% for (let ruleset in firewall.bridge_rulesets): %}
        {% rule_m[ruleset.name] = rule_c; %}
        name rule{{ rule_c++ }} {
        {% if (ruleset.description): %}
            description {{ ruleset.description }}
        {% endif %}
        {% if (ruleset.default_action): %}
            default-action {{ ruleset.default_action }}
        {% endif %}
        {% if (ruleset.default_log): %}
            default-log
        {% endif %}

        {% for (let rule in ruleset.rules): %}
            rule {{ rule.rule_number }} {
            {% if (rule.disabled): %}
                disable
            {% endif %}
                action {{ rule.action }}
            {% if (rule.log): %}
                log
            {% endif %}

            {% if (rule.source): %}
                source {
                {% if (rule.source.mac_address): %}
                    mac-address {{ rule.source.mac_address }}
                {% endif %}
                {% if (rule.source.mac_group): %}
                    mac-group {{ rule.source.mac_group }}
                {% endif %}
                }
            {% endif %}

            {% if (rule.destination): %}
                destination {
                {% if (rule.destination.mac_address): %}
                    mac-address {{ rule.destination.mac_address }}
                {% endif %}
                {% if (rule.destination.mac_group): %}
                    mac-group {{ rule.destination.mac_group }}
                {% endif %}
                }
            {% endif %}

            {% if (rule.vlan): %}
                vlan {
                {% if (rule.vlan.id): %}
                    id {{ rule.vlan.id }}
                {% endif %}
                {% if (rule.vlan.priority): %}
                    priority {{ rule.vlan.priority }}
                {% endif %}
                }
            {% endif %}

            {% if (rule.ethertype): %}
                ethertype {{ rule.ethertype }}
            {% endif %}
            {% if (rule.inbound_interface): %}
                inbound-interface {{ rule.inbound_interface }}
            {% endif %}
            {% if (rule.outbound_interface): %}
                outbound-interface {{ rule.outbound_interface }}
            {% endif %}
            }
        {% endfor %}
        }
    {% endfor %}
    }
{% endif %}
{% if (length(firewall.zones)): %}
    {% for (let z in firewall.zones): %}
    zone {{ u(z.name) }} {
        {% if (z.local_zone): %}
        local-zone
        {% else %}
        member {
            {% for (let i in z.interfaces): %}
            interface {{ ethernet.get_iface_by_name(i) }}
            {% endfor %}
        }
        {% endif %}

        {% if (length(firewall.zone_policies)): %}
            {% for (let zp in firewall.zone_policies): %}
                {% if (zp.to == z.name): %}
        from {{ u(zp.from) }} {
            firewall {
                name rule{{ rule_m[zp.ruleset] }}
            }
        }
                {% endif %}
            {% endfor %}
        {% endif %}
    }
    {% endfor %}
{% endif %}
}
