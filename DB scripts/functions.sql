create or replace function timeZoneExist ( tzName IN VARCHAR2 ) return boolean 
is
  res boolean := false;
begin
  for c1 in ( select 1 from timeZones where name = tzName and rownum = 1 ) loop
    res := true;
    exit; -- only care about one record, so exit.
  end loop;
  return( res );
end timeZoneExist;

/

create or replace function GameStatusExist ( statusCode IN number ) return boolean 
is
  res boolean := false;
begin
  for c1 in ( select 1 from gameStatus where code = statusCode and rownum = 1 ) loop
    res := true;
    exit; -- only care about one record, so exit.
  end loop;
  return( res );
end GameStatusExist;

/

create or replace function VenueIdExist ( vId IN number ) return boolean 
is
  res boolean := false;
begin
  for c1 in ( select 1 from venues where v_id = vId and rownum = 1 ) loop
    res := true;
    exit; -- only care about one record, so exit.
  end loop;
  return( res );
end VenueIdExist;

/

create or replace function VenueNameExist ( vName IN varchar2 ) return boolean 
is
  res boolean := false;
begin
  for c1 in ( select 1 from venues where name = vName and rownum = 1 ) loop
    res := true;
    exit; -- only care about one record, so exit.
  end loop;
  return( res );
end VenueNameExist;

/

create or replace function divisionExist ( dJsonId IN INTEGER ) return boolean 
is
  res boolean := false;
begin
  for c1 in ( select 1 from divisions where d_jsonId = dJsonId and rownum = 1 ) loop
    res := true;
    exit; -- only care about one record, so exit.
  end loop;
  return( res );
end divisionExist;

/


create or replace function conferenceExist ( cJsonId IN INTEGER ) return boolean 
is
  res boolean := false;
begin
  for c1 in ( select 1 from conferences where c_jsonId = cJsonId and rownum = 1 ) loop
    res := true;
    exit; -- only care about one record, so exit.
  end loop;
  return( res );
end conferenceExist;

/

create or replace function conferenceDivisionExist ( c_id in integer, d_id in integer, season in integer) return boolean
is
    res boolean := false;
begin
    for c1 in ( select conference_id, division_id, season from conference_division where conference_id = c_id and division_id = d_id) 
    loop
        if c1.season = season then
            res := true;
            exit;
        end if;
    end loop;
return (res);
end conferenceDivisionExist;

/

create or replace function divisionTeamsExist( teamId in integer, divisionId in integer, season in integer) return number
is
    res number := 0;
begin
    for c1 in (select dt_id, season from division_teams where division_id = divisionId and team_id = teamId)
    loop
        if c1.season = season then
            res := c1.dt_id;
        end if;
    end loop;
return (res);
end divisionTeamsExist;

/

create or replace function conferenceTeamsExist( teamId in integer, conferenceId in integer, season in integer) return number
is
    res number := 0;
begin
    for c1 in (select ct_id, season from conference_teams where conference_id = conferenceId and team_id = teamId)
    loop
        if c1.season = season then
            res := c1.ct_id;
        end if;
    end loop;
return (res);
end conferenceTeamsExist;

/

create or replace function divisionTeamsMatches ( divisionTeamsId in integer, season in integer) return boolean
is
    res boolean := false;
    dSeason integer;
begin
    select season into dSeason from division_teams where dt_id = divisionTeamsId;
    if season = dSeason then
        res:= true;
    end if;
return (res);
end divisionTeamsMatches;

/

create or replace function conferenceTeamsMatches (conferenceTeamsId integer, season in integer) return boolean
is
    res boolean:= false;
    dSeason integer;
begin
    select season into dSeason from conference_teams where ct_id = conferenceTeamsId;
    if season = dSeason then
        res:= true;
    end if;
return (res);
end conferenceTeamsMatches;

/

create or replace function teamExist ( tJsonId IN INTEGER ) return boolean 
is
  res boolean := false;
begin
  for c1 in ( select 1 from teams where t_jsonId = tJsonId and rownum = 1 ) loop
    res := true;
    exit; -- only care about one record, so exit.
  end loop;
  return( res );
end teamExist;

/

create or replace function positionExist ( pName IN VARCHAR2 ) return boolean 
is
  res boolean := false;
