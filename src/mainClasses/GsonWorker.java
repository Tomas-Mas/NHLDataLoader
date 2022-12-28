package mainClasses;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;

import com.google.gson.Gson;

import org.json.JSONArray;
import org.json.JSONObject;

import gsonClasses.GameEventModel;
import gsonClasses.GameGEM;
import gsonClasses.GoalieStats;
import gsonClasses.PlayerPM;
import gsonClasses.PlayerStats;
import gsonClasses.SkaterStats;
import gsonClasses.TeamModel;

public class GsonWorker {
	
	private static Gson gson = new Gson();
	
	public static PlayerPM getPlayerDataByPlayerId(String playerId) {
		String url = "http://statsapi.web.nhl.com/api/v1/people/" + playerId;
		String playerData = GsonWorker.readURL(url);
		PlayerPM p = new PlayerPM();
		p = gson.fromJson(playerData, PlayerPM.class);
		return p;
	}
	
	public static TeamModel getTeamDataById(String id) {
		String url = "http://statsapi.web.nhl.com/api/v1/teams/" + id;
		String teamData = GsonWorker.readURL(url);
		TeamModel tm = new TeamModel();
		tm = gson.fromJson(teamData, TeamModel.class);
		return tm;
	}
	
	public static GameEventModel getEventsDataById(JSONObject liveData) {
		//events: [Game Scheduled, Period Ready, Period Start, Faceoff, Hit, Stoppage, Shot, 
		//Blocked Shot, Missed Shot, Takeaway, Giveaway, Goal, Penalty, Period End, Period Official, Game End]
		ArrayList<String> eventTypes = new ArrayList<String>();
		eventTypes.add("Goal");
		eventTypes.add("Shot");
		eventTypes.add("Blocked Shot");
		eventTypes.add("Missed Shot");
		eventTypes.add("Penalty");
		eventTypes.add("Faceoff");
		eventTypes.add("Hit");
		eventTypes.add("Takeaway");
		eventTypes.add("Giveaway");
		GameEventModel gameEventModel = new GameEventModel();
		JSONArray allPlays = liveData.getJSONObject("plays").getJSONArray("allPlays");
		for(int i = 0; i<allPlays.length(); i++) {
			JSONObject play = allPlays.getJSONObject(i);
			String eventName = play.getJSONObject("result").getString("event");
			if(eventTypes.contains(eventName)) {
				GameGEM event = gson.fromJson(play.toString(), GameGEM.class);
				gameEventModel.addEvent(event);
			}
		}
		return gameEventModel;
	}
	
	public static JSONObject getGameDataJson(String gameId) {
		String url = "http://statsapi.web.nhl.com/api/v1/game/" + gameId + "/feed/live";
		JSONObject data = new JSONObject(GsonWorker.readURL(url));
		JSONObject liveData = data.getJSONObject("liveData");
		return liveData;
	}
	
	public static HashMap<String, ArrayList<Integer>> getListOfTeamPlayersIds(String gameId, JSONObject liveData) {
		HashMap<String, ArrayList<Integer>> ret = new HashMap<String, ArrayList<Integer>>();
		JSONObject jsonTeam = liveData.getJSONObject("boxscore").getJSONObject("teams");
		ret.put("home", getIdsFromOneTeam("home", jsonTeam));
		ret.put("away", getIdsFromOneTeam("away", jsonTeam));
		return ret;
	}
	
