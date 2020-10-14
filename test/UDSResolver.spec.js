const { accounts, contract, web3, config } = require("@openzeppelin/test-environment");
const { constants, ether, time, expectEvent, expectRevert } = require("@openzeppelin/test-helpers");

const { expect } = require("chai");

const UDSRegistry = contract.fromArtifact("UDSRegistry");
// const UDSResolver = contract.fromArtifact("UDSResolver");
// const UDSResolver = contract.fromArtifact("UDSResolverWithFallback");
const UDSResolver = contract.fromArtifact("UDSResolverWithDefault");

describe("UDS", function () {
  const [ admin, user1, user2 ] = accounts;

  beforeEach(async function () {
    this.registry = await UDSRegistry.new({ from: admin });
    this.resolver = await UDSResolver.new({ from: admin });
  });

  describe("write and read", async function () {
    it("address", async function () {
      const key   = web3.utils.soliditySha3("myaddress");
      const value = web3.utils.toChecksumAddress(web3.utils.randomHex(20));

      expectEvent(await this.resolver.setAddress(key, value, { from: user1 }), "ValueUpdated", { account: user1, key });
      expect(await this.resolver.getAddress(user1, key)).to.be.equal(value);
    });

    it("uint256", async function () {
      const key   = web3.utils.soliditySha3("myuint256");
      const value = web3.utils.toBN(42);

      expectEvent(await this.resolver.setUint256(key, value, { from: user1 }), "ValueUpdated", { account: user1, key });
      expect(await this.resolver.getUint256(user1, key)).to.be.bignumber.equal(value);
    });

    it("bytes32", async function () {
      const key   = web3.utils.soliditySha3("mybytes32");
      const value = web3.utils.randomHex(32);

      expectEvent(await this.resolver.setBytes32(key, value, { from: user1 }), "ValueUpdated", { account: user1, key });
      expect(await this.resolver.getBytes32(user1, key)).to.be.equal(value);
    });

    it("string", async function () {
      const key   = web3.utils.soliditySha3("mystring");
      const value = "Don't panic!";

      expectEvent(await this.resolver.setString(key, value, { from: user1 }), "ValueUpdated", { account: user1, key });
      expect(await this.resolver.getString(user1, key)).to.be.equal(value);
    });

    it("bytes", async function () {
      const key   = web3.utils.soliditySha3("mybytes");
      const value = web3.utils.randomHex(128);

      expectEvent(await this.resolver.setBytes(key, value, { from: user1 }), "ValueUpdated", { account: user1, key });
      expect(await this.resolver.getBytes(user1, key)).to.be.equal(value);
    });
  });

  describe("delegation", async function () {
    beforeEach(async function () {
      this.key   = web3.utils.soliditySha3("some key");
      this.value = web3.utils.toBN(42);
      await this.resolver.setUint256(this.key, this.value, { from: user1 });
    });

    it("read data", async function () {
      expect(await this.resolver.getUint256(user1, this.key)).to.be.bignumber.equal(this.value);
    });

    it("read no data", async function () {
      await expectRevert.unspecified(this.resolver.getUint256(user2, this.key));
    });

    it("read delegated", async function () {
      expectEvent(await this.resolver.setDelegation(user1, { from: user2 }), "DelegationUpdated", { account: user2, delegateTo: user1 });
      expect(await this.resolver.getUint256(user2, this.key)).to.be.bignumber.equal(this.value);
    });
  });

  describe("default", async function () {
    beforeEach(async function () {
      this.key   = web3.utils.soliditySha3("some key");
      this.value = "Default value";
      await this.resolver.setDefaultString(this.key, this.value, { from: admin });
    });

    it("read default", async function () {
      expect(await this.resolver.getString(user1, this.key)).to.be.equal(this.value);
    });

    it("read overload", async function () {
      const overloadvalue = "Personal value"
      await this.resolver.setString(this.key, overloadvalue, { from: user1 });
      expect(await this.resolver.getString(user1, this.key)).to.be.equal(overloadvalue);
    });
  });

});
