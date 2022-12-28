package gsonClasses;

import java.util.ArrayList;

public class TeamInfo {

	private String id;
	private String name;
	private TeamVenue venue;
	private String abbreviation;
	private String teamName;
	private String locationName;
	private String firstYearOfPlay;
	private TeamDivision division;
	private TeamConference conference;
	private Franchise franchise;
	private String shortName;
	private String officialSiteUrl;
	private String active;
	
	public ArrayList<String> getTeamData() {
		ArrayList<String> data = new ArrayList<String>();
		data.add(id);
		data.add(name);
		data.addAll(venue.getVenueData());
		data.addAll(venue.getTimeZone().getTimeZoneData());
		data.add(abbreviation);
		data.add(teamName);
		data.add(locationName);
		data.add(firstYearOfPlay);
		data.addAll(division.getDivisionData());
		data.addAll(conference.getConferenceData());
		data.addAll(franchise.getFranchiseData());
		data.add(shortName);
		data.add(officialSiteUrl);
		data.add(active);
		
		return data;
	}
}
