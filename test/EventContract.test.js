const EventContract = artifacts.require("./wip/domain/event/EventContractImpl");
const NFTicket = artifacts.require("./wip/domain/nft/NFTicketImpl");

const truffleAssert = require("truffle-assertions");
const BN = web3.utils.BN;

contract("EventContract Test", function (accounts) {
    const [deployer, recipient, other, unknown] = accounts;

    const ticketPrice = 2;

    beforeEach(async () => {
        const eventId = 1;
        this.nfticket = await NFTicket.new("GaiaNFTicket", "GAIA");
        this.eventContract = await EventContract.new(
            eventId,
            311221,
            ticketPrice,
            this.nfticket.address,
            [recipient, other]
        );
    });

    it("sell ticket to whitelisted customer", async () => {
        const ticketId = 1;

        assert.equal(await this.nfticket.balanceOf(recipient), 0);

        await this.eventContract.emitTicket(ticketId, recipient, {
            from: recipient,
        });

        assert.equal(await this.nfticket.balanceOf(recipient), 1);
    });
});
