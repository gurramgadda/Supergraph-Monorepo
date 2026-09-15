import { CodegenConfig } from "@graphql-codegen/cli";

const config: CodegenConfig = {
  schema: "./testing/schema.graphql",
  generates: {
    "./testing/src/__generated__/resolvers-types.ts": {
      config: {
        federation: true,
        useIndexSignature: true,
      },
      plugins: ["typescript", "typescript-resolvers"],
    },
  },
};

export default config;