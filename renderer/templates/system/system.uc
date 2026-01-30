system {
    conntrack {
        modules {

        }
    }
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
    {% if (system.name_server): %}
        {% for (let server in system.name_server): %}
    name-server {{ server }}
        {% endfor %}
    {% endif %}
}
