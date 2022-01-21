module Main where 

import Types
import Init
import ChildMovements
import RobotMovements
import Data.Array

main::IO()
main= do
    a <- initBoard
    loop a

loop::Board->IO()
loop board = do 
    putStr $ toString board
    let x = moveRobots board
    putStr $ toString x
    y <- moveChilds x

    if ended y
    then putStr $ toString y
    else loop y

ended::Board->Bool
ended x = sum y == 0
            where 
                n = rows x
                m = cols x
                fun p = x!p
                y = [1 | i <- [0..n], j <- [0..m],
                        fun (i,j) == Child || 
                        fun (i,j) == Muck ||
                        fun (i,j) == ChildRobot ||
                        fun (i,j) == MuckRobot]





