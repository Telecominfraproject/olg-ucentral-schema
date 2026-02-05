{% for (let v in lb.): %}
    virtual-server 192.168.240.100 {
        address 192.168.240.100
        algorithm source-hashing
        forward-method nat
        port 8888
        real-server 192.168.0.1 {
            port 80
        }
        real-server 192.168.0.2 {
            port 80
        }
    }
{% endfor %}