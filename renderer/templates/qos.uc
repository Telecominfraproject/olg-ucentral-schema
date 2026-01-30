{% if (qos && length(qos.shaper)): %}
qos {
{% for (let shaper in qos.shaper): %}
    policy {
        shaper {{ shaper.name }} {
            bandwidth "{{ shaper.bandwidth }}"
{% if (shaper.default): %}
            default {
                bandwidth "{{ shaper.default.bandwidth }}"
{% if (shaper.default.burst): %}
                burst "{{ shaper.default.burst }}"
{% endif %}
{% if (shaper.default.ceiling): %}
                ceiling "{{ shaper.default.ceiling }}"
{% endif %}
{% if (shaper.default['queue-type']): %}
                queue-type "{{ shaper.default['queue-type'] }}"
{% endif %}
            }
{% endif %}
{% if (length(shaper.classes)): %}
{% for (let cls in shaper.classes): %}
            class {{ cls.id }} {
                bandwidth "{{ cls.bandwidth }}"
{% if (cls.burst): %}
                burst "{{ cls.burst }}"
{% endif %}
{% if (cls.ceiling): %}
                ceiling "{{ cls.ceiling }}"
{% endif %}
                priority {{ cls.priority }}
{% if (cls['queue-type']): %}
                queue-type "{{ cls['queue-type'] }}"
{% endif %}
{% if (length(cls.match)): %}
{% for (let m in cls.match): %}
                match {{ m.name }} {
{% if (m.protocol || m.source || m.destination): %}
                    ip {
{% if (m.protocol): %}
                        protocol "{{ m.protocol }}"
{% endif %}
{% if (m.source): %}
                        source {
{% if (m.source.address): %}
                            address "{{ m.source.address }}"
{% endif %}
{% if (m.source.port): %}
                            port {{ m.source.port }}
{% endif %}
                        }
{% endif %}
{% if (m.destination): %}
                        destination {
{% if (m.destination.address): %}
                            address "{{ m.destination.address }}"
{% endif %}
{% if (m.destination.port): %}
                            port {{ m.destination.port }}
{% endif %}
                        }
{% endif %}
                    }
{% endif %}
{% if (m['inbound-interface']): %}
                    interface "{{ m['inbound-interface'] }}"
{% endif %}
                }
{% endfor %}
{% endif %}
            }
{% endfor %}
{% endif %}
        }
    }
{% endfor %}
}
{% endif %}
