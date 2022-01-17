module Testing where 
import Types
import Utils
import Data.Array

main::IO()
main= print n
    where
        x = new 5 5 Empty
        y1 = x // [((1,1),Obstacle)]
        y2 = y1 // [((1,3),Obstacle)]
        y3 = y2 // [((0,0),Obstacle)]
        y4 = y3 // [((3,2),Obstacle)]
        m = distanceMatrix x (2,2)
        n = buildPath m (2,2) (5,5)