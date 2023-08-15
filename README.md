# TicTacToe

## Background 
Inspired by an ELI5 question I wrote this small module. See https://www.reddit.com/r/explainlikeimfive/comments/15rlp9e/eli5_how_many_total_combinations_are_there_in_tic/?utm_source=share&utm_medium=web2x&context=3

## Notes
* Convention is that Player 1 begins the game

## Results
Possible states, exhaustive search:
```

julia> @time cnt,iswoncnt,isvalidcount,player1haswoncnt,player2haswoncnt = exhaustiveboardpositions()
  0.022254 seconds (377.36 k allocations: 24.655 MiB, 39.05% gc time)
(19683, 6220, 5868, 3110, 3110)

julia> @show cnt,iswoncnt,isvalidcount,player1haswoncnt,player2haswoncnt
(cnt, iswoncnt, isvalidcount, player1haswoncnt, player2haswoncnt) = (19683, 6220, 5868, 3110, 3110)
(19683, 6220, 5868, 3110, 3110)

julia> player1haswoncnt + player2haswoncnt
6220
```

## Simulation based results
Currently this script results in 958 possible (SIMULATED!) ending board positions
```
@time res = simulategames(1_000_000) #7.6 seconds on my notebook for 1 million simulations
unique(res) #958 unique results (10 mio simulations)

@time res2,bpv = simulategames_with_positions(10_000_000); # 253 seconds on my notebook
length(unique(bpv)) #5477 possible board positions in total
```
