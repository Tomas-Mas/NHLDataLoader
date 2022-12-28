package gsonClasses;

import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;

import org.json.JSONObject;

import mainClasses.GsonWorker;

public class GameGM {
	
	private String gamePk;
	private String gameType;
	private String season;
	private String gameDate;
	
	private Status status;
	private TeamsGM teams;
	private Venue venue;
	
	private PlayerModel playerModel = new PlayerModel();
	
	private GameEventModel gameEventModel = new GameEventModel();
	
	private ArrayList<PlayerStats> playersStats = new ArrayList<PlayerStats>();
	
	
	public ArrayList<String> getGameData() {
		ArrayList<String> data = new ArrayList<String>();
		data.add(gamePk);
		data.add(gameType);
		data.add(season);
		data.add(gameDate);
		data.addAll(status.getStatusData());
		//data.addAll(teams.getAwayTeam().getLeagueRecord().getLeagueRecordArray());
		data.add(teams.getAwayTeam().getScore());
		data.addAll(teams.getAwayTeam().getTeam().getTeamData());
		//data.addAll(teams.getHomeTeam().getLeagueRecord().getLeagueRecordArray());
		data.add(teams.getHomeTeam().getScore());
		data.addAll(teams.getHomeTeam().getTeam().getTeamData());
		data.add(venue.getId());
		data.add(venue.getName());
		return data;
	}
	
	public String getGameId() {
		return this.gamePk;
	}
	
	public PlayerModel getPlayerModel() {
		return playerModel;
	}
	
	public GameEventModel getGameEventModel() {
		return gameEventModel;
	}
	
	public TeamsGM getTeamsGM() {
		return teams;
	}

	public ArrayList<String> getAwayTeamData() {
		return teams.getAwayTeamDetails();
	}
	
	public ArrayList<String> getHomeTeamData() {
		return teams.getHomeTeamDetails();
	}
	
	public ArrayList<PlayerStats> getPlayersStats() {
		return this.playersStats;
	}
	
	public String getGameType() {
		return this.gameType;
	}
	
	//////////////fills teams, players and game events data////////////////////
	public void findData() {
		try {
			JSONObject liveData = new JSONObject();
			liveData = GsonWorker.getGameDataJson(gamePk);
			this.teams.setAwayTeamData(GsonWorker.getTeamDataById(teams.getAwayTeam().getTeamId()));
			this.teams.setHomeTeamData(GsonWorker.getTeamDataById(teams.getHomeTeam().getTeamId()));
			this.playerModel.findPlayers(gamePk, liveData);
			this.gameEventModel = GsonWorker.getEventsDataById(liveData);
			this.playersStats = GsonWorker.getPlayerStats(liveData);
		} catch (Exception e) {
			String dateTime = new Date().toString();
			String message = dateTime + "; game id: " + this.gamePk + "; error: " + e.getMessage();
			writeErrorLog(message);
		}
	}
	
	private void writeErrorLog(String error) {
		try {
			FileWriter errLog = new FileWriter("errlog.txt", true);
			errLog.write(error + "\n");
			errLog.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
