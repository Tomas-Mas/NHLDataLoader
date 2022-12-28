create or replace procedure insertPlayer (
    pGameId in integer,
    pTeamId in integer,
    pJsonId in integer,
    pFirstName in varchar2,
    pLastName in varchar2,
    pPrimaryNumber in integer,
    pBirthDate in varchar2,
    pBirthCountry in varchar2,
    teamJsonId in integer,
    positionName in varchar2,
    positionType in varchar2,
    positionAbbreviation in varchar2
    )
as
    dTeamId integer;
    dPositionId integer;
    dPlayerNumber integer;
    dPlayerData players%ROWTYPE;
    dRosterTeamId integer;
    dRosterGameId integer;
    dRosterPlayerId integer;
begin
    savepoint insertPlayer_start;
    --get t_id by json id if team exists, null if not
    select COALESCE(MAX(t_id), null) into dTeamId from teams where t_jsonId = teamJsonId;
    
    --position
    if positionExist(positionName) = false then
        insert into positions(name, type, abbreviation) values(positionName, positionType, positionAbbreviation);
    end if;
    select p_id into dPositionId from positions where name = positionName;
    
    --player todo age
    if playerExist(pJsonId) then
        select p_id, p_jsonId, firstName, lastName, primaryNumber, age, birthDate, birthCountry, currentTeamId, positionId
            into dPlayerData from players where p_jsonId = pJsonId;
        if pFirstName != dPlayerData.firstName then
            update players set players.firstName = pFirstName where p_jsonId = pJsonId;
        end if;
        if pLastName != dPlayerData.lastName then
            update players set players.lastName = pLastName where p_jsonId = pJsonId;
        end if;
        if pPrimaryNumber != dPlayerData.primaryNumber then
            update players p set p.primaryNumber = pPrimaryNumber where p_jsonId = pJsonId;
        end if;
        if nvl(dTeamId, 0) != nvl(dPlayerData.currentTeamId, 0) then
            update players p set p.currentTeamId = dTeamId where p_jsonId = pJsonId;
        end if;
        if dPositionId != dPlayerData.positionId then
            update players p set p.positionId = dPositionId where p_jsonId = pJsonId;
        end if;
    else
        insert into players(p_jsonId, firstName, lastName, primaryNumber, birthDate, birthCountry, currentTeamId, positionId)
            values(pJsonId, pFirstName, pLastName, pPrimaryNumber, to_date(pBirthDate, 'YYYY-MM-DD'), pBirthCountry, dTeamId, dPositionId);
    end if;
    
    --rosters
    select g_id into dRosterGameId from games where g_jsonId = pGameId;
    if pFirstName = 'Unknown' and pLastName = 'Unknown' then
        dRosterTeamId := null;
    else
        select t_id into dRosterTeamId from Teams where t_jsonId = pTeamId;
    end if;
    select p_id into dRosterPlayerId from Players where p_jsonId = pJsonId;
    if rosterExist(dRosterGameId, dRosterTeamId, dRosterPlayerId) = false then
        insert into Rosters(g_id, t_id, p_id) values (dRosterGameId, dRosterTeamId, dRosterPlayerId);
    end if;
    
exception
    when others then
    rollback to insertPlayer_start;
    raise;
end;

execute insertPlayer(2015020704, 24, 8471699, 'Andrew', 'Cogliano', 11, '1987-06-14', 'CAN', 28, 'Center', 'Forward', 'C');  

--execute insertPlayer(8476116, 'Ryan', 'Garbutt', 16, '1985-08-12', 'CAN', null, null, 'Center', 'Forward', 'C');



--[8471699, Andrew, Cogliano, 11, 1987-06-14, CAN, 28, San Jose Sharks, Center, Forward, C]