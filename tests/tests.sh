#!/usr/bin/env bash

set -ex -o pipefail

cd $(dirname $0)

echo build the tools
(
	cd tools
	yarn
	$(yarn bin)/tsc
)

echo install project dependencies
(
	cd project
	yarn
)

echo run startup test
(
	node tools/dist/mock-host --file assets/startup-test.json --pwd $(pwd) | node ../client/server/server.js --stdio | node tools/dist/validate-expected --expect assets/startup-golden.json
)

echo run completion test
(
	node tools/dist/mock-host --file assets/completion-test.json --pwd $(pwd) | node ../client/server/server.js --stdio | node tools/dist/validate-expected --expect assets/completion-golden.json
)