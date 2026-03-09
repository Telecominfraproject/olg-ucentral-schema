{%
let eth_used = {};
let upstream_assigned = false;
// All other bridges start from br1
let next_br_index = 1;
//TODO: The ethernet interfaces should be retrieved from VyoS config, not to be set every time when a load operation is performed . Or we may need to implement logic for applying diff in the configurations instead of (retrieve + load) as it may become tedioud to manage going forward.
%}

interfaces {
	{% if (type(config.interfaces) == "array"): %}
		{% for (let iface in config.interfaces): %}
			{%
				// Skip VLAN sub-interfaces here; they are rendered as VIFs under the downstream bridge
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
{{ include('interface/ethernet.uc', { eth_list }) }}
}
