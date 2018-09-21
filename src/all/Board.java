package all;

import java.util.ArrayList;
import java.util.List;

public class Board {
	
	private Field[][] fields;
	private int width;
	private int height;
	private Type type;

	enum Type {
		Problem, Solution
	}
	
	public Board(int width, int height) {
		this.width = width;
		this.height = height;
		fields = new Field[height][width];
		
		for (int y = 0; y < height; y++) {
			for (int x = 0; x < width; x++) {
				fields[y][x] = new Field();
			}
		}
	}
	
	public void initialize(int[][] values) {
		for (int y = 0; y < height; y++) {
			for (int x = 0; x < width; x++) {
				setValue(values[y][x], new Position(x,y));
			}
		}
	}
	
	public void setValue(int value, Position pos) {
		fields[pos.getY()][pos.getX()] = new Field(value);
		this.type = Type.Problem;
	}
	
	public void placeStone(Stone stone, Location loc) {
		fields[loc.getPos1().getY()][loc.getPos2().getX()] = new Field(stone.getId());
		fields[loc.getPos2().getY()][loc.getPos2().getX()] = new Field(stone.getId());
		this.type = Type.Solution;
	}
	
	public Type getType() {
		return type;
	}

	public void setType(Type type) {
		this.type = type;
	}
	
	public Field getField(int x, int y) {
		return fields[y][x];
	}
	
	public boolean fits(Location loc, Stone stone) {
		boolean fitsOneWay1 = getField(loc.getPos1().getX(), loc.getPos1().getY()).getValue() == stone.getPip1();
		boolean fitsOneWay2 = getField(loc.getPos2().getX(), loc.getPos2().getY()).getValue() == stone.getPip2();
		boolean fitsOtherWay1 = getField(loc.getPos1().getX(), loc.getPos1().getY()).getValue() == stone.getPip2();
		boolean fitsOtherWay2 = getField(loc.getPos2().getX(), loc.getPos2().getY()).getValue() == stone.getPip1();
		return  (fitsOneWay1 && fitsOneWay2) || (fitsOtherWay1 && fitsOtherWay2); 
	}
	
	public List<Location> positions() {
		List<Location> locations = new ArrayList<Location>();
		for (int y = 0; y < height; y++) {
			for (int x = 0; x < width - 1; x++) {
				locations.add(new Location(new Position(x,y), new Position(x+1,y)));
			}
		}
		
		for (int y = 0; y < height - 1; y++) {
			for (int x = 0; x < width; x++) {
				locations.add(new Location(new Position(x,y), new Position(x,y+1)));
			}
		}
		return locations;
//		 where hor_locations = [((x,y),(x+1,y)) | x <- [0..(width board)-2], y <- [0..(height board)-1]] 
//		       ver_locations = [((x,y),(x,y+1)) | x <- [0..(width board)-1], y <- [0..(height board)-2]] 
	}
	
	
	public String toString() {
		StringBuilder result = new StringBuilder();
		for (int y = 0; y < height; y++) {
			for (int x = 0; x < width; x++) {
				if (fields[y][x].isEmpty()) {
					result.append("   ");
				} else if (Integer.toString(fields[y][x].getValue()).length() == 1) {
					result.append("  " + fields[y][x].getValue());
				} else  {
					result.append(" " + fields[y][x].getValue());
				}
			}
			result.append("\n");
		}
		result.append("\n");
		return result.toString();
	}
	
	

}
