// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

// version 2.0
// pools stakes: A - 0.01, B - 0.05, C - 0.1, D - 0.3

contract Banzai_game_Turbo {
  uint256 constant STAKE = 0.02 ether;
  uint256 constant MAX_PLAYERS = 300;
  uint256 constant STAKES_LIMIT = 50;
  uint256 public round = 1;
  uint256 lastBlock = 0;
  address public lastWinner;
  address constant CREATOR = 0x90fe1986092Ec963C4e9368837D02CB297f545Fe;
  address constant ORACLE = 0xe7c161b9CCc53447E57d322138111AaBC322Dece;
  mapping(address => uint256) public stakes;
  address[] pool;

  function claimReward() public payable {
    require(msg.sender == CREATOR, "Only creator can get rewards");
    require(pool.length < 1, "Pool must be empty");
    (bool sentReward,) = CREATOR.call{ value: address(this).balance - 0.001 ether }("");
    require(sentReward, "Failed to send reward");
  }

  function showPool() external view returns (address [] memory) {
    return pool;
  }

  function detectWinner() public payable {
      require(msg.sender == ORACLE, "Only oracle can call this method");
      require(pool.length > MAX_PLAYERS - 1, "Pool is not full");
      require(block.number > lastBlock + 2, "Please wait 2 more blocks");
      
      uint256 ind = msg.value % MAX_PLAYERS;
      address winner = pool[ind];
      lastWinner = winner;

      for (uint256 i = 0; i < MAX_PLAYERS; ++i) {
        address c = pool[i];
        delete stakes[c];
      }

      delete pool; // reset pool
      ++round;

      (bool sent,) = winner.call{ value: STAKE*(MAX_PLAYERS - 14)}("");
      require(sent, "Failed to send prize");
  }

  function play() public payable {
    require(tx.origin == msg.sender, "No stakes from smart contracts!");
    require(msg.value == STAKE, "Invalid amount!");
    require(pool.length < MAX_PLAYERS, "Pool is filled, please wait");

    if (stakes[msg.sender] > 0) {
        require(stakes[msg.sender] < STAKES_LIMIT, "No more stakes this round");
    }

    pool.push(msg.sender);
    stakes[msg.sender]++;
    lastBlock = block.number;   
  }

  receive() external payable {
    play();
  }

  fallback() external payable {
    play();
  }
}