begin
  for c1 in ( select 1 from positions where name = pName and rownum = 1 ) loop
    res := true;
    exit; -- only care about one record, so exit.
  end loop;
  return( res );
end positionExist;

/

create or replace function playerExist ( pId IN INTEGER ) return boolean 
is
  res boolean := false;
begin
  for c1 in ( select 1 from players where p_jsonId = pId and rownum = 1 ) loop
    res := true;
    exit; -- only care about one record, so exit.
  end loop;
  return( res );
end playerExist;

/

create or replace function gameExist ( gId IN INTEGER ) return boolean 
is
  res boolean := false;
begin
  for c1 in ( select 1 from games where g_jsonId = gId and rownum = 1 ) loop
    res := true;
    exit; -- only care about one record, so exit.
  end loop;
  return( res );
end gameExist;

/

create or replace function gameEventExist ( gId in integer, eventId in integer ) return boolean 
is
    res boolean := false;
begin
    for c1 in ( select gameId, gameEventId from gameEvents where gameId = gId ) loop
        if c1.gameEventId = eventId then
            res := true;
            exit;
        end if;
    end loop;
    return( res );
end gameEventExist;

/

create or replace function eventExist ( eName in varchar2, eSecondaryType in varchar2, eStrength in varchar2, eEmptyNet in varchar2, 
        ePenaltySeverity in varchar2, ePenaltyMinutes in integer) return boolean
is
    res boolean := false;
begin
    if eName != 'Goal' and eName != 'Penalty' then
        for c1 in ( select name, secondaryType from Events where name = eName ) loop
            if varComparator(c1.secondaryType, eSecondaryType) then
                res := true;
            end if;
        end loop;
    elsif eName = 'Goal' then
        for c2 in (select name, secondaryType, strength, emptyNet from Events where name = eName) loop
            if varComparator(c2.secondaryType, eSecondaryType) and varComparator(c2.strength, eStrength) and varComparator(c2.emptyNet, eEmptyNet) then
                res := true;
                exit;
            end if;
        end loop;
    elsif eName = 'Penalty' then
        for c3 in (select name, secondaryType, penaltySeverity, penaltyMinutes from Events where name = eName) loop
            if varComparator(c3.secondaryType, eSecondaryType) and varComparator(c3.penaltySeverity, ePenaltySeverity) and intComparator(c3.penaltyMinutes, ePenaltyMinutes) then
                res := true;
                exit;
            end if;
        end loop;
    end if;
    return(res);
end eventExist;

/

create or replace function eventPlayerExist ( eventId IN INTEGER, rosterId IN INTEGER ) return boolean 
is
  res boolean := false;
begin
  for c1 in ( select 1 from EventPlayers where event_id = eventId and roster_id = rosterId and rownum = 1 ) loop
    res := true;
    exit; -- only care about one record, so exit.
  end loop;
  return( res );
end eventPlayerExist;

/

create or replace function rosterExist ( gId in integer, tId in integer, pId in integer ) return boolean
is
    res boolean := false;
begin
    for c1 in ( select g_id, t_id, p_id from Rosters where g_id = gId and t_id = tId and p_id = pId) loop
        res := true;
        exit;
    end loop;
    return (res);
end rosterExist;

/

create or replace function goalieStatsExist( rosterId in integer ) return boolean
is
    res boolean := false;
begin
    for c1 in ( select gs_id from Rosters where r_id = rosterId and rosters.gs_id is not null) loop
        res := true;
        exit;
    end loop;
    return(res);
end goalieStatsExist;

/

create or replace function skaterStatsExist( rosterId in integer) return boolean
is
    res boolean := false;
begin
    for c1 in ( select ss_id from Rosters where r_id = rosterId and rosters.ss_id is not null) loop
        res := true;
        exit;
    end loop;
    return(res);
end skaterStatsExist;

/

create or replace function varComparator( var1 in varchar2, var2 in varchar2) return boolean
is
    res boolean := false;
begin
    if (var1 is null and var2 is null) OR (var1 = var2) then
        res := true;
    end if;
    return res;
end varComparator;

/

create or replace function intComparator (int1 in integer, int2 in integer) return boolean
is
    res boolean := false;
begin
    if (int1 is null and int2 is null) OR (int1 = int2) then
        res := true;
    end if;
    return res;
end intComparator;