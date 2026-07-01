vpn {
    {%
        if (vpn.ipsec) {
            include("ipsec.uc", {
                location: location + '/ipsec',
                ipsec: vpn.ipsec,
                ethernet
            });
        }
    %}
}
