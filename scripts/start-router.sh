#!/bin/sh
set -eu

artifact="${SUPERGRAPH_ARTIFACT:-router/artifacts/supergraph.graphql}"
router_bin="${APOLLO_ROUTER_BIN:-router}"

if [ ! -s "$artifact" ]; then
  printf '%s\n' "Missing Router artifact: $artifact" >&2
  printf '%s\n' "Run npm run fetch:graphos before starting Router." >&2
  exit 1
fi

exec "$router_bin" --supergraph "$artifact" --http-port "${SUPERGRAPH_PORT:-4000}"