package all;

import java.util.ArrayList;
import java.util.List;

public class Board {
	
	private Field[][] fields;
	private int width;
	private int height;
	private boolean valid;
	
	public Board(int width, int height) {
		this.width = width;
		this.height = height;
		this.valid = true;
		fields = new Field[height][width];
		
		for (int y = 0; y < height; y++) {
			for (int x = 0; x < width; x++) {
				fields[y][x] = new Field();
			}
		}
	}
	
	//it's always a solution
	public Board deepCopy() {
		Board b = new Board(this.width, this.height);
		for (int y = 0; y < height; y++) {
			for (int x = 0; x < width; x++) {
				b.setField(this.getField(x, y).deepCopy(), new Position(x,y));
			}
		}
		b.setValidity(this.isValid());
		return b;
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
	}
	
	public void setField(Field f, Position pos) {
		fields[pos.getY()][pos.getX()] = f;
	}
	
	public void placeStone(Stone stone, Location loc) {
		fields[loc.getPos1().getY()][loc.getPos1().getX()] = new Field(stone.getId());
		fields[loc.getPos2().getY()][loc.getPos2().getX()] = new Field(stone.getId());
	}

	public Field getField(int x, int y) {
		return fields[y][x];
	}
	
	public boolean fits(Location loc, Stone stone) {
		Field field1 = getField(loc.getPos1().getX(), loc.getPos1().getY());
		Field field2 = getField(loc.getPos2().getX(), loc.getPos2().getY());
		boolean fitsOneWay1 = (!field1.isEmpty()) && field1.getValue() == stone.getPip1();
		boolean fitsOneWay2 = (!field2.isEmpty()) && field2.getValue() == stone.getPip2();
		boolean fitsOtherWay1 = (!field1.isEmpty()) && field1.getValue() == stone.getPip2();
		boolean fitsOtherWay2 = !field2.isEmpty() && field2.getValue() == stone.getPip1();
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
	
	public boolean valid(Location loc) {
		return fields[loc.getPos1().getY()][loc.getPos1().getX()].isEmpty() && fields[loc.getPos2().getY()][loc.getPos2().getX()].isEmpty();
	}
	
	public Board nand(Board b2) {
		Board newB = new Board(width, height);
		for (int y = 0; y < height; y++) {
			for (int x = 0; x < width; x++) {
				if (b2.getField(x, y).isEmpty()) {
					newB.setValue(this.getField(x, y).getValue(), new Position(x,y));
				}
			}
		}
		return newB;
	}
	
	public void empty() {
		for (int y = 0; y < height; y++) {
			for (int x = 0; x < width; x++) {
				this.getField(x, y).setEmpty(true);
			}
		}
	}
	
	public boolean isEmpty() {
		for (int y = 0; y < height; y++) {
			for (int x = 0; x < width; x++) {
				if (!this.getField(x, y).isEmpty()) {
					return false;
				}
			}
		}
		return true;
	}
	
	public void setValidity(boolean valid) {
		this.valid = valid;
	}
	
	public boolean isValid() {
		return this.valid;
	}
	
	public String toString() {
		StringBuilder result = new StringBuilder();
		for (int y = 0; y < height; y++) {
			for (int x = 0; x < width; x++) {
				result.append(" " + fields[y][x].toString());
			}
			result.append("\n");
		}
		result.append("\n");
		return result.toString();
	}
}
