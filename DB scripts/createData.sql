--creating tables
CREATE TABLE Conference_Division
  (
    conference_id INTEGER NOT NULL ,
    division_id   INTEGER NOT NULL ,
    season integer not null
  ) ;
ALTER TABLE Conference_Division ADD CONSTRAINT Conference_Division_PK PRIMARY KEY ( conference_id, division_id, season );

create table Division_Teams (
    dt_id integer not null,
    division_id integer not null,
    team_id integer not null,
    season integer not null
);
alter table Division_Teams add constraint Division_Teams_PK primary key (dt_id);

create table Conference_Teams (
    ct_id integer not null,
    conference_id integer not null,
    team_id integer not null,
    season integer not null
);
alter table conference_Teams add constraint Conference_Teams_PK primary key (ct_id);

CREATE TABLE Conferences
  (
    c_id     INTEGER NOT NULL ,
    c_jsonId INTEGER NOT NULL ,
    name     VARCHAR2 (15) NOT NULL
  ) ;
ALTER TABLE Conferences ADD CONSTRAINT Conferences_PK PRIMARY KEY ( c_id );

CREATE TABLE Divisions
  (
    d_id     INTEGER NOT NULL ,
    d_jsonId INTEGER NOT NULL ,
    name     VARCHAR2 (15) NOT NULL
  );
ALTER TABLE Divisions ADD CONSTRAINT Divisions_PK PRIMARY KEY ( d_id );

CREATE TABLE Games
  (
    g_id       INTEGER NOT NULL ,
    g_jsonId   INTEGER NOT NULL ,
    gameType   VARCHAR2(5) NOT NULL ,
    season     INTEGER NOT NULL ,
    gameDate   DATE NOT NULL ,
    awayScore  INTEGER NOT NULL ,
    awayTeamId INTEGER NOT NULL ,
    homeScore  INTEGER NOT NULL ,
    homeTeamId INTEGER NOT NULL ,
    venueId    INTEGER NOT NULL ,
    gameStatus INTEGER NOT NULL
  );
ALTER TABLE Games ADD CONSTRAINT Games_PK PRIMARY KEY ( g_id );

CREATE TABLE Players
  (
    p_id          INTEGER NOT NULL ,
    p_jsonId      INTEGER NOT NULL ,
    firstName     VARCHAR2 (25) NOT NULL ,
    lastName      VARCHAR2 (25) NOT NULL ,
    primaryNumber INTEGER ,
    age           integer,
    birthDate     DATE ,
    birthCountry  VARCHAR2 (3) ,
    currentTeamId INTEGER ,
    positionId    INTEGER NOT NULL
  );
ALTER TABLE Players ADD CONSTRAINT Players_PK PRIMARY KEY ( p_id );

CREATE TABLE Positions
  (
    p_id         INTEGER NOT NULL ,
    name         VARCHAR2 (15) NOT NULL ,
    type         VARCHAR2 (15) NOT NULL ,
    abbreviation VARCHAR2 (2)
  );
ALTER TABLE Positions ADD CONSTRAINT Positions_PK PRIMARY KEY ( p_id );

CREATE TABLE Teams
  (
    t_id         INTEGER NOT NULL ,
    t_jsonId     INTEGER NOT NULL ,
    name         VARCHAR2 (50) NOT NULL ,
    abbreviation VARCHAR2 (5) ,
    teamName     VARCHAR2 (15) NOT NULL ,
    shortName    VARCHAR2 (15) NOT NULL ,
    venueId      INTEGER NOT NULL ,
    timeZoneId   INTEGER NOT NULL ,
    location     VARCHAR2 (25) NOT NULL ,
    firstYear    INTEGER NOT NULL ,
    divisionId   INTEGER NOT NULL ,
    conferenceId INTEGER NOT NULL ,
    active       VARCHAR2 (5) NOT NULL
  );
ALTER TABLE Teams ADD CONSTRAINT Teams_PK PRIMARY KEY ( t_id );

CREATE TABLE TimeZones
  (
    tz_id  INTEGER NOT NULL ,
    name   VARCHAR2 (30) NOT NULL ,
    offset INTEGER NOT NULL
  );
ALTER TABLE TimeZones ADD CONSTRAINT TimeZones_PK PRIMARY KEY ( tz_id );

CREATE TABLE GameStatus
  (
    code INTEGER NOT NULL,
    name VARCHAR2 (15)
  );
ALTER TABLE GameStatus ADD CONSTRAINT GameStatus_PK PRIMARY KEY ( code );

CREATE TABLE Venues
  (
    v_id INTEGER NOT NULL ,
    name VARCHAR2 (50) NOT NULL ,
    city VARCHAR2 (25)
  );
ALTER TABLE Venues ADD CONSTRAINT Venues_PK PRIMARY KEY ( v_id );

create table Rosters(
    r_id integer not null,
    g_id integer not null,
    t_id integer,
    p_id integer not null,
    ss_id integer,
    gs_id integer
);
alter table Rosters add constraint Rosters_PK primary key(r_id);

