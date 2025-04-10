// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// pools:
// A - 0.01
// B - 0.05
// C - 0.1

contract Game_neo_C {
  uint256 public constant STAKE = 0.1 ether;
  uint256 round = 1;
  uint256 lastBlock = 0;
  address public lastWinner;
  address constant CREATOR = 0x90fe1986092Ec963C4e9368837D02CB297f545Fe;
  uint8 constant WINNERS_HISTORY_SIZE = 20;
  address[] pool;
  address[] winners;

  function claimReward() public payable {
    require(msg.sender == CREATOR, "Only creator can get rewards");
    require(pool.length < 1, "Pool must be empty");
    (bool sentReward,) = CREATOR.call{ value: address(this).balance - 0.01 ether }("");
    require(sentReward, "Failed to send reward");
  }

  function showPool() external view returns (address [] memory) {
    return pool;
  }

  function showWinners() external view returns (address [] memory) {
    return winners;
  }

  function showChance() public view returns (uint8) {
    uint8 myChance = 0;
    for (uint8 i = 0; i < pool.length; i++) {
         if (pool[i] == msg.sender) {
            myChance += 10;
         }
    }
    return myChance;
  }

  function detectWinner() public payable {
      require(pool.length > 9, "Pool is not full");
      require(block.number > lastBlock+2, "Please wait 2 more blocks to detect winner");
      
      uint256 diff = block.number - lastBlock;
      uint rand1 = uint(keccak256(abi.encodePacked(block.timestamp, diff, msg.sender, round*5))) % 10;
      uint rand2 = uint(keccak256(abi.encodePacked(block.number, diff*4, msg.sender, round*8))) % 10;
      uint rand3 = uint(keccak256(abi.encodePacked(block.coinbase, diff*7, msg.sender, round*3))) % 10;

      uint256 ind = uint(keccak256(abi.encodePacked(block.timestamp, pool[rand1], msg.sender, pool[rand2], round * diff, pool[rand3]))) % 10;
      address winner = pool[ind];
      lastWinner = winner;
      delete pool; // reset pool
      round++;

      if (winners.length < WINNERS_HISTORY_SIZE) {
        winners.push(winner);
      } else {
        for (uint256 i = 0; i < WINNERS_HISTORY_SIZE-1; i++) {
            winners[i] = winners[i+1];
        }
        winners[WINNERS_HISTORY_SIZE-1] = winner;
      }

      (bool sent,) = winner.call{ value: STAKE*9 }("");

      // every 5 rounds send rewards to developer
      if (sent && round % 5 == 0) {
        (bool sentReward,) = CREATOR.call{ value: address(this).balance - 0.015 ether }("");
        require(sentReward, "Failed to send reward to devs");
      }
  }

  function play() public payable {
    require(msg.value == STAKE, "Invalid amount!");

    if (pool.length > 9) {
        detectWinner();
    }

    uint8 myChance = showChance();
    require(myChance < 50, "Stake limit, not more than 5 stakes per round from 1 address");

    pool.push(msg.sender);
    lastBlock = block.number;   
  }

  receive() external payable {
    play();
  }

  fallback() external payable {
    play();
  }
}
