# banzai-gamefi-solidity
Smart contracts for mini games Banzai GameFi ecosystem (EVM)

Players send same amount stakes to smart contract, storing in pool. When pool is filled 
with 10 stakes, after 2 blocks smart contract detects winner and sends him 90% of pool.

Simple MEV/Frontrunning protection is implemented: winner detected after some delay, when
transactions was already 2 blocks behind in chain. So bots cant try to play and after rewrite 
their transaction if they losed.

Website: https://banzai.meme
