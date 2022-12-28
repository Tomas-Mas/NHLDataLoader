package gsonClasses;

import java.util.ArrayList;

public class Franchise {

	private String franchiseId;
	private String teamName;
	
	public ArrayList<String> getFranchiseData() {
		ArrayList<String> fd = new ArrayList<>();
		fd.add(franchiseId);
		fd.add(teamName);
		return fd;
	}
}
