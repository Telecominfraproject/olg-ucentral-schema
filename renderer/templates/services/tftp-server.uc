{%%}
    tftp-server {
        directory {{ tftp.directory }}
{% if (tftp.listen_address): %}
        listen-address {{ tftp.listen_address }} {
            
        }
{% endif %}
{% if (tftp.allow_upload): %}
        allow-upload
{% endif %}
    }