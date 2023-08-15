# TicTacToe

## Background 
Inspired by an ELI5 question I wrote this small module. See https://www.reddit.com/r/explainlikeimfive/comments/15rlp9e/eli5_how_many_total_combinations_are_there_in_tic/?utm_source=share&utm_medium=web2x&context=3

## Notes
* Convention is that Player 1 begins the game
* This code is simulation based, and thus different from an exhaustive search approach. 

## Results
Currently this script results in 958 possible (SIMULATED!) ending board positions
```
@time res = simulategames(1_000_000) #7.6 seconds on my notebook for 1 million simulations
unique(res) #958 unique results (10 mio simulations)

@time res2,bpv = simulategames_with_positions(10_000_000); # 253 seconds on my notebook
length(unique(bpv)) #5477 possible board positions in total
```
