package gsonClasses;

import java.util.ArrayList;

public class TimeZone {

	private String id;
	private String offset;
	
	public ArrayList<String> getTimeZoneData() {
		ArrayList<String> tz = new ArrayList<>();
		tz.add(id);
		tz.add(offset);
		return tz;
	}
}
