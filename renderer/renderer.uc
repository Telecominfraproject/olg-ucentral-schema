/*
 * OLG uCentral Configuration Renderer
 *
 * Master renderer module that orchestrates configuration generation
 * for OpenLan Gateway (OLG) L3 routers using VyOS tree config format.
 *
 * Based on wlan-ucentral-schema renderer patterns adapted for VyOS.
 */

'use strict';

import * as fs from 'fs';

/* Helper function: Convert value to boolean string */
function b(val) {
	return val ? 'true' : 'false';
}

/* Helper function: Format string with proper quoting */
function s(str) {
	if (str == null)
		return "''";
	str = '' + str;
	/* Escape single quotes */
	str = replace(str, "'", "'\\''");
	return "'" + str + "'";
}

/*
 * Files utility class for managing configuration file outputs
 */
let files = {
	/* Storage for pending file writes */
	pending: {},

	/* Base directory for config files */
	base_path: '/config',

	/* Create directory path recursively */
	mkdir_path: function(path) {
		let parts = split(path, '/');
		let current = '';

		for (let i = 0; i < length(parts) - 1; i++) {
			if (parts[i] == '')
				continue;
			current += '/' + parts[i];
			fs.mkdir(current);
		}
	},

	/* Add a file with explicit path */
	add_named: function(path, content) {
		/* Expand relative paths against base directory */
		if (substr(path, 0, 1) != '/')
			path = this.base_path + '/' + path;

		this.pending[path] = content;
	},

	/* Add a file with generated name based on location and hint */
	add_anonymous: function(location, name, content) {
		/* Generate path from location pointer and name hint */
		let escaped_location = replace(location, '~', '~0');
		escaped_location = replace(escaped_location, '/', '~1');

		let escaped_name = replace(name, '~', '~0');
		escaped_name = replace(escaped_name, '/', '~1');

		let path = sprintf('%s/%s-%s.uc', this.base_path, escaped_location, escaped_name);
		this.pending[path] = content;
	},

	/* Write all pending files to filesystem */
	write: function(logs) {
		logs = logs || [];
		let success = true;

		for (let path in keys(this.pending)) {
			let content = this.pending[path];

			/* Create parent directories */
			this.mkdir_path(path);

			/* Write file */
			let fd = fs.open(path, 'w');
			if (fd) {
				fd.write(content);
				fd.close();
				push(logs, { type: 'info', message: sprintf('Wrote config file: %s', path) });
			} else {
				push(logs, { type: 'error', message: sprintf('Failed to write: %s', path) });
				success = false;
			}
		}

		/* Clear pending files after write */
		this.pending = {};
		return success;
	},

	/* Clear all pending files without writing */
	clear: function() {
		this.pending = {};
	}
};

/*
 * Template registry for interface renderers
 */
let templates = {
	interfaces: {}
};

/* Register an interface template */
function register_interface_template(type, handler) {
	templates.interfaces[type] = handler;
}

/* Load and register interface templates */
function load_interface_templates() {
	/* Bridge interface handler */
	let bridge_module = require('interfaces/bridge.uc');
	if (bridge_module)
		templates.interfaces['bridge'] = bridge_module;

	/* Ethernet interface handler */
	let ethernet_module = require('interfaces/ethernet.uc');
	if (ethernet_module)
		templates.interfaces['ethernet'] = ethernet_module;
}

/*
 * Main render function
 *
 * Processes configuration state and generates output files
 */
function render(state) {
	let logs = {
		warnings: [],
		errors: [],
		info: []
	};

	if (!state) {
		push(logs.errors, 'No state configuration provided');
		return logs;
	}

	/* Load interface templates */
	load_interface_templates();

	/* Process interfaces */
	if (state.interfaces && type(state.interfaces) == 'array') {
		for (let iface in state.interfaces) {
			let iface_type = iface.type;

			if (templates.interfaces[iface_type]) {
				let handler = templates.interfaces[iface_type];
				if (handler.render) {
					try {
						handler.render(iface, state, files, logs);
					} catch (e) {
						push(logs.errors, sprintf('Error rendering %s interface: %s', iface_type, e));
					}
				}
			}
		}
	}

	/* Write all pending files */
	if (!files.write(logs.info)) {
		push(logs.errors, 'Some files failed to write');
	}

	return logs;
}

/*
 * Render configuration for a specific interface type
 */
function render_interface(iface, state) {
	let logs = { warnings: [], errors: [], info: [] };

	let iface_type = iface.type;
	if (templates.interfaces[iface_type]) {
		let handler = templates.interfaces[iface_type];
		if (handler.render) {
			handler.render(iface, state, files, logs);
		}
	}

	return logs;
}

/* Export public API */
return {
	b,
	s,
	files,
	templates,
	register_interface_template,
	render,
	render_interface
};
