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
	
	public Field deepCopy() {
		Field f = new Field();
		if (this.isEmpty()) {
			f.setEmpty(true);
		} else {
			f.setValue(this.getValue());
		}
		return f;
	}
	
	public void setEmpty(boolean empty) {
		this.empty = empty;
	}
	
	public boolean isEmpty() {
		return empty;
	}
	
	public void setValue(int val) {
		this.value = val;
		this.empty = false;
	}
	
	public int getValue() {
		return this.value;
	}
	
	public String toString() {
		StringBuilder result = new StringBuilder();
		if (isEmpty()) {
			result.append("  ");
		} else if (Integer.toString(getValue()).length() == 1) {
			result.append(" " + getValue());
		} else  {
			result.append(getValue());
		}
		return result.toString();
	}

}
