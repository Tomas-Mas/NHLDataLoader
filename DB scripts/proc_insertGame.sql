CREATE OR REPLACE PROCEDURE insertGame
  (jsonId IN number, gameType IN varchar2, season IN number, gameDate IN Varchar2, gameStatus IN varchar2,
  awayScore IN number, awayId IN number, homeScore IN number, homeId IN number, venueName IN varchar2)
AS
venueId number;
aId number;
hId number;
BEGIN
  SAVEPOINT insertGame_start;
  
  SELECT COALESCE(MAX(v_id), 0) into venueId FROM venues WHERE name = venueName;
  SELECT t_id into aId FROM teams WHERE t_jsonID = awayId;
  SELECT t_id into hId FROM teams WHERE t_jsonId = homeId;

  IF gameExist(jsonId) = false THEN
    insert into games(g_jsonId, gameType, season, gameDate, awayScore, awayTeamId, homeScore, homeTeamId, venueId, gameStatus) 
      values(jsonId, gameType, season, TO_DATE(gameDate, 'YYYY-MM-DD"T"HH24:MI:SS"Z"'), awayScore, aId, homeScore, hId, venueId, gameStatus);
  END IF ;

EXCEPTION
  WHEN OTHERS THEN
  ROLLBACK TO insertGame_start;
  RAISE;
END;


EXECUTE insertGame(2015020716, 'R', 20152016, '2016-04-10T23:00:00Z', 'Final', 5, 4, 2, 2, 'Barclays Center');

select * from venues;
select * from games
select * from teams;