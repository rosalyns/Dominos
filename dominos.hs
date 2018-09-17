pile :: [(Int, Int)]
pile = [(x,y) | x <- [0..6], y <- [x..6]]

data Pos = Empty Int Int | Filled Int Int Int  

type Board = [Pos]