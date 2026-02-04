{% let name_c = 0, name_m = {}; %}
high-availability {
    {%
        if (ha.load_balancing) {
            include("load-balancing.uc", { location: location + '/load_balancing', lb: ha.load_balancing });
        }
    %}

    {%
        if(ha.vrrp) {
            include("vrrp.uc", { location: location + '/vrrp', vrrp: ha.vrrp });
        }
    %}
}
