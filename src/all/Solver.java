package all;

import java.util.ArrayList;
import java.util.List;

public class Solver {

	private Board problem;
	private Pile startingPile;
	private List<Board> solutions;
	
	public Solver(Board problem, Pile pile) {
		this.problem = problem;
		this.startingPile = pile;
		this.solutions = new ArrayList<Board>();
	}
	
	public List<Board> solve() {
		
	}
	
	private List<ForcedStone> findForcedStones(Board b, Pile p) {
		List<ForcedStone> fs = new ArrayList<>();
		for (Stone s : p.getStones()) {
			List<Location> locs = findLocations(b, s);
			if (locs.size() == 1) {
				fs.add(new ForcedStone(s, locs.get(0)));
			}
		}
		return fs;
	}
	
	private List<Location> findLocations(Board b, Stone s) {
		List<Location> locs = new ArrayList<Location>();
		for (Location l : b.positions()) {
			if (b.fits(l, s)) {
				locs.add(l);
			}
		}
		return locs;
	}

}
