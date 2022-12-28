package gsonClasses;

import java.util.ArrayList;

public class TeamJson {

	private String id;
	private String name;
	
	public void putTeamJson(String id, String name) {
		this.id = id;
		this.name = name;
	}
	
	public String getId() {
		return id;
	}
	
	public String getName() {
		return name;
	}
	
	public ArrayList<String> getTeamData() {
		ArrayList<String> td = new ArrayList<>();
		td.add(id);
		td.add(name);
		return td;
	}
}
