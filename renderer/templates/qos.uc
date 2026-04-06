{% let shaper_c = 0, match_c = 0, shaper_map = {}; %}
{% if (qos && length(qos.shaper)): %}
qos {
    {% for (let i in qos.interfaces): %}
    interface {{ ethernet.get_iface_by_name(i.name) }} {
        {%
        if (!shaper_map[i.policy])
            shaper_map[i.policy] = "shaper" + shaper_c++;
        %}
        egress {{ shaper_map[i.policy] }}
    }
    {% endfor %}
    policy {
    {% for (let s in qos.shaper): %}
        shaper {{ shaper_map[s.name] }} {
            bandwidth {{ s.bandwidth }}
        {% for (let c in s.classes): %}
            class {{ c.id }} {
                bandwidth {{ c.bandwidth }}
                ceiling {{ c.ceiling }}
                burst {{ c.burst }}
            {% for (let m in c.match): %}
                match match_{{ match_c++ }} {
                    ip {
                {% if (m.source): %}
                        source {
                    {% if (m.source.address): %}
                            address {{ m.source.address }}
                    {% endif %}
                    {% if (m.source.port): %}
                            port {{ m.source.port }}
                    {% endif %}
                        }
                {% endif %}
                {% if (m.destination): %}
                        destination {
                    {% if (m.destination.address): %}
                            address {{ m.destination.address }}
                    {% endif %}
                    {% if (m.destination.port): %}
                            port {{ m.destination.port }}
                    {% endif %}
                        }
                {% endif %}
                {% if (m.protocol): %}
                        protocol {{ m.protocol }}
                {% endif %}
                    }
                }
            {% endfor %}
                priority {{ c.priority }}
                queue-type fair-queue
            }
        {% endfor %}
            default {
                bandwidth {{ s.default.bandwidth }}
                burst {{ s.default.burst }}
                ceiling {{ s.default.ceiling }}
                priority 7
                queue-type {{ s.default.queue_type }}
            }
        }
    {% endfor %}
    }
}
{% endif %}
