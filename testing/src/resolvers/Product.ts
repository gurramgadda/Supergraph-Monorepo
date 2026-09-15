import { Resolvers } from "../__generated__/resolvers-types";

export const Product: Resolvers = {
  Product: {
    __resolveReference(reference) {
      const numericId = Number(reference.id);
      return {
        ...reference,
        testStatus: numericId % 2 === 0 ? "WARN" : "PASS",
        testScore: numericId % 2 === 0 ? 76 : 98,
      };
    },
  },
};