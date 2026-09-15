import { Product } from "./Product";
import { Query } from "./Query";

const resolvers = {
  ...Product,
  ...Query,
};

export default resolvers;