

const GovernorElection = artifacts.require("GovernorElection");

// module.exports = function (
//   deployer: Truffle.Deployer,
//   network: any,
//   accounts: string[]) {
//   deployer.deploy(RomeElection);
// };

module.exports = function (
  deployer) {
  deployer.deploy(GovernorElection);
};