package gsonClasses;

import java.util.ArrayList;

public class GameModel {

	private String totalItems;
	ArrayList<DateGM> dates = new ArrayList<>();
	
	
	public String getTotalItems() {
		return totalItems;
	}
	
	public ArrayList<DateGM> getDates() {
		return dates;
	}
}
