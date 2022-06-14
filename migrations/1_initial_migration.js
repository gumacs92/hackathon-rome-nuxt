
// // type Network = "development" //| "kovan" | "mainnet";
const Migrations = artifacts.require("Migrations");

// module.exports = function (
//   deployer: Truffle.Deployer,
//   network: any,
//   accounts: string[]) {
//   deployer.deploy(Migrations);
// };



// // type Network = "development" //| "kovan" | "mainnet";
// const Migrations = artifacts.require("Migrations");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
};
