module Utils where 

dx = [0, 1, 0, -1]
dy = [1, 0, -1, 0]

insideBoard::Pos->(Int,Int)->Bool
insideBoard (x,y) (n,m) = 0 <= x && x < n && 0 <= y && y < m

type Pos = (Int,Int)

data Mov = L | R | U | D  
move :: Pos -> Mov -> Pos
move (x,y) L = (x-1,y)
move (x,y) R = (x+1,y)
move (x,y) U = (x,y+1)
move (x,y) D = (x,y-1)

moves = [L, R, U, D]

adjacents::Pos->(Int,Int)->[Pos]
adjacents x y = [p | p <- map (move x) moves, insideBoard p y]
                            
