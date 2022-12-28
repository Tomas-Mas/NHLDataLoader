package gsonClasses;

import java.util.ArrayList;

public class TeamDivision {

	private String id;
	private String name;
	
	public ArrayList<String> getDivisionData() {
		ArrayList<String> dd = new ArrayList<>();
		dd.add(id);
		dd.add(name);
		return dd;
	}
}
