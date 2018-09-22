package all;

public class Stone {
	
	public int id; 
	public int pip1;
	public int pip2; 
	
	public Stone(int id, int pip1, int pip2) {
		this.id = id;
		this.pip1 = pip1;
		this.pip2 = pip2;
	}

	public int getId() {
		return id;
	}

	public int getPip1() {
		return pip1;
	}

	public int getPip2() {
		return pip2;
	}
}
