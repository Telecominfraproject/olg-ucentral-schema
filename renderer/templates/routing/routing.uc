protocols {
    {%
        if (routing.bgp) {
            include("bgp.uc", { location: location + '/bgp', bgp: routing.bgp });
        }
        if (routing.ospf) {
            include("ospf", { location: location + '/ospf', ospf: routing.ospf });
        }
        if (routing.rip) {
            include("rip", { location: location + '/rip', rip: routing.rip });
        }
    %}
}