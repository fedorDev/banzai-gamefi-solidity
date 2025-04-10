// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("GameBsc_prod_B", (m) => {
  const game = m.contract("Game_neo_B", [], {});
  return { game };
});
