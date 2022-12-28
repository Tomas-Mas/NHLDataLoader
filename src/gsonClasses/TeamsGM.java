package gsonClasses;

import java.util.ArrayList;

public class TeamsGM {
	
	private PlayingTeam away;
	private PlayingTeam home;
	
	TeamModel awayData = new TeamModel();
	TeamModel homeData = new TeamModel();
	
	public PlayingTeam getAwayTeam() {
		return away;
	}
	
	public PlayingTeam getHomeTeam() {
		return home;
	}
	
	public ArrayList<String> getAwayTeamDetails() {
		return awayData.getTeams().get(0).getTeamData();
	}
	
	public ArrayList<String> getHomeTeamDetails() {
		return homeData.getTeams().get(0).getTeamData();
	}
	
	public void setAwayTeamData(TeamModel awayData) {
		this.awayData = awayData;
	}
	
	public void setHomeTeamData(TeamModel homeData) {
		this.homeData = homeData;
	}
}
