module Distances where 

import Types
import Utils
import Moves
import Data.Array

distanceMatrix::Board->Pos->[Cell]->Matrix Int
distanceMatrix b p = distanceMatrixBFS b x [p]
                        where 
                            (n,m) = limits b
                            y = new n m oo
                            x = y // [(p,0)]

distanceMatrixBFS::Board->Matrix Int->[Pos]->[Cell]->Matrix Int
distanceMatrixBFS b mat [] _ = mat 
distanceMatrixBFS b mat (x:xs) available =
                distanceMatrixBFS b newm newx available
                    where 
                    c = b!x
                    lim = limits b
                    neighbors = filter (\p -> b!p `elem` available) 
                            $ adjacents x lim
                    adj = filter (\p -> mat!p == oo) neighbors
                    newv = mat!x + 1
                    newm = mat // [(p, newv) | p <- adj]
                    newx = xs ++ adj 

nearest::Cell->Board->Matrix Int->(Int,Pos)
nearest c b mat = if null list then (oo,(-1,-1)) else minimum list
            where 
                (n,m) = limits b
                list = [(mat!(i,j), (i,j)) | 
                    i <- [0..n], j <- [0..m],
                    b!(i,j) == c &&
                    mat!(i,j) /= oo]

nearestHouse = nearest House
nearestChild = nearest Child
nearestMuck = nearest Muck

buildPath mat b e = if b == e || mat!e == oo then []
                    else buildPath mat b newe ++ [e]
                    where 
                        l = limits mat
                        adj = adjacents e l 
                        cur = mat!e
                        newe :_ = filter (\x -> mat!x == (cur - 1)) adj

emptyHouse b = head $ filter (\t -> b!t == House) [(i,j) | 
                    i <- [0..n], j <- [0..m]]
                where (n,m) = limits b

pathExists::Board->Pos->Int
pathExists b p = if p /= (-1,-1) && target /= (-1,-1)
                then m!target
                else oo
                where
                    m = distanceMatrix b p [Empty,House]
                    target = snd $ nearestHouse b m 