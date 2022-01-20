module Moves where 

import Types(Cell(..), Board)
import Utils(Pos)
import Data.Array

moveTo b p e = put (put b p Empty) e (b!p)

put::Board->Pos->Cell->Board
put b p x = b // [(p,x)] 
                       
clean::Board->Pos->Board
clean b p = put b p Empty