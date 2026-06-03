{% let shaper_c = 0, match_c = 0, shaper_map = {}; %}
{% if (qos && length(qos.shaper)): %}
qos {
    {% for (let s in qos.shaper): %}
        {% for (let eg in s.egress): %}
    interface {{ ethernet.get_iface_by_name(eg) }} {
        {%
        if (!shaper_map[s.name])
            shaper_map[s.name] = "shaper" + shaper_c++;
        %}
        egress {{ shaper_map[s.name] }}
    }
        {% endfor %}
    {% endfor %}
    policy {
    {% for (let s in qos.shaper): %}
        shaper {{ shaper_map[s.name] }} {
        {% for (let c in s.classes): %}
            class {{ c.id }} {
            {% for (let m in c.match): %}
                match {{ m.serial }} {
                    mark {{ m.mark }}
                }
            {% endfor %}
                bandwidth {{ c.bandwidth }}
                ceiling {{ c.ceiling }}
                burst {{ c.burst }}
                priority {{ c.priority }}
                queue-type {{ c.queue_type }}
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
