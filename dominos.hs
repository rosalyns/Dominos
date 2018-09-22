-- starting pile of all 28 stones
pile :: Pile
pile = map (\(x,(y,z)) -> (x,y,z)) (zip [1..28] pipCombinations)

-- possible domino combinations
pipCombinations :: [(Int, Int)]
pipCombinations = [(x,y) | x <- [0..6], y <- [x..6]]

--type and data declarations
data Direction = Hor | Ver

instance Eq Direction where  
    Hor == Hor = True
    Ver == Ver = True
    _ == _ = False


type Bone = Int
type Pos = (Int, Int)
type Location = (Pos, Pos)
type Stone = (Bone, Int, Int)
type ForcedStone = (Stone, Location)
type Board = [Row]
type Solutions = [Board]
type Pile = [Stone]
type Row = [Int]

-- sampleBoards used as examples
sampleBoard :: Board
sampleBoard = [[5,4,3,6,5,3,4,6],
               [0,6,0,1,2,3,1,1],
               [3,2,6,5,0,4,2,0],
               [5,3,6,2,3,2,0,6],
               [4,0,4,1,0,0,4,1],
               [5,2,2,4,4,1,6,5],
               [5,5,3,6,1,2,3,1]]

sampleBoard2 :: Board
sampleBoard2 = [[4,2,5,2,6,3,5,4],
                [5,0,4,3,1,4,1,1],
                [1,2,3,0,2,2,2,2],
                [1,4,0,1,3,5,6,5],
                [4,0,6,0,3,6,6,5],
                [4,0,1,6,4,0,3,0],
                [6,5,3,6,2,1,5,3]]

emptyBoard :: Board
emptyBoard = [[-1,-1,-1,-1,-1,-1,-1,-1],
              [-1,-1,-1,-1,-1,-1,-1,-1],
              [-1,-1,-1,-1,-1,-1,-1,-1],
              [-1,-1,-1,-1,-1,-1,-1,-1],
              [-1,-1,-1,-1,-1,-1,-1,-1],
              [-1,-1,-1,-1,-1,-1,-1,-1],
              [-1,-1,-1,-1,-1,-1,-1,-1]]

-- helper functions
width :: Board -> Int
width board = length (head board)

height :: Board -> Int
height board = length board

x :: (a,b) -> a
x = fst

y :: (a,b) -> b
y = snd

show2d :: Int -> String 
show2d n | length (show n) == 1 = " " ++ (show n)
         | n == -1 = " -"
         | n == -2 = " x"
         | otherwise = show n

putBoard :: Board -> IO ()
putBoard board = do sequence_ [putRow row | row <- board]
                    putStrLn ""

putRow :: Row -> IO ()
putRow [] = putStrLn ""
putRow (x:xs) = do putStr (show2d x) 
                   putStr " "
                   putRow xs

-- not AND
nand :: Board -> Board -> Board
nand problem partialSolution = [nandRow row1 row2 | (row1, row2) <- zip problem partialSolution]

nandRow :: Row -> Row -> Row
nandRow problem partialSolution = [if cell2 == -1 then cell1 else -1 | (cell1, cell2) <- zip problem partialSolution]

-- get the direction of a location
getDirection :: Location -> Direction
getDirection (pos1, pos2) | (x pos1 == x pos2) = Ver
                          | otherwise = Hor

-- get the value on a board from a position
getValue :: Board -> Pos -> Int
getValue board (x,y) = (board !! y) !! x

-- implementation functions

-- all possible positions on a board
positions :: Board -> [Location]
positions board = hor_locations ++ ver_locations
 where hor_locations = [((x,y),(x+1,y)) | x <- [0..(width board)-2], y <- [0..(height board)-1]] 
       ver_locations = [((x,y),(x,y+1)) | x <- [0..(width board)-1], y <- [0..(height board)-2]] 

-- used to determine what the possibilities are for placing a stone
fits :: Board -> Stone -> Location -> Bool
fits board (_,n1,n2) location | n1 == m1 && n2 == m2 = True
                              | n2 == m1 && n1 == m2 = True
                              | otherwise = False
                               where m1 = getValue board (fst location)
                                     m2 = getValue board (snd location)

-- gives all the stones + location that only have one possible location
forcedStones :: Board -> Pile ->[ForcedStone]
forcedStones board pile = [(stone, head (findLocations board stone))| stone <- pile, length (findLocations board stone) == 1]

-- calculates one step of the solution
-- usage: partialSolutions = solve problem partialSolution availableStones
solve :: Board -> Board -> Pile -> Solutions
solve _ [] _ = []
solve _ solution [] = [solution]
solve problem partialSolution pile
 | length currentForcedStones > 0 = solve problem (placeForcedStones partialSolution currentForcedStones) (removeUsedStones pile (map fst currentForcedStones))
 | otherwise                      = concat (map ($ newPile) (map (solve problem) particularStoneSolutions))
   where currentForcedStones      = forcedStones (nand problem partialSolution) pile
         particularStoneSolutions = placePossibilities problem partialSolution stone
         newPile                  = removeUsedStones pile [stone]
         stone                    = head pile

-- checks if that location is still free
valid :: Board -> Location -> Bool
valid board location | getValue board (fst location) == -1 && getValue board (snd location) == -1 = True
                     | otherwise = False

-- find all possible locations of a stone
findLocations :: Board -> Stone -> [Location]
findLocations board stone = filter (fits board stone) (positions board)

placeForcedStones :: Board -> [ForcedStone] -> Board
placeForcedStones board [] = board
placeForcedStones board (x:xs) | valid board location = placeForcedStones (placeStone board stone location) xs 
                               | otherwise = []
                                where stone = fst x
                                      location = snd x

-- find intermediate possibilities of a stone
placePossibilities :: Board -> Board -> Stone -> Solutions
placePossibilities problem partialSolution stone = map (placeStone partialSolution stone) (findLocations (nand problem partialSolution) stone)

-- makes a copy of the old board where the location is replaced with the new stone
placeStone :: Board -> Stone -> Location -> Board
placeStone board stone (pos1,pos2) = before ++ middle ++ after
                                where before = [board !! row | row <- [0..(y pos1)-1]]
                                      middle
                                       | getDirection (pos1,pos2) == Ver = [row1] ++ [changedRow (board !! y pos2) stone pos2]
                                       | otherwise = [changedRow row1 stone pos2]
                                         where row1 = changedRow (board !! y pos1) stone pos1
                                      after = [board !! row | row <- [(y pos2)+1..(height board) - 1]]

-- changes the row where the stone is placed
changedRow :: Row -> Stone -> Pos -> Row
changedRow row (bone,_,_) (x,_) = [row !! col | col <- [0..x-1]] ++ [bone] ++ [row !! col | col <- [x+1..(length row)-1]]

-- remove stones from a pile, return the new pile
removeUsedStones :: Pile -> Pile -> Pile
removeUsedStones pile toRemove = filter (\stone -> not (stone `elem` toRemove)) pile

dominos :: Board -> IO ()
dominos board = sequence_ [putBoard solution | solution <- solve board emptyBoard pile]

main :: IO ()
main = dominos sampleBoard
