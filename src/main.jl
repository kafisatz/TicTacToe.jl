using Revise
using TicTacToe
using StaticArrays
using BenchmarkTools
using CSV

@time  resdf,cnt,iswoncnt,valid_position_count,player1haswoncnt,player2haswoncnt,isdrawcnt = exhaustiveboardpositions();
resdf
@show cnt,iswoncnt,valid_position_count,player1haswoncnt,player2haswoncnt,isdrawcnt
resdf[!,:is_won_and_reachable] = map(x->x.is_won && x.is_reachable,eachrow(resdf))
resdf[!,:is_draw_and_reachable] = map(x->x.is_draw && x.is_reachable,eachrow(resdf))
@show is_reachable_and_won = sum(resdf.is_won_and_reachable) #1332 (verus 'Positions where someone wins: 1794' in the blog post)
@show valid_position_count,is_reachable_and_won

player1haswoncnt + player2haswoncnt
CSV.write(raw"C:\temp\resdf.csv",resdf)

board = @MArray zeros(Int,3,3)
board[1,2] = 1
board[2,2] = 1
board[3,3] = 2
board[1,1] = 1
board[2,1] = 2

@assert boardisvalid(board)[1]
@assert !(boardiswon(board)[1])
boardisfull(board)

playrandom!(board)
boardiswon(board)

playuntilfinished!(board)
board

#simulate single game
@time board,iswon,isdraw,winningplayer = simulategame(); board

simulategame()

@time res = simulategames(1_000_000) #7.6 seconds on my notebook for 1 million simulations
unique(res) #958 unique ending board positions (10 mio simulations)

@time res2,bpv = simulategames_with_positions(10_000_000);
length(unique(bpv)) #5477 possible board positions in total

