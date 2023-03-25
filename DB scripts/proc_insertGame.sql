create or replace procedure insertGameTeams (
    --away team = id, name, venue name, venue city, timezone name, timezone offset, abbreviation, 'nickname firstname?', team city, first year played, div id, div name, 
    --conference id, conference name, franchise id, franchise name, another 'nickname surname?', url, active
    awayJsonId IN integer,
    awayFullName in varchar2,
    awayVenueName in varchar2,
    awayVenueCity in varchar2,
    awayTZName in varchar2,
    awayTZOffset in integer,
    awayTeamAbbreviation in varchar2,
    awayFirstNick in varchar2,
    awayLocation in varchar2,
    awayFirstYear in integer,
    awayDivId in integer,
    awayDivName in varchar2,
    awayConfId in integer,
    awayConfName in varchar2,
    awayLastNick in varchar2,
    awayURL in varchar2,
    awayActive in varchar2,
    --home team
    homeJsonId IN integer,
    homeFullName in varchar2,
    homeVenueName in varchar2,
    homeVenueCity in varchar2,
    homeTZName in varchar2,
    homeTZOffset in integer,
    homeTeamAbbreviation in varchar2,
    homeFirstNick in varchar2,
    homeLocation in varchar2,
    homeFirstYear in integer,
    homeDivId in integer,
    homeDivName in varchar2,
    homeConfId in integer,
    homeConfName in varchar2,
    homeLastNick in varchar2,
    homeURL in varchar2,
    homeActive in varchar2,
    --game data = jsonid, gameType, season, gamedate, statusName, statusCode, awayScore, awayJsonId, awayName, homeScore, homeJsonId, homeName, venueJsonId, venueName
    gameJsonId in integer,
    gameType in varchar2,
    gameSeason in integer,
    gameDate in varchar2,
    gameStatusName in varchar2,
    gameStatusCode in integer,
    gameAwayScore in integer,
    gameHomeScore in integer,
    gameVenueName in varchar2
    )
AS
    dHomeDivTeams_id number;  --division_teams id
    dHomeConfTeams_id number; --conference_teams id
    dAwayDivTeams_id number;
    dAwayConfTeams_id number;
    dHomeTeamT_id number; --team id
    dAwayTeamT_id number;
    dHomeVenueId number;
    dAwayVenueId number;
    dGameVenueId number;
    dHomeDivId number;  --division.id
    dHomeConfId number; --conference.id
    dAwayDivId number;
    dAwayConfId number;
    dHomeTZId number;
    dAwayTZId number;

