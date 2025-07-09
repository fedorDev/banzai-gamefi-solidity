// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("bsc_game_prod_E", (m) => {
  const game = m.contract("Banzai_game_Turbo", [], {});
  return { game };
});
