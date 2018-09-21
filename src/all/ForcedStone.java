package all;

public class ForcedStone {
	
	private Stone stone;
	private Location location;
	
	public ForcedStone(Stone stone, Location loc) {
		this.stone = stone;
		this.location = loc;
	}

	public Stone getStone() {
		return stone;
	}

	public Location getLocation() {
		return location;
	}

	public void setStone(Stone stone) {
		this.stone = stone;
	}

	public void setLocation(Location location) {
		this.location = location;
	}

}
