module Random where

newtype RandomGen = RandomGen { current::Int } deriving (Show)

randomFactor = 13
randomMod = 73939133
randomSum = 1000000007

next::RandomGen->Int
next rg = mod (randomSum + current rg * randomFactor) randomMod

gen::Int->Int->RandomGen->(Int,RandomGen)
gen l r rg = (l + mod (next rg) (r - l + 1), RandomGen (next rg))

