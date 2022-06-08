

const RomeElection = artifacts.require("RomeElection");

module.exports = function (
  deployer: Truffle.Deployer,
  network: Network,
  accounts: string[]) {
  deployer.deploy(RomeElection);
};
