package gsonClasses;

import java.util.ArrayList;

public class GameGEM {

	private ArrayList<PlayerGEM> players = new ArrayList<PlayerGEM>();
	private ResultGEM result = new ResultGEM();
	private AboutGEM about = new AboutGEM();
	private Coordinates coordinates = new Coordinates();
	
	public ArrayList<PlayerGEM> getPlayers() {
		return this.players;
	}
	
	public ResultGEM getResult() {
		return this.result;
	}
	
	public AboutGEM getAbout() {
		return this.about;
	}
	
	public Coordinates getCoordinates() {
		return this.coordinates;
	}
	
	public ArrayList<String> getEventData() {
		ArrayList<String> gd = new ArrayList<String>();
		for(PlayerGEM player : players) {
			gd.add(player.getPlayer().getId());
			gd.add(player.getPlayerType());
		}
		gd.add(result.getEvent());
		//gd.add(result.getStrength().getName());
		gd.add(result.getSecondaryType());
		gd.add(result.getStrength().getName());
		gd.add(result.getEmptyNet());
		gd.add(result.getPenaltySeverity());
		gd.add(result.getPenaltyMinutes());
		//gd.add(result.getEmptyNet());
		gd.add(about.getEventId());
		gd.add(about.getPeriod());
		gd.add(about.getPeriodType());
		gd.add(about.getPeriodTime());
		gd.add(coordinates.getX());
		gd.add(coordinates.getY());
		return gd;
	}
}
