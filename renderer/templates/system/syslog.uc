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
    {% for (let host in syslog.remote_hosts): %}
        host {{ host.address }} {
            facility {{ host.facility }} {
                level {{ host.severity }}
            }
            port {{ host.port ?? 514 }}
            protocol {{ host.protocol ?? "udp" }}
        }
    {% endfor %}
{% endif %}
    }
