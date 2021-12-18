const Migrations = artifacts.require("./infra/Migrations");

module.exports = function (deployer) {
    deployer.deploy(Migrations);
};
