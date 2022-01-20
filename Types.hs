module Types where

import Utils
import Data.Array
import Data.List(unlines, unwords, intercalate)

data Cell = Obstacle | Muck | House | ChildHouse | Empty |
            Child | Robot | ChildRobot deriving (Eq)
instance Show Cell where
    show Obstacle     = "*"
    show Muck         = "M" 
    show Child        = "C"
    show House        = "^"
    show Robot        = "R"
    show ChildRobot   = "%"
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
