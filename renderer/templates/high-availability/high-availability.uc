{% let name_c = 0, name_m = {}; %}
high-availability {
    {%
        if (ha.virtual_servers) {
            include("virtual-server.uc", { location: location + '/virtual_server', servers: ha.virtual_servers });
        }
    %}

    {%
        if(ha.vrrp) {
            include("vrrp.uc", { location: location + '/vrrp', vrrp: ha.vrrp });
        }
    %}
}
