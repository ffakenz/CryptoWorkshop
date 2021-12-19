const EventMarket = artifacts.require("./wip/application/EventMarket");
const compiledNFTicket = require("../build/contracts/NFTicketImpl.json");
const compiledEventContract = require("../build/contracts/EventContractImpl.json");

const truffleAssert = require("truffle-assertions");
const BN = web3.utils.BN;
const Contract = require("web3-eth-contract");

contract("EventMarket Test", function (accounts) {
    const [deployer, recipient, other, unknown] = accounts;
    // set provider for all later instances to use
    Contract.setProvider("ws://localhost:9545");

    beforeEach(async () => {
        this.eventMarket = await EventMarket.new();
    });

    it("sell ticket to whitelisted customer", async () => {
        const ticketId = 1;
        const eventId = 1;
        const ticketPrice = 2;

        await this.eventMarket.createEvent(
            eventId,
            311221,
            ticketPrice,
            "GaiaNFTicket",
            "GAIA",
            [recipient, other]
        );

        // obtain deployed contracts
        const nftContractAddress = await this.eventMarket.nftContract({
            from: deployer,
        });
        this.nftContract = new Contract(
            compiledNFTicket.abi,
            nftContractAddress
        );

        const eventContractAddress = await this.eventMarket.eventContract({
            from: deployer,
        });
        this.eventContract = new Contract(
            compiledEventContract.abi,
            eventContractAddress
        );

        // check customer HAS NO nft balance
        assert.equal(
            await this.nftContract.methods.balanceOf(deployer).call(),
            0
        );

        await this.eventMarket.buyTicket(ticketId, {
            from: deployer,
            value: ticketPrice,
            gasPrice: 0,
        });

        // check customer HAS nft balance
        assert.equal(
            await this.nftContract.methods.balanceOf(deployer).call(),
            1
        );
    });
});
