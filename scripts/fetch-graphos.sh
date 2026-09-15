#!/bin/sh
set -eu

# Never trace environment loading: .env may contain APOLLO_KEY.
set +x
if [ -f .env ]; then
  set -a
  . ./.env
  set +a
fi

PATH="/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:$HOME/.rover/bin:$PATH"
export PATH

graph_ref="${APOLLO_GRAPH_REF:-supergraph-federation@local}"
artifact="${SUPERGRAPH_ARTIFACT:-router/artifacts/supergraph.graphql}"

if [ -z "${APOLLO_KEY:-}" ]; then
  printf '%s\n' "APOLLO_KEY is required to fetch $graph_ref." >&2
  exit 1
fi

mkdir -p "$(dirname "$artifact")"
rover supergraph fetch "$graph_ref" --output "$artifact"

sha256="$(shasum -a 256 "$artifact" | awk '{print $1}')"
cat > "${artifact}.metadata.json" <<EOF
{
  "graphRef": "$graph_ref",
  "artifact": "$artifact",
  "sha256": "$sha256",
  "source": "rover supergraph fetch",
  "fetchedAt": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
printf '%s\n' "Fetched $graph_ref to $artifact"