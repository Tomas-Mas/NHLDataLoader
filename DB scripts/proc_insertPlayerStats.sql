create or replace procedure insertPlayerStats (
    gameJsonId in integer,
    playerJsonId in integer,
    --goalie
    gTimeOnIce in varchar2,
    gPenaltyMinutes in integer,
    gShots in integer,
    gSaves in integer,
    gPpShots in integer,
    gPpSaves in integer,
    gShShots in integer,
    gShSaves in integer,
    --skater
    sTimeOnIce in varchar2,
    sPpTimeOnIce in varchar2,
    sShTimeOnIce in varchar2,
    sPenaltyMinutes in integer,
    sPlusMinus in integer
)
as
    rosterId integer;
    skaterStatsId integer;
    goalieStatsId integer;
    gsRow GoalieStats%ROWTYPE;
    ssRow SkaterStats%ROWTYPE;
begin
    savepoint insertPlayerStats_start;
    
    select r_id into rosterId from (rosters inner join games on games.g_id=rosters.g_id) inner join Players on Players.p_id=Rosters.p_id 
        where games.g_jsonId = gameJsonId and players.p_jsonId = playerJsonId;
        
    if goalieStatsExist(rosterId) = false and gTimeOnIce is not null then
        goalieStatsId := seq_goalieStats.nextVal;
        insert into GoalieStats(gs_id, timeOnIce, penaltyMinutes, shots, saves, ppShots, ppSaves, shShots, shSaves)
            values(goalieStatsId, gTimeOnIce, gPenaltyMinutes, gShots, gSaves, gPpShots, gPpSaves, gShShots, gShSaves);
        update Rosters set gs_id = goalieStatsId where r_id = rosterId;
    elsif goalieStatsExist(rosterId) then
        select gs_id into goalieStatsId from Rosters where r_id = rosterId;
        select gs_id, timeOnIce, penaltyMinutes, shots, saves, ppShots, ppSaves, shShots, shSaves into gsRow from GoalieStats where gs_id = goalieStatsId;
        if gsRow.timeOnIce != gTimeOnIce then
            update GoalieStats set timeOnIce = gTimeOnIce where gs_id = goalieStatsId;
        end if;
        if gsRow.penaltyMinutes != gPenaltyMinutes then
            update GoalieStats set penaltyMinutes = gPenaltyMinutes where gs_id = goalieStatsId;
        end if;
        if gsRow.shots != gShots then
            update GoalieStats set shots = gShots where gs_id = goalieStatsId;
        end if;
        if gsRow.saves != gSaves then
            update GoalieStats set saves = gSaves where gs_id = goalieStatsId;
        end if;
        if gsRow.ppShots != gPpShots then
            update GoalieStats set ppShots = gPpShots where gs_id = goalieStatsId;
        end if;
        if gsRow.ppSaves != gPpSaves then
            update GoalieStats set ppSaves = gPpSaves where gs_id = goalieStatsId;
        end if;
        if gsRow.shShots != gShShots then
            update GoalieStats set shShots = gShShots where gs_id = goalieStatsId;
        end if;
        if gsRow.shSaves != gShSaves then
            update GoalieStats set shSaves = gShSaves where gs_id = goalieStatsId;
        end if;
    end if;
    
    if skaterStatsExist(rosterId) = false and sTimeOnIce is not null then
        skaterStatsId := seq_skaterStats.nextVal;
        insert into SkaterStats(ss_id, timeOnIce, ppTimeOnIce, shTimeOnIce, penaltyMinutes, plusMinus)
            values(skaterStatsId, sTimeOnIce, sPpTimeOnIce, sShTimeOnIce, sPenaltyMinutes, sPlusMinus);
        update Rosters set ss_id = skaterStatsId where r_id = rosterId;
    elsif skaterStatsExist(rosterId) then
        select ss_id into skaterStatsId from Rosters where r_id = rosterId;
        select ss_id, timeOnIce, ppTimeOnIce, shTimeOnIce, penaltyMinutes, plusMinus into ssRow from SkaterStats where ss_id = skaterStatsId;
        if ssRow.timeOnIce != sTimeOnIce then
            update SkaterStats set timeOnIce = sTimeOnIce where ss_id = skaterStatsId;
        end if;
        if ssRow.ppTimeOnIce != sPpTimeOnIce then
            update SkaterStats set ppTimeOnIce = sPpTimeOnIce where ss_id = skaterStatsId;
        end if;
        if ssRow.shTimeOnIce != sShTimeOnIce then
            update SkaterStats set shTimeOnIce = sShTimeOnIce where ss_id = skaterStatsId;
        end if;
        if ssRow.penaltyMinutes != sPenaltyMinutes then
            update SkaterStats set penaltyMinutes = sPenaltyMinutes where ss_id = skaterStatsId;
        end if;
        if ssRow.plusMinus != sPlusMinus then
            update SkaterStats set plusMinus = sPlusMinus where ss_id = skaterStatsId;
        end if;
    end if;
    
exception
    when others then
    rollback to insertPlayerStats_start;
    raise;
end;

execute insertPlayerStats(2015020704, 8475883, '59:57', 0, 24, 24, 4, 1, 1, 4, null, null, null, null, null);
execute insertPlayerStats(2015020704, 8475883, '14:57', 33, 32, 31, 30, 29, 28, 27, null, null, null, null, null);
--20152016 8475883:[59:57, 0, 24, 24, 4, 1, 1, 4]

execute insertPlayerStats(2015020704, 8476312, null, null, null, null, null, null, null, null, '22:27', '0:38', '2:44', 4, 2);


execute insertPlayerStats(2015020704, 8476312, null, null, null, null, null, null, null, null, '66:27', '66:38', '66:44', 66, 66);
--Skater 8476312:[22:27, 0, 0, 4, 0, 0, 2, 0:38, 2:44]