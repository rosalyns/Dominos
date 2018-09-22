package all;

import java.util.ArrayList;
import java.util.List;

public class Solver {
	public static List<Board> solve(Board problem, Board partialSolution, Pile pile) {
		if (!partialSolution.isValid()) {
			return new ArrayList<Board>();
		}
		
		if (pile.getStones().isEmpty()) {
			List<Board> solutions = new ArrayList<Board>();
			solutions.add(partialSolution);
			return solutions;
		}
		
		List<ForcedStone> currentForcedStones = forcedStones(problem.nand(partialSolution), pile);
		if (currentForcedStones.size() > 0) {
			placeForcedStones(partialSolution, currentForcedStones);
			for (ForcedStone fs : currentForcedStones) {
				pile.removeStone(fs.getStone());
			}
			return solve(problem, partialSolution, pile);
		} else {
			List<Board> solutions = new ArrayList<Board>();
			Stone stone = pile.removeFirst();
			List<Board> particularStoneSolutions = placePossibilities(problem, partialSolution, stone);
			for (Board b : particularStoneSolutions) {
				solutions.addAll(solve(problem, b, pile.deepCopy()));
			}
			return solutions;
		}
	}
	
	private static List<Board> placePossibilities(Board problem, Board partialSolution, Stone stone) {
		List<Board> solutions = new ArrayList<Board>();
		List<Location> locs = findLocations(problem.nand(partialSolution), stone);
		for (Location loc : locs) {
			Board copy = partialSolution.deepCopy();
			copy.placeStone(stone, loc);
			solutions.add(copy);
		}
		return solutions;
	}
	
	private static List<ForcedStone> forcedStones(Board b, Pile p) {
		List<ForcedStone> fs = new ArrayList<>();
		for (Stone s : p.getStones()) {
			List<Location> locs = findLocations(b, s);
			if (locs.size() == 1) {
				fs.add(new ForcedStone(s, locs.get(0)));
			}
		}
		return fs;
	}
	
	private static List<Location> findLocations(Board b, Stone s) {
		List<Location> locs = new ArrayList<Location>();
		for (Location l : b.positions()) {
			if (b.fits(l, s)) {
				locs.add(l);
			}
		}
		return locs;
	}
	
	private static void placeForcedStones(Board b, List<ForcedStone> fs) {
		for (ForcedStone forcedStone : fs) {
			if (b.valid(forcedStone.getLocation())) {
				b.placeStone(forcedStone.getStone(), forcedStone.getLocation());
			} else {
				b.setValidity(false);
			}
		}
	}

}
