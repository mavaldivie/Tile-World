module Types where

import Utils
import Data.Array
import Data.List(unlines, unwords)

data Cell = Obstacle | Muck | House | ChildHouse | Empty |
            Child { moved::Bool } | Robot { moved::Bool } | 
            ChildRobot { moved::Bool }
instance Eq Cell where
    Obstacle == Obstacle = True
    Muck == Muck = True 
    Child x == Child y = True
    House == House = True 
    Robot x == Robot y = True
    ChildRobot x == ChildRobot y = True 
    Empty == Empty = True
    ChildHouse == ChildHouse = True
    _ == _ = False
instance Show Cell where
    show Obstacle      = "O"
    show Muck          = "M"
    show (Child _)     = "C"
    show House         = "H"
    show (Robot _)     = "R"
    show (ChildRobot _)= "A"
    show Empty         = "E"
    show ChildHouse    = "B"

type Matrix a = Array (Int,Int) a
new::Int->Int->a->Matrix a
new n m d = array ((0,0),(n-1,m-1)) [((i,j),d) | i <- [0..n-1], j <- [0..m-1]]

limits = snd . bounds 

rows = fst . limits
cols = snd . limits

toString::Show a => Matrix a->String
toString arr = unlines $ map row [0..n]
    where 
        n = rows arr
        m = cols arr
        row x = unwords [show (arr ! (x,y)) | y <- [0..m]]

type Board = Array (Int,Int) Cell

occupied::Pos->Board->Bool
occupied x b = b!x /= Empty

distanceMatrix::Board->Pos->Matrix Int
distanceMatrix b p = distanceMatrixBFS b x [p]
                        where 
                            n = rows b
                            m = cols b
                            y = new n m (n * m + 1)
                            x = y // [(p,0)]

distanceMatrixBFS::Board->Matrix Int->[Pos]->Matrix Int
distanceMatrixBFS b mat [] = mat 
distanceMatrixBFS b mat (x:xs) | b!x /= Empty && b!x /= Muck = distanceMatrixBFS b mat xs
                             | otherwise = distanceMatrixBFS b newm newx
                                where 
                                    n = rows b
                                    m = cols b
                                    seen p = mat!p /= (n * m + 1)
                                    adj = filter seen $ adjacents x $ limits b
                                    newm = mat // [(p, mat!x + 1) | p <- adj]
                                    newx = xs ++ adj 
                             

-- execute::Board->Board
-- execute b = executeChilds $ executeRobots b a 
--                 where 
--                     n = rows arr
--                     m = cols arr
--                     a = [(i,j) | i <- [1..n],
--                                  j <- [1..m],
--                                  b!(i,j) == Robot False || 
--                                  b!(i,j) == ChildRobot False]