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

	public void setId(int id) {
		this.id = id;
	}

	public void setPip1(int pip1) {
		this.pip1 = pip1;
	}

	public void setPip2(int pip2) {
		this.pip2 = pip2;
	}
}
