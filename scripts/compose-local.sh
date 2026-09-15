#!/bin/sh
set -eu

PATH="/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:$HOME/.rover/bin:$PATH"
export PATH

artifact="${SUPERGRAPH_ARTIFACT:-router/artifacts/supergraph.local.graphql}"
mkdir -p "$(dirname "$artifact")"
rover supergraph compose --config supergraph.yaml --output "$artifact"
printf '%s\n' "Local composition written to $artifact (fallback/diagnostic mode)."