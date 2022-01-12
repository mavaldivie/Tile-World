module Main where 
import Types
import Data.Array

main::IO()
main= do
    let x = array ((0,0),(5,5)) [((i,j), Empty ) | 
                            i <- [0..5], 
                            j <- [0..5]]
    loop x

loop::Board->IO()
loop board = do 
    putStr $ toString board ++ "\n"
    let x = execute board
    if ended x
    then putStr $ toString x ++ "\n"
    else loop x

ended x = sum y == 0
            where 
                n = rows x
                m = cols x
                y = [1 | i <- [0..n], j <- [0..m],
                        x!(i,j) == Child False || 
                        x!(i,j) == Muck ||
                        x!(i,j) == ChildRobot False]


