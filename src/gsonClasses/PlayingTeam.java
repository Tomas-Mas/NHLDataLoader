package gsonClasses;

public class PlayingTeam {

	private LeagueRecord leagueRecord;
	private String score;
	private TeamJson team;
	
	public String getScore() {
		return score;
	}
	
	public TeamJson getTeam() {
		return team;
	}
	
	public String getTeamId() {
		return team.getId();
	}
	
	public LeagueRecord getLeagueRecord() {
		return leagueRecord;
	}
	
	public TeamJson getTeamData() {
		return this.team;
	}
}
