create or replace procedure insertEvent (
    pGameJsonId in integer,
    player1JsonId in integer,
    player1Type in varchar2,
    player2JsonId in integer,
    player2Type in varchar2,
    player3JsonId in integer,
    player3Type in varchar2,
    player4JsonId in integer,
    player4Type in varchar2,
    eventName in varchar2,
    eventSecondaryType in varchar2,
    goalStrength in varchar2,
    goalEmptyNet in varchar2,
    pPenaltySeverity in varchar2,
    pPenaltyMinutes in integer,
    ingameEventId in integer,
    periodNum in integer,
    pPeriodType in varchar2,
    pPeriodTime in varchar2,
    pCoordX in integer,
    pCoordY in integer
)
as
    dGameId integer;
    dEId integer;
    dEventId integer;
    dEvent gameEvents%ROWTYPE;
    dPlayer1Id integer;
    dPlayer2Id integer;
    dPlayer3Id integer;
    dPlayer4Id integer;
    dPlayer1RosterId integer;
    dPlayer2RosterId integer;
    dPlayer3RosterId integer;
    dPlayer4RosterId integer;
begin
    savepoint insertEvent_start;
    
   /* if player1Type = 'PlayerID' then
        player1Type := null;
    end if;
    if player2Type = 'PlayerID' then
        player2Type := null;
    end if;
    if player3Type = 'PlayerID' then
        player3Type := null;
    end if;
    if player4Type = 'PlayerID' then
        player4Type := null;
    end if;*/
    
    select g_id into dGameId from games where g_jsonId = pGameJsonId;
    
    if eventExist(eventName, eventSecondaryType, goalStrength, goalEmptyNet, pPenaltySeverity, pPenaltyMinutes) = false then
        insert into Events(e_id, name, secondaryType, strength, emptyNet, penaltySeverity, penaltyMinutes) 
            values (seq_events.nextval, eventName, eventSecondaryType, goalStrength, goalEmptyNet, pPenaltySeverity, pPenaltyMinutes);
    end if;
    
    select e_id into dEId from Events where name = eventName and
    ((secondaryType is null and eventSecondaryType is null) OR (secondaryType = eventSecondaryType)) and
    ((strength is null and goalStrength is null) OR (strength = goalStrength)) and
    ((emptyNet is null and goalEmptyNet is null) or (emptyNet = goalEmptyNet)) and
    ((penaltySeverity is null and pPenaltySeverity is null) or (penaltySeverity = pPenaltySeverity)) and
    ((penaltyMinutes is null and pPenaltyMinutes is null) or (penaltyMinutes = pPenaltyMinutes));
    
    if gameEventExist(dGameId, ingameEventId) = false then
        insert into GameEvents(ge_id, gameId, gameEventId, eventId, periodNumber, periodType, periodTime, coordX, coordY)
            values(seq_gameEvents.NEXTVAL, dGameId, ingameEventId, dEId, periodNum, pPeriodType, pPeriodTime, pCoordX, pCoordY);
    end if;
    
    select ge_id into dEventId from GameEvents where gameId = dGameId and gameEventId = ingameEventId and eventId = dEId;
    if player1JsonId != 0 then
        select coalesce(max(p_id), 0) into dPlayer1Id from Players where p_jsonId = player1JsonId;
        if dPlayer1Id = 0 then
            insertPlayer(pGameJsonId, null, player1JsonId, 'Unknown', 'Unknown', null, null, null, null, 'Unknown', 'Unknown', 'NA');
            select p_id into dPlayer1Id from Players where p_jsonId = player1JsonId;
        end if;
        select r_id into dPlayer1RosterId from Rosters where g_id = dGameId and p_id = dPlayer1Id;
        if eventPlayerExist(dEventId, dPlayer1RosterId) = false then
            insert into EventPlayers(event_id, roster_id, role) values (dEventId, dPlayer1RosterId, player1Type);
        end if;
    end if;
    if player2JsonId != 0 then
        select coalesce(max(p_id), 0) into dPlayer2Id from Players where p_jsonId = player2JsonId;
        if dPlayer2Id = 0 then
            insertPlayer(pGameJsonId, null, player2JsonId, 'Unknown', 'Unknown', null, null, null, null, 'Unknown', 'Unknown', 'NA');
            select p_id into dPlayer2Id from Players where p_jsonId = player2JsonId;
        end if;
        select r_id into dPlayer2RosterId from Rosters where g_id = dGameId and p_id = dPlayer2Id;
        if eventPlayerExist(dEventId, dPlayer2RosterId) = false then
            insert into EventPlayers(event_id, roster_id, role) values (dEventId, dPlayer2RosterId, player2Type);
        end if;
    end if;
    if player3JsonId != 0 then
        select coalesce(max(p_id), 0) into dPlayer3Id from Players where p_jsonId = player3JsonId;
        if dPlayer3Id = 0 then
            insertPlayer(pGameJsonId, null, player3JsonId, 'Unknown', 'Unknown', null, null, null, null, 'Unknown', 'Unknown', 'NA');
            select p_id into dPlayer3Id from Players where p_jsonId = player3JsonId;
        end if;
        select r_id into dPlayer3RosterId from Rosters where g_id = dGameId and p_id = dPlayer3Id;
        if eventPlayerExist(dEventId, dPlayer3RosterId) = false then
            insert into EventPlayers(event_id, roster_id, role) values (dEventId, dPlayer3RosterId, player3Type);
        end if;
    end if;
    if player4JsonId != 0 then
        select coalesce(max(p_id), 0) into dPlayer4Id from Players where p_jsonId = player4JsonId;
        if dPlayer4Id = 0 then
            insertPlayer(pGameJsonId, null, player4JsonId, 'Unknown', 'Unknown', null, null, null, null, 'Unknown', 'Unknown', 'NA');
            select p_id into dPlayer4Id from Players where p_jsonId = player4JsonId;
        end if;
        select r_id into dPlayer4RosterId from Rosters where g_id = dGameId and p_id = dPlayer4Id;
        if eventPlayerExist(dEventId, dPlayer4RosterId) = false then
            insert into EventPlayers(event_id, roster_id, role) values (dEventId, dPlayer4RosterId, player4Type);
        end if;
    end if;
    
