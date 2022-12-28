package mainClasses;

import java.io.FileWriter;
import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Date;

import com.google.gson.Gson;

import gsonClasses.*;

public class Database {

	private Gson gson = new Gson();
	private String oracleConnection = "jdbc:oracle:thin:@localhost:1521:orcl";
	private String user = "c##nhl";
	private String password = "nhl";
	
	//connect to database
	public Connection createConnection() {
		Connection conn = null;
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			//conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:orcl", "c##nhl", "nhl");
			conn = DriverManager.getConnection(oracleConnection, user, password);
		} catch (Exception e) {
			e.printStackTrace();
			writeLog("errLog", "error while creating connection to db; " + e.getMessage());
		}
		return conn;
	}
	
	public void closeConnection(Connection conn) {
		try {
			if(conn != null)
				conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
			writeLog("errLog", "error while closing connection; " + e.getMessage());
		}
	}
	
	public void closeCallableStatement(CallableStatement cs) {
		try {
			if(cs != null) {
				cs.close();
			}
		} catch (SQLException e) {
			e.printStackTrace();
			writeLog("errLog", "error while closing callableStatement; " + e.getMessage());
		}
	}
	
	public void insertGamesByDate(String startDate, String endDate) {
		String url = "http://statsapi.web.nhl.com/api/v1/schedule?teamId=&startDate=" + startDate + "&endDate=" + endDate;
		String jsonText = GsonWorker.readURL(url);
		GameModel gm = new GameModel();
		gm = gson.fromJson(jsonText, GameModel.class);
		int totalGames = 0;
		int counter = 1;
		Connection conn = createConnection();
		
		System.out.println("Celkem zapasu: " + gm.getTotalItems());
		for(DateGM d : gm.getDates()){
			totalGames = Integer.parseInt(d.getTotalItems());
			counter = 1;
			System.out.println("\n" + d.getDate() + " - " + totalGames + " games");
			for(GameGM g : d.getGames()){
				System.out.println(counter + "/" + totalGames);
				counter++;
				
				/*if(!g.getGameId().equals("2015020995"))
					continue;*/
				
				//System.out.println(g.getGameData());
				if(!g.getGameType().equals("A")) {	// I dont care about all-star
					g.findData();
					
					insertGameTeam(conn, g.getAwayTeamData(), g.getHomeTeamData(), g.getGameData());
					insertPlayers(conn, g.getGameId(), g.getTeamsGM().getHomeTeam().getTeam().getId(), g.getTeamsGM().getAwayTeam().getTeam().getId(), g.getPlayerModel());
					insertEvents(conn, g.getGameId(), g.getGameEventModel().getEvents());
					insertStats(conn, g.getGameId(), g.getPlayersStats());
				}
			}
		}
		closeConnection(conn);
	}
	
	//////insert game and team//////////////////////////////////////////////////
	public void insertGameTeam(Connection conn, ArrayList<String> awayTeam, ArrayList<String> homeTeam, ArrayList<String> gameData) {
		CallableStatement cs = null;
		String insertGameTeamsStoredProc = "{call insertGameTeams(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
		
		try {
			cs = conn.prepareCall(insertGameTeamsStoredProc);
			
			//TODO access data using getters instead of arrayLists
			cs.setInt("awayJsonId", Integer.parseInt(awayTeam.get(0)));
			cs.setString("awayFullName", awayTeam.get(1));
			cs.setString("awayVenueName", awayTeam.get(2));
			cs.setString("awayVenueCity", awayTeam.get(3));
			cs.setString("awayTZName", awayTeam.get(4));
			cs.setInt("awayTZOffset", Integer.parseInt(awayTeam.get(5)));
			cs.setString("awayTeamAbbreviation", awayTeam.get(6));
			cs.setString("awayFirstNick", awayTeam.get(7));
			cs.setString("awayLocation", awayTeam.get(8));
			cs.setInt("awayFirstYear", Integer.parseInt(awayTeam.get(9)));
			cs.setInt("awayDivId", Integer.parseInt(awayTeam.get(10)));
			cs.setString("awayDivName", awayTeam.get(11));
			cs.setInt("awayConfId", Integer.parseInt(awayTeam.get(12)));
			cs.setString("awayConfName", awayTeam.get(13));
			cs.setString("awayLastNick", awayTeam.get(16));
			cs.setString("awayURL", awayTeam.get(17));
			cs.setString("awayActive", awayTeam.get(18));
			
			cs.setInt("homeJsonId", Integer.parseInt(homeTeam.get(0)));
			cs.setString("homeFullName", homeTeam.get(1));
			cs.setString("homeVenueName", homeTeam.get(2));
			cs.setString("homeVenueCity", homeTeam.get(3));
			cs.setString("homeTZName", homeTeam.get(4));
			cs.setInt("homeTZOffset", Integer.parseInt(homeTeam.get(5)));
			cs.setString("homeTeamAbbreviation", homeTeam.get(6));
			cs.setString("homeFirstNick", homeTeam.get(7));
			cs.setString("homeLocation", homeTeam.get(8));
			cs.setInt("homeFirstYear", Integer.parseInt(homeTeam.get(9)));
			cs.setInt("homeDivId", Integer.parseInt(homeTeam.get(10)));
			cs.setString("homeDivName", homeTeam.get(11));
			cs.setInt("homeConfId", Integer.parseInt(homeTeam.get(12)));
			cs.setString("homeConfName", homeTeam.get(13));
			cs.setString("homeLastNick", homeTeam.get(16));
			cs.setString("homeURL", homeTeam.get(17));
			cs.setString("homeActive", homeTeam.get(18));
			
			cs.setInt("gameJsonId", Integer.parseInt(gameData.get(0)));
			cs.setString("gameType", gameData.get(1));
			cs.setInt("gameSeason", Integer.parseInt(gameData.get(2)));
			cs.setString("gameDate", gameData.get(3));
			cs.setString("gameStatusName", gameData.get(4));
			cs.setInt("gameStatusCode", Integer.parseInt(gameData.get(5)));
			cs.setInt("gameAwayScore", Integer.parseInt(gameData.get(6)));
			cs.setInt("gameHomeScore", Integer.parseInt(gameData.get(9)));
			cs.setString("gameVenueName", gameData.get(13));
			
			cs.execute();
		} catch(Exception e) {
			e.printStackTrace();
			String dateTime = new Date().toString();
			writeLog("errLog", dateTime + ";game json id: " + gameData.get(0) + ", game date: " + 
					gameData.get(3) + ", error: " + e.getMessage());
		} finally {
			closeCallableStatement(cs);
		}
	}
	
	////////////////////////////////////////////////////////
	public void insertPlayers(Connection conn, String gameId, String homeTeamId, String awayTeamId, PlayerModel playerModel) {
		CallableStatement cs = null;
		String insertStoredProc = "{call insertPlayer(?,?,?,?,?,?,?,?,?,?,?,?)}";
		
		try {
			if(playerModel.getAwayPlayers().size() == 0) {
				String message = new Date().toString() + "; game id: " + gameId + "; No away players found";
				writeLog("infoLog", message);
			} else {
				for(PlayerPM p: playerModel.getAwayPlayers()) {
					try {
						if(p.getPlayer().size() != 1) {
							writeLog("infoLog", new Date().toString() + "game id: " + gameId + "; away team player: " + p.getPlayerData().toString());
						}
						PeoplePM player = p.getPlayer().get(0);
						cs = null;
						cs = conn.prepareCall(insertStoredProc);
						cs.setInt("pGameId", Integer.parseInt(gameId));
						cs.setInt("pTeamId", Integer.parseInt(awayTeamId));
						cs.setInt("pJsonId", Integer.parseInt(player.getId()));
						cs.setString("pFirstName", player.getFirstName());
						cs.setString("pLastName", player.getLastName());
						if(player.getPrimaryNumber() == null) {
							cs.setNull("pPrimaryNumber", Types.INTEGER);
						} else {
							cs.setInt("pPrimaryNumber", Integer.parseInt(player.getPrimaryNumber()));
						}
						cs.setString("pBirthDate", player.getBirthDate());
						cs.setString("pBirthCountry", player.getBirthCountry());
						if(player.getCurrentTeam() == null || player.getCurrentTeam().getId() == null) {
							cs.setNull("teamJsonId", Types.INTEGER);
						} else {
							cs.setInt("teamJsonId", Integer.parseInt(player.getCurrentTeam().getId()));
						}
						cs.setString("positionName", player.getPrimaryPosition().getName());
						cs.setString("positionType", player.getPrimaryPosition().getType());
						cs.setString("positionAbbreviation", player.getPrimaryPosition().getAbbreviation());
						
						cs.execute();
					} catch(Exception e) {
						e.printStackTrace();
						writeLog("errLog", new Date().toString() + "; game id: " + gameId + "; player id: " + p.getPlayer().get(0).getId() + "; error: " + e.getMessage());
					} finally {
						closeCallableStatement(cs);
					}
				}
			}
			if(playerModel.getHomePlayers().size() == 0) {
				String message = new Date().toString() + "; game id: " + gameId + "; No home players found";
				writeLog("infoLog", message);
			} else {
				for(PlayerPM p: playerModel.getHomePlayers()) {
					try {
						if(p.getPlayer().size() != 1) {
							writeLog("infoLog", new Date().toString() + "game id: " + gameId + "; home team player: " + p.getPlayerData().toString());
						}
						PeoplePM player = p.getPlayer().get(0);
						cs = null;
						
						cs = conn.prepareCall(insertStoredProc);
						cs.setInt("pGameId", Integer.parseInt(gameId));
						cs.setInt("pTeamId", Integer.parseInt(homeTeamId));
						cs.setInt("pJsonId", Integer.parseInt(player.getId()));
						cs.setString("pFirstName", player.getFirstName());
						cs.setString("pLastName", player.getLastName());
						if(player.getPrimaryNumber() == null) {
							cs.setNull("pPrimaryNumber", Types.INTEGER);
						} else {
							cs.setInt("pPrimaryNumber", Integer.parseInt(player.getPrimaryNumber()));
						}
						cs.setString("pBirthDate", player.getBirthDate());
						cs.setString("pBirthCountry", player.getBirthCountry());
						if(player.getCurrentTeam() == null || player.getCurrentTeam().getId() == null) {
							cs.setNull("teamJsonId", Types.INTEGER);
						} else {
							cs.setInt("teamJsonId", Integer.parseInt(player.getCurrentTeam().getId()));
						}
						cs.setString("positionName", player.getPrimaryPosition().getName());
						cs.setString("positionType", player.getPrimaryPosition().getType());
						cs.setString("positionAbbreviation", player.getPrimaryPosition().getAbbreviation());
						
						cs.execute();
					} catch(Exception e) {
						e.printStackTrace();
						writeLog("errLog", new Date().toString() + "; game id: " + gameId + "; player id: " + p.getPlayer().get(0).getId() + "; error: " + e.getMessage());
					} finally {
						closeCallableStatement(cs);
					}
				}
			}
		} catch(Exception e) {
			e.printStackTrace();
			writeLog("errLog", new Date().toString() + "; game id: " + gameId + "; error: " + e.getMessage());
		} finally {
			closeCallableStatement(cs);
		}
	}
	
	public void insertEvents(Connection conn, String gameId, ArrayList<GameGEM> events) {
		CallableStatement cs = null;
		String insertStoredProc = "{call insertEvent(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
		
		if(events.size() > 0) {
			for(GameGEM event : events) {
				////// who knew coaches can get penalty too :(
				if(event.getResult().getSecondaryType() != null)
					if(event.getResult().getSecondaryType().equals("Game Misconduct - Head coach")) {
						writeLog("skippedLog", "event: " + event.getEventData());
						continue;
					}
				
				try {
					//System.out.println(event.getEventData());
					cs = null;
					cs = conn.prepareCall(insertStoredProc);
					int numberOfPlayers = event.getPlayers().size();
					cs.setInt("pGameJsonId", Integer.parseInt(gameId));
					switch (numberOfPlayers) {
						case 1:
							cs.setInt("player1JsonId", Integer.parseInt(event.getPlayers().get(0).getPlayer().getId()));
							if (event.getPlayers().get(0).getPlayerType().equals("PlayerID")) {
								cs.setNull("player1Type", Types.VARCHAR);
							} else {
								cs.setString("player1Type", event.getPlayers().get(0).getPlayerType());
							}
							cs.setInt("player2JsonId", 0);
							cs.setString("player2Type", "");
							cs.setInt("player3JsonId", 0);
							cs.setString("player3Type", "");
							cs.setInt("player4JsonId", 0);
							cs.setString("player4Type", "");
							break;
						case 2:
							cs.setInt("player1JsonId", Integer.parseInt(event.getPlayers().get(0).getPlayer().getId()));
							if(event.getPlayers().get(0).getPlayerType().equals("PlayerID")) {
								cs.setNull("player1Type", Types.VARCHAR);
							} else {
								cs.setString("player1Type", event.getPlayers().get(0).getPlayerType());
							}
							cs.setInt("player2JsonId", Integer.parseInt(event.getPlayers().get(1).getPlayer().getId()));
							if(event.getPlayers().get(1).getPlayerType().equals("PlayerID")) {
								cs.setNull("player2Type", Types.VARCHAR);
							} else {
								cs.setString("player2Type", event.getPlayers().get(1).getPlayerType());
							}
							cs.setInt("player3JsonId", 0);
							cs.setString("player3Type", "");
							cs.setInt("player4JsonId", 0);
							cs.setString("player4Type", "");
							break;
						case 3:
							cs.setInt("player1JsonId", Integer.parseInt(event.getPlayers().get(0).getPlayer().getId()));
							if(event.getPlayers().get(0).getPlayerType().equals("PlayerID")) {
								cs.setNull("player1Type", Types.VARCHAR);
							} else {
								cs.setString("player1Type", event.getPlayers().get(0).getPlayerType());
							}
							cs.setInt("player2JsonId", Integer.parseInt(event.getPlayers().get(1).getPlayer().getId()));
							if(event.getPlayers().get(1).getPlayerType().equals("PlayerID")) {
								cs.setNull("player2Type", Types.VARCHAR);
							} else {
								cs.setString("player2Type", event.getPlayers().get(1).getPlayerType());
							}
							cs.setInt("player3JsonId", Integer.parseInt(event.getPlayers().get(2).getPlayer().getId()));
							if(event.getPlayers().get(2).getPlayerType().equals("PlayerID")) {
								cs.setNull("player3Type", Types.VARCHAR);
							} else {
								cs.setString("player3Type", event.getPlayers().get(2).getPlayerType());
							}
							cs.setInt("player4JsonId", 0);
							cs.setString("player4Type", "");
							break;
						case 4:
							cs.setInt("player1JsonId", Integer.parseInt(event.getPlayers().get(0).getPlayer().getId()));
							if(event.getPlayers().get(0).getPlayerType().equals("PlayerID")) {
								cs.setNull("player1Type", Types.VARCHAR);
							} else {
								cs.setString("player1Type", event.getPlayers().get(0).getPlayerType());
							}
							cs.setInt("player2JsonId", Integer.parseInt(event.getPlayers().get(1).getPlayer().getId()));
							if(event.getPlayers().get(1).getPlayerType().equals("PlayerID")) {
								cs.setNull("player2Type", Types.VARCHAR);
							} else {
								cs.setString("player2Type", event.getPlayers().get(1).getPlayerType());
							}
							cs.setInt("player3JsonId", Integer.parseInt(event.getPlayers().get(2).getPlayer().getId()));
							if(event.getPlayers().get(2).getPlayerType().equals("PlayerID")) {
								cs.setNull("player3Type", Types.VARCHAR);
							} else {
								cs.setString("player3Type", event.getPlayers().get(2).getPlayerType());
							}
							cs.setInt("player4JsonId", Integer.parseInt(event.getPlayers().get(3).getPlayer().getId()));
							if(event.getPlayers().get(3).getPlayerType().equals("PlayerID")) {
								cs.setNull("player4Type", Types.VARCHAR);
							} else {
								cs.setString("player4Type", event.getPlayers().get(3).getPlayerType());
							}
							break;
						default:
							String dateTime = new Date().toString();
							writeLog("errLog", dateTime + ";game json id: " + gameId + ", event: " + event.getAbout().getEventId() + " - " + 
									event.getResult().getEvent() + "wrong amount of players involving in event: " + numberOfPlayers);
						}
					cs.setString("eventName", event.getResult().getEvent());
					if(event.getResult().getSecondaryType() == null) {
						cs.setNull("eventSecondaryType", Types.VARCHAR);
					} else {
						cs.setString("eventSecondaryType", event.getResult().getSecondaryType());
					}
					if(event.getResult().getStrength().getName() == null) {
						cs.setNull("goalStrength", Types.VARCHAR);
					} else {
						cs.setString("goalStrength", event.getResult().getStrength().getName());
					}
					if(event.getResult().getEmptyNet() == null) {
						cs.setNull("goalEmptyNet", Types.VARCHAR);
					} else {
						cs.setString("goalEmptyNet", event.getResult().getEmptyNet());
					}
					if(event.getResult().getPenaltySeverity() == null) {
						cs.setNull("pPenaltySeverity", Types.VARCHAR);
					} else {
						cs.setString("pPenaltySeverity", event.getResult().getPenaltySeverity());
					}
					if(event.getResult().getPenaltyMinutes() == null) {
						cs.setNull("pPenaltyMinutes", Types.INTEGER);
					} else {
						cs.setInt("pPenaltyMinutes", Integer.parseInt(event.getResult().getPenaltyMinutes()));
					}
					cs.setInt("ingameEventId", Integer.parseInt(event.getAbout().getEventId()));
					cs.setInt("periodNum", Integer.parseInt(event.getAbout().getPeriod()));
					cs.setString("pPeriodType", event.getAbout().getPeriodType());
					cs.setString("pPeriodTime", event.getAbout().getPeriodTime());
					if(event.getCoordinates().getX() == null) {
						cs.setNull("pCoordX", Types.INTEGER);
					} else {
						cs.setInt("pCoordX", Integer.parseInt(event.getCoordinates().getX()));
					}
					if(event.getCoordinates().getY() == null) {
						cs.setNull("pCoordY", Types.INTEGER);
					} else {
						cs.setInt("pCoordY", Integer.parseInt(event.getCoordinates().getY()));
					}
					cs.execute();
				} catch(Exception e) {
					e.printStackTrace();
					String dateTime = new Date().toString();
					writeLog("errLog", event.getEventData() +"\n" +  dateTime + ";game json id: " + gameId + ", event: " + event.getAbout().getEventId() + 
							" - " + event.getResult().getEvent() + ", error: " + e.getMessage());
				} finally {
					closeCallableStatement(cs);
				}
			}
		} else {
			String message = new Date().toString() + "; game id: " + gameId + "; no events found";
			writeLog("infoLog", message);
		}
	}
	
	public void insertStats(Connection conn, String gameId, ArrayList<PlayerStats> playerStats) {
		if(playerStats == null) {
			String message = new Date().toString() + "; game id: " + gameId + "; no player stats found";
			writeLog("infoLog", message);
		} else {
			CallableStatement cs = null;
			String insertStoredProc = "{call insertPlayerStats(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
			
			for(PlayerStats ps : playerStats) {
				try {
					cs = null;
					cs = conn.prepareCall(insertStoredProc);
					cs.setInt("gameJsonId", Integer.parseInt(gameId));
					cs.setInt("playerJsonId", ps.getId());
					if(ps.getGoalieStats() == null) {
						cs.setNull("gTimeOnIce", Types.VARCHAR);
						cs.setNull("gPenaltyMinutes", Types.INTEGER);
						cs.setNull("gShots", Types.INTEGER);
						cs.setNull("gSaves", Types.INTEGER);
						cs.setNull("gPpShots", Types.INTEGER);
						cs.setNull("gPpSaves", Types.INTEGER);
						cs.setNull("gShShots", Types.INTEGER);
						cs.setNull("gShSaves", Types.INTEGER);
					} else {
						cs.setString("gTimeOnIce", ps.getGoalieStats().getTimeOnIce());
						cs.setInt("gPenaltyMinutes", ps.getGoalieStats().getPim());
						cs.setInt("gShots", ps.getGoalieStats().getShots());
						cs.setInt("gSaves", ps.getGoalieStats().getSaves());
						cs.setInt("gPpShots", ps.getGoalieStats().getPowerPlayShotsAgainst());
						cs.setInt("gPpSaves", ps.getGoalieStats().getPowerPlaySaves());
						cs.setInt("gShShots", ps.getGoalieStats().getShortHandedShotsAgainst());
						cs.setInt("gShSaves", ps.getGoalieStats().getShortHandedSaves());
					}
					if(ps.getSkaterStats() == null) {
						cs.setNull("sTimeOnIce", Types.VARCHAR);
						cs.setNull("sPpTimeOnIce", Types.VARCHAR);
						cs.setNull("sShTimeOnIce", Types.VARCHAR);
						cs.setNull("sPenaltyMinutes", Types.INTEGER);
						cs.setNull("sPlusMinus", Types.INTEGER);
					} else {
						cs.setString("sTimeOnIce", ps.getSkaterStats().getTimeOnIce());
						cs.setString("sPpTimeOnIce", ps.getSkaterStats().getPowerPlayTimeOnIce());
						cs.setString("sShTimeOnIce", ps.getSkaterStats().getShortHandedTimeOnIce());
						cs.setInt("sPenaltyMinutes", ps.getSkaterStats().getPenaltyMinutes());
						cs.setInt("sPlusMinus", ps.getSkaterStats().getPlusMinus());
					}
					cs.execute();
				} catch(Exception e) {
					e.printStackTrace();
					String dateTime = new Date().toString();
					writeLog("errLog", dateTime + ";game json id: " + gameId + "; player: " + ps.getId() + "; error: " + e.getMessage());
				} finally {
					closeCallableStatement(cs);
				}
			}
		}
	}
	
	///////////////////////////////////////////////////
	private void writeLog(String typeOfMessage, String error) {
		try {
			FileWriter errLog = new FileWriter(typeOfMessage + ".txt", true);
			errLog.write(error + "\n\n");
			errLog.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	//tiny error debugging
	public void printCursorsCount(Connection conn) {
		Statement st = null;
		try {
			st = conn.createStatement();
			String sql = "SELECT sid,user_name, COUNT(*) \"Cursors per session\" FROM v$open_cursor GROUP BY sid,user_name having user_name = 'C##NHL'";
			ResultSet rs = st.executeQuery(sql);
			while (rs.next()) {
				System.out.println(rs.getInt(1) + "  " + rs.getString(2) + " " + rs.getInt(3));
			}
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			try {
				st.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
	
	public void getOpenCursors(Connection conn) {
		Statement st = null;
		try {
			st = conn.createStatement();
			String sql = "select sid, user_name, sql_text, last_sql_active_time, cursor_type from v$open_cursor where last_sql_active_time is not null order by last_sql_active_time desc";
			ResultSet rs = st.executeQuery(sql);
			while (rs.next()) {
				writeLog("cursor", (rs.getInt(1) + "  " + rs.getString(2) + " " + rs.getString(3) + " " + rs.getDate(4) + " " + rs.getString(5)));
			}
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			try {
				st.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
	
	public void getCursorCount(Connection conn) {
		Statement st = null;
		try {
			st = conn.createStatement();
			String sql = "SELECT sid,user_name, COUNT(*) \"Cursors per session\" FROM v$open_cursor GROUP BY sid,user_name";
			ResultSet rs = st.executeQuery(sql);
			while (rs.next()) {
				writeLog("count", (rs.getInt(1) + "  " + rs.getString(2) + " " + rs.getInt(3)));
			}
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			try {
				st.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
	
	///////////////////////////////////////////////////
/*	public void easyQuery() throws SQLException {
		Connection conn = null;
		conn = createConnection();
		
		Statement st = conn.createStatement();
		String sql = "select * from teams";
		ResultSet rs = st.executeQuery(sql);
		
		while (rs.next()) {
			System.out.println(rs.getInt(1) + "  " + rs.getString(2) + " " + rs.getString(3));
		}
		
		conn.close();
		System.out.println("Success!!!!");
	}
	
	///////////////////////////////////////////////////
	public void easyProc() throws SQLException {
		Connection conn = null;
		CallableStatement cs = null;
		String insertStoredProc = "{call insertPlayer(?,?,?,?,?,?,?,?,?,?,?,?,?)}";
		
		try {
			conn = createConnection();
			cs = conn.prepareCall(insertStoredProc);
			
			cs.setInt(1, 8470187);
			cs.setString(2, "Johnny");
			cs.setString(3, "Boychuk");
			cs.setInt(4, 55);
			cs.setString(5, "1984-01-19");
			cs.setString(6, "CAN");
			cs.setString(7, "true");
			cs.setString(8, "Y");
			cs.setInt(9, 2);
			cs.setString(10, "New York Islanders");
			cs.setString(11, "Defenseman");
			cs.setString(12, "Defenseman");
			cs.setString(13, "D");
			
			cs.executeUpdate();
			
			System.out.println("Item succesfully added to db");
			
		} catch(Exception e) {
			System.out.println(e.getMessage());
		} finally {
			if(cs != null)
				cs.close();
			if(conn != null)
				conn.close();
		}
	}*/
}
