const NFTicket = artifacts.require("NFTicket");
const GaiaStore = artifacts.require("GaiaStore");

module.exports = async function (deployer, network, accounts) {
    await deployer.deploy(NFTicket, "GaiaNFTicket", "GAIA");
    const nfticket = await NFTicket.deployed();

    const [owner, recipient, other, unknown] = accounts;
    await deployer.deploy(GaiaStore, nfticket.address, [recipient, other]);
    const gaiaStore = await GaiaStore.deployed();

    // @TODO
    // deploy usdc
    // deploy nft
    // deploy payment gateway + initialize (usdc)
    // deploy store + initialize (nft, payment gateway)
    // set store to payment gateway (store)
    // set store to nft (store)
};
