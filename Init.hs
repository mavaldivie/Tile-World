module Init where 
import Configuration
import Random
import Types
import Data.Array

validateBoard::Bool 
validateBoard = house >= childs &&
                sum [house, reactiveRobots, stateRobots, childs, obstacles] <= board 
                where 
                    house = houseRows * houseColumns
                    board = boardRows * boardColumns
                    
initBoard::IO Board
initBoard =
    if not validateBoard
    then do
        putStr "Invalid configuration constraints\n"
        return $ new 1 1 Empty
    else do
        let empty x = [(i,j) | i <- [0..boardRows-1], 
                            j <- [0..boardColumns-1], 
                            x!(i,j)==Empty]
            a = new (boardRows-1) (boardColumns-1) Empty
            b = a // [((i,j),House) | i <- [0..houseRows-1], 
                                    j <- [0..houseColumns-1]]
        c <- randomSelect (empty b) childs
        let d = b // [(p,Child) | p <- c]
        e <- randomSelect (empty d) reactiveRobots
        let f = d // [(p,ReactiveRobot) | p <- e]
        g <- randomSelect (empty f) obstacles
        let h = f // [(p,Obstacle) | p <- g]
        i <- randomSelect (empty f) stateRobots
        let j = h // [(p,StateRobot ((-1,-1),Empty)) | p <- i]
        return j

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