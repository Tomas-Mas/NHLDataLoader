package gsonClasses;

import java.util.ArrayList;

public class TeamConference {

	private String id;
	private String name;
	
	public ArrayList<String> getConferenceData() {
		ArrayList<String> cd = new ArrayList<>();
		cd.add(id);
		cd.add(name);
		return cd;
	}
}
