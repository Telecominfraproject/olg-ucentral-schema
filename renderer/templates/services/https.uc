    https {
        api {
            keys {
                id MY-HTTPS-API-ID {
                    key "shinycolors"
                }
            }
            rest {
            }
        }
        certificates {
            ca-certificate "vyosca"
            certificate "vyoscert2"
        }
        allow-client {
            address "127.0.0.1"
        }
        enable-http-redirect
    }
