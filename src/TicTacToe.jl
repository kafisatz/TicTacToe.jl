module TicTacToe

using StaticArrays
#convention Player1 begins
# Write your package code here.

export boardisvalid
function boardisvalid(board)
    uq = unique(board)
    iv = issubset(uq,[0,1,2])
    if !iv
        return iv 
    end

    n1 = sum(board.==1)
    n2 = sum(board.==2)
    #@show n1, n2
    iv = n1>=n2
    if !iv
        return iv 
    end
    iv = n1-n2<=1
    if !iv
        return iv 
    end

    return true,n1,n2
end

export boardisfull
function boardisfull(board)
    #iv,n1,n2 = boardisvalid(board)
    #@assert iv
    #return n1 + n2 == 9
    nzeros = sum(board.==0)
    isfull = nzeros == 0
    return isfull,nzeros 
end

export boardiswon
function boardiswon(board)
    #iv,n1,n2 = boardisvalid(board)
    #n = n1 + n2 
    n = sum(board.!=0)
    if n<4
        return false,0
    end

    iswon = false
    for p in [1,2] 
        w = board .== p
        #rows
        iswon = any(map(i->sum(view(w,i,:)),1:3) .== 3)
        if iswon
            return iswon,p
        end

        #columns
        iswon = any(map(i->sum(view(w,:,i)),1:3) .== 3)
        if iswon
            return iswon,p
        end

        #diagonal
        iswon = (w[1,1] && w[2,2] && w[3,3]) || (w[1,3] && w[2,2] && w[3,1])
        if iswon
            return iswon,p
        end
    end

    @assert !iswon
    return iswon,0
end

export playrandom!
function playrandom!(board)
    iv,n1,n2 = boardisvalid(board)
    isfull,nzeros = boardisfull(board)
    @assert !isfull
    zrs = findall(board.==0)
    #here zrs must have length >0, as !isfull
    pick = rand(zrs)
    if n2 == n1
        #player 1 plays
        board[pick] = 1
    else
        #player 2 plays
        board[pick] = 2
    end 

    isfull,nzeros_new = boardisfull(board)
    @assert nzeros_new == nzeros - 1
    return isfull
end

export newboard
function newboard()
    board = @MArray zeros(Int,3,3)
    return board 
end

export playuntilfinished!
function playuntilfinished!(board)
    iswon,isdraw,winningplayer = evaluateboard(board)
    isfinished = iswon || isdraw

    while !isfinished
        playrandom!(board)
        iswon,isdraw,winningplayer = evaluateboard(board)
        isfinished = iswon || isdraw
    end
    @assert isfinished
    return iswon,isdraw,winningplayer
end


export playuntilfinished_with_board_position!
function playuntilfinished_with_board_position!(board)
    iswon,isdraw,winningplayer = evaluateboard(board)
    isfinished = iswon || isdraw

    boardposvector = Vector{MMatrix{3, 3, Int64, 9}}(undef,0)
    while !isfinished
        playrandom!(board)
        iswon,isdraw,winningplayer = evaluateboard(board)
        push!(boardposvector,deepcopy(board))
        isfinished = iswon || isdraw
    end
    @assert isfinished
    return boardposvector,iswon,isdraw,winningplayer
end


export evaluateboard
function evaluateboard(board)
    isdraw = false
    iswon,winningplayer = boardiswon(board)
    if iswon 
        return iswon,isdraw,winningplayer
    end
    isfull,nzeros = boardisfull(board)
    if isfull 
        isdraw = true 
        return iswon,isdraw,winningplayer
    end
    return iswon,isdraw,winningplayer
end

export simulategame
function simulategame() 
    board = newboard() 
    iswon,isdraw,winningplayer = playuntilfinished!(board)
    return board,iswon,isdraw,winningplayer
end

export simulategame_with_positions
function simulategame_with_positions() 
    board = newboard()
    boardposv,iswon,isdraw,winningplayer = playuntilfinished_with_board_position!(board)
    return boardposv,iswon,isdraw,winningplayer
end


export simulategames
function simulategames(n::Int)
    res = Vector{MMatrix{3, 3, Int64, 9}}(undef,n)
    for i=1:n
        board,iswon,isdraw,winningplayer = simulategame()
        res[i] = board
    end
return res
end

export simulategames_with_positions
function simulategames_with_positions(n::Int)
    res = Vector{MMatrix{3, 3, Int64, 9}}(undef,n)
    boardposvector0 = Vector{MMatrix{3, 3, Int64, 9}}(undef,0)
    for i=1:n
        boardposv,iswon,isdraw,winningplayer = simulategame_with_positions()
        append!(boardposvector0,boardposv)
        res[i] = deepcopy(boardposv[end])
    end
    boardposvector = unique(boardposvector0)
return res,boardposvector
end

export number_of_winning_lines
function number_of_winning_lines(board)
r1wins = (board[1,1]!=0 && board[1,2]==board[1,3] && board[1,2]==board[1,1])
r2wins = (board[2,1]!=0 && board[2,2]==board[2,3] && board[2,2]==board[3,1])
r3wins = (board[3,1]!=0 && board[3,2]==board[3,3] && board[3,2]==board[3,1])

c1wins = (board[1,1]!=0 && board[2,1]==board[3,1] && board[2,1]==board[1,1])
c2wins = (board[1,2]!=0 && board[2,2]==board[3,2] && board[2,2]==board[1,2])
c3wins = (board[1,3]!=0 && board[2,3]==board[3,3] && board[2,3]==board[1,3])

d1wins = (board[1,1]!=0 && board[2,2]==board[3,3] && board[2,2]==board[1,1])
d2wins = (board[2,2]!=0 && board[3,1]==board[1,3] && board[2,2]==board[1,3])

ss =r1wins+r2wins+r3wins  + c1wins + c2wins + c3wins + d1wins + d2wins
#@assert ss <= 1
#@assert ss >= 0 

return ss 
end 

export exhaustiveboardpositions 
function exhaustiveboardpositions()

    board = newboard()

    cnt = 0 
    iswoncnt = 0
    ivcnt = 0 
    player1haswoncnt = 0
    player2haswoncnt = 0

        vals = [0,1,2]
        for pos1 in vals 
            for pos2 in vals 
                for pos3 in vals 
                    for pos4 in vals 
                        for pos5 in vals 
                            for pos6 in vals 
                                for pos7 in vals 
                                    for pos8 in vals 
                                        for pos9 in vals 
                                            board[1,1] = pos1
                                            board[1,2] = pos2
                                            board[1,3] = pos3
                                            board[2,1] = pos4
                                            board[2,2] = pos5
                                            board[2,3] = pos6
                                            board[3,1] = pos7
                                            board[3,2] = pos8
                                            board[3,3] = pos9
                                            
                                            cnt += 1
                                            nwinlines = number_of_winning_lines(board)
                                            ivtmp = boardisvalid(board)[1]
                                            if ivtmp && (nwinlines <=1)
                                                ivcnt += 1
                                            end
                                            iw,p = boardiswon(board)
                                            error("something is still off")
                                            if iw
                                                @assert nwinlines >= 1
                                            end
                                            if (nwinlines <=1)
                                                iswoncnt += iw 
                                                player1haswoncnt += (iw && p==1)
                                                player2haswoncnt += (iw && p==2)    
                                            end
                                        end 
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end 

        return cnt,iswoncnt,ivcnt,player1haswoncnt,player2haswoncnt
end


end #end module
