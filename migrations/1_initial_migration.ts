
type Network = "development" //| "kovan" | "mainnet";
const Migrations = artifacts.require("Migrations");

module.exports = function (
  deployer: Truffle.Deployer,
  network: Network,
  accounts: string[]) {
  deployer.deploy(Migrations);
};
