{%
    let wan  = null;
    let lans = [];

    if (type(config.interfaces) == "array") {
        for (let iface in config.interfaces) {
            if (iface.role == "upstream" && !wan)
                wan = iface;
            else if (iface.role == "downstream")
                push(lans, iface);
        }
    }
%}

interfaces {
    {% if (wan): %}
    {%
        let ipv4      = wan.ipv4;
        let addr_mode = ipv4 ? ipv4.addressing : null;
        let cidr      = (ipv4 && type(ipv4.subnet) == "string") ? ipv4.subnet : null;
    %}
    ethernet {{ wan_ifname }} {
        {% if (addr_mode == "dynamic"): %}
        address dhcp
        {% elif (addr_mode == "static" && cidr): %}
        address {{ cidr }}
        {% endif %}
        {% if (wan.name): %}
        description {{ wan.name }}
        {% endif %}
    }
    {% endif %}
    {% for (let i = 0; i < length(lans); i++): %}
    {%
        let iface     = lans[i];
        let ipv4      = iface.ipv4;
        let addr_mode = ipv4 ? ipv4.addressing : null;
        let cidr      = (ipv4 && type(ipv4.subnet) == "string") ? ipv4.subnet : null;

        let ifname = null;
        if (i == 0 && lan_ifname)
            ifname = lan_ifname;
        else
            ifname = sprintf("eth%d", 1 + i);
    %}
    ethernet {{ ifname }} {
        {% if (addr_mode == "dynamic"): %}
        address dhcp
        {% elif (addr_mode == "static" && cidr): %}
        address {{ cidr }}
        {% endif %}
        {% if (iface.name): %}
        description {{ iface.name }}
        {% endif %}

        {% if (type(iface.vif) == "array"): %}
            {% for (let v in iface.vif): %}
                {% if (v.vlan && type(v.subnet) == "string"): %}
        vif {{ v.vlan }} {
            address {{ v.subnet }}
            description VLAN{{ v.vlan }}
        }
                {% endif %}
            {% endfor %}
        {% endif %}
    }
    {% endfor %}
}
