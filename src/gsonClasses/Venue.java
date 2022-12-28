package gsonClasses;

public class Venue {

	private String id;
	private String name;
	
	public void print() {
		System.out.println("Venue = " + name);
	}
	
	public String getId() {
		return id;
	}
	
	public String getName() {
		return name;
	}
}
