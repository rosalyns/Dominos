package all;

import java.util.List;

public class Pile {
	private List<Stone> stones;
	
	public Pile(List<Stone> stones) {
		this.stones = stones;
	}
	
	public void removeStones(List<Stone> stonesToRemove) {
		stones.removeAll(stonesToRemove);
	}
	
	public void removeStones(Stone stoneToRemove) {
		stones.remove(stoneToRemove);
	}
	
	public List<Stone> getStones() { 
		return this.stones;
	}

}
