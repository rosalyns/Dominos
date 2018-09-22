package all;

import java.util.ArrayList;
import java.util.List;

public class Pile {
	private List<Stone> stones;
	
	public Pile(List<Stone> stones) {
		this.stones = stones;
	}
	
	public Pile deepCopy() {
		List<Stone> newStones = new ArrayList<Stone>();
		for (Stone stone : stones) {
			newStones.add(stone);
		}
		return new Pile(newStones);
	}
	
	public void removeStones(List<Stone> stonesToRemove) {
		stones.removeAll(stonesToRemove);
	}
	
	public void removeStone(Stone stoneToRemove) {
		stones.remove(stoneToRemove);
	}
	
	public Stone removeFirst() {
		return stones.remove(0);
	}
	
	public List<Stone> getStones() { 
		return this.stones;
	}

}
