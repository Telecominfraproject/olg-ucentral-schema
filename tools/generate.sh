#!/bin/sh

set -e
set -x

./tools/merge-schema.py schema schema ucentral.yml ucentral.schema.json 1 1
./tools/merge-schema.py schema schema ucentral.yml ucentral.schema.pretty.json 0 1
./tools/merge-schema.py schema schema ucentral.yml ucentral.schema.full.json 0 0
./tools/merge-schema.py state state state.yml ucentral.state.pretty.json 0 1
mkdir -p ./validator/ucode ./validator/bash
./generators/ucode/generate-reader.uc > ./validator/ucode/schemareader.uc
./generators/bash/generate-bash-reader.uc > ./validator/bash/schemareader.sh
chmod +x ./validator/bash/schemareader.sh

mkdir -p docs
if command -v generate-schema-doc >/dev/null 2>&1; then
	generate-schema-doc --config expand_buttons=true ucentral.schema.pretty.json docs/ucentral-schema.html
	generate-schema-doc --config expand_buttons=true ucentral.state.pretty.json docs/ucentral-state.html
else
	echo "Warning: generate-schema-doc is not installed. Skipping schema documentation generation."
fi
