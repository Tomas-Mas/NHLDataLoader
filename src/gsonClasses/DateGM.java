package gsonClasses;

import java.util.ArrayList;

public class DateGM {

	private String date;
	private String totalItems;
	ArrayList<GameGM> games = new ArrayList<>();
	
	
	public String getDate() {
		return date;
	}
	
	public String getTotalItems() {
		return totalItems;
	}
	
	public ArrayList<GameGM> getGames() {
		return games;
	}
}
