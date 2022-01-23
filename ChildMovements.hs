module ChildMovements where 

import Utils
import Types
import Random
import Moves
import Data.Array
import Data.Foldable
import Control.Monad

moveChilds::Board->IO Board 
moveChilds b = do
    let n = rows b
    let m = cols b
    let r = [(i,j) | i <- [0..n], j <- [0..m], 
                b!(i,j) == Child]
    foldlM moveChild b r

moveChild::Board->Pos->IO Board
moveChild b p = do 
    r <- rand 5
    if r == 0 then return b 
    else do  
        let lim = limits b 
            d = moves !! (r-1)
            e = move p d 
            f = first b e d 
        if f == (-1,-1) then return b 
        else do 
            let c = if f == e then moveTo b p e 
                else moveTo (moveTo b e f) p e
                i = [x | x <- around p lim, c!x == Empty] ++ [p]
                h = [x | x <- around p lim, c!x == Child]
                t   | length h == 1 = 1
                    | length h == 2 = 3
                    | otherwise = 6
                times = min t (length i)
            s <- randomSelect i times
            g <- filterM (\x -> ber 2) s 
            return $ foldl (\x y -> put x y Muck) c g    

first::Board->Pos->Mov->Pos
first b p d | not $ insideBoard p lim  = (-1,-1)
            | b!p == Empty = p
            | b!p == Obstacle = first b (move p d) d 
            | otherwise = (-1,-1)
            where lim = limits b 