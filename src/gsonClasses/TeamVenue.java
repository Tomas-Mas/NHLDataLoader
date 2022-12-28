package gsonClasses;

import java.util.ArrayList;

public class TeamVenue {

	private String name;
	private String city;
	private TimeZone timeZone;
	
	public TimeZone getTimeZone() {
		return timeZone;
	}
	
	public ArrayList<String> getVenueData() {
		ArrayList<String> vd = new ArrayList<>();
		vd.add(name);
		vd.add(city);
		return vd;
	}
}
