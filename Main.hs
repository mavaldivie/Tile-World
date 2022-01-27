module Main where 

import Types
import Init
import ChildMovements
import RobotMovements
import Data.Array
import Utils
import Configuration(shuffleInterval)

main::IO()
main= do
    a <- initBoard
    loop a 0 shuffleInterval

loop::Board->Int->Int->IO()
loop board mx s = do 
    putStr $ toString board
    let x = moveRobots board    
    putStr $ toString x
    y <- moveChilds x

    let (n,m) = limits y
        empty = length $ filter (\t -> y!t == Empty) [(i,j) | 
                    i <- [0..n], j <- [0..m]]
        muck = length $ filter (\t -> y!t == Muck) [(i,j) | 
                    i <- [0..n], j <- [0..m]]
        percent = muck * 100 `div` (empty + muck)
        nmx = max mx percent
    putStr $ "Muck percent: " ++ show percent ++ "%\n\n"

    if y == board && not (childMove y)
    then putStr $ "Max muck percent: " ++ show nmx ++ "%\n" ++ "Finished\n"
    else if s == 0
        then do
            putStr "Random Shuffle\n\n"
            z <- shuffle y
            loop z nmx shuffleInterval
        else loop y nmx (s - 1)

childMove::Board->Bool
childMove b = any canMove childs
    where 
        (n,m) = limits b
        childs = filter (\t -> b!t == Child) [(i,j) | 
                    i <- [0..n], j <- [0..m]]
        valid p d = first b (move p d) d /= (-1,-1)
        canMove t = any (valid t) moves





