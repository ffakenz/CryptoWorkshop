const NFTicket = artifacts.require("NFTicket");
const GaiaStore = artifacts.require("GaiaStore");

const chai = require("./chaisetup.js");
const BN = web3.utils.BN;
const expect = chai.expect;

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
        const gaiaStoreNFTBalance = await this.nfticket.balanceOf(this.gaiaStore.address);
        expect(gaiaStoreNFTBalance).to.be.bignumber.equal('1');
    });

    it("create event", async () => {
        const ticketId = 1;
        const eventId = 1;
        
        await this.nfticket.createTicket(ticketId, this.gaiaStore.address, { from: deployer });
        await this.gaiaStore.createEvent(eventId, 311221, 2, [ticketId]);

        // check event exists
        const created = await this.gaiaStore.getEvent(eventId);
        expect(created.status).to.be.bignumber.equal('1');
    });

    it("reject unknown buyer", async () => {
        const ticketId = 1;
        const eventId = 1;

        await this.nfticket.createTicket(ticketId, this.gaiaStore.address, { from: deployer });
        await this.gaiaStore.createEvent(eventId, 311221, 2, [ticketId]);

        // reject buy due to unknown buyer
        const maybeTicket = await this.gaiaStore.buyTicket(eventId, { from: unknown, value: "2", gasPrice: 0 });
        await expect(maybeTicket).to.eventually.be.rejected;
    });

    it("reject buy due to insufficient funds", async () => {
        const ticketId = 1;
        const eventId = 1;

        await this.nfticket.createTicket(ticketId, this.gaiaStore.address, { from: deployer });
        await this.gaiaStore.createEvent(eventId, 311221, 2, [ticketId]);

        // reject buy due to insufficient funds
        const maybeTicket = await this.gaiaStore.buyTicket(eventId, { from: recipient, value: "1", gasPrice: 0 });
        await expect(maybeTicket).to.eventually.be.rejected;
    });

    it("reject buy due to not enough tickets", async () => {
        const eventId = 1;

        await this.gaiaStore.createEvent(eventId, 311221, 2, []);

        // reject buy due to not enough tickets
        const maybeTicket = await this.gaiaStore.buyTicket(eventId, { from: recipient, value: "2", gasPrice: 0 });
        await expect(maybeTicket).to.eventually.be.rejected;
    });

    it("sell ticket to whitelisted customer", async () => {
        const ticketId = 1;
        const eventId = 1;

        await this.nfticket.createTicket(ticketId, this.gaiaStore.address, { from: deployer });
        await this.gaiaStore.createEvent(eventId, 311221, 2, [ticketId]);

        // check gaia has balance 0
        expect(await web3.eth.getBalance(this.gaiaStore.address)).to.be.bignumber.equal('0');

        // sell ticket to whitelisted customer
        await this.gaiaStore.buyTicket(eventId, { from: recipient, value: "2", gasPrice: 0 });
        
        // check customer has nft balance
        expect(await this.nfticket.balanceOf(recipient)).to.be.bignumber.equal('1');
        
        // check gaia has balance 2
        expect(await web3.eth.getBalance(this.gaiaStore.address)).to.be.bignumber.equal('2');
    });
});
