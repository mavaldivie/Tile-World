module Utils where 

dx = [0, 1, 0, -1]
dy = [1, 0, -1, 0]

insideBoard::Pos->(Int,Int)->Bool
insideBoard (x,y) (n,m) = 0 <= x && x <= n && 0 <= y && y <= m

type Pos = (Int,Int)

data Mov = L | R | U | D  deriving (Show, Eq)
move :: Pos -> Mov -> Pos
move (x,y) U = (x-1,y)
move (x,y) D = (x+1,y)
move (x,y) R = (x,y+1)
move (x,y) L = (x,y-1)

moves = [L, R, U, D]

adjacents::Pos->(Int,Int)->[Pos]
adjacents x y = filter (`insideBoard` y) $ map (move x) moves

around (f,s) y = filter (`insideBoard` y) [(f-1,s-1),(f-1,s+1),(f+1,s-1),(f+1,s+1)] 
                    ++ adjacents (f,s) y

oo::Int
oo = 99

del::[a]->Int->[a]
del a i = take i a ++ drop (i+1) a