{%
let bridge_c = 0, pppoe_c = 0, dummy_c = 0;
let iface_mapping = {};
function getIfaceName(type, name) {
    let iface_temp;
    switch (type) {
    case "ethernet":
        return name;
    case "bridge":
        iface_temp = "br" + bridge_c++;
        iface_mapping[name] = iface_temp;
        return iface_temp;
    case "pppoe":
        iface_temp = "pppoe" + pppoe_c++;
        iface_mapping[name] = iface_temp;
        return iface_temp;
    case "dummy":
        iface_temp = "dummy" + dummy_c++;
        iface_mapping[name] = iface_temp;
        return iface_temp;
    default:
        return name;
    }
}
%}

interfaces {
    {% for (let i in interfaces): %}
        {% let iface = getIfaceName(i.type, i.name) %}
    /* {{ i.role }} interface {{ iface }} */
    {{ i.type }} {{ iface }} {
        mac {{ i.mac_address }}
        {% if (!i.enabled): %}
        disable
        {% endif %}
        {% if (i.mtu):%}
        mtu {{ i.mtu }}
        {% endif %}

        {% if (i.type == "ethernet"): %}
        /* ethernet section */
            {% if (i.ethernet.duplex): %}
        duplex {{ i.ethernet.duplex }}
            {% endif %}
            {% if (i.ethernet.speed): %}
        speed {{ i.ethernet.speed }}
            {% endif %}
        /* end ethernet section */
        {% endif %}

        {% if (i.type == "bridge"): %}
        /* bridge section */
        member {
            {% for (let j in i.bridge.members): %}
            interface {{ j }} {}   
            {% endfor %}
        }
            {% if (i.bridge.stp): %}
        stp
            {% endif %}
        /* end bridge section */
        {% endif %}

        {% if (i.type == "pppoe"): %}
        /* pppoe section */
        authentication {
            username {{ i.pppoe.username }}
            password {{ i.pppoe.password }}
        }
        source-interface {{ i.source-interface }}
            {% if (!i.pppoe.default_route): %}
        no-default-route
            {% endif %}
        /* end pppoe section*/
        {% endif %}

        {% if (i.vlan): %}
            {% for (let j in i.vlan): %}
        vif {{ j.id }} {
                {% if (!j.enabled): %}
            disable
                {% endif %}
            mac {{ j.mac_address }}
                {% if (j.mtu): %}
            mtu {{ j.mtu }}
                {% endif %}
                {% if (j.ipv4): %}
            /* vlan ipv4 section */
                    {% if (j.ipv4.addressing == "static"): %}
                        {% for (let k in i.ipv4.address): %}
            address {{ k }}
                        {% endfor %}
                    {% elif (j.ipv4.addressing == "dhcp"): %}
            address dhcp
                    {% endif %}
            /* end vlan ipv4 section */
                {% endif %}
                {% if (j.ipv6 && j.ipv6.addressing != "none"): %}
            ipv6 {
                    {% if (j.ipv6.addressing == "static"): %}
                        {% for (let k in j.ipv6.address): %}
                address {{ k }}
                        {% endfor %}
                    {% elif (j.ipv6.addressing == "dhcpv6"): %}
                address dhcpv6
                    {% elif (j.ipv6.addressing == "slaac"): %}
                address autoconf
                    {% elif (j.ipv6.addressing == "eui64"): %}
                        {% for (let k in j.ipv6.address): %}
                address {{ k }} eui64
                        {% endfor %}
                    {% endif %}
            }
                {% endif %}
        }
            {% endfor %}
        {% endif %}

        {% if (i.ipv4): %}
        /* ipv4 section */
            {% if (i.ipv4.addressing == "static"): %}
                {% for (let j in i.ipv4.address): %}
        address {{ j }}
                {% endfor %}
            {% elif (i.ipv4.addressing == "dhcp"): %}
        address dhcp
            {% endif %}
        /* end ipv4 section */
        {% endif %}

        {% if (i.ipv6 && i.ipv6.addressing != "none"): %}
        /* ipv6 section */
        ipv6 {
            {% if (i.ipv6.addressing == "static"): %}
                {% for (let j in i.ipv6.address): %}
            address {{ j }}
                {% endfor %}
            {% elif (i.ipv6.addressing == "dhcpv6"): %}
            address dhcpv6
            {% elif (i.ipv6.addressing == "slaac"): %}
            address autoconf
            {% elif (i.ipv6.addressing == "eui64"): %}
                {% for (let j in i.ipv6.address): %}
            address {{ j }} eui64
                {% endfor %}
            {% endif %}
        }
        /* end ipv6 section */
        {% endif %}
    }
    {% endfor %}
}