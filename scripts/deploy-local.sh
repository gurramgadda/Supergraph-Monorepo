#!/bin/sh
set -eu

# Never trace environment loading: .env may contain APOLLO_KEY.
	set +x
	if [ -f .env ]; then
	set -a
	. ./.env
	set +a
fi

npm run build:local
npm run check:graphos
npm run publish:graphos
npm run fetch:graphos
printf '%s\n' "Local artifact deployment prepared. Start subgraphs, then run npm run start:router."