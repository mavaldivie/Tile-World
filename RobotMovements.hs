

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

                

-- moveRobots::Board->Board
-- moveRobots b = foldl moveRobot b r
--     where 
--         n = rows b
--         m = cols b
--         p = b!(i,j)
--         r = [(i,j) | i <- [0..n], j <- [0..m], 
--             p == Robot || p == ChildRobot]

-- moveRobot::Board->Pos->Board
-- moveRobot b p = moveRobotTo b p $ head $ buildPath m p $ fun b m p
--     where 
--         m = distanceMatrix b p 
--         fun = case b!p of
--                 Robot      -> nearestChild
--                 ChildRobot -> nearestHouse

-- moveRobotTo::Board->Pos->Pos->Board
-- moveRobotTo b p e | end == Empty || end == Muck = moveTo b p e
--                   | end == Child = put cleaned e ChildRobot
--                   | start == ChildRobot
--                   where 
--                     cleaned = clean b p
--                     start = b!p
--                     end = b!e