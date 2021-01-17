import { Client, Provider, ProviderRegistry, Result } from "@blockstack/clarity";
import { assert } from "chai";

// contract publisher signature
const contractSignature = "SP3GWX3NE58KXHESRYE4DYQ1S31PQJTCRXB3PE9SB";

const child1 = "SP3GWX3NE58KXHESRYE4DYQ1S31PQJTCRXB3PE9SB";

function createClient(name: string, provider: Provider): Client {
  return new Client(contractSignature + "." + name, name, provider);
}

describe("supply chain contract test suite", () => {
  let supplyChainClient: Client;
  let endlessListClient: Client;
  let provider: Provider;

  before(async () => {
    provider = await ProviderRegistry.createProvider();
    supplyChainClient = createClient("supply-chain", provider);
    endlessListClient = createClient("endless-list", provider);
  });
  
  it("should have a valid syntax", async () => {
    await endlessListClient.checkContract();
    await supplyChainClient.checkContract();
  });

  describe("deploying an instance of the contract", () => {
    before(async () => {
      // Make sure to deploy endless list first due to dependency
      await endlessListClient.deployContract();
      await supplyChainClient.deployContract();
    });

    const getParentProduct = async () => {
      const query = supplyChainClient.createQuery({
          method: { name: "get-parent-product", args: [] }
      });
      const receipt = await supplyChainClient.submitQuery(query);
      const result = Result.unwrap(receipt);
      return result;
    }

    it("should return initial product", async () => {
      const product = await getParentProduct();
      assert.equal(product, child1);
    })

    /*
    it("should return 'hello world'", async () => {
      const query = supplyChainClient.createQuery({ method: { name: "say-hi", args: [] } });
      const receipt = await supplyChainClient.submitQuery(query);
      const result = Result.unwrapString(receipt, "utf8");
      assert.equal(result, "hello world");
    });

    it("should echo number", async () => {
      const query = supplyChainClient.createQuery({
        method: { name: "echo-number", args: ["123"] }
      });
      const receipt = await supplyChainClient.submitQuery(query);
      const result = Result.unwrapInt(receipt)
      assert.equal(result, 123);
    });
    */
  });

  after(async () => {
    await provider.close();
  });
});
// brownie REPL - etherium smart contract