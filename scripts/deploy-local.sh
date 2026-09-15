#!/bin/sh
set -eu

npm run build:local
npm run check:graphos
npm run publish:graphos
npm run fetch:graphos
printf '%s\n' "Local artifact deployment prepared. Start subgraphs, then run npm run start:router."