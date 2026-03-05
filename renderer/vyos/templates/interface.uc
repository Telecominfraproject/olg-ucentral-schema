{%
let eth_used = {};
let upstream_assigned = false;
// All other bridges start from br1
let next_br_index = 1;
// Track downstream ethernet interfaces for VLAN rendering
let downstream_eth_vifs = {};
//TODO: The ethernet interfaces should be retrieved from VyoS config, not to be set every time when a load operation is performed . Or we may need to implement logic for applying diff in the configurations instead of (retrieve + load) as it may become tedioud to manage going forward.
%}

interfaces {
	{% if (type(config.interfaces) == "array"): %}
		{%
			// First pass: collect VLAN interfaces and group by parent ethernet
			for (let iface in config.interfaces) {
				if (type(iface?.vlan) == "object" && iface.role == "downstream") {
					let members = ethernet.lookup_interface_by_port(iface);
					if (length(members) > 0) {
						let eth_if = members[0];  // Use first ethernet interface
						if (!downstream_eth_vifs[eth_if])
							downstream_eth_vifs[eth_if] = [];
						push(downstream_eth_vifs[eth_if], iface);
						ethernet.mark_eth_used([eth_if], eth_used);
					}
				}
			}
		%}

		{% for (let iface in config.interfaces): %}
			{%
				// Skip VLAN sub-interfaces - they will be rendered as VIFs on ethernet below
				if (type(iface?.vlan) == "object")
					continue;

				if (iface?.role != "upstream" && iface?.role != "downstream")
					continue;

				let role = iface.role;
				let br_name;

				if (role == "upstream" && !upstream_assigned) {
					br_name = ethernet.upstream_bridge_name();
					upstream_assigned = true;
				}
				else {
					br_name = ethernet.calculate_next_bridge_name(next_br_index);
					next_br_index++;
				}

				let members = ethernet.lookup_interface_by_port(iface);
				ethernet.mark_eth_used(members, eth_used);
			%}

{{ include('interface/bridge.uc', { config, role, br_name, iface, members }) }}

		{% endfor %}
	{% endif %}

	{%
		let eth_list = sort(keys(eth_used));
	%}

	{% for (let eth_if in eth_list): %}
	ethernet {{ eth_if }} {
		{% if (downstream_eth_vifs[eth_if]): %}
			{% for (let vif in downstream_eth_vifs[eth_if]): %}
				{% if (type(vif.vlan) == "object" && vif.vlan.id): %}
		vif {{ vif.vlan.id }} {
					{% if (type(vif.ipv4) == "object" && type(vif.ipv4.subnet) == "string"): %}
			address {{ vif.ipv4.subnet }}
					{% endif %}
					{% if (vif.name): %}
			description {{ vif.name }}
					{% else %}
			description VLAN{{ vif.vlan.id }}
					{% endif %}
		}
				{% endif %}
			{% endfor %}
		{% endif %}
	}
	{% endfor %}
}
