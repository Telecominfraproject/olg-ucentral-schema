{%
    let nets = [];
    let wans = [];

    if (type(config.interfaces) == "array") {
        for (let iface in config.interfaces) {
	    if (iface.role == "upstream")
                push(wans, iface);

            if (iface.role != "downstream")
                continue;

            // Base LAN IPv4
            if (type(iface.ipv4) == "object" &&
                iface.ipv4.addressing == "static" &&
                type(iface.ipv4.subnet) == "string") {

                let nb = network_base(iface.ipv4.subnet);
                if (nb)
                    push(nets, nb[0]); // 192.168.50.0/24
            }

        }
    }
   let wan_bridge = ethernet.upstream_bridge_name(); 
%}

nat {
    source {
        {% if (length(nets) > 0 && length(wans) > 0): %}
            {% for (let i = 0; i < length(nets); i++): %}
        rule {{ i + 1 }} {
            outbound-interface {
                name {{wan_bridge}}
            }
            source {
                address {{ nets[i] }}
            }
            translation {
                address masquerade
            }
        }
            {% endfor %}
        {% endif %}
    }
}

