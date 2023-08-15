using TicTacToe
using Test
using StaticArrays

@testset "TicTacToe.jl" begin
    # Write your tests here.

    board = @MArray zeros(Int,3,3)
    board[1,2] = 1
    board[2,2] = 1
    board[3,3] = 2
    board[1,1] = 1
    board[2,1] = 2

    @test boardisvalid(board)[1]
    @test !boardiswon(board)[1]

    board=newboard()
    @test boardisvalid(board)[1]
    @test !boardiswon(board)[1]

    #invalid board
    board = @MArray zeros(Int,3,3)
    board[1,2] = 1
    board[2,2] = 1
    @test !boardisvalid(board)[1]

    #invalid board
    board = @MArray zeros(Int,3,3)
    board[1,2] = 2
    board[2,2] = 2
    @test !boardisvalid(board)[1]

    wincount = 0 
    nnn = 1000_000
    for i=1:nnn   
        board = newboard()
        playrandom!(board)
        @test sum(board.==1)==1
        @test sum(board.==2)==0
        @test sum(board.==0)==8
        @test boardisvalid(board)[1]
        @test !boardisfull(board)[1]
        
        playrandom!(board)
        @test sum(board.==1)==1
        @test sum(board.==2)==1
        @test sum(board.==0)==7
        @test boardisvalid(board)[1]
        @test !boardiswon(board)[1]
        @test !boardisfull(board)[1]

        playrandom!(board)
        @test sum(board.==1)==2
        @test sum(board.==2)==1
        @test sum(board.==0)==6
        @test boardisvalid(board)[1]
        @test !boardiswon(board)[1]
        @test !boardisfull(board)[1]

        playrandom!(board)
        @test sum(board.==1)==2
        @test sum(board.==2)==2
        @test sum(board.==0)==5
        @test boardisvalid(board)[1]
        @test !boardiswon(board)[1]
        @test !boardisfull(board)[1]

        playrandom!(board)
        @test sum(board.==1)==3
        @test sum(board.==2)==2
        @test sum(board.==0)==4
        @test boardisvalid(board)[1]
        wincount += boardiswon(board)[1]
        @test !boardisfull(board)[1]

        iswon,isdraw,winningplayer = evaluateboard(board)
        @test !isdraw
        playuntilfinished!(board)
        iswon,isdraw,winningplayer = evaluateboard(board)
        @test iswon || isdraw
    end
    #@show wincount/nnn

end
