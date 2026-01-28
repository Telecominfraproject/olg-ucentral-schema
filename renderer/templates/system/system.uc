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
}
