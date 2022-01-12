module Testing where 
import Types
import Utils
import Data.Array

main::IO()
main= putStr $ toString y
    where
        x = array ((0,0),(5,5)) [((i,j), Obstacle) | 
                        i <- [0..5], 
                        j <- [0..5]]
        y = x // [((0,0),Empty)]