create table Events(
    e_id integer not null,
    name varchar2(15),
    secondaryType varchar2(50),
    strength varchar2(20),
    emptyNet varchar2(10),
    penaltySeverity varchar2(30),
    penaltyMinutes integer
);
alter table Events add constraint Events_PK primary key(e_id);

create table GameEvents(
    ge_id integer not null,
    gameId integer not null,
    gameEventId integer not null,
    eventId integer not null,
    periodNumber integer not null,
    periodType varchar2(15) not null,
    periodTime varchar2(10) not null,
    coordX integer,
    coordY integer
);
alter table GameEvents add constraint GameEvents_PK primary key(ge_id);

create table EventPlayers(
    event_id integer not null,
    roster_id integer not null,
    role varchar2(50)
);
alter table EventPlayers add constraint EventPlayers_PK primary key(event_id, roster_id);

create table SkaterStats(
    ss_id integer not null,
    timeOnIce varchar2(10) not null,
    ppTimeOnIce varchar2(10) not null,
    shTimeOnIce varchar2(10) not null,
    penaltyMinutes integer not null,
    plusMinus integer not null
);
alter table SkaterStats add constraint SkaterStats_PK primary key(ss_id);

create table GoalieStats(
    gs_id integer not null,
    timeOnIce varchar2(10) not null,
    penaltyMinutes integer not null,
    shots integer not null,
    saves integer not null,
    ppShots integer not null,
    ppSaves integer not null,
    shShots integer not null,
    shSaves integer not null
);
alter table GoalieStats add constraint GoalieStats_PK primary key(gs_id);

insert into venues (v_id, name, city) Values(0, 'Unknown', 'N/A');

--fk constraints
ALTER TABLE Conference_Division ADD CONSTRAINT Conference_Div_Con_FK FOREIGN KEY ( conference_id ) REFERENCES Conferences ( c_id );
ALTER TABLE Conference_Division ADD CONSTRAINT Con_Div_Division_FK FOREIGN KEY ( division_id ) REFERENCES Divisions ( d_id );
alter table Division_Teams add constraint Division_Teams_Divisions_FK foreign key (division_id) references Divisions (d_id);
alter table Division_Teams add constraint Division_Teams_Teams_FK foreign key (team_id) references Teams (t_id) INITIALLY DEFERRED DEFERRABLE;
alter table Conference_Teams add constraint Conference_Teams_Conferences_FK foreign key (conference_id) references Conferences (c_id);
alter table Conference_Teams add constraint Conference_Teams_Teams_FK foreign key (team_id) references Teams (t_id) INITIALLY DEFERRED DEFERRABLE;
ALTER TABLE Games ADD CONSTRAINT Games_Teams_FK_Away FOREIGN KEY ( awayTeamId ) REFERENCES Teams ( t_id );
ALTER TABLE Games ADD CONSTRAINT Games_Teams_FK_Home FOREIGN KEY ( homeTeamId ) REFERENCES Teams ( t_id );
ALTER TABLE Games ADD CONSTRAINT Games_GameStatus_FK FOREIGN KEY ( gameStatus ) REFERENCES GameStatus ( code );
ALTER TABLE Games ADD CONSTRAINT Games_Venues_FK FOREIGN KEY ( venueId ) REFERENCES Venues ( v_id );
ALTER TABLE Players ADD CONSTRAINT Players_Positions_FK FOREIGN KEY ( positionId ) REFERENCES Positions ( p_id );
ALTER TABLE Players ADD CONSTRAINT Players_Teams_FK FOREIGN KEY ( currentTeamId ) REFERENCES Teams ( t_id );
alter table Teams add constraint Teams_Division_Teams_FK foreign key(divisionId) references Division_Teams(dt_id) INITIALLY DEFERRED DEFERRABLE;
alter table Teams add constraint Teams_Conference_Teams_FK foreign key(conferenceId) references Conference_Teams(ct_id) INITIALLY DEFERRED DEFERRABLE;
ALTER TABLE Teams ADD CONSTRAINT Teams_TimeZones_FK FOREIGN KEY ( timeZoneId ) REFERENCES TimeZones ( tz_id );
ALTER TABLE Teams ADD CONSTRAINT Teams_Venues_FK FOREIGN KEY ( venueId ) REFERENCES Venues ( v_id );
alter table Rosters add constraint Rosters_Games_FK foreign key (g_id) references Games (g_id);
alter table Rosters add constraint Rosters_Teams_FK foreign key (t_id) references Teams (t_id);
alter table Rosters add constraint Rosters_Players_FK foreign key (p_id) references Players (p_id);
alter table GameEvents add constraint GameEvents_Games_FK foreign key(gameId) references Games(g_id);
alter table EventPlayers add constraint EventPlayers_GameEvents_FK foreign key(event_id) references GameEvents (ge_id);
alter table EventPlayers add constraint EventPlayers_Rosters_FK foreign key(roster_id) references Rosters(r_id);
alter table GameEvents add constraint GameEvents_Events_FK foreign key(eventId) references Events(e_id);
alter table Rosters add constraint Rosters_SkaterStats_FK foreign key(ss_id) references SkaterStats(ss_id);
alter table Rosters add constraint Rosters_GoalieStats_FK foreign key(gs_id) references GoalieStats(gs_id);


