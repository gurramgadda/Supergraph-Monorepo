import { readFileSync } from "fs";
import { resolve } from "path";
import gql from "graphql-tag";
import { buildSubgraphSchema } from "@apollo/subgraph";
import { ApolloServer } from "@apollo/server";
import { startStandaloneServer } from "@apollo/server/standalone";
import resolvers from "./resolvers";

const port = 4002;

async function main() {
  const typeDefs = gql(
    readFileSync(resolve(__dirname, "../schema.graphql"), "utf-8")
  );
  const server = new ApolloServer({
    schema: buildSubgraphSchema([{ typeDefs, resolvers }]),
  });
  const { url } = await startStandaloneServer(server, {
    listen: { port },
  });

  console.log(`Testing subgraph ready at ${url}`);
}

main();