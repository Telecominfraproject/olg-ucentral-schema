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
    %}
    {% if (system.name_server): %}
        {% for (let server in system.name-server): %}
    name-server {{ server }}
        {% endfor %}
    {% endif %}
}
