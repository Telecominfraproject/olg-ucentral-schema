{%
    let snat_rules = [];

    // Check for explicit NAT configuration
    if (type(config.nat) == "object" &&
        type(config.nat.snat) == "object" &&
        type(config.nat.snat.rules) == "array") {
        snat_rules = config.nat.snat.rules;
    }
    // Auto-generate NAT masquerade rules for downstream interfaces if no explicit config
    else if (type(config.interfaces) == "array") {
        // First, check if we have an upstream interface (WAN)
        let has_upstream = false;
        let upstream_bridge = null;

        for (let iface in config.interfaces) {
            if (iface.role == "upstream") {
                has_upstream = true;
                upstream_bridge = ethernet.upstream_bridge_name();
                break;
            }
        }

        // Only auto-generate if we have an upstream interface
        if (has_upstream && upstream_bridge) {
            let rule_id = 100;

            for (let iface in config.interfaces) {
                // Auto-generate NAT for downstream interfaces with IPv4 addressing
                if (iface.role == "downstream" &&
                    type(iface.ipv4) == "object" &&
                    type(iface.ipv4.subnet) == "string") {

                    // Use network_base helper to extract network address from subnet
                    let subnet_parts = network_base(iface.ipv4.subnet);

                    if (subnet_parts && subnet_parts[0]) {
                        // Create masquerade rule for this downstream network
                        push(snat_rules, {
                            rule_id: rule_id++,
                            out_interface: { name: upstream_bridge },
                            source: { address: subnet_parts[0] },
                            translation: { address: "masquerade" }
                        });
                    }
                }
            }
        }
    }
%}

nat {
    source {
        {% if (type(snat_rules) == "array" && length(snat_rules) > 0): %}
            {% for (let rule_index = 0; rule_index < length(snat_rules); rule_index++): %}
                {%
                    let snat_rule = snat_rules[rule_index] || {};

                    let rule_id = snat_rule.rule_id ?? snat_rule["rule-id"];

                    let out_if_obj =
                        (type(snat_rule.out_interface) == "object") ? snat_rule.out_interface :
                        (type(snat_rule["out-interface"]) == "object") ? snat_rule["out-interface"] :
                        null;

                    let outbound_if_name = null;
                    if (type(out_if_obj) == "object")
                        outbound_if_name = out_if_obj.name ?? out_if_obj.group;

                    let source_subnet = (type(snat_rule.source) == "object") ? snat_rule.source.address : null;

                    let translation_address = (type(snat_rule.translation) == "object")
                        ? snat_rule.translation.address : null;

                %}
        rule {{ rule_id }} {
            outbound-interface {
                name {{ outbound_if_name }}
            }
            source {
                address {{ source_subnet }}
            }
            translation {
                address {{ translation_address }}
            }
        }
            {% endfor %}
        {% endif %}
    }
}

