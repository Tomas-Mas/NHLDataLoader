package gsonClasses;

public class ResultGEM {

	private String event;
	private String secondaryType;
	private String penaltySeverity;
	private String penaltyMinutes;
	private StrengthGEM strength = new StrengthGEM();
	private String emptyNet;
	
	public String getEvent() {
		return this.event;
	}
	
	public String getSecondaryType() {
		return this.secondaryType;
	}
	
	public String getPenaltySeverity() {
		return this.penaltySeverity;
	}
	
	public String getPenaltyMinutes() {
		return this.penaltyMinutes;
	}
	
	public StrengthGEM getStrength() {
		return this.strength;
	}
	
	public String getEmptyNet() {
		return this.emptyNet;
	}
}
