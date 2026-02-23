{%
let bridge_c = 0, pppoe_c = 0, dummy_c = 0, vtun_c = 0, client_c = 0;
let wg_c = 0, peer_c = 0;
let iface_mapping = {}, iface_vlan_mapping = {};
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

function getVlanIfaceName(type, name, vlanId) {
    let iface_temp;
    switch (type) {
    case "ethernet":
        iface_temp = name + "v" + vlanId;

        return iface_temp;
    case "bridge":
        iface_temp = "br" + bridge_c++ + "v" + vlanId;
        return iface_temp;
    case "pppoe":
        iface_temp = "pppoe" + bridge_c++ + "v" + vlanId;
        return iface_temp;
    case "dummy":
        iface_temp = "dummy" + bridge_c++ + "v" + vlanId;
        return iface_temp;
    default:
        return name;
    }
}
%}

interfaces {
    {% for (let i in interfaces): %}
        {% let iface = getIfaceName(i.type, i.name) %}
    {{ i.type }} {{ iface }} {
        {% if (i.mac_address): %}
        mac "{{ i.mac_address }}"
        {% endif %}
        {% if (!i.enabled): %}
        disable
        {% endif %}
        {% if (i.mtu):%}
        mtu "{{ i.mtu }}"
        {% endif %}

        {% if (i.type == "ethernet" && i.ethernet): %}
            {% if (i.ethernet.duplex): %}
        duplex {{ i.ethernet.duplex }}
            {% endif %}
            {% if (i.ethernet.speed): %}
        speed {{ i.ethernet.speed }}
            {% endif %}
        {% endif %}

        {% if (i.type == "bridge"): %}
        member {
            {% for (let j in i.bridge.members): %}
            interface {{ j }} {

            }
            {% endfor %}
        }
            {% if (i.bridge.stp): %}
        stp
            {% endif %}
        {% endif %}

        {% if (i.type == "pppoe"): %}
        authentication {
            username "{{ i.pppoe.username }}"
            password "{{ i.pppoe.password }}"
        }
        source-interface {{ i.source_interface }}
            {% if (!i.pppoe.default_route): %}
        no-default-route
            {% endif %}
        {% endif %}

        {% if (i.vlan): %}
            {% if (i.type == "bridge"): %}
        enable-vlan
            {% endif %}
            {% for (let j in i.vlan): %}
        vif {{ j.id }} {
                {% if (!j.enabled): %}
            disable
                {% endif %}
                {% if (j.mac_address): %}
            mac "{{ j.mac_address }}"
                {% endif %}
                {% if (j.mtu): %}
            mtu {{ j.mtu }}
                {% endif %}
                {% if (j.ipv4): %}
                    {% if (j.ipv4.addressing == "static"): %}
                        {% for (let k in j.ipv4.address): %}
            address "{{ k }}"
                        {% endfor %}
                    {% elif (j.ipv4.addressing == "dhcp"): %}
            address "dhcp"
                    {% endif %}
                {% endif %}
                {% if (i.ipv6): %}
                    {% if (i.ipv6.addressing == "static"): %}
                        {% for (let j in i.ipv6.address): %}
            address "{{ j }}"
                        {% endfor %}
                    {% elif (i.ipv6.addressing == "dhcpv6"): %}
            address "dhcpv6"
            dhcpv6-options {

            }
                    {% endif %}
                {% endif %}

                {% if (i.ipv6 && i.ipv6.addressing != "none"): %}
            ipv6 {
                    {% if (i.ipv6.addressing == "slaac"): %}
                address {
                    autoconf
                }
                    {% elif (i.ipv6.addressing == "eui64"): %}
                        {% for (let j in i.ipv6.address): %}
                eui64 {{ j }}
                        {% endfor %}
                    {% endif %}
            }
                {% endif %}
        }
            {% endfor %}
        {% endif %}

        {% if (i.ipv4): %}
            {% if (i.ipv4.addressing == "static"): %}
                {% for (let j in i.ipv4.address): %}
        address "{{ j }}"
                {% endfor %}
            {% elif (i.ipv4.addressing == "dhcp"): %}
        address "dhcp"
            {% endif %}
        {% endif %}

        {% if (i.ipv6): %}
            {% if (i.ipv6.addressing == "static"): %}
                {% for (let j in i.ipv6.address): %}
        address "{{ j }}"
                {% endfor %}
            {% elif (i.ipv6.addressing == "dhcpv6"): %}
        address "dhcpv6"
        dhcpv6-options {

        }
            {% endif %}
        {% endif %}

        {% if (i.ipv6 && i.ipv6.addressing != "none"): %}
        ipv6 {
            {% if (i.ipv6.addressing == "slaac"): %}
            address {
                autoconf
            }
            {% elif (i.ipv6.addressing == "eui64"): %}
                {% for (let j in i.ipv6.address): %}
            eui64 {{ j }}
                {% endfor %}
            {% endif %}
        }
        {% endif %}
    }
    {% endfor %}

    {% if (vpn): %}
        {% if (vpn.wireguard): %}
            {% for (let i in vpn.wireguard.interfaces): %}
    wireguard wg{{ wg_c++ }} {
                {% if (i.name): %}
        description "{{ i.name }}"
                {% endif %}
        private-key "{{ i.private_key }}"
                {% if (i.root_node.ipaddr): %}
                    {% for (let ip in i.root_node.ipaddr): %}
        address "{{ ip }}"
                    {% endfor %}
                {% endif %}
                {% if (i.port): %}
        port "{{ i.peer_port }}"
                {% else %}
        port "51820"
                {% endif %}
                {% if (i.hosts && length(i.hosts)): %}
                {% for (let p in i.hosts): %}
        peer peer{{ peer_c++ }} {
            public-key "{{ p.key }}"
                    {% if (p.name): %}
            description "{{ p.name }}"
                    {% endif %}
                    {% for (let a in p.subnet): %}
            allowed-ips "{{ a }}"
                    {% endfor %}
                    {% if (p.persistent_keepalive): %}
            persistent-keepalive "{{ p.persistent_keepalive }}"
                    {% endif %}
                    {% if (p.preshared_key): %}
            preshared-key "{{ p.preshared_key }}"
                    {% endif %}
                    {% if (p.endpoint): %}
            address "{{ p.endpoint }}"
                    {% endif %}
                    {% if (p.port): %}
            port "{{ p.endpoint.port }}"
                    {% endif %}
        }
                {% endfor %}
                {% endif %}
    }
            {% endfor %}
        {% endif %}
        {% if (vpn.openvpn): %}
            {% for (let ov in vpn.openvpn.servers): %}
    openvpn vtun{{ vtun_c++ }} {
        encryption {
                {% for (let cipher in ov.encryption.data_ciphers): %}
            data-ciphers "{{ cipher }}"
                {% endfor %}
                {% if (ov.encryption.cipher): %}
            cipher "{{ ov.encryption.cipher }}"
                {% endif %}
        }
                {% if (ov.hash): %}
        hash "{{ ov.hash }}"
                {% endif %}
        local-host "{{ ov.address }}"
        local-port "{{ ov.port }}"
        mode "{{ ov.mode }}"
                {% if (!ov.persistent_tunnel): %}
        persistent-tunnel
                {% endif %}
        protocol "{{ ov.protocol }}"
        server {
                {% for (let c in ov.clients): %}
            client client{{ client_c++ }} {
                ip "{{ c.address }}"
                subnet "{{ c.subnet }}"
            }
                {% endfor %}
                {% if (ov.domain): %}
            domain-name "{{ ov.domain }}"
                {% endif %}
                {% if (ov.max_connections): %}
            max-connections "{{ ov.max_connections }}"
                {% endif %}
            name-server "{{ ov.name_server }}"
                {% if (ov.subnet): %}
            subnet "{{ ov.subnet }}"
                {% endif %}
                {% if (ov.topology): %}
            topology "{{ ov.topology }}"
                {% endif %}
        }
        tls {
            ca-certificate "{{ ov.tls.ca_cert }}"
            certificate "{{ ov.tls.cert }}"
            dh-params "{{ ov.tls.dh }}"
        }
    }
            {% endfor %}
        {% endif %}
    {% endif %}
}
