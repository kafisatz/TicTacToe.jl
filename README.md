# TicTacToe

## Background 
Inspired by an ELI5 question I wrote this small module. See https://www.reddit.com/r/explainlikeimfive/comments/15rlp9e/eli5_how_many_total_combinations_are_there_in_tic/?utm_source=share&utm_medium=web2x&context=3

## Notes
* Convention is that Player 1 begins the game

## Results
Possible states, exhaustive search:
```
@time  resdf,cnt,iswoncnt,valid_position_count,player1haswoncnt,player2haswoncnt,isdrawcnt = exhaustiveboardpositions();
resdf[!,:is_won_and_reachable] = map(x->x.is_won && x.is_reachable,eachrow(resdf))
resdf[!,:is_draw_and_reachable] = map(x->x.is_draw && x.is_reachable,eachrow(resdf))
@show is_reachable_and_won = sum(resdf.is_won_and_reachable) #1884
@show valid_position_count,is_reachable_and_won #8533, 1884
@show cnt,iswoncnt,valid_position_count,player1haswoncnt,player2haswoncnt,isdrawcnt
@assert cnt == 3^9 

resdf[!,:hash] = map(x->hash(x),eachrow(select(resdf,[:x1,:x2,:x3,:x4,:x5,:x6,:x7,:x8,:x9])))
player1haswoncnt + player2haswoncnt
CSV.write(raw"C:\temp\resdf.csv",resdf)
```

## Simulation based results

```
@time res = simulategames(1_000_000) #7.6 seconds on my notebook for 1 million simulations
unique(res) #958 unique ending board positions (10 mio simulations) for one player to start
#@time bpv = simulategames_with_positions(10_000_000);
@time bpv = simulategames_with_positions(1_000_000);
length(unique(bpv)) #5478 possible board positions in total (player 1 beginning!)
simresdf0 = mapreduce(x->boarddf(x),vcat,bpv)
mr = mirrorpositions(simresdf0)
simresdf = vcat(simresdf0,mr)
unique!(simresdf) #8533 uniqe possibilities

@assert size(simresdf,1) == valid_position_count #simuluation approach agrees with exhaustive search
```
