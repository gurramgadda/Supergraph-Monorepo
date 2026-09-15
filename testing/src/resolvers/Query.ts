import { Resolvers } from "../__generated__/resolvers-types";
import { testProducts } from "../testData";

export const Query: Resolvers = {
  Query: {
    testProduct(_parent, { id }) {
      return testProducts.find((product) => product.id === String(id)) ?? null;
    },
    testProducts() {
      return testProducts.map((product) => ({ ...product }));
    },
  },
};