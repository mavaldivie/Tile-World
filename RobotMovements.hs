module RobotMovements where 

import Types
import Utils
import Moves
import Data.Array
import ReactiveRobot
import StateRobot

isRobot::Cell->Bool
isRobot x = x `notElem` [Obstacle, Muck, House, ChildHouse, Empty, Child]

moveRobots::Board->Int->Board
moveRobots b s = foldl (\x y -> individual x y s) b r 
                where 
                    (n,m) = limits b
                    r = [(i,j) | i <- [0..n], j <- [0..m], isRobot (b!(i,j))]

individual::Board->Pos->Int->Board
individual b p s = case b!p of
        ReactiveRobot       -> moveReactiveRobot b p
        ChildReactiveRobot  -> moveChildReactiveRobot b p
        MuckReactiveRobot   -> moveMuckReactiveRobot b p
        StateRobot _        -> moveStateRobot b p s
        ChildStateRobot     -> moveChildStateRobot b p s
        MuckStateRobot _    -> moveMuckStateRobot b p s