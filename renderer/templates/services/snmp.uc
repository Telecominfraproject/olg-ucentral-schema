    snmp {
{% if(snmp.listen_addresses): %}
    {% for (let a in snmp.listen_addresses): %}
        listen-address {{ a }}
    {% endfor %}
    {% if (snmp.location): %}
        location snmp.location
    {% endif %}
        v3 {
            engineid {{ snmp.engine_id }}
    {% for (let g in snmp.groups): %}
            group {{ g.name }} {
                mode {{ g.mode }}
                view {{ g.view }}
            }
            view {{ g.view }} {
                oid {{ g.oid }}
            }
    {% endfor %}
    {% for (let u in snmp.users): %}
            user {{ u.name }} {
                group {{ u.group }}
                auth {
                    {% if(u.auth.encrypted): %}
                    encrypted-password {{ u.auth.password }}
                    {% else %}
                    plaintext-password {{ u.auth.password }}
                    {% endif %}
                    type {{ u.auth.hash_algo }}
                }
                privacy {
                    {% if(u.privacy.encrypted): %}
                    encrypted-password {{ u.privacy.password }}
                    {% else %}
                    plaintext-password {{ u.privacy.password }}
                    {% endif %}
                    type {{ u.privacy.hash_algo }}
                }
            }
    {% endfor %}
        }
{% endif %}
    }