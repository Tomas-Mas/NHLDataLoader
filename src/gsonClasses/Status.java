package gsonClasses;

import java.util.ArrayList;

public class Status {
	private String detailedState;
	private String statusCode;
	
	
	public void print() {
		System.out.println("Status: " + "state: " + detailedState + ", statusCode: " + statusCode);
	}
	
	public String getDetailedState() {
		return detailedState;
	}
	
	public String getStatusCode() {
		return statusCode;
	}
	
	public ArrayList<String> getStatusData() {
		ArrayList<String> sd = new ArrayList<>();
		sd.add(detailedState);
		sd.add(statusCode);
		return sd;
	}
}
