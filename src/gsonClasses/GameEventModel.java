package gsonClasses;

import java.util.ArrayList;

public class GameEventModel {
	
	private ArrayList<GameGEM> events = new ArrayList<GameGEM>();
	
	public ArrayList<GameGEM> getEvents() {
		return events;
	}
	
	public void addEvent(GameGEM event) {
		this.events.add(event);
	}
}
