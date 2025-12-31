{%
/*
 * VyOS Configuration - Toplevel Template
 *
 * NOTE: This template is NOT the primary entry point.
 *
 * The renderer automatically discovers and processes domain-specific
 * templates (interfaces.uc, routing.uc, firewall.uc, etc.) and generates
 * separate .vyos files for each domain.
 *
 * This toplevel template can optionally be used for:
 * 1. Generating a combined/monolithic configuration file
 * 2. Adding global header/footer content
 * 3. Custom orchestration if needed
 *
 * Template Discovery:
 *   The renderer scans templates/ for *.uc files and maps them to state:
 *   - interfaces.uc -> state.interfaces -> interfaces.vyos
 *   - routing.uc    -> state.routing    -> routing.vyos
 *   - firewall.uc   -> state.firewall   -> firewall.vyos
 *   - nat.uc        -> state.nat        -> nat.vyos
 *   - vpn.uc        -> state.vpn        -> vpn.vyos
 *   - services.uc   -> state.services   -> services.vyos
 *   - pki.uc        -> state.pki        -> pki.vyos
 *   - high-availability.uc -> state.high-availability -> high-availability.vyos
 *   - unit.uc       -> state.unit       -> unit.vyos
 *   - globals.uc    -> state.globals    -> globals.vyos
 *
 * Available Context (passed to all templates):
 *   state      - Domain-specific configuration data
 *   full_state - Complete configuration object
 *   vyos       - VyOS tree format helper module
 *   b          - Boolean helper function
 *   s          - String quoting helper function
 *
 * VyOS Helper Functions:
 *   vyos.block_open(name, ...keys)  - Open: "name key1 key2 {"
 *   vyos.block_close()              - Close: "}"
 *   vyos.leaf(key, value)           - Leaf: "key value"
 *   vyos.leaf_list(key, values)     - Multiple leaves for array
 *   vyos.flag(key, condition)       - Presence flag if true
 *   vyos.comment(text)              - Comment: "/* text * /"
 *   vyos.reset_indent()             - Reset indentation to 0
 */

 	let fs = require('fs');

	// reject the config if there is no valid upstream configuration
	if (!state.uuid) {
		state.strict = true;
		error('Configuration must contain a valid UUID. Rejecting whole file');
		return;
	}

    let upstream;
	for (let i, interface in state.interfaces) {
		if (interface.role != 'upstream')
			continue;
		upstream = interface;
	}

    if (state.interfaces)
        include("interfaces.uc", { location: '/interfaces', interfaces: state.interfaces})
%}
