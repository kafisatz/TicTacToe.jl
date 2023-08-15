# TicTacToe

Convention Player1 begins


Currently this script results in 958 possible (SIMULATED!) ending board positions
```
@time res = simulategames(1_000_000) #7.6 seconds on my notebook for 1 million simulations
unique(res) #958 unique results (10 mio simulations)
```
