    rip {
{% for (let i in rip.interfaces): %}
        interface {{ i }} {
        }
{% endfor %}
        neighbor "192.168.240.22"
{% for (let n in rip.networks): %}
        network "{{ n }}"
{% endfor %}
{% for (let p in rip.passive_interfaces): %}
        passive-interface "{{ p }}"
{% endfor %}
        redistribute {
{% if (rip.connected): %}
            connected {
            }
{% endif %}
{% if (rip.static): %}
            static {
            }
{% endif %}
{% if (rip.babel): %}
            babel {
            }
{% endif %}
{% if (rip.bgp): %}
            bgp {
            }
{% endif %}
{% if (rip.isis): %}
            isis {
            }
{% endif %}
{% if (rip.kernel): %}
            kernel {
            }
{% endif %}
{% if (rip.nhrp): %}
            nhrp {
            }
{% endif %}
{% if (rip.ospf): %}
            nhrp {
            }
{% endif %}
        }
    }