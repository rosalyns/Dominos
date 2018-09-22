package all;

import java.util.ArrayList;
import java.util.List;

public class Main {

	private static Board sampleBoard1;
	private static Board sampleBoard2;
	private static Board emptyBoard;
	private static Pile pile;
	
	public static void initializeBoard() {
		int[][] array = {
			{5,4,3,6,5,3,4,6},
			{0,6,0,1,2,3,1,1}, 
			{3,2,6,5,0,4,2,0}, 
			{5,3,6,2,3,2,0,6},
			{4,0,4,1,0,0,4,1},
			{5,2,2,4,4,1,6,5},
			{5,5,3,6,1,2,3,1}
		};
		sampleBoard1 = new Board(8,7);
		sampleBoard1.initialize(array);
		
		int[][] array2 = {
				{4,2,5,2,6,3,5,4},
				{5,0,4,3,1,4,1,1}, 
				{1,2,3,0,2,2,2,2}, 
				{1,4,0,1,3,5,6,5},
				{4,0,6,0,3,6,6,5},
				{4,0,1,6,4,0,3,0},
				{6,5,3,6,2,1,5,3}
		};
		sampleBoard2 = new Board(8,7);
		sampleBoard2.initialize(array2);
		
		emptyBoard = new Board(8,7);
		emptyBoard.empty();
	}
	
	public static void initializePile() {
		List<Stone> stones = new ArrayList<Stone>();
		
		stones.add(new Stone(1,0,0));
		stones.add(new Stone(2,0,1));
		stones.add(new Stone(3,0,2));
		stones.add(new Stone(4,0,3));
		stones.add(new Stone(5,0,4));
		stones.add(new Stone(6,0,5));
		stones.add(new Stone(7,0,6));
		stones.add(new Stone(8,1,1));
		stones.add(new Stone(9,1,2));
		stones.add(new Stone(10,1,3));
		stones.add(new Stone(11,1,4));
		stones.add(new Stone(12,1,5));
		stones.add(new Stone(13,1,6));
		stones.add(new Stone(14,2,2));
		stones.add(new Stone(15,2,3));
		stones.add(new Stone(16,2,4));
		stones.add(new Stone(17,2,5));
		stones.add(new Stone(18,2,6));
		stones.add(new Stone(19,3,3));
		stones.add(new Stone(20,3,4));
		stones.add(new Stone(21,3,5));
		stones.add(new Stone(22,3,6));
		stones.add(new Stone(23,4,4));
		stones.add(new Stone(24,4,5));
		stones.add(new Stone(25,4,6));
		stones.add(new Stone(26,5,5));
		stones.add(new Stone(27,5,6));
		stones.add(new Stone(28,6,6));
		
		pile = new Pile(stones);
	}

	public static void main(String[] args) {
		initializeBoard();
		initializePile();
		for (String s : args) {
			System.out.println(s);
		}
		Board example = sampleBoard1;
		if (args.length > 0 && args[0].equals("1")) {
			example = sampleBoard1;
		} else if (args.length > 0 && args[0].equals("2")) {
			example = sampleBoard2;
		}
		
		List<Board> solutions = Solver.solve(example, emptyBoard, pile);
		System.out.println("Input: ");
		System.out.println(example.toString());
		System.out.println("Mappings: ");
		for (Board b : solutions) {
			System.out.println(b.toString());
		}
	}

}
