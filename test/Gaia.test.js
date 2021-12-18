const NFTicket = artifacts.require("NFTicket");
const GaiaStore = artifacts.require("GaiaStore");

const truffleAssert = require("truffle-assertions");
const BN = web3.utils.BN;

contract("Gaia Test", function (accounts) {
    const [deployer, recipient, other, unknown] = accounts;

    // errors
    const USER_NOT_ALLOWED = "user not allowed";
    const EVENT_DOES_NOT_EXISTS = "event does not exists";
    const NOT_ENOUGH_TICKETS = "not enough tickets";
    const NOT_ENOUGH_MONEY = "not enough money";
    const CALLER_IS_NOT_THE_OWNER = "caller is not the owner";

    beforeEach(async () => {
        this.nfticket = await NFTicket.new("GaiaNFTicket", "GAIA");
        this.gaiaStore = await GaiaStore.new(nfticket.address, [
            recipient,
            other,
        ]);
    });

    it("reject to create nft ticket if not owner", async () => {
        const ticketId = 1;
        await truffleAssert.reverts(
            this.nfticket.createTicket(ticketId, this.gaiaStore.address, {
                from: other,
            }),
            CALLER_IS_NOT_THE_OWNER
        );
    });

    it("create nft ticket", async () => {
        const ticketId = 1;
        await this.nfticket.createTicket(ticketId, this.gaiaStore.address, {
            from: deployer,
        });

        // check gaia has nft ticket balance
        assert.equal(await this.nfticket.balanceOf(this.gaiaStore.address), 1);
    });

    it("reject to create event if not owner", async () => {
        const eventId = 1;
        const ticketPrice = 2;

        await truffleAssert.reverts(
            this.gaiaStore.createEvent(eventId, 311221, ticketPrice, [], {from: other}),
            CALLER_IS_NOT_THE_OWNER
        );
    });

    it("create event", async () => {
        const ticketId1 = 1;
        const ticketId2 = 2;
        const eventId = 1;
        const ticketPrice = 2;
        const eventStartDate = 311221;

        await this.nfticket.createTicket(ticketId1, this.gaiaStore.address, {
            from: deployer,
        });
        await this.nfticket.createTicket(ticketId2, this.gaiaStore.address, {
            from: deployer,
        });
        const eventCreated = await this.gaiaStore.createEvent(
            eventId, 311221, ticketPrice, [ticketId1, ticketId2], {from: deployer }
        );
        truffleAssert.eventEmitted(eventCreated, 'EventCreated', (ev) => {
            return ev._eventId == eventId &&
            ev._startDate == eventStartDate &&
            ev._ticketPrice == ticketPrice &&
            ev._status == 1 &&
            ev._tickets == `${ticketId1},${ticketId2}`;
        });

        // check event exists
        const created = await this.gaiaStore.getEvent(eventId);
        assert.equal(created.status, 1);
    });

    it("reject buy due event does not exists", async () => {
        const nonExistingEventId = 1;
        await truffleAssert.reverts(
            this.gaiaStore.buyTicket(nonExistingEventId, {
                from: recipient,
                value: "2",
                gasPrice: 0,
            }),
            EVENT_DOES_NOT_EXISTS
        );
    });

    it("reject buy due to not enough tickets", async () => {
        const eventId = 1;
        const ticketPrice = 2;

        await this.gaiaStore.createEvent(eventId, 311221, ticketPrice, [], {
            from: deployer,
        });

        // reject buy due to not enough tickets
        await truffleAssert.reverts(
            this.gaiaStore.buyTicket(eventId, {
                from: recipient,
                value: ticketPrice,
                gasPrice: 0,
            }),
            NOT_ENOUGH_TICKETS
        );
    });

    it("reject unknown buyer", async () => {
        const ticketId = 1;
        const eventId = 1;
        const ticketPrice = 2;

        await this.nfticket.createTicket(ticketId, this.gaiaStore.address, {
            from: deployer,
        });
        await this.gaiaStore.createEvent(eventId, 311221, ticketPrice, [ticketId], {
            from: deployer,
        });

        // reject buy due to unknown buyer
        await truffleAssert.reverts(
            this.gaiaStore.buyTicket(eventId, {
                from: unknown,
                value: ticketPrice,
                gasPrice: 0,
            }),
            USER_NOT_ALLOWED
        );
    });

    it("reject buy due to insufficient funds", async () => {
        const ticketId = 1;
        const eventId = 1;
        const ticketPrice = 2;

        await this.nfticket.createTicket(ticketId, this.gaiaStore.address, {
            from: deployer,
        });
        await this.gaiaStore.createEvent(eventId, 311221, ticketPrice, [ticketId], {
            from: deployer,
        });

        // reject buy due to insufficient funds
        await truffleAssert.reverts(
            this.gaiaStore.buyTicket(eventId, {
                from: recipient,
                value: "1",
                gasPrice: 0,
            }),
            NOT_ENOUGH_MONEY
        );
    });

    it("sell ticket to whitelisted customer", async () => {
        const ticketId = 1;
        const eventId = 1;
        const ticketPrice = 2;

        await this.nfticket.createTicket(ticketId, this.gaiaStore.address, {
            from: deployer,
        });
        await this.gaiaStore.createEvent(eventId, 311221, ticketPrice, [ticketId], {
            from: deployer,
        });

        // check gaia has balance 0
        assert.equal(await web3.eth.getBalance(this.gaiaStore.address), 0);

        // sell ticket to whitelisted customer
        const ticketSold = await this.gaiaStore.buyTicket(eventId, {
            from: recipient,
            value: ticketPrice,
            gasPrice: 0,
        });
        truffleAssert.eventEmitted(ticketSold, 'TicketSold', (ev) => {
            return ev._ticketId == ticketId &&
            ev._eventId == eventId &&
            ev._customer == recipient &&
            ev._price == ticketPrice;
        });

        // check customer has nft balance
        assert.equal(await this.nfticket.balanceOf(recipient), 1);

        // check gaia has balance 2
        assert.equal(await web3.eth.getBalance(this.gaiaStore.address), ticketPrice);
    });
});
