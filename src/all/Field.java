package all;

public class Field {
	
	private boolean empty;
	private int value;
	
	public Field(int value) {
		this.value = value;
		this.empty = false;
	}
	
	public Field() {
		this.empty = true;
	}
	
	public boolean isEmpty() {
		return empty;
	}
	
	public void setValue(int val) {
		this.value = val;
	}
	
	public int getValue() {
		return this.value;
	}

}