Begin
    savepoint insertGame_start;

    --gameStatus
    IF gameStatusExist(gameStatusCode) = false THEN
        insert into gameStatus(code, name) values(gameStatusCode, gameStatusName);
    END IF ;

    --Venues
    IF venueNameExist(gameVenueName) = false then
        insert into venues (name) values(gameVenueName);
    end if;

    if gameVenueName != homeVenueName then
        if venueNameExist(homeVenueName) = false then
            insert into venues(name, city) values(homeVenueName, homeVenueCity);
        end if;
    end if;
    select v_id into dHomeVenueId from venues where name = homeVenueName;

    if venueNameExist(awayVenueName) = false then
        insert into venues(name, city) values (awayVenueName, awayVenueCity);
    end if;
    select v_id into dAwayVenueId from venues where name = awayVenueName;

    if gameVenueName = homeVenueName then
        update venues set city = homeVenueCity
            where venues.v_id = dHomeVenueId and rownum = 1;
    end if;

    select COALESCE(MAX(v_id), 0) into dGameVenueId FROM venues WHERE name = gameVenueName;

    --Divisions
    if homeDivId = awayDivId then
        if divisionExist(homeDivId) = false then
            insert into divisions(d_jsonId, name) values (homeDivId, homeDivName);
        end if;
    else
        if divisionExist(homeDivId) = false then
            insert into divisions(d_jsonId, name) values (homeDivId, homeDivName);
        end if;
        if divisionExist(awayDivId) = false then
            insert into divisions(d_jsonId, name) values (awayDivId, awayDivName);
        end if;
    end if;

    --conferences
    if homeConfId = awayConfId then
        if conferenceExist(homeConfId) = false then
            insert into conferences(c_jsonId, name) values (homeConfId, homeConfName);
        end if;
    else
        if conferenceExist(homeConfId) = false then
            insert into conferences(c_jsonId, name) values (homeConfId, homeConfName);
        end if;
        if conferenceExist(awayConfId) = false then
            insert into conferences(c_jsonId, name) values (awayConfId, AwayConfName);
        end if;
    end if;

    --conference_division
    select d_id into dHomeDivId from divisions where d_jsonId = homeDivId;
    select d_id into dAwayDivId from divisions where d_jsonId = awayDivId;
    select c_id into dHomeConfId from conferences where c_jsonId = homeConfId;
    select c_id into dAwayConfId from conferences where c_jsonId = awayConfId;

    if dHomeConfId = dAwayConfId AND dHomeDivId = dAwayDivId then
        if conferenceDivisionExist(dHomeConfId, dHomeDivId, gameSeason) = false then
            insert into conference_division (conference_id, division_id, season) values (dHomeConfId, dHomeDivId, gameSeason);
        end if;
    else
        if conferenceDivisionExist(dHomeConfId, dHomeDivId, gameSeason) = false then
            insert into conference_division (conference_id, division_id, season) values (dHomeConfId, dHomeDivId, gameSeason);
        end if;
        if conferenceDivisionExist(dAwayConfId, dAwayDivId, gameSeason) = false then
            insert into conference_division (conference_id, division_id, season) values (dAwayConfId, dAwayDivId, gameSeason);
        end if;
    end if;

    --timeZones
    if homeTZName = awayTZName then
        if timeZoneExist(homeTZName) = false then
            insert into timeZones(name, offset) values (homeTZName, homeTZOffset);
        end if;
    else
        if timezoneexist(homeTZName) = false then
            insert into timeZones(name, offset) values (homeTZName, homeTZOffset);
        end if;
        if timezoneExist(awayTZName) = false then
            insert into timeZones(name, offset) values (awayTZName, awayTZOffset);
        end if;
    end if;

    select tz_id into dHomeTZId from timeZones where name = homeTZName;
    select tz_id into dAwayTZId from timeZones where name = awayTZName;

    --Teams home team
    if teamExist(homeJsonId) = false then
        dHomeTeamT_id := seq_team.nextVal;    --teams.t_id
        dHomeDivTeams_id := seq_divisionTeams.nextVal;    --division_teams.dt_id
        dHomeConfTeams_id := seq_conferenceTeams.nextVal; --conference_teams.ct_id
        insert into division_Teams (dt_id, division_id, team_id, season) values (dHomeDivTeams_id, dHomeDivId, dHomeTeamT_id, gameSeason);
        insert into conference_Teams (ct_id, conference_id, team_id, season) values(dHomeConfTeams_id, dHomeConfId, dHomeTeamT_id, gameSeason);
        insert into teams(t_id, t_jsonId, name, abbreviation, teamName, shortName, venueId, timeZoneId, location, firstYear, divisionId, conferenceId, active)
            values (dHomeTeamT_id, homeJsonId, homeFullName, homeTeamAbbreviation, homeLastNick, homeFirstNick, dHomeVenueId, dHomeTZId, homeLocation, homeFirstYear, dHomeDivTeams_id, dHomeConfTeams_id, homeActive);
    else --team already exists - need to check if division is correct
        select t_id into dHomeTeamT_id from teams where t_jsonId = homeJsonId;
        select divisionId into dHomeDivTeams_id from teams where t_id = dHomeTeamT_id;
        if divisionTeamsMatches(dHomeDivTeams_id, gameSeason) = false then      --division_Teams doesnt match teams.divisionId
            dHomeDivTeams_id := divisionTeamsExist(dHomeTeamT_id, dHomeDivId, gameSeason);
            if dHomeDivTeams_id = 0 then        --new entry in division_Teams
                dHomeDivTeams_id := seq_divisionTeams.nextVal;
                insert into division_Teams (dt_id, division_id, team_id, season) values (dHomeDivTeams_id, dHomeDivId, dHomeTeamT_id, gameSeason);
                update teams set divisionId = dHomeDivTeams_id where t_id = dHomeTeamT_id;
            else
                update teams set divisionId = dHomeDivTeams_id where t_id = dHomeTeamT_id;
            end if;
        end if;
        select conferenceId into dHomeConfTeams_id from teams where t_id = dHomeTeamT_id;
        if conferenceTeamsMatches(dHomeConfTeams_id, gameSeason) = false then
            dHomeConfTeams_id := conferenceTeamsExist(dHomeTeamT_id, dHomeConfId, gameSeason);
            if dHomeConfTeams_id = 0 then
                dHomeConfTeams_id := seq_conferenceTeams.nextVal;
                insert into conference_Teams (ct_id, conference_id, team_id, season) values ( dHomeConfTeams_id, dHomeConfId, dHomeTeamT_id, gameSeason);
                update teams set conferenceId = dHomeConfTeams_id where t_id = dHomeTeamT_id;
            else
                update teams set conferenceId = dHomeConfTeams_id where t_id = dHomeTeamT_id;
            end if;
        end if;
    end if;

    --Teams away team
    if teamExist(awayJsonId) = false then
        dAwayTeamT_id := seq_team.nextVal;    --teams.t_id
        dAwayDivTeams_id := seq_divisionTeams.nextVal;    --division_teams.dt_id
        dAwayConfTeams_id := seq_conferenceTeams.nextVal; --conference_teams.ct_id
        insert into division_Teams (dt_id, division_id, team_id, season) values (dAwayDivTeams_id, dAwayDivId, dAwayTeamT_id, gameSeason);
        insert into conference_Teams (ct_id, conference_id, team_id, season) values(dAwayConfTeams_id, dAwayConfId, dAwayTeamT_id, gameSeason);
        insert into teams(t_id, t_jsonId, name, abbreviation, teamName, shortName, venueId, timeZoneId, location, firstYear, divisionId, conferenceId, active)
            values (dAwayTeamT_id, awayJsonId, awayFullName, awayTeamAbbreviation, awayLastNick, awayFirstNick, dAwayVenueId, dAwayTZId, awayLocation, awayFirstYear, dAwayDivTeams_id, dAwayConfTeams_id, awayActive);
    else --team already exists - need to check if division is correct
        select t_id into dAwayTeamT_id from teams where t_jsonId = awayJsonId;
        select divisionId into dAwayDivTeams_id from teams where t_id = dAwayTeamT_id;
        if divisionTeamsMatches(dAwayDivTeams_id, gameSeason) = false then      --division_Teams doesnt match teams.divisionId
            dAwayDivTeams_id := divisionTeamsExist(dAwayTeamT_id, dAwayDivId, gameSeason);
            if dAwayDivTeams_id = 0 then        --new entry in division_Teams
                dAwayDivTeams_id := seq_divisionTeams.nextVal;
                insert into division_Teams (dt_id, division_id, team_id, season) values (dAwayDivTeams_id, dAwayDivId, dAwayTeamT_id, gameSeason);
                update teams set divisionId = dAwayDivTeams_id where t_id = dAwayTeamT_id;
            else
                update teams set divisionId = dAwayDivTeams_id where t_id = dAwayTeamT_id;
            end if;
        end if;
        select conferenceId into dAwayConfTeams_id from teams where t_id = dAwayTeamT_id;
        if conferenceTeamsMatches(dAwayConfTeams_id, gameSeason) = false then
            dAwayConfTeams_id := conferenceTeamsExist(dAwayTeamT_id, dAwayConfId, gameSeason);
            if dAwayConfTeams_id = 0 then
                dAwayConfTeams_id := seq_conferenceTeams.nextVal;
                insert into conference_Teams (ct_id, conference_id, team_id, season) values ( dAwayConfTeams_id, dAwayConfId, dAwayTeamT_id, gameSeason);
                update teams set conferenceId = dAwayConfTeams_id where t_id = dAwayTeamT_id;
            else
                update teams set conferenceId = dAwayConfTeams_id where t_id = dAwayTeamT_id;
            end if;
        end if;
    end if;

    --Games
    if gameExist(gameJsonId) = false then
        insert into games (g_jsonId, gameType, season, gameDate, awayScore, awayTeamId, homeScore, homeTeamId, venueId, gameStatus)
            values (gameJsonId, gameType, gameSeason, to_date(gameDate, 'YYYY-MM-DD"T"HH24:MI:SS"Z"'), gameAwayScore, dAwayTeamT_id, gameHomeScore, dHomeTeamT_id, dGameVenueId, gameStatusCode);
    end if;

EXCEPTION
  WHEN OTHERS THEN
  ROLLBACK TO insertGame_start;
  RAISE;
END;
