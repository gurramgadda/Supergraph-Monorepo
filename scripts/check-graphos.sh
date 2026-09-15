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

if [ -z "${APOLLO_KEY:-}" ]; then
  printf '%s\n' "APOLLO_KEY is required to check $graph_ref." >&2
  exit 1
fi

rover subgraph check "$graph_ref" --name products --schema schema.graphql
rover subgraph check "$graph_ref" --name testing --schema testing/schema.graphql
printf '%s\n' "GraphOS checks passed for $graph_ref"