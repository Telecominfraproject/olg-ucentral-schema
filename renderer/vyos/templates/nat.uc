{%
    let snat_rules = [];

    // Check for explicit NAT configuration
    if (type(config.nat) == "object" &&
        type(config.nat.snat) == "object" &&
        type(config.nat.snat.rules) == "array") {
        snat_rules = config.nat.snat.rules;
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

