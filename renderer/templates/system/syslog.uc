    syslog {
{% if (syslog.marker): %}
        global {
            marker {
    {% if (syslog.marker.enable): %}
                interval {{ syslog.marker.interval ?? 1200 }}
    {% endif %}
            }
        }
{% endif %}
{% if (syslog.preserve_fqdn): %}
        global {
            preserve-fqdn
        }
{% endif %}
{% if (syslog.remote_hosts): %}
    {% for (let remote in syslog.remote_hosts): %}
        remote {{ remote.address }} {
            facility {{ remote.facility }} {
                level {{ remote.severity }}
            }
            port {{ remote.port ?? 514 }}
            protocol {{ remote.protocol ?? "udp" }}
        }
    {% endfor %}
{% endif %}
{% if (syslog.local): %}
        local {
    {% for (let s in syslog.local): %}
            facility {{ s.facility }} {
        {% if (s.severity): %}
                level {{ s.severity }}
        {% endif %}
            }
    {% endfor %}
        }
{% endif %}
    }
