module RobotMovements where 

import Types
import Utils
import Moves
import Data.Array

distanceMatrix::Board->Pos->[Cell]->Matrix Int
distanceMatrix b p = distanceMatrixBFS b x [p]
                        where 
                            n = rows b
                            m = cols b
                            y = new n m oo
                            x = y // [(p,0)]

distanceMatrixBFS::Board->Matrix Int->[Pos]->[Cell]->Matrix Int
distanceMatrixBFS b mat [] _ = mat 
distanceMatrixBFS b mat (x:xs) available = --trace (toString mat ++ show x) 
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
                n = rows b 
                m = cols b
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

moveRobots::Board->Board
moveRobots b = foldl individual b r
    where 
        n = rows b
        m = cols b
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
                    target = snd $ min (nearestChild b m) (nearestMuck b m)
                    e = head $ buildPath m p target

moveChildRobot::Board->Pos->Board
moveChildRobot b p = if target == (-1, -1) then b
                else case b!e of 
                    Empty -> moveTo b p e 
                    House -> put b p Robot
                where 
                    lim = limits b 
                    m = distanceMatrix b p [Empty,House]
                    target = snd $ nearestHouse b m 
                    e = head $ buildPath m p target
        
moveMuckRobot::Board->Pos->Board
moveMuckRobot b p = put b p Robot