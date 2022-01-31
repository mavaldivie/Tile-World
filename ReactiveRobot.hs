module ReactiveRobot where 

import Types
import Utils
import Moves
import Data.Array
import Distances

moveReactiveRobot::Board->Pos->Board
moveReactiveRobot b p = if target == (-1, -1) then b
                else case b!e of  
                    Empty -> moveTo b p e 
                    Muck  -> put (clean b p) e MuckReactiveRobot
                    Child -> put (clean b p) e ChildReactiveRobot 
                where 
                    lim = limits b 
                    m = distanceMatrix b p [Empty, Muck, Child]
                    child = if pathExists (put b p Empty) (snd x) /= oo
                            then x
                            else (oo, (-1,-1))
                            where x = nearestChild b m
                    muck = nearestMuck b m
                    target = snd $ min child muck
                    e:_ =  buildPath m p target

moveChildReactiveRobot::Board->Pos->Board
moveChildReactiveRobot b p = if target /= (-1, -1) 
                then case b!e of 
                    Empty -> moveTo b p e 
                    House -> put (put b p ReactiveRobot) h ChildHouse
                else case b!x of 
                    Muck        -> put (put b p Child) x MuckReactiveRobot
                    Empty       -> put (put b p Child) x ReactiveRobot
                    Child       -> put (put b p Child) x ChildReactiveRobot
                    _           -> b
                where 
                    lim = limits b 
                    m = distanceMatrix b p [Empty,House]
                    target = snd $ nearestHouse b m 
                    path = buildPath m p target
                    e = if length path == 1 || b!(path !! 1) == House
                        then g 
                        else path !! 1
                        where g:_ = path
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

        
moveMuckReactiveRobot::Board->Pos->Board
moveMuckReactiveRobot b p = put b p ReactiveRobot