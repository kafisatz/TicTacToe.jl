using Revise
using TicTacToe
using StaticArrays
using BenchmarkTools

board = @MArray zeros(Int,3,3)
board[1,2] = 1
board[2,2] = 1
board[3,3] = 2
board[1,1] = 1
board[2,1] = 2

@time cnt,iswoncnt,isvalidcount,player1haswoncnt,player2haswoncnt = exhaustiveboardpositions()
player1haswoncnt + player2haswoncnt

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

