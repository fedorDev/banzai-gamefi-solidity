#!/bin/zsh

npx hardhat compile
npx hardhat ignition deploy ./ignition/modules/GameA.js --network bsc
npx hardhat ignition deploy ./ignition/modules/GameB.js --network bsc
npx hardhat ignition deploy ./ignition/modules/GameC.js --network bsc

npx hardhat ignition deploy ./ignition/modules/GameA.js --network eth
npx hardhat ignition deploy ./ignition/modules/GameB.js --network eth
npx hardhat ignition deploy ./ignition/modules/GameC.js --network eth


