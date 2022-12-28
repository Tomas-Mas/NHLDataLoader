package gsonClasses;

public class PlayerStats {
	private int id;
	
	private SkaterStats skaterStats = new SkaterStats();
	private GoalieStats goalieStats = new GoalieStats();
	
	public void putId(int id) {
		this.id = id;
	}
	
	public void putSkaterStats(SkaterStats skaterStats) {
		this.skaterStats = skaterStats;
	}
	
	public void putGoalieStats(GoalieStats goalieStats) {
		this.goalieStats = goalieStats;
	}
	
	public int getId() {
		return this.id;
	}
	
	public SkaterStats getSkaterStats() {
		return this.skaterStats;
	}
	
	public GoalieStats getGoalieStats() {
		return this.goalieStats;
	}
}