--create sequences
CREATE SEQUENCE seq_division
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 29
NOCACHE
NOCYCLE;
CREATE OR REPLACE TRIGGER division_d_id_TRG BEFORE
  INSERT ON Divisions FOR EACH ROW WHEN (NEW.d_id IS NULL) BEGIN :NEW.d_id := seq_division.NEXTVAL;
END;

/

CREATE SEQUENCE seq_conference
START WITH 30
INCREMENT BY 1
MINVALUE 30
MAXVALUE 49
NOCACHE
NOCYCLE;
CREATE OR REPLACE TRIGGER conference_c_id_TRG BEFORE
  INSERT ON Conferences FOR EACH ROW WHEN (NEW.c_id IS NULL) BEGIN :NEW.c_id := seq_conference.NEXTVAL;
END;

/

create sequence seq_divisionTeams
start with 1
increment by 1
minvalue 1
maxvalue 1000
nocache
nocycle;
/*CREATE OR REPLACE TRIGGER divisionTeams_dt_id_TRG BEFORE
  INSERT ON Division_Teams FOR EACH ROW WHEN (NEW.dt_id IS NULL) BEGIN :NEW.dt_id := seq_divisionTeams.NEXTVAL;
END;*/

/

create sequence seq_conferenceTeams
start with 1
increment by 1
minvalue 1
maxvalue 1000
nocache
nocycle;
/*create or replace trigger conferenceTeams_ct_id_TRG before
    insert on Conference_Teams for each row when (new.ct_id is null) begin :new.ct_id := seq_conferenceTeams.nextval;
end;*/

/

CREATE SEQUENCE seq_tZone
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 1000
NOCACHE
NOCYCLE;
CREATE OR REPLACE TRIGGER timeZone_tz_id_TRG BEFORE
  INSERT ON TimeZones FOR EACH ROW WHEN (NEW.tz_id IS NULL) BEGIN :NEW.tz_id := seq_tZone.NEXTVAL;
END;

/

CREATE SEQUENCE seq_position
START WITH 100
INCREMENT BY 1
MINVALUE 100
MAXVALUE 1000
NOCACHE
NOCYCLE;
CREATE OR REPLACE TRIGGER position_p_id_TRG BEFORE
  INSERT ON Positions FOR EACH ROW WHEN (NEW.p_id IS NULL) BEGIN :NEW.p_id := seq_position.NEXTVAL;
END;

/

CREATE SEQUENCE seq_team
START WITH 100
INCREMENT BY 1
MINVALUE 100
MAXVALUE 499
NOCACHE
NOCYCLE;
/*CREATE OR REPLACE TRIGGER team_t_id_TRG BEFORE
  INSERT ON Teams FOR EACH ROW WHEN (NEW.t_id IS NULL) BEGIN :NEW.t_id := seq_team.NEXTVAL;
END;*/

/

CREATE SEQUENCE seq_venue
START WITH 500
INCREMENT BY 1
MINVALUE 500
MAXVALUE 999
NOCACHE
NOCYCLE;
CREATE OR REPLACE TRIGGER venue_v_id_TRG BEFORE
  INSERT ON Venues FOR EACH ROW WHEN (NEW.v_id IS NULL) BEGIN :NEW.v_id := seq_venue.NEXTVAL;
END;
--drop sequence seq_venue;

/

CREATE SEQUENCE seq_player
START WITH 1000
INCREMENT BY 1
MINVALUE 1000
MAXVALUE 49999
CACHE 20
NOCYCLE;
CREATE OR REPLACE TRIGGER player_p_id_TRG BEFORE
  INSERT ON Players FOR EACH ROW WHEN (NEW.p_id IS NULL) BEGIN :NEW.p_id := seq_player.NEXTVAL;
END;

/

create sequence seq_roster
start with 1
increment by 1
minvalue 1
maxvalue 9999999999
cache 40
nocycle;
create or replace trigger roster_r_id_TRG before
    insert on Rosters for each row when (new.r_id is null) begin :NEW.r_id := seq_roster.nextval;
end;

/


CREATE SEQUENCE seq_gameEvents
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 9999999999
CACHE 50
NOCYCLE;

/

CREATE SEQUENCE seq_events
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 10000
NOCACHE
NOCYCLE;

/

CREATE SEQUENCE seq_game
START WITH 200000
INCREMENT BY 1
MINVALUE 200000
NOMAXVALUE 
CACHE 5
NOCYCLE;
CREATE OR REPLACE TRIGGER game_g_id_TRG BEFORE
  INSERT ON Games FOR EACH ROW WHEN (NEW.g_id IS NULL) BEGIN :NEW.g_id := seq_game.NEXTVAL;
END;

/

create sequence seq_skaterStats
start with 1
increment by 1
minvalue 1
maxvalue 99999999999
cache 20
nocycle;

/

create sequence seq_goalieStats
start with 1
increment by 1
minvalue 1
maxvalue 9999999999
cache 5
nocycle;
