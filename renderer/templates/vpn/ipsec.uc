{% let prop_c = 1, prop_e = 1; %}
    ipsec {
{% for (let iface in ipsec.interfaces): %}
        interface "{{ iface }}"
{% endfor %}
{% for (let ike_g in ipsec.ike_groups): %}
        ike-group {{ ike_g.name }} {
            key-exchange {{ ike.key_exchange }}
    {% for (let prop in ike_g.proposal): %}
            proposal {{ prop_c++ }} {
                encryption {{ prop.encryption }}
                hash {{ prop.hash }}
                dh-group {{ prop.dh_group }}
            }
    {% endfor %}
        }
{{% endfor %}}
{% for (let esp_g in ipsec.esp_group): %}
        esp-group {{ esp_g.name }} {
    {% if (!esp_g.pfs): %}
            psf disable
    {% endif %}
    {% for (let prop in esp_g.proposal): %}
            proposal {{ prop_e++ }} {
                encryption {{ prop.encryption }}
                hash {{ prop.hash }}
            }
    {% endfor %}
        }
{% endfor %}
        remote-access {
{% for (let p in ipsec.remote_access): %}
            connection {{ p.name }} {
                authentication {
                    local-id {{ p.local_id }}
    {% if (p.local_user && length(p.local_user)): %}
                    local-users {
        {% for (let u in p.local_user): %}
                        username {{ u.username }} {
                            password {{ u.password }}
                        }
        {% endfor %}
                    }
    {% endif %}
                    x509 {
                        ca-certificate {{ p.ca_cert }}
                        certificate {{ p.server_cert }}
                    }
    {% if (p.dhcp_interface): %}
                    dhcp-interface {{ p.dhcp_interface }}
    {% endif %}
    {% if (p.local_address): %}
                    local-address {{ p.local_address }}
    {% endif %}
                    esp-group {{ p.esp_group }}
                    ike-group {{ p.ike_group }}
                    pool {{ p.pool }}
                }
            }
{% endfor %}
{% for (let pool in ipsec.pools): %}
            pool {{ pool.name }} {
                name-server {{ pool.name_server }}
                prefix {{ pool.prefix }}
            }
{% endfor %}
    }
