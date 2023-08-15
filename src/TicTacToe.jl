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

export simulategames
function simulategames(n::Int)
    res = Vector{MMatrix{3, 3, Int64, 9}}(undef,n)
    for i=1:n
        board,iswon,isdraw,winningplayer = simulategame()
        res[i] = board
    end
return res
end

end #end module
