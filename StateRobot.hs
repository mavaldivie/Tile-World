module StateRobot where 

import Types
import Utils
import Moves
import Data.Array
import Distances 

moveStateRobot::Board->Pos->Int->Board
moveStateRobot b p s = if target == (-1, -1) || e == (-1,-1) then b
                    else case b!e of  
                        Empty -> put (clean b p) e (StateRobot (target, b!target))
                        Muck  -> put (clean b p) e (MuckStateRobot (target, b!target))
                        Child -> put (clean b p) e ChildStateRobot
                    where 
                        StateRobot (x,y) = b!p
                        lim = limits b 
                        tmp = filter (\f -> b!f==y) $ x : adjacents x lim

                        m = distanceMatrix b p [Empty, Muck, Child]
                        child = if fst x /= oo && l + m!snd x - m!p < s
                                then x
                                else (oo, (-1,-1))
                                where 
                                    x = nearestChild b m
                                    l = pathExists (put b p Empty) (snd x)
                        muck = nearestMuck b m 

                        target = if x == (-1,-1) || null tmp
                                then snd $ min child muck
                                else g
                                where g:_ = tmp 

                        n = distanceMatrix b p [Empty, Muck]

                        e:_ | not (insideBoard target lim) = [(-1,-1)]
                            | x /= (-1,-1) && n!target /= oo = buildPath n p target
                            | m!target /= oo = buildPath m p target
                            | otherwise = [(-1,-1)]

moveChildStateRobot::Board->Pos->Int->Board
moveChildStateRobot b p s = if target /= (-1, -1) 
                then case b!e of 
                    Empty -> moveTo b p e 
                    House -> put (put b p (StateRobot ((-1,-1),Empty))) h ChildHouse
                else case b!x of 
                    Muck        -> put (put b p Child) x (MuckStateRobot (x,Muck))
                    Empty       -> put (put b p Child) x (StateRobot ((-1,-1),Empty))
                    Child       -> put (put b p Child) x ChildStateRobot
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
                                    pathExists (put b p Child) t /= oo) adj
                    x:_ | not $ null muck = muck 
                        | not $ null empty = empty
                        | not $ null child = child
                        | otherwise = [p]
                    h = emptyHouse b

        
moveMuckStateRobot::Board->Pos->Int->Board
moveMuckStateRobot b p s = if x == p 
                        then put b p (StateRobot ((-1,-1),Empty))
                        else put b p (StateRobot (x,y))
                        where MuckStateRobot (x, y) = b!p