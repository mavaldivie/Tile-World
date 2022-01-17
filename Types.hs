module Types where

import Utils
import Data.Array
import Data.List(unlines, unwords, intercalate)
import Debug.Trace

data Cell = Obstacle | Muck | House | ChildHouse | Empty |
            Child | Robot | ChildRobot deriving (Eq)
instance Show Cell where
    show Obstacle     = "O"
    show Muck         = "M" 
    show Child        = "C"
    show House        = "H"
    show Robot        = "R"
    show ChildRobot   = "A"
    show Empty        = "_"
    show ChildHouse   = "B"

type Matrix a = Array (Int,Int) a
new::Int->Int->a->Matrix a
new n m d = array ((0,0),(n,m)) [((i,j),d) | i <- [0..n], j <- [0..m]]

limits = snd . bounds 

rows = fst . limits
cols = snd . limits

toString::Show a => Matrix a->String
toString arr = unlines (map row [0..n]) ++ "\n" 
    where 
        n = rows arr
        m = cols arr
        row x = intercalate "|" [show (arr ! (x,y)) | y <- [0..m]]

type Board = Array (Int,Int) Cell

occupied::Pos->Board->Bool
occupied x b = b!x /= Empty

distanceMatrix::Board->Pos->Matrix Int
distanceMatrix b p = distanceMatrixBFS b x [p]
                        where 
                            n = rows b
                            m = cols b
                            y = new n m oo
                            x = y // [(p,0)]

distanceMatrixBFS::Board->Matrix Int->[Pos]->Matrix Int
distanceMatrixBFS b mat [] = mat 
distanceMatrixBFS b mat (x:xs)  = --trace (toString mat ++ show x) 
                                distanceMatrixBFS b newm newx
                                    where 
                                    c = b!x
                                    n = rows b
                                    m = cols b
                                    notseen p = mat!p == oo && canwalk b p
                                    adj = filter notseen $ adjacents x $ limits b
                                    newv = mat!x + 1
                                    newm = mat // [(p, newv) | p <- adj]
                                    newx = xs ++ adj 
canwalk b p = c == Empty || c == Muck || c == Child 
            where c = b!p

nearest::Cell->Board->Matrix Int->Pos->Pos
nearest c b mat p = if null list then (-1,-1) else snd $ minimum list
            where 
                n = rows b 
                m = cols b
                list = [(mat!(i,j), (i,j)) | 
                    i <- [0..n], j <- [0..m],
                    b!(i,j) == c]

nearestHouse = nearest House

nearestChild = nearest Child

nearestMuck = nearest Muck

buildPath mat b e = if b == e then []
                    else buildPath mat b newe ++ [e]
                    where 
                        l = limits mat
                        adj = adjacents e l 
                        cur = mat!e
                        newe = head $ filter (\x -> mat!x == cur - 1) adj

moveRobotTo::Board->Pos->Pos->Board
moveRobotTo b p e | end == Empty || end == Muck = put cleaned e start
                  | end == Child = put cleaned e ChildRobot
                  | start == ChildRobot && end == House = put (put b p Robot) e ChildHouse
                  where 
                    cleaned = clean b p
                    start = b!p
                    end = b!e

put::Board->Pos->Cell->Board
put b p x = b // [(p,x)] 
                       
clean::Board->Pos->Board
clean b p = put b p Empty

                    
-- execute::Board->Board
-- execute b = executeChilds $ executeRobots b a 
--                 where 
--                     n = rows arr
--                     m = cols arr
--                     a = [(i,j) | i <- [1..n],
--                                  j <- [1..m],
--                                  b!(i,j) == Robot False || 
--                                  b!(i,j) == ChildRobot False]