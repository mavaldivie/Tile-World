module StateRobot where 

import Types
import Utils
import Moves
import Data.Array
import Distances

moveStateRobot::Board->Pos->Board
moveStateRobot b p = if target == (-1, -1) then b
                else case b!e of  
                    Empty -> moveTo b p e 
                    Muck  -> put (clean b p) e MuckStateRobot
                    Child -> put (clean b p) e ChildStateRobot 
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

moveChildStateRobot::Board->Pos->Board
moveChildStateRobot b p = if target /= (-1, -1) 
                then case b!e of 
                    Empty -> moveTo b p e 
                    House -> put (put b p (StateRobot ((0,0),Muck))) h ChildHouse
                else case b!x of 
                    Muck        -> put (put b p Child) x MuckStateRobot
                    Empty       -> put (put b p Child) x (StateRobot ((0,0),Muck))
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
                                    pathExists (put b p Child) t) adj
                    x | not $ null muck = head muck 
                      | not $ null empty = head empty
                      | not $ null child = head child
                      | otherwise = p
                    h = emptyHouse b

        
moveMuckStateRobot::Board->Pos->Board
moveMuckStateRobot b p = put b p (StateRobot ((0,0),Muck))