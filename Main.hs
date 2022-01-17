module Main where 
import Types
import Data.Array
import Utils

main::IO()
main= do
    let x = array ((0,0),(5,5)) [((i,j), Empty ) | 
                            i <- [0..5], 
                            j <- [0..5]]
    let x1 = put x (0,0) Child
    let x2 = put x1 (5,5) Robot
    let x22 = put x2 (0, 5) Robot
    let x3 = moveRobots x22
    let x4 = moveRobots x3 
    let x5 = moveRobots x4

    putStr $ toString x3 
    putStr $ toString x4 
    putStr $ toString x5

-- loop::Board->IO()
-- loop board = do 
--     putStr $ toString board ++ "\n"
--     let x = execute board
--     if ended x
--     then putStr $ toString x ++ "\n"
--     else loop x

-- ended x = sum y == 0
--             where 
--                 n = rows x
--                 m = cols x
--                 y = [1 | i <- [0..n], j <- [0..m],
--                         x!(i,j) == Child False || 
--                         x!(i,j) == Muck ||
--                         x!(i,j) == ChildRobot False]

moveRobots::Board->Board
moveRobots b = foldl moveRobot b r
    where 
        n = rows b
        m = cols b
        r = [(i,j) | i <- [0..n], j <- [0..m], 
                b!(i,j) == Robot || b!(i,j) == ChildRobot]

moveRobot::Board->Pos->Board
moveRobot b p = moveto b p $ head $ buildPath m p $ fun b m p
    where 
        m = distanceMatrix b p 
        fun = case b!p of
                Robot      -> nearestChild
                ChildRobot -> nearestHouse





