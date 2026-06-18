#!/usr/bin/ucode
push(REQUIRE_SEARCH_PATH,
	"/usr/lib/ucode/*.so",
	"/usr/share/ucentral/*.uc");

"use strict";

system("docker exec -it vyos vtysh -c 'show ip route json' > /tmp/routes.json");
