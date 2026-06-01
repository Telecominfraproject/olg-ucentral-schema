    webproxy {
{% if (wbp.default_port): %}
        default-port {{ wbp.default_port }}
{% endif %}
{% if (wbp.append_domain): %}
    {% if (substr(wbp.append_domain, 0, 1) != "."): %}
        append-domain ".{{ wbp.append_domain }}"
    {% else %}
        append-domain "{{ wbp.append_domain }}"
    {% endif %}
{% endif %}
{% for (let s in wbp.servers): %}
        listen-address {{ s.address }} {
    {% if (s.port): %}
            port "{{ s.port }}"
    {% endif %}
            disable-transparent
        }
{% endfor %}
{% if (wbp.cache_size): %}
        cache-size {{ wbp.cache_size }}
{% endif %}
{% for (let b in wbp.block_domains): %}
        domain-block "{{ b }}"
{% endfor %}
{% for (let n in wbp.noncache_domains): %}
        domain-noncache "{{ n }}"
{% endfor %}
    }
