package gsonClasses;

import java.util.ArrayList;

public class PositionPM {

	private String name;
	private String type;
	private String abbreviation;
	
	public String getName() {
		return name;
	}
	
	public String getType() {
		return type;
	}
	
	public String getAbbreviation() {
		return abbreviation;
	}

	public ArrayList<String> getPositionData() {
		ArrayList<String> pd = new ArrayList<String>();
		pd.add(name);
		pd.add(type);
		pd.add(abbreviation);
		return pd;
	}
	
	public void putPositionPM(String name, String type, String abbreviation) {
		this.name = name;
		this.type = type;
		this.abbreviation = abbreviation;
	}
}