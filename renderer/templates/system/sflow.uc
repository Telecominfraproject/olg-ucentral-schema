    sflow {
{% if (sflow.agent): %}
        agent-address "{{ sflow.agent.address }}"
    {% if (sflow.agent.interface): %}
        agent-interface "{{ sflow.agent.interface }}"
    {% endif %}
{% endif %}
{% for (let i in sflow.interfaces): %}
        interface "{{ i }}"
{% endfor %}
{% for (let s in sflow.servers): %}
        server {{ s.address }} {
    {% if (s.port): %}
            port "{{ s.port }}"
    {% endif %}
        }
{% endfor %}
{% if (sflow.sampling_rate): %}
        sampling-rate "{{ sflow.sampling_rate }}"
{% endif %}
{% if (sflow.sample_egress): %}
        enable-egress
{% endif %}
    }
