using Revise
using TicTacToe
using DataFrames 
using StaticArrays
using BenchmarkTools
using CSV

############################################
#exhaustive search 
############################################

@time  resdf,cnt,iswoncnt,valid_position_count,player1haswoncnt,player2haswoncnt,isdrawcnt = exhaustiveboardpositions();
resdf
@show cnt,iswoncnt,valid_position_count,player1haswoncnt,player2haswoncnt,isdrawcnt
resdf[!,:is_won_and_reachable] = map(x->x.is_won && x.is_reachable,eachrow(resdf))
resdf[!,:is_draw_and_reachable] = map(x->x.is_draw && x.is_reachable,eachrow(resdf))
@show is_reachable_and_won = sum(resdf.is_won_and_reachable) #2076 (versus 'Positions where someone wins: 1794' in the blog post)
@show valid_position_count,is_reachable_and_won

resdf[!,:hash] = map(x->hash(x),eachrow(select(resdf,[:x1,:x2,:x3,:x4,:x5,:x6,:x7,:x8,:x9])))

player1haswoncnt + player2haswoncnt
CSV.write(raw"C:\temp\resdf.csv",resdf)

############################################
#simulation approach 
############################################

@time res = simulategames(1_000_000) #7.6 seconds on my notebook for 1 million simulations
unique(res) #958 unique ending board positions (10 mio simulations)

@time res2,bpv = simulategames_with_positions(10_000_000);
@time res2,bpv = simulategames_with_positions(1_000_000);
length(unique(bpv)) #5478 possible board positions in total (player 1 beginning!)
simresdf0 = mapreduce(x->boarddf(x),vcat,bpv)
mr = mirrorpositions(simresdf0)
simresdf = vcat(simresdf0,mr)
unique!(simresdf)

CSV.write(raw"C:\temp\simresdf.csv",simresdf)

############################################
#compare
############################################
es = filter(x->x.is_reachable,resdf)
select!(es,[:x1,:x2,:x3,:x4,:x5,:x6,:x7,:x8,:x9])
sort!(es)

sort!(simresdf)
es
simresdf

es2 = deepcopy(es)
simresdf2 = deepcopy(simresdf)
es2[!,:hash] = map(x->hash(x),eachrow(es))
simresdf2[!,:hash] = map(x->hash(x),eachrow(simresdf))

diff1 = setdiff(es2.hash,simresdf2.hash)
diff2 = setdiff(simresdf2.hash,es2.hash)
@assert length(diff2) == 0
diff2

interesting_positions1 = filter(x->in(x.hash,diff1),es2)
interesting_positions2 = filter(x->in(x.hash,diff2),simresdf2)

CSV.write(raw"C:\temp\interesting_positions1.csv",interesting_positions1)
CSV.write(raw"C:\temp\interesting_positions2.csv",interesting_positions2)

#invert 1 and two
ip1 = Matrix(interesting_positions1[:,1:end-1])
ip1[ip1.==2] .= 3
ip1[ip1.==1] .= 2
ip1[ip1.==3] .= 1

ip1_players_inverted = DataFrame(ip1,:auto)
ip1_players_inverted2 = deepcopy(ip1_players_inverted)
ip1_players_inverted2[!,:hash] = map(x->hash(x),eachrow(ip1_players_inverted2))

diffa = setdiff(ip1_players_inverted2.hash,simresdf2.hash)
error("continue here")
interesting_positions1 = filter(x->in(x.hash,diff1),es2)

boardv = interesting_positions1[1,1:end-1]
hash(boardv[1:end-1])
fillboard!(board,boardv) ;board

boardv = interesting_positions2[1,1:end-1]
fillboard!(board,boardv) ;board

error("simulation does not reach all possibilities!")
board


############################################
#other stuff 
############################################

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


board = @MArray zeros(Int,3,3)
board[1,2] = 1
board[1,3] = 2
board[2,2] = 2
board[2,3] = 1
board[3,1] = 2
board[3,2] = 1