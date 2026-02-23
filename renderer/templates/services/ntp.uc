{% if (ntp): %}
    ntp {
        allow-client {
            address "192.168.0.0/16"
            address "10.28.3.254"
        }
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
{% endif %}