	public static ArrayList<PlayerStats> getPlayerStats(JSONObject liveData) {
		ArrayList<PlayerStats> playersStats = new ArrayList<PlayerStats>();
		JSONObject teams = liveData.getJSONObject("boxscore").getJSONObject("teams");
		JSONObject awayPlayers = teams.getJSONObject("away").getJSONObject("players");
		JSONObject homePlayers = teams.getJSONObject("home").getJSONObject("players");
		
		JSONObject stats = new JSONObject();
		if(awayPlayers.names() != null) {
			for(Object o : awayPlayers.names()) {
				String nodeName = o.toString();
				stats = awayPlayers.getJSONObject(nodeName).getJSONObject("stats");
				if(stats.has("skaterStats") || stats.has("goalieStats")) {
					PlayerStats playerStats = new PlayerStats();
					playerStats.putId(awayPlayers.getJSONObject(nodeName).getJSONObject("person").getInt("id"));
					if(stats.has("skaterStats") && !stats.has("goalieStats")) {
						SkaterStats skaterStats = gson.fromJson(stats.getJSONObject("skaterStats").toString(), SkaterStats.class);
						playerStats.putSkaterStats(skaterStats);
						playerStats.putGoalieStats(null);
					} else if(stats.has("goalieStats") && !stats.has("skaterStats")) {
						GoalieStats goalieStats = gson.fromJson(stats.getJSONObject("goalieStats").toString(), GoalieStats.class);
						playerStats.putGoalieStats(goalieStats);
						playerStats.putSkaterStats(null);
					} else {
						SkaterStats skaterStats = gson.fromJson(stats.getJSONObject("skaterStats").toString(), SkaterStats.class);
						playerStats.putSkaterStats(skaterStats);
						GoalieStats goalieStats = gson.fromJson(stats.getJSONObject("goalieStats").toString(), GoalieStats.class);
						playerStats.putGoalieStats(goalieStats);
					}
					playersStats.add(playerStats);
				}
			}
			for(Object o : homePlayers.names()) {
				String nodeName = o.toString();
				stats = homePlayers.getJSONObject(nodeName).getJSONObject("stats");
				if(stats.has("skaterStats") || stats.has("goalieStats")) {
					PlayerStats playerStats = new PlayerStats();
					playerStats.putId(homePlayers.getJSONObject(nodeName).getJSONObject("person").getInt("id"));
					if(stats.has("skaterStats") && !stats.has("goalieStats")) {
						SkaterStats skaterStats = gson.fromJson(stats.getJSONObject("skaterStats").toString(), SkaterStats.class);
						playerStats.putSkaterStats(skaterStats);
						playerStats.putGoalieStats(null);
					} else if(stats.has("goalieStats") && !stats.has("skaterStats")) {
						GoalieStats goalieStats = gson.fromJson(stats.getJSONObject("goalieStats").toString(), GoalieStats.class);
						playerStats.putGoalieStats(goalieStats);
						playerStats.putSkaterStats(null);
					} else {
						SkaterStats skaterStats = gson.fromJson(stats.getJSONObject("skaterStats").toString(), SkaterStats.class);
						playerStats.putSkaterStats(skaterStats);
						GoalieStats goalieStats = gson.fromJson(stats.getJSONObject("goalieStats").toString(), GoalieStats.class);
						playerStats.putGoalieStats(goalieStats);
					}
					playersStats.add(playerStats);
				}
			}
			return playersStats;
		} else {
			return null;
		}
	}
	
	public static ArrayList<Integer> getIdsFromOneTeam(String team, JSONObject jsonTeam) {
		ArrayList<Integer> players = new ArrayList<Integer>();
		JSONArray json = new JSONArray();
		
		json = jsonTeam.getJSONObject(team).getJSONArray("skaters");
		for(int i = 0; i < json.length(); i++) 
			players.add(json.getInt(i));
		json = jsonTeam.getJSONObject(team).getJSONArray("goalies");
		for(int i = 0; i < json.length(); i++)
			players.add(json.getInt(i));
		
		return players;
	}
	
	/*public static String getMatchGoalEvents (String id) {
		String matchEvents = GsonWorker.readURL("http://statsapi.web.nhl.com/api/v1/game/" + id + "/feed/live");
		String goalEvent;
		StringBuilder jsonGoals = new StringBuilder("{\n\"goals\":[");
		
		int xMiddle = 0;
		int startIndex = 0;
		int i = 0;
		
		while((xMiddle = matchEvents.indexOf("\"event\" : \"Goal\"", startIndex)) != -1) {
			//find goal event
			xMiddle = matchEvents.indexOf("\"event\" : \"Goal\"", startIndex);
			
			//put whole goal event into goalEvent string
			goalEvent = matchEvents.substring((matchEvents.lastIndexOf("{", matchEvents.lastIndexOf("\"players\"", xMiddle))),
					((startIndex = matchEvents.indexOf("\"players\"", xMiddle))));
			
			//modify goalEvent to be in valid json format
			StringBuilder sb = new StringBuilder(goalEvent);
			sb.delete((sb.indexOf("\"goals\"")), (sb.indexOf("},", sb.indexOf("\"goals\""))));
			sb.deleteCharAt(sb.indexOf(",", sb.indexOf("\"dateTime\"")));
			sb.delete(sb.indexOf("\"coordinates\""), sb.indexOf("\"team\"", sb.indexOf("\"goals\"")));
			sb.delete(sb.lastIndexOf(","), sb.length());
			goalEvent = sb.toString();
			
			//modify the resulting String to be in valid json format
			if(i == 0) {
				jsonGoals.append(goalEvent);
			}
			else if(i > 0) {
				jsonGoals.append(",\n");
				jsonGoals.append(goalEvent);
			}
			
			i++;
			//startIndex = matchEvents.indexOf("\"players\"", xMiddle);
		}
		jsonGoals.append("\n]\n}");
		
		return jsonGoals.toString();
	}*/
	
	public static String readURL(String url) {
		final String USER_AGENT = "Mozilla/5.0";
		StringBuffer response = new StringBuffer();
		
		try {
			URL obj = new URL(url);
			HttpURLConnection con = (HttpURLConnection) obj.openConnection();
			
			con.setRequestMethod("GET");
			con.setRequestProperty("User-Agent", USER_AGENT);
			if(!con.getResponseMessage().equals("OK"))
				System.out.println(con.getResponseMessage());
			
			BufferedReader input = new BufferedReader(new InputStreamReader(con.getInputStream()));
			String inputLine;
	
			while ((inputLine = input.readLine()) != null) {
				response.append(inputLine);
				response.append("\n");
			}
			input.close();
		
		} catch (Exception e) {
			System.out.println(e);
		}
		
		return response.toString();
	}
	
	public static String readFile(String path) {
		String json = new String();
		BufferedReader br = null;
		try {
			String sCurrentLine;
			br = new BufferedReader(new FileReader(path));
		
			while ((sCurrentLine = br.readLine()) != null) {
				//System.out.println(sCurrentLine);
				json += sCurrentLine + "\n";
			}
		} catch (Exception e) {
			System.out.println(e);
		}
		return json;
	}
	
	/*public static ArrayList<String> getListOfPlayersIds(String gameId) {
	//long startTime = System.currentTimeMillis();
	
	String url = "http://statsapi.web.nhl.com/api/v1/game/" + gameId + "/feed/live";
	String jfd = GsonWorker.readURL(url); //json game feed data
	
	int startIndex = jfd.indexOf("players");
	int endIndex = jfd.indexOf("venue", startIndex);
	
	ArrayList<String> playersId = new ArrayList<String>();
	String inputLine;
	String id;
	try {
	BufferedReader reader = new BufferedReader(new StringReader(jfd.substring(startIndex, endIndex)));
	while((inputLine = reader.readLine()) != null) {
		if(inputLine.contains("\"id\" :")) {
			startIndex = inputLine.indexOf(':');
			endIndex = inputLine.indexOf(',', startIndex);
			if(((id = inputLine.substring(startIndex+2, endIndex)).length()) > 3)
				playersId.add(id);
		}
	}
	
	} catch (Exception e) {
		System.out.println(e);
	}
	//System.out.println(playersId);
	//long stopTime = System.currentTimeMillis();
	//System.out.println("index code: " + (stopTime - startTime));
	return playersId;
	}*/
	
	
	/*public static PlayerPM getPlayerDataByPlayerId(int playerId) {	//pretty neat but all the conditions are pain and Gson is doing it all automatically
	String url = "http://statsapi.web.nhl.com/api/v1/people/" + playerId;
	JSONObject json = new JSONObject(GsonWorker.readURL(url)).getJSONArray("people").getJSONObject(0);
	
	PlayerPM player = new PlayerPM();
	PeoplePM people = new PeoplePM();
	
	int id = json.getInt("id");
	String firstName = json.getString("firstName");
	String lastName = json.getString("lastName");
	String primaryNumber = json.has("primaryNumber") ? json.getString("primaryNumber") : "";
	String birthDate = json.has("birthDate") ? json.getString("birthDate") : "";
	String birthCountry = json.has("birthCountry") ? json.getString("birthCountry") : "";
	
	int teamId = 0;
	String teamName = "";
	if(json.has("currentTeam")) {
		teamId = json.getJSONObject("currentTeam").has("id") ? json.getJSONObject("currentTeam").getInt("id") : 0;
		teamName = json.getJSONObject("currentTeam").has("name") ? json.getJSONObject("currentTeam").getString("name") : "";
	}
	
	String posName = "";
	String posType = "";
	String posAbbreviation = "";
	if(json.has("primaryPosition")) {
		posName = json.getJSONObject("primaryPosition").has("name") ? json.getJSONObject("primaryPosition").getString("name") : "";
		posType = json.getJSONObject("primaryPosition").has("type") ? json.getJSONObject("primaryPosition").getString("type") : "";
		posAbbreviation = json.getJSONObject("primaryPosition").has("abbreviation") ? json.getJSONObject("primaryPosition").getString("abbreviation") : "";
	}
	
	people.putPeopleData(String.valueOf(id), firstName, lastName, primaryNumber, birthDate, birthCountry, 
			String.valueOf(teamId), teamName, posName, posType, posAbbreviation);
	player.putPeople(people);
	return player;
	}*/
}
