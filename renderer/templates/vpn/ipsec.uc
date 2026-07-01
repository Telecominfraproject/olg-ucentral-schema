{% let prop_c = 1, prop_e = 1, ike_c = 1, esp_c = 1, pool_c = 1; %}
{% let ike_map = {}, esp_map = {}, pool_map = {}; %}
    ipsec {
{% for (let ike_g in ipsec.ike_groups): %}
    {% ike_map[ike_g.name] = "ike_" + ike_c++; %}
        ike-group {{ ike_map[ike_g.name] }} {
            key-exchange {{ ike_g.key_exchange }}
    {% for (let prop in ike_g.proposal): %}
            proposal {{ prop_c++ }} {
                encryption {{ prop.encryption }}
                hash {{ prop.hash }}
                dh-group {{ prop.dh_group }}
            }
    {% endfor %}
        }
{% endfor %}
{% for (let esp_g in ipsec.esp_groups): %}
    {% esp_map[esp_g.name] = "esp_" + esp_c++; %}
        esp-group {{ esp_map[esp_g.name] }} {
    {% if (!esp_g.pfs): %}
            pfs disable
    {% endif %}
    {% for (let prop in esp_g.proposal): %}
            proposal {{ prop_e++ }} {
                encryption {{ prop.encryption }}
                hash {{ prop.hash }}
            }
    {% endfor %}
        }
{% endfor %}
{% if (ipsec.remote_access): %}
        remote-access {
    {% for (let pool in ipsec.remote_access.pools): %}
        {% pool_map[pool.name] = "pool_" + pool_c++; %}
            pool {{ pool_map[pool.name] }} {
                name-server {{ pool.name_server }}
                prefix {{ pool.prefix }}
            }
    {% endfor %}
    {% for (let p in ipsec.remote_access.connections): %}
            connection {{ p.name }} {
                authentication {
        {% if (p.authentication && p.authentication.client_mode): %}
                    client-mode {{ p.authentication.client_mode }}
        {% endif %}
        {% if (ipsec.local_id): %}
                    local-id {{ ipsec.local_id }}
        {% elif (p.local_id): %}
                    local-id {{ p.local_id }}
        {% endif %}
        {% if (ipsec.users && length(ipsec.users)): %}
                    local-users {
            {% for (let u in ipsec.users): %}
                        username {{ u.username }} {
                            password {{ u.password }}
                        }
            {% endfor %}
                    }
        {% endif %}
                    x509 {
        {% if (ipsec.ca_cert): %}
                        ca-certificate {{ ipsec.ca_cert }}
        {% elif (p.ca_cert): %}
                        ca-certificate {{ p.ca_cert }}
        {% endif %}
        {% if (ipsec.server_cert): %}
                        certificate {{ ipsec.server_cert }}
        {% elif (p.server_cert): %}
                        certificate {{ p.server_cert }}
        {% endif %}
                    }
                }
        {% if (p.dhcp_interface): %}
                dhcp-interface {{ p.dhcp_interface }}
        {% endif %}
        {% if (p.local_address): %}
                local-address {{ p.local_address }}
        {% endif %}
                bind {{ ethernet.get_iface_by_name(p.bind) }}
                esp-group {{ esp_map[p.esp_group] }}
                ike-group {{ ike_map[p.ike_group] }}
                pool {{ pool_map[p.pool] }}
            }
    {% endfor %}
{% endif %}
        }
    }
