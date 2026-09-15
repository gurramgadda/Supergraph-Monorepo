#!/bin/sh
set -eu

# Never trace environment loading: .env may contain APOLLO_KEY.
set +x
if [ -f .env ]; then
  set -a
  . ./.env
  set +a
fi

artifact="${SUPERGRAPH_ARTIFACT:-router/artifacts/supergraph.graphql}"
router_bin="${APOLLO_ROUTER_BIN:-router}"
metadata="${artifact}.metadata.json"

if [ ! -s "$artifact" ]; then
  printf '%s\n' "Missing Router artifact: $artifact" >&2
  printf '%s\n' "Run npm run fetch:graphos before starting Router." >&2
  exit 1
fi

if [ ! -s "$metadata" ]; then
  printf '%s\n' "Missing artifact provenance metadata: $metadata" >&2
  printf '%s\n' "Run npm run fetch:graphos before starting Router." >&2
  exit 1
fi

expected_sha256="$(awk -F'"' '/"sha256"/ {print $4}' "$metadata")"
actual_sha256="$(/usr/bin/shasum -a 256 "$artifact" | awk '{print $1}')"
if [ -z "$expected_sha256" ] || [ "$expected_sha256" != "$actual_sha256" ]; then
  printf '%s\n' "Artifact checksum verification failed: $artifact" >&2
  exit 1
fi

graph_ref="$(awk -F'"' '/"graphRef"/ {print $4}' "$metadata")"
printf '%s\n' "Starting Apollo Router from GraphOS artifact"
printf '%s\n' "  graphRef: $graph_ref"
printf '%s\n' "  artifact: $artifact"
printf '%s\n' "  sha256: $actual_sha256"

exec "$router_bin" --supergraph "$artifact" --listen "${SUPERGRAPH_LISTEN:-127.0.0.1:${SUPERGRAPH_PORT:-4000}}"