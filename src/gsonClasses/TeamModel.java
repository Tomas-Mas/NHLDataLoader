package gsonClasses;

import java.util.ArrayList;

public class TeamModel {

	private ArrayList<TeamInfo> teams = new ArrayList<>();
	
	public ArrayList<TeamInfo> getTeams() {
		return teams;
	}
	
	/*public TeamInfo getTeam() {
		if(teams.size() >1){
			System.out.println("More than one team was loaded!?!?");
		}
		return teams.get(0);
	}*/
}
