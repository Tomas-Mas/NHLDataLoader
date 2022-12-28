package mainClasses;

public class Run {

	public static void main(String[] args) {
		Database db = new Database();
		//2015-2016 season
		//db.insertGamesByDate("2015-09-19", "2015-10-06"); // preparation
		//db.insertGamesByDate("2015-10-07", "2016-04-12"); // main
		//db.insertGamesByDate("2016-04-13", "2016-06-15"); // play off
		db.insertGamesByDate("2015-09-20", "2015-09-21");
	}
}
