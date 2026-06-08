    rip {
        version {{ rip.version }}
{% for (let i in rip.interfaces): %}
        interface {{ i.name }} {
        }
{% endfor %}
{% for (let n in rip.neighbors): %}
        neighbor {{ n }}
{% endfor %}
{% for (let n in rip.networks): %}
        network "{{ n }}"
{% endfor %}
{% for (let p in rip.passive_interfaces): %}
        passive-interface "{{ p }}"
{% endfor %}
{% if (rip.redistribute): %}
        redistribute {
    {% if (rip.redistribute.connected): %}
            connected {
            }
    {% endif %}
    {% if (rip.redistribute.static): %}
            static {
            }
    {% endif %}
    {% if (rip.redistribute.babel): %}
            babel {
            }
    {% endif %}
    {% if (rip.redistribute.bgp): %}
            bgp {
            }
    {% endif %}
    {% if (rip.redistribute.isis): %}
            isis {
            }
    {% endif %}
    {% if (rip.redistribute.kernel): %}
            kernel {
            }
    {% endif %}
    {% if (rip.redistribute.nhrp): %}
            nhrp {
            }
    {% endif %}
    {% if (rip.redistribute.ospf): %}
            nhrp {
            }
    {% endif %}
        }
{% endif %}
    }