exception
    when others then
    rollback to insertEvent_start;
    raise;
end;

execute insertEvent(2015020716, 8473579, 'Scorer', 8475177, 'Assist', 8477506, 'Assist', 8473607, 'Goalie', 'Goal', null, null, null, null, null, 33, 1, 'REGULAR', '05:58', -78, 6);
--[8473579, Scorer, 8475177, Assist, 8477506, Assist, 8473607, Goalie, Goal, 33, 1, REGULAR, 05:58, -78, 6]

execute insertEvent(2015020716, 8473579, 'Scorer', 8475177, 'Assist', 8477506, 'Assist', 8473607, 'Goalie', 'Goal', 'Slap Shot', null, null, null, null, 33, 1, 'REGULAR', '05:58', -78, 6);

execute insertEvent(2015020716, 8476393, 'Winner', 8471996, 'Loser', 0, 'N/A', 0, 'N/A', 'Faceoff', null, null, null, null, null, 34, 1, 'REGULAR', '05:58', 0, 0);
--[8476393, Winner, 8471996, Loser, Faceoff, 34, 1, REGULAR, 05:58, 0, 0]

execute insertEvent(2015020716, 8476116, 'Shooter', 8475831, 'Goalie', 0, 'N/A', 0, 'N/A', 'Shot', null, null, null, null, null, 34, 1, 'REGULAR', '19:34', -85, 23);
--[8476116, Shooter, 8475831, Goalie, Shot, null, 2, REGULAR, 19:34, -85, 23]

execute insertEvent(2015020716, 8476116, 'Shooter', 8475831, 'Goalie', 0, 'N/A', 0, 'N/A', 'Shot', 'Wrist Shot', null, null, null, null, 34, 1, 'REGULAR', '19:34', -85, 23);
--[8475155, Shooter, 8475831, Goalie, Shot, Wrist Shot, null, null, null, null, 3, REGULAR, 17:58, 5, 0]

execute insertEvent(2015010032, 8475225, 'Shooter', 9000011, 'Goalie', 0, 'N/A', 0, 'N/A', 'Shot', 'Wrist Shot', null, null, null, null, 194, 2, 'REGULAR', '12:29', 72, 11);
--[8475225, Shooter, 9000011, Goalie, Shot, Wrist Shot, null, null, null, null, 2, REGULAR, 12:29, 72, 11]