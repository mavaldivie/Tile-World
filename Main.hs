module Main where 

import Types
import Init
import ChildMovements
import RobotMovements
import Data.Array
import Utils
import Configuration

main::IO()
main= do
    a <- initBoard
    loop a 0 shuffleInterval 0

loop::Board->Int->Int->Int->IO()
loop board mx s step = do 
    putStr $ toString board
    let x = moveRobots board s    
    putStr $ toString x
    y <- moveChilds x

    let (n,m) = limits y
        empty = length $ filter (\t -> y!t == Empty) [(i,j) | 
                    i <- [0..n], j <- [0..m]]
        muck = length $ filter (\t -> y!t == Muck) [(i,j) | 
                    i <- [0..n], j <- [0..m]]
        percent = muck * 100 `div` (empty + muck)
        nmx = max mx percent
    
    putStr $ replicate (2 * boardColumns) '-' ++ "\n"
    putStr $ "Muck percent: " ++ show percent ++ "%\n"
    putStr $ replicate (2 * boardColumns) '-' ++ "\n\n"

    if y == board && not (childMove y)
    then do
        putStr $ "Childs: " ++ show childs ++ "\n"
        putStr $ "Reactive Robots: " ++ show reactiveRobots ++ "\n"
        putStr $ "State Robots: " ++ show stateRobots ++ "\n"
        putStr $ "Obstacles: " ++ show obstacles ++ "\n"
        putStr $ "Shuffle Interval: " ++ show shuffleInterval ++ "\n"
        putStr $ "Board: " ++ show boardRows ++ " x " ++ show boardColumns ++ "\n"
        putStr $ "Steps: " ++ show step ++ "\n"
        putStr $ "Max muck percent: " ++ show nmx ++ "%\n" ++ "Finished\n"
    else if s == 0
        then do
            putStr "Random Shuffle\n\n"
            z <- shuffle y
            loop z nmx shuffleInterval (step + 1)
        else loop y nmx (s - 1) (step + 1)

childMove::Board->Bool
childMove b = any canMove childs
    where 
        (n,m) = limits b
        childs = filter (\t -> b!t == Child) [(i,j) | 
                    i <- [0..n], j <- [0..m]]
        valid p d = first b (move p d) d /= (-1,-1)
        canMove t = any (valid t) moves





