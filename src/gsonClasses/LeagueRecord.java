package gsonClasses;

import java.util.ArrayList;

public class LeagueRecord {

	private String wins;
	private String losses;
	private String ot;
	private String type;
	
	public void print() {
		System.out.println("League record of team is: " + wins + " wins, " + losses + " losses, " + ot + " ot losses. Liga=" + type);
	}
	
	public ArrayList<String> getLeagueRecordArray() {
		ArrayList<String> lr = new ArrayList<>();
		lr.add(wins);
		lr.add(losses);
		lr.add(ot);
		lr.add(type);
		return lr;
	}
}
