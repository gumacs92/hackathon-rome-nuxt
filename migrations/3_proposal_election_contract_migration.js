
const GovernorElection = artifacts.require("GovernorElection");
const ProposalElection = artifacts.require("ProposalElection");

// module.exports = function (
//   deployer: Truffle.Deployer,
//   network: any,
//   accounts: string[]) {
//   deployer.deploy(RomeElection);
// };

module.exports = async function (deployer) {
  deployer.deploy(ProposalElection, GovernorElection.address);
};