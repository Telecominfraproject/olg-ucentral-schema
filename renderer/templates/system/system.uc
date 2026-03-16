system {
    {%
        include("login.uc", { location: location + '/login' });
        if (system.syslog) {
            include("syslog.uc", { location: location + '/syslog', syslog: system.syslog });
        }

        if (system.netflow) {
            include("netflow.uc", { location: location + '/netflow', netflow: system.netflow });
        }

        if (system.sflow) {
            include("sflow.uc", { location: location + '/slow', sflow: system.sflow });
        }
    %}
    {% if (system.name_servers): %}
        {% if (system.name_servers.dhcp-interfaces): %}
            {% for (let interface in system.name_servers.dhcp-interfaces): %}
    name-server {{ interface }}
            {% endfor %}
        {% endif %}
        {% if (system.name_servers.addresses): %}
            {% for (let address in system.name_servers.addresses): %}
    name-server {{ address }}
            {% endfor %}
        {% endif %}
    {% endif %}
}
