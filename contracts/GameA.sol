// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

// version 2.0
// pools stakes: A - 0.01, B - 0.05, C - 0.1

contract Banzai_game_A {
  uint256 constant STAKE = 0.01 ether;
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
    (bool sentReward,) = CREATOR.call{ value: address(this).balance - 0.005 ether }("");
    require(sentReward, "Failed to send reward");
  }

  function showPool() external view returns (address [] memory) {
    return pool;
  }

  function detectWinner() public payable {
      require(msg.sender == ORACLE, "Only oracle can call this method");
      require(pool.length > 9, "Pool is not full");
      require(block.number > lastBlock+2, "Please wait 2 more blocks");
      
      uint256 ind = msg.value % 10;
      address winner = pool[ind];
      lastWinner = winner;

      for (uint256 i = 0; i < 10; ++i) {
        address c = pool[i];
        delete stakes[c];
      }

      delete pool; // reset pool
      ++round;

      (bool sent,) = winner.call{ value: STAKE*9 }("");
      require(sent, "Failed to send prize");
  }

  function play() public payable {
    require(tx.origin == msg.sender, "No stakes from smart contracts!");
    require(msg.value == STAKE, "Invalid amount!");
    require(pool.length < 10, "Pool is filled, please wait");

    if (stakes[msg.sender] > 0) {
        require(stakes[msg.sender] < 5, "Max 5 stakes per round");
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
