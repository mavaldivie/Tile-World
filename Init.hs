module Init where 
import Configuration
import Random
import Types
import Data.Array

validateBoard::Bool 
validateBoard = house >= childs &&
                sum [house, robots, childs, obstacles] <= board 
                where 
                    house = houseRows * houseColumns
                    board = boardRows * boardColumns
                    
initBoard::IO Board
initBoard = do
    let empty x = [(i,j) | i <- [0..boardRows-1], 
                           j <- [0..boardColumns-1], 
                           x!(i,j)==Empty]
    let a = new (boardRows-1) (boardColumns-1) Empty
    let b = a // [((i,j),House) | i <- [0..houseRows-1], 
                                  j <- [0..houseColumns-1]]
    c <- randomSelect (empty b) childs
    let d = b // [(p,Child) | p <- c]
    e <- randomSelect (empty d) robots
    let f = d // [(p,Robot) | p <- e]
    g <- randomSelect (empty f) obstacles
    let h = f // [(p,Obstacle) | p <- g]
    return h

shuffle::Board->IO Board
shuffle board = do
    let a = [(i,j) | i <- [0..boardRows-1], 
                           j <- [0..boardColumns-1], 
                           i >= houseRows || j >= houseColumns]
        (n,m) = limits board
        c = [board!p | p <- a]
    d <- randomSelect a (length c)
    let e = board // zip d c
    return e