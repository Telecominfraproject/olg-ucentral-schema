load-balancing {
    {% 
        if (lb.wan_lb) {
            include("wan.uc", {
                location: location + '/wan_lb',
                wan: lb.wan_lb,
                ethernet: ethernet
            });
        }
        if (lb.haproxy) {
            include("haproxy.uc", {
                location: location + '/haproxy',
                haproxy: lb.haproxy
            });
        }
    %}
}
