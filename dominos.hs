-- starting pile of all 28 stones
pile :: Pile
pile = map (\(x,(y,z)) -> (x,y,z)) (zip [1..28] pipCombinations)

-- possible domino combinations
pipCombinations :: [(Int, Int)]
pipCombinations = [(x,y) | x <- [0..6], y <- [x..6]]

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

sampleBoard :: Board
sampleBoard = [[5,4,3,6,5,3,4,6],
               [0,6,0,1,2,3,1,1],
               [3,2,6,5,0,4,2,0],
               [5,3,6,2,3,2,0,6],
               [4,0,4,1,0,0,4,1],
               [5,2,2,4,4,1,6,5],
               [5,5,3,6,1,2,3,1]]

emptyBoard :: Board
emptyBoard = [[-1,-1,-1,-1,-1,-1,-1,-1],
              [-1,-1,-1,-1,-1,-1,-1,-1],
              [-1,-1,-1,-1,-1,-1,-1,-1],
              [-1,-1,-1,-1,-1,-1,-1,-1],
              [-1,-1,-1,-1,-1,-1,-1,-1],
              [-1,-1,-1,-1,-1,-1,-1,-1],
              [-1,-1,-1,-1,-1,-1,-1,-1]]

wrongBoard :: Board
wrongBoard = [[-2,-2,-2,-2,-2,-2,-2,-2],
              [-2,-2,-2,-2,-2,-2,-2,-2],
              [-2,-2,-2,-2,-2,-2,-2,-2],
              [-2,-2,-2,-2,-2,-2,-2,-2],
              [-2,-2,-2,-2,-2,-2,-2,-2],
              [-2,-2,-2,-2,-2,-2,-2,-2],
              [-2,-2,-2,-2,-2,-2,-2,-2]]

testPossible :: Board
testPossible = [[6,6,0,0,0,0,0,0],
                [5,0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0,0]]

-- showing a board
show2d :: Int -> String 
show2d n | length (show n) == 1 = " " ++ (show n)
         | n == -1 = " -"
         | n == -2 = " x"
         | otherwise = show n

putBoard :: Board -> IO ()
putBoard xss = sequence_ [putRow xs | xs <- xss]

putRow :: Row -> IO ()
putRow [] = putStrLn " "
putRow (x:xs) = do putStr (show2d x) 
                   putStr " "
                   putRow xs

-- find all posibbilities of a stone
find :: Board -> Stone -> [Location]
find xss stone = filter (fits xss stone) positions

-- all possible positions on a board
positions :: [Location]
positions = hor_locations ++ ver_locations
 where hor_locations = [((x,y),(x+1,y)) | x <- [0..6], y <- [0..6]] 
       ver_locations = [((x,y),(x,y+1)) | x <- [0..7], y <- [0..5]] 

-- used to determine what the possibilities are for placing a stone
fits :: Board -> Stone -> Location -> Bool
fits xss (_,n1,n2) location | n1 == m1 && n2 == m2 = True
                            | n2 == m1 && n1 == m2 = True
                            | otherwise = False
                             where m1 = getValue xss (fst location)
                                   m2 = getValue xss (snd location)

-- get the value on a board from a position
getValue :: Board -> Pos -> Int
getValue xss (x,y) = (xss !! y) !! x


-- finds the stone ID corresponding to the pip numbers
findStone :: Int -> Int -> Stone
findStone x y | x <= y = head (filter (\(a,b,c) -> b == x && c == y) pile)
              | otherwise = findStone y x

-- gives all the stones + location that only have one possible location
forcedStones :: Board -> Pile ->[ForcedStone]
forcedStones xss pile = [(stone, head (find xss stone))| stone <- pile, length (find xss stone) == 1]

-- solutions :: Board -> [[(Stone, Location)]]
-- solutions xss = [forcedStones xss pile]

-- calculates one step of the solution
-- usage: partialSolutions = solve problem partialSolution availableStones
solve :: Board -> Board -> Pile -> Solutions
solve problem partialSolution pile | length currentForcedStones > 0 = solve problem (placeForcedStones partialSolution currentForcedStones) (removeUsedStones pile (map fst currentForcedStones))
                                              | otherwise = concat [concat (map ($ (snd particularStoneSolution)) (map (solve problem) (fst particularStoneSolution))) | particularStoneSolution <- particularStoneSolutions]
                                              where currentForcedStones = forcedStones problem pile
                                                    particularStoneSolutions = [(map (placeStone partialSolution stone) (find problem stone), (removeUsedStones pile [stone])) | stone <- pile]


-- checks if that location is still free
valid :: Board -> Location -> Bool
valid xss location | getValue xss (fst location) == -1 && getValue xss (snd location) == -1 = True
                   | otherwise = False

-- get the direction of a location
getDirection :: Location -> Direction
getDirection (p1, p2) | (fst p1 == fst p2) = Ver
                      | otherwise = Hor

-- makes a copy of the old board where the location (location) is replaced with the new stone
placeStone :: Board -> Stone -> Location -> Board
placeStone xss stone (p1,p2) = before ++ middle ++ after
                                where before = [xss !! row | row <- [0..(snd p1)-1]]
                                      middle
                                       | getDirection (p1,p2) == Ver = [row1] ++ [changedRow (xss !! snd p2) stone p2]
                                       | otherwise = [changedRow row1 stone p2]
                                         where row1 = changedRow (xss !! snd p1) stone p1
                                      after = [xss !! row | row <- [(snd p2)+1..6]]

-- changes the row where the stone is placed
changedRow :: Row -> Stone -> Pos -> Row
changedRow row (b,_,_) (x,_) = [row !! col | col <- [0..x-1]] ++ [b] ++ [row !! col | col <- [x+1..7]]


-- solution flow
-- solutions :: Board -> [[(Stone, Location)]]
-- solutions xss = placeForcedStones xss (forcedStones xss pile)

--                    else putStr "This board is not solvable."

placeForcedStones :: Board -> [ForcedStone] -> Board
placeForcedStones xss [] = xss
placeForcedStones xss (x:xs) | valid xss (snd x) = placeForcedStones (placeStone xss (fst x) (snd x)) xs 
                             | otherwise = wrongBoard

removeUsedStones :: Pile -> Pile -> Pile
removeUsedStones pile xs = [stone | stone <- pile, not (elem stone xs)]


