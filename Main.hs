module Main where 

import Types
import Init
import ChildMovements
import Data.Array

main::IO()
main= do
    a <- initBoard
    loop a

loop::Board->IO()
loop board = do 
    putStr $ toString board ++ "\n"
    x <- moveChilds board
    loop x
    -- if ended x
    -- then putStr $ toString x ++ "\n"
    -- else loop x

ended::Board->Bool
ended x = sum y == 0
            where 
                n = rows x
                m = cols x
                y = [1 | i <- [0..n], j <- [0..m],
                        x!(i,j) == Child|| 
                        x!(i,j) == Muck ||
                        x!(i,j) == ChildRobot]





