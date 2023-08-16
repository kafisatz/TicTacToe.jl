# TicTacToe

## Background 
Inspired by an ELI5 question I wrote this small module. See https://www.reddit.com/r/explainlikeimfive/comments/15rlp9e/eli5_how_many_total_combinations_are_there_in_tic/?utm_source=share&utm_medium=web2x&context=3

## Notes
* Convention is that Player 1 begins the game

## Results
Possible states, exhaustive search:
```
@time  resdf,cnt,iswoncnt,valid_position_count,player1haswoncnt,player2haswoncnt,isdrawcnt = exhaustiveboardpositions();
resdf
@show cnt,iswoncnt,valid_position_count,player1haswoncnt,player2haswoncnt,isdrawcnt
resdf[!,:is_won_and_reachable] = map(x->x.is_won && x.is_reachable,eachrow(resdf))
resdf[!,:is_draw_and_reachable] = map(x->x.is_draw && x.is_reachable,eachrow(resdf))
@show is_reachable_and_won = sum(resdf.is_won_and_reachable) #1332 (verus 'Positions where someone wins: 1794' in the blog post)
@show valid_position_count,is_reachable_and_won
```

## Simulation based results
Currently this script results in 958 possible (SIMULATED!) ending board positions, assuming Player 1 always starts the game
```
@time res = simulategames(1_000_000) #7.6 seconds on my notebook for 1 million simulations
unique(res) #958 unique results (10 mio simulations)

@time bpv = simulategames_with_positions(10_000_000); # 253 seconds on my notebook
length(unique(bpv)) #5477 possible board positions in total
```
