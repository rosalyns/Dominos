pile :: [Stone]
pile = map (\(x,(y,z)) -> (x,y,z)) (zip [1..28] pipCombinations)

pipCombinations :: [(Int, Int)]
pipCombinations = [(x,y) | x <- [0..6], y <- [x..6]]

-- data Val = Empty | Int 
data Direction = Hor | Ver

instance Eq Direction where  
    Hor == Hor = True
    Ver == Ver = True
    _ == _ = False

type Bone = Int
type Pos = (Int, Int)
type Pair = (Pos, Pos)
type Stone = (Bone, Int, Int)
type Board = [[Int]]

sampleBoard :: Board
sampleBoard = [[5,4,3,6,5,3,4,6],[0,6,0,1,2,3,1,1],[3,2,6,5,0,4,2,0],[5,3,6,2,3,2,0,6],[4,0,4,1,0,0,4,1],[5,2,2,4,4,1,6,5],[5,5,3,6,1,2,3,1]]

emptyBoard :: Board
emptyBoard = [[-1,-1,-1,-1,-1,-1,-1,-1],[-1,-1,-1,-1,-1,-1,-1,-1],[-1,-1,-1,-1,-1,-1,-1,-1],[-1,-1,-1,-1,-1,-1,-1,-1],[-1,-1,-1,-1,-1,-1,-1,-1],[-1,-1,-1,-1,-1,-1,-1,-1],[-1,-1,-1,-1,-1,-1,-1,-1]]

testPossible :: Board
testPossible = [[6,6,0,0,0,0,0,0],[5,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0]]

-- instance Show Val where
--  show (Empty) = show " "
--  show (x) = show x 

putBoard :: Board -> IO ()
putBoard xss = sequence_ [putRow xs | xs <- xss]

putRow :: [Int] -> IO ()
putRow [] = putStrLn " "
putRow (x:xs) = do putStr (show x) 
                   putStr " "
                   putRow xs

find :: Board -> Stone -> [Pair]
find xss stone = filter (fits xss stone) positions

-- bord en een steen: op welke Pos past een steen
-- alle posities opvragen van een bord

positions :: [Pair]
positions = hor_pairs ++ ver_pairs
 where hor_pairs = [((x,y),(x+1,y)) | x <- [0..6], y <- [0..6]] 
       ver_pairs = [((x,y),(x,y+1)) | x <- [0..7], y <- [0..5]] 

fits :: Board -> Stone -> Pair -> Bool
fits xss (_,n1,n2) pair | n1 == m1 && n2 == m2 = True
                        | n2 == m1 && n1 == m2 = True
                        | otherwise = False
                        where m1 = getValue xss (fst pair)
                              m2 = getValue xss (snd pair)

getValue :: Board -> Pos -> Int
getValue xss (x,y) = (xss !! y) !! x

findStone :: Int -> Int -> Stone
findStone x y | x <= y = head (filter (\(a,b,c) -> b == x && c == y) pile)
              | otherwise = findStone y x

forcedStones :: Board -> [Stone] ->[(Stone, Pair)]
forcedStones xss pile = [(stone, head (find xss stone))| stone <- pile, length (find xss stone) == 1]

solutions :: Board -> [[(Stone, Pair)]]
solutions xss = [forcedStones xss pile]

-- placeStone :: Board -> Stone -> Pair -> Board
-- placeStone xss stone pair = 

valid :: Board -> Pair -> Bool
valid xss pair | getValue xss (fst pair) == -1 && getValue xss (snd pair) == -1 = True
               | otherwise = False

getDirection :: Pair -> Direction
getDirection (p1, p2) | (fst p1 == fst p2) = Ver
                      | otherwise = Hor

placeStone :: Board -> Stone -> Pair -> Board
placeStone xss stone (p1,p2) = left ++ middle ++ right
                                where left = [xss !! row | row <- [0..(snd p1)-1]]
                                      middle
                                       | getDirection (p1,p2) == Ver = [row1] ++ [changedRow (xss !! snd p2) stone p2]
                                       | otherwise = [changedRow row1 stone p2]
                                         where row1 = changedRow (xss !! snd p1) stone p1
                                      right = [xss !! row | row <- [(snd p2) + 1 ..6]]

changedRow :: [Int] -> Stone -> Pos -> [Int]
changedRow xs (b,_,_) (x,_) = [xs !! col | col <- [0..x-1]] ++ [b] ++ [xs !! col | col <- [x+1..7]]







