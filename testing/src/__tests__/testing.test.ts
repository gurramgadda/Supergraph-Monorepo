import { readFileSync } from "fs";
import { resolve } from "path";
import { buildSubgraphSchema } from "@apollo/subgraph";
import { ApolloServer } from "@apollo/server";
import gql from "graphql-tag";
import resolvers from "../resolvers";

describe("Testing subgraph", () => {
  const server = new ApolloServer({
    schema: buildSubgraphSchema([
      {
        typeDefs: gql(
          readFileSync(resolve(process.cwd(), "testing/schema.graphql"), "utf-8")
        ),
        resolvers,
      },
    ]),
  });

  it("returns dummy product data", async () => {
    const response = await server.executeOperation({
      query: "{ testProducts { id name testStatus testScore } }",
    });

    expect(response.body.kind).toBe("single");
    const data = (response.body as any).singleResult.data.testProducts;
    expect(data).toHaveLength(2);
    expect(data[0]).toMatchObject({ id: "1", testStatus: "PASS", testScore: 98 });
  });

  it("resolves testing fields for a federated Product", async () => {
    const response = await server.executeOperation({
      query: "query($representations: [_Any!]!) { _entities(representations: $representations) { ... on Product { testStatus testScore } } }",
      variables: {
        representations: [{ __typename: "Product", id: "2" }],
      },
    });

    expect(response.body.kind).toBe("single");
    const data = (response.body as any).singleResult.data._entities[0];
    expect(data).toEqual({ testStatus: "WARN", testScore: 76 });
  });
});