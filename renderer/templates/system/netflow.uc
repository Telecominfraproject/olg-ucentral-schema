    flow-accounting {
        netflow {
{% for (let i in netflow.interfaces): %}
            interface "{{ i }}"
{% endfor %}
{% for (let s in netflow.servers): %}
            server {{ s.address }} {
    {% if (s.port): %}
                port "{{ s.port }}"
    {% endif %}
            }
{% endfor %}
            version "{{ netflow.version }}"
        }
    }
