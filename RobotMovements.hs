module RobotMovements where 

import Types
import Utils
import Moves
import Data.Array

distanceMatrix::Board->Pos->[Cell]->Matrix Int
distanceMatrix b p = distanceMatrixBFS b x [p]
                        where 
                            (n,m) = limits b
                            y = new n m oo
                            x = y // [(p,0)]

distanceMatrixBFS::Board->Matrix Int->[Pos]->[Cell]->Matrix Int
distanceMatrixBFS b mat [] _ = mat 
distanceMatrixBFS b mat (x:xs) available =
                distanceMatrixBFS b newm newx available
                    where 
                    c = b!x
                    lim = limits b
                    neighbors = filter (\p -> b!p `elem` available) 
                            $ adjacents x lim
                    adj = filter (\p -> mat!p == oo) neighbors
                    newv = mat!x + 1
                    newm = mat // [(p, newv) | p <- adj]
                    newx = xs ++ adj 

nearest::Cell->Board->Matrix Int->(Int,Pos)
nearest c b mat = if null list then (oo,(-1,-1)) else minimum list
            where 
                (n,m) = limits b
                list = [(mat!(i,j), (i,j)) | 
                    i <- [0..n], j <- [0..m],
                    b!(i,j) == c &&
                    mat!(i,j) /= oo]

nearestHouse = nearest House
nearestChild = nearest Child
nearestMuck = nearest Muck

buildPath mat b e = if b == e then []
                    else buildPath mat b newe ++ [e]
                    where 
                        l = limits mat
                        adj = adjacents e l 
                        cur = mat!e
                        newe = head $ filter (\x -> mat!x == (cur - 1)) adj

isRobot x = x `notElem` [Obstacle, Muck, House, ChildHouse, Empty, Child]

emptyHouse b = head $ filter (\t -> b!t == House) [(i,j) | 
                    i <- [0..n], j <- [0..m]]
                where (n,m) = limits b

pathExists::Board->Pos->Bool
pathExists b p = p /= (-1,-1) && target /= (-1,-1)
                where
                    m = distanceMatrix b p [Empty,House]
                    target = snd $ nearestHouse b m 

moveRobots::Board->Board
moveRobots b = foldl individual b r
                where 
                    (n,m) = limits b
                    r = [(i,j) | i <- [0..n], j <- [0..m], isRobot (b!(i,j))]

individual::Board->Pos->Board
individual b p = case b!p of
        Robot       -> moveRobot b p
        ChildRobot  -> moveChildRobot b p
        MuckRobot   -> moveMuckRobot b p
        
moveRobot::Board->Pos->Board
moveRobot b p = if target == (-1, -1) then b
                else case b!e of  
                    Empty -> moveTo b p e 
                    Muck  -> put (clean b p) e MuckRobot
                    Child -> put (clean b p) e ChildRobot 
                where 
                    lim = limits b 
                    m = distanceMatrix b p [Empty, Muck, Child]
                    child = if pathExists (put b p Empty) (snd x)
                            then x
                            else (oo, (-1,-1))
                            where x = nearestChild b m
                    muck = nearestMuck b m
                    target = snd $ min child muck
                    e = head $ buildPath m p target

moveChildRobot::Board->Pos->Board
moveChildRobot b p = if target /= (-1, -1) 
                then case b!e of 
                    Empty -> moveTo b p e 
                    House -> put (put b p Robot) h ChildHouse
                else case b!x of 
                    Muck        -> put (put b p Child) x MuckRobot
                    Empty       -> put (put b p Child) x Robot
                    Child       -> put (put b p Child) x ChildRobot
                    _           -> b
                where 
                    lim = limits b 
                    m = distanceMatrix b p [Empty,House]
                    target = snd $ nearestHouse b m 
                    path = buildPath m p target
                    e = if length path == 1 || b!(path !! 1) == House
                        then head path 
                        else path !! 1
                    adj = adjacents p lim 
                    muck = filter (\t -> b!t == Muck) adj
                    empty = filter (\t -> b!t == Empty) adj
                    child = filter (\t -> b!t == Child && 
                                    pathExists (put b p Child) t) adj
                    x | not $ null muck = head muck 
                      | not $ null empty = head empty
                      | not $ null child = head child
                      | otherwise = p
                    h = emptyHouse b

        
moveMuckRobot::Board->Pos->Board
moveMuckRobot b p = put b p Robot