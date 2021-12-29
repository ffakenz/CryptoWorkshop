const NFT = artifacts.require("./wip/NFT");
const USDC = artifacts.require("./wip/MockUSDC");
const PaymentGateway = artifacts.require("./wip/PaymentGateway");
const Store = artifacts.require("./wip/Store");

const truffleAssert = require("truffle-assertions");
const BN = web3.utils.BN;

contract("Store Test", function (accounts) {
    // deployer is god
    // recipient is client { ie: dino, gaia, delphi }
    const [deployer, client, customer, hacker] = accounts;

    // @TODO check events on init and on store-set
    beforeEach(async () => {
        this.usdc = await USDC.new();
        this.paymentGateway = await PaymentGateway.new();
        await this.paymentGateway.initialize(this.usdc.address, client);
        this.nft = await NFT.new("NFTicket", "GAIA");
        this.store = await Store.new();
        await this.store.initialize(
            this.nft.address,
            this.paymentGateway.address,
            client
        );
        await this.nft.initialize(this.store.address);
    });

    it("e2e", async () => {
        // check client & customer USDC balance == 0
        assert.equal(await this.usdc.balanceOf(client), 0);
        assert.equal(await this.usdc.balanceOf(customer), 0);

        // deposit USDC to customer
        await this.usdc.faucet(customer, 100);
        assert.equal(await this.usdc.balanceOf(customer), 100);

        // set NFT price
        await this.store.setTokenPrice(
            1, // tokenId
            50, // price
            {
                from: client,
            }
        );

        // check customer NFT balance == 0
        assert.equal(await this.nft.balanceOf(client), 0);

        // customer buy NFT
        await this.store.buyNFT(
            1, // tokenId
            1, // paymentId
            {
                from: customer,
            }
        );

        // check client & customer USDC balance
        assert.equal(await this.usdc.balanceOf(client), 50);
        assert.equal(await this.usdc.balanceOf(customer), 50);

        // check customer NFT balance == 1
        assert.equal(await this.nft.balanceOf(client), 1);
    });
});
