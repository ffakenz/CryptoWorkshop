const NFTicket = artifacts.require("NFTicket");
const GaiaStore = artifacts.require("GaiaStore");

const truffleAssert = require('truffle-assertions');
const BN = web3.utils.BN;

contract("Gaia Test", function (accounts) {
    const [deployer, recipient, other, unknown] = accounts;

    beforeEach(async () => {
        this.nfticket = await NFTicket.new("GaiaNFTicket", "GAIA");
        this.gaiaStore = await GaiaStore.new(nfticket.address, [recipient, other]);
    });

    it("create nft ticket", async () => {
        const ticketId = 1;
        await this.nfticket.createTicket(ticketId, this.gaiaStore.address, { from: deployer });

        // check gaia has nft ticket balance
        assert.equal(await this.nfticket.balanceOf(this.gaiaStore.address), 1);
    });

    it("create event", async () => {
        const ticketId = 1;
        const eventId = 1;
        
        await this.nfticket.createTicket(ticketId, this.gaiaStore.address, { from: deployer });
        await this.gaiaStore.createEvent(eventId, 311221, 2, [ticketId]);

        // check event exists
        const created = await this.gaiaStore.getEvent(eventId);
        assert.equal(created.status, 1);
    });

    it("reject unknown buyer", async () => {
        const ticketId = 1;
        const eventId = 1;

        await this.nfticket.createTicket(ticketId, this.gaiaStore.address, { from: deployer });
        await this.gaiaStore.createEvent(eventId, 311221, 2, [ticketId]);

        // reject buy due to unknown buyer
        await truffleAssert.reverts(
            this.gaiaStore.buyTicket(eventId, { from: unknown, value: "2", gasPrice: 0 }),
            "user not allowed"
        );
    });

    it("reject buy due to insufficient funds", async () => {
        const ticketId = 1;
        const eventId = 1;

        await this.nfticket.createTicket(ticketId, this.gaiaStore.address, { from: deployer });
        await this.gaiaStore.createEvent(eventId, 311221, 2, [ticketId]);

        // reject buy due to insufficient funds
        await truffleAssert.reverts(
            this.gaiaStore.buyTicket(eventId, { from: recipient, value: "1", gasPrice: 0 }),
            "not enough money"
        );
    });

    it("reject buy due to not enough tickets", async () => {
        const eventId = 1;

        await this.gaiaStore.createEvent(eventId, 311221, 2, []);

        // reject buy due to not enough tickets
        await truffleAssert.reverts(
            this.gaiaStore.buyTicket(eventId, { from: recipient, value: "2", gasPrice: 0 }),
            "revert not enough tickets"
        );
    });

    it("sell ticket to whitelisted customer", async () => {
        const ticketId = 1;
        const eventId = 1;

        await this.nfticket.createTicket(ticketId, this.gaiaStore.address, { from: deployer });
        await this.gaiaStore.createEvent(eventId, 311221, 2, [ticketId]);

        // check gaia has balance 0
        assert.equal(await web3.eth.getBalance(this.gaiaStore.address), 0);

        // sell ticket to whitelisted customer
        await this.gaiaStore.buyTicket(eventId, { from: recipient, value: "2", gasPrice: 0 });
        
        // check customer has nft balance
        assert.equal(await this.nfticket.balanceOf(recipient), 1);
        
        // check gaia has balance 2
        assert.equal(await web3.eth.getBalance(this.gaiaStore.address), 2);
    });
});
