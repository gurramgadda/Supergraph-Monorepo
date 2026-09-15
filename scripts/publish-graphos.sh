#!/bin/sh
set -eu

PATH="/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:$HOME/.rover/bin:$PATH"
export PATH

graph_ref="${APOLLO_GRAPH_REF:-supergraph-federation@local}"

if [ -z "${APOLLO_KEY:-}" ]; then
  printf '%s\n' "APOLLO_KEY is required to publish $graph_ref." >&2
  exit 1
fi

rover subgraph publish "$graph_ref" --name products --schema schema.graphql --no-url --check --changelog-message "Local products schema"
rover subgraph publish "$graph_ref" --name testing --schema testing/schema.graphql --no-url --check --changelog-message "Local testing schema"
printf '%s\n' "Published products and testing to $graph_ref"