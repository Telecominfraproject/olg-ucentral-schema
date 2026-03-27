    ntp {
{% if (ntp.allow_clients && length(ntp.allow_clients)): %}
        allow-client {
    {% for (let a in ntp.allow_clients): %}
            address "{{ a }}"
    {% endfor %}
        }
{% endif %}
        listen-address "192.168.240.31"

{% for (let s in ntp.servers): %}
        server {{ s.address }} {
    {% if (s.no_select): %}
            no-select
    {% elif (s.nts):%}
            nts
    {% elif (s.pool): %}
            pool
    {% elif (s.prefer): %}
            prefer
    {% elif (s.ptp): %}
            ptp
    {% elif (s.interleave): %}
            interleave
    {% endif %}
        }
{% endfor %}
    }
