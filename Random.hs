module Random where

import Utils(del)
import Data.Time.Clock(getCurrentTime)

fun::IO Int 
fun = do 
    x <- fmap show getCurrentTime
    let y = take 7 $ drop 20 x 
    return $ read y

rand::Int->IO Int 
rand m = fmap (`mod` m) fun

ber::Int->IO Bool 
ber x = fmap (== 0) (rand x)

randomSelect::[a]->Int->IO [a]
randomSelect a 0 = return []
randomSelect a n = do
    r <- rand $ length a 
    x <- randomSelect (del a r) (n-1) 
    return $ (a !! r) : x
