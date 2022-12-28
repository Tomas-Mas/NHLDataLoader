package gsonClasses;

import java.util.ArrayList;

public class PlayerPM {

	private ArrayList<PeoplePM> people = new ArrayList<PeoplePM>();	//1 hrac
	
	public ArrayList<PeoplePM> getPlayer() {
		return people;
	}
	
	public ArrayList<String> getPlayerData() {
		if(people.size() > 1) {
			System.out.println("More than one player was loaded?!?");
		}
		return people.get(0).getPeopleData();
	}
}
