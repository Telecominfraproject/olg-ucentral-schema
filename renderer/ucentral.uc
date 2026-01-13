#!/usr/bin/ucode
push(REQUIRE_SEARCH_PATH,
	"/usr/lib/ucode/*.so",
	"/usr/share/ucentral/*.uc",
	"/home/tsumugi/olg-ucentral-schema/*.uc"
	);

let schemareader = require("schemareader");
let renderer = require("renderer");
let fs = require("fs");

let inputfile = fs.open(ARGV[0], "r");
let inputjson = json(inputfile.read("all"));
let custom_config = (split(ARGV[0], ".")[0] != "/etc/ucentral/ucentral");

let error = 0;

inputfile.close();
let logs = [];

try {
    let state = schemareader.validate(inputjson, logs);
	let batch = state ? renderer.render(state, logs) : "";

    if (state?.strict && length(logs)) {
		push(logs, 'Rejecting config due to strict-mode validation');
		state = null;
	}

	fs.stdout.write("Log messages:\n" + join("\n", logs) + "\n\n");
	if (state) {
		fs.stdout.write("VyOS batch output:\n" + batch + "\n");

		let outputjson = fs.open("/tmp/config.new", "w");
		outputjson.write(batch);
		outputjson.close();

        if (!custom_config) {
			fs.unlink('/etc/ucentral/ucentral.active');
			fs.symlink(ARGV[0], '/etc/ucentral/ucentral.active');
			let cfgs = [];
			for (let k, v in fs.lsdir('/etc/ucentral/'))
				if (wildcard(v, 'ucentral.cfg.1*', true))
					push(cfgs, v);
			cfgs = sort(cfgs);
			while (length(cfgs) >= 5) {
				fs.unlink('/etc/ucentral/' + cfgs[0]);
				shift(cfgs);
			}
		}
    } else {
		error = 1;
	}
	if (!length(batch) || !state)
		error = 2;
	else if (length(logs))
		error = 1;
}
catch (e) {
	error = 2;
	warn("Fatal error while generating UCI: ", e, "\n", e.stacktrace[0].context, "\n");
}

if (inputjson.uuid && inputjson.uuid > 1 && !custom_config) {
	let text = [ 'Success', 'Rejects', 'Failed' ];
	let status = {
		error,
		text: text[error] || "Failed",
	};
	if (length(logs))
		status.rejected = logs;

	if (error > 1)
		exit(1);
}
