# Local GraphOS Variant Platform

This repository uses GraphOS for build-time schema coordination and keeps the
runtime local.

## Responsibilities

GraphOS owns:

- The `supergraph-federation@local` graph variant.
- Subgraph schema history for `products` and `testing`.
- Composition and schema checks.
- The latest composed supergraph artifact available for retrieval.

The local machine owns:

- Subgraph processes on ports `4001` and `4002`.
- Router process on port `4000`.
- Process supervision, local networking, logs, and health checks.
- The fetched schema file used by Router at runtime.

GraphOS is not contacted by Router during request handling.

## Primary deployment flow

```text
npm run build:local
        |
        v
GraphOS check -> GraphOS publish -> rover supergraph fetch
                                      |
                                      v
                         router/artifacts/supergraph.graphql
                                      |
                                      v
                              local Apollo Router
```

Run:

```sh
export APOLLO_GRAPH_REF=supergraph-federation@local
export APOLLO_KEY='read-from-your-secret-store'
npm run deploy:local
```

`deploy:local` builds and tests the subgraphs, checks and publishes their SDLs,
fetches the latest composed artifact, and leaves the local runtime ready to
start. Then run:

```sh
npm run dev
npm run dev:testing
npm run start:router
```

Router reads only the fetched artifact. It does not read `supergraph.yaml`,
compose schemas, or call GraphOS while serving requests.

The publish step records the local routing URLs from `PRODUCTS_URL` and
`TESTING_URL` in the GraphOS artifact. GraphOS does not need to reach these
URLs for this local variant, but the local Router needs them when it executes
subgraph requests.

## Fallback mode

For offline development or diagnosing a GraphOS discrepancy:

```sh
npm run compose:local
```

This writes `router/artifacts/supergraph.local.graphql`. It is a diagnostic
artifact and is not the primary deployment input.

## Credentials

Never commit `APOLLO_KEY`. Use an exported environment variable, macOS Keychain
integration, or an untracked `.env` file based on `.env.example`.

The repository scripts disable shell tracing before loading `.env`, so normal
script output contains only non-secret values such as the graph reference,
artifact path, and checksum. Do not run scripts with `sh -x`, and do not print
the environment with `env`, `set`, or diagnostic tooling while `APOLLO_KEY` is
loaded. If the key has appeared in terminal output, rotate it in GraphOS.

The GraphOS API key previously present in workspace settings must be rotated
before using the publish commands. The workspace settings now contain only the
non-secret graph reference.

## Artifact provenance

`fetch:graphos` writes a sidecar metadata file next to the fetched schema with:

- Graph reference
- Fetch source
- Fetch timestamp
- SHA-256 artifact hash

Keep the previous artifact and metadata when testing a new local deployment so
Router can be rolled back without recomposing or contacting GraphOS.