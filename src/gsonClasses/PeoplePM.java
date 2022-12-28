package gsonClasses;

import java.util.ArrayList;

public class PeoplePM {

	private String id;
	private String firstName;
	private String lastName;
	private String primaryNumber;
	private String birthDate;
	private String birthCountry;
	private TeamJson currentTeam = new TeamJson();
	private PositionPM primaryPosition = new PositionPM();
	
	public String getId() {
		return id;
	}
	
	public String getFirstName() {
		return firstName;
	}
	
	public String getLastName() {
		return lastName;
	}
	
	public String getPrimaryNumber() {
		return primaryNumber;
	}
	
	public String getBirthDate() {
		return birthDate;
	}
	
	public String getBirthCountry() {
		return birthCountry;
	}
	
	public TeamJson getCurrentTeam() {
		return currentTeam;
	}
	
	public PositionPM getPrimaryPosition() {
		return primaryPosition;
	}
	
	public ArrayList<String> getPeopleData() {
		ArrayList<String> pd = new ArrayList<String>();
		pd.add(id);
		pd.add(firstName);
		pd.add(lastName);
		pd.add(primaryNumber);
		pd.add(birthDate);
		pd.add(birthCountry);
		pd.add(currentTeam.getId());
		pd.addAll(primaryPosition.getPositionData());
		return pd;
	}
}