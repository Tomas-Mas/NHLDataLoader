package gsonClasses;

import java.util.ArrayList;
import java.util.HashMap;

import org.json.JSONObject;

import mainClasses.GsonWorker;

public class PlayerModel {

	private ArrayList<PlayerPM> homePlayers = new ArrayList<PlayerPM>();	//pole hracu
	private ArrayList<PlayerPM> awayPlayers = new ArrayList<PlayerPM>();
	
	
	public ArrayList<PlayerPM> getHomePlayers() {
		return homePlayers;
	}
	
	public ArrayList<PlayerPM> getAwayPlayers() {
		return awayPlayers;
	}
	
	public void findPlayers(String gameId, JSONObject liveData) {
		HashMap<String, ArrayList<Integer>> playersId = GsonWorker.getListOfTeamPlayersIds(gameId, liveData);
		ArrayList<PlayerThread> threadsWithHomePlayers = new ArrayList<PlayerThread>();
		ArrayList<PlayerThread> threadsWithAwayPlayers = new ArrayList<PlayerThread>();
		
		
		for(int i : playersId.get("home")) {
			PlayerThread t = new PlayerThread(i);
			t.start();
			threadsWithHomePlayers.add(t);
		}
		for(int i : playersId.get("away")) {
			PlayerThread t = new PlayerThread(i);
			t.start();
			threadsWithAwayPlayers.add(t);
		}
		for(PlayerThread thread : threadsWithHomePlayers) {
			try {
				thread.join();
				this.homePlayers.add(thread.getPlayer());
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
		for(PlayerThread thread : threadsWithAwayPlayers) {
			try {
				thread.join();
				this.awayPlayers.add(thread.getPlayer());
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
	}
}

class PlayerThread extends Thread {
	int playerId;
	PlayerPM playerData;
	
	public PlayerThread(int id) {
		this.playerId = id;
		this.playerData = new PlayerPM();
	}
	
	public void run() {
		this.playerData = GsonWorker.getPlayerDataByPlayerId(String.valueOf(playerId));
	}
	public PlayerPM getPlayer() {
		return this.playerData;
	}
}