--creating tables
CREATE TABLE Conference_Division
  (
    Conferences_c_id INTEGER NOT NULL ,
    Divisions_d_id   INTEGER NOT NULL
  ) ;
ALTER TABLE Conference_Division ADD CONSTRAINT Conference_Division_PK PRIMARY KEY ( Conferences_c_id, Divisions_d_id );

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
    gameType   VARCHAR2 (1 CHAR) NOT NULL ,
    season     INTEGER NOT NULL ,
    gameDate   DATE NOT NULL ,
    awayScore  INTEGER NOT NULL ,
    awayTeamId INTEGER NOT NULL ,
    homeScore  INTEGER NOT NULL ,
    homeTeamId INTEGER NOT NULL ,
    venueId    INTEGER NOT NULL ,
    gameStatus Varchar2(15)
  );
ALTER TABLE Games ADD CONSTRAINT Games_PK PRIMARY KEY ( g_id );

CREATE TABLE GoalEvents
  (
    g_id         INTEGER NOT NULL ,
    gameId       INTEGER NOT NULL ,
    emptyNet     VARCHAR2 (5) NOT NULL ,
    strength     VARCHAR2 (25) NOT NULL ,
    strengthCode VARCHAR2 (10) ,
    period       INTEGER NOT NULL ,
    periodType   VARCHAR2 (15) NOT NULL ,
    ordinalNum   VARCHAR2 (5) ,
    periodTime   VARCHAR2(6) NOT NULL ,
    teamId       INTEGER NOT NULL
  );
ALTER TABLE GoalEvents ADD CONSTRAINT GoalEvents_PK PRIMARY KEY ( g_id );

CREATE TABLE Goal_Players
  (
    GoalEvents_g_id INTEGER NOT NULL ,
    Players_p_id    INTEGER NOT NULL ,
    role            VARCHAR2 (10) NOT NULL
  );
ALTER TABLE Goal_Players ADD CONSTRAINT Goal_Players_PK PRIMARY KEY ( GoalEvents_g_id, Players_p_id );

CREATE TABLE Players
  (
    p_id          INTEGER NOT NULL ,
    p_jsonId      INTEGER NOT NULL ,
    firstName     VARCHAR2 (25) NOT NULL ,
    lastName      VARCHAR2 (25) NOT NULL ,
    "NUMBER"	  INTEGER ,
    birthDate     DATE ,
    birthCountry  VARCHAR2 (3) ,
    active        VARCHAR2 (5) NOT NULL ,
    rosterStatus  VARCHAR2 (1) ,
    currentTeamId INTEGER NOT NULL ,
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

CREATE TABLE Venues
  (
    v_id INTEGER NOT NULL ,
    name VARCHAR2 (50) NOT NULL ,
    city VARCHAR2 (25)
  );
ALTER TABLE Venues ADD CONSTRAINT Venues_PK PRIMARY KEY ( v_id );


--fk constraints
ALTER TABLE Conference_Division ADD CONSTRAINT Conference_Div_Con_FK FOREIGN KEY ( Conferences_c_id ) REFERENCES Conferences ( c_id );
ALTER TABLE Conference_Division ADD CONSTRAINT Con_Div_Division_FK FOREIGN KEY ( Divisions_d_id ) REFERENCES Divisions ( d_id );
ALTER TABLE Games ADD CONSTRAINT Games_Teams_FK_Away FOREIGN KEY ( awayTeamId ) REFERENCES Teams ( t_id );
ALTER TABLE Games ADD CONSTRAINT Games_Teams_FK_Home FOREIGN KEY ( homeTeamId ) REFERENCES Teams ( t_id );
ALTER TABLE Games ADD CONSTRAINT Games_Venues_FK FOREIGN KEY ( venueId ) REFERENCES Venues ( v_id );
ALTER TABLE GoalEvents ADD CONSTRAINT GoalEvents_Games_FK FOREIGN KEY ( gameId ) REFERENCES Games ( g_id );
ALTER TABLE GoalEvents ADD CONSTRAINT GoalEvents_Teams_FK FOREIGN KEY ( teamId ) REFERENCES Teams ( t_id );
ALTER TABLE Goal_Players ADD CONSTRAINT Goal_Players_GoalEvents_FK FOREIGN KEY ( GoalEvents_g_id ) REFERENCES GoalEvents ( g_id );
ALTER TABLE Goal_Players ADD CONSTRAINT Goal_Players_Players_FK FOREIGN KEY ( Players_p_id ) REFERENCES Players ( p_id );
ALTER TABLE Players ADD CONSTRAINT Players_Positions_FK FOREIGN KEY ( positionId ) REFERENCES Positions ( p_id );
ALTER TABLE Players ADD CONSTRAINT Players_Teams_FK FOREIGN KEY ( currentTeamId ) REFERENCES Teams ( t_id );
ALTER TABLE Teams ADD CONSTRAINT Teams_Conferences_FK FOREIGN KEY ( conferenceId ) REFERENCES Conferences ( c_id );
ALTER TABLE Teams ADD CONSTRAINT Teams_Divisions_FK FOREIGN KEY ( divisionId ) REFERENCES Divisions ( d_id );
ALTER TABLE Teams ADD CONSTRAINT Teams_TimeZones_FK FOREIGN KEY ( timeZoneId ) REFERENCES TimeZones ( tz_id );
ALTER TABLE Teams ADD CONSTRAINT Teams_Venues_FK FOREIGN KEY ( venueId ) REFERENCES Venues ( v_id );

--create sequences
drop sequence seq_division;
drop sequence seq_conference;
drop sequence seq_tZone;
drop sequence seq_position;
drop sequence seq_team;
drop sequence seq_venue;
drop sequence seq_player;
drop sequence seq_goalEvnt;
drop sequence seq_game;

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

CREATE SEQUENCE seq_tZone
START WITH 50
INCREMENT BY 1
MINVALUE 50
MAXVALUE 59
NOCACHE
NOCYCLE;
CREATE OR REPLACE TRIGGER timeZone_tz_id_TRG BEFORE
  INSERT ON TimeZones FOR EACH ROW WHEN (NEW.tz_id IS NULL) BEGIN :NEW.tz_id := seq_tZone.NEXTVAL;
END;

CREATE SEQUENCE seq_position
START WITH 60
INCREMENT BY 1
MINVALUE 60
MAXVALUE 79
NOCACHE
NOCYCLE;
CREATE OR REPLACE TRIGGER position_p_id_TRG BEFORE
  INSERT ON Positions FOR EACH ROW WHEN (NEW.p_id IS NULL) BEGIN :NEW.p_id := seq_position.NEXTVAL;
END;

CREATE SEQUENCE seq_team
START WITH 100
INCREMENT BY 1
MINVALUE 100
MAXVALUE 499
NOCACHE
NOCYCLE;
CREATE OR REPLACE TRIGGER team_t_id_TRG BEFORE
  INSERT ON Teams FOR EACH ROW WHEN (NEW.t_id IS NULL) BEGIN :NEW.t_id := seq_team.NEXTVAL;
END;

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

--CREATE SEQUENCE seq_goalEvnt
--START WITH 50000
--INCREMENT BY 1
--MINVALUE 50000
--MAXVALUE 199999
--CACHE 30
--NOCYCLE;
--CREATE OR REPLACE TRIGGER goalevnt_g_id_TRG BEFORE
--  INSERT ON GoalEvents FOR EACH ROW WHEN (NEW.g_id IS NULL) BEGIN :NEW.g_id := seq_goalEvnt.NEXTVAL;
--END;

CREATE SEQUENCE seq_game
START WITH 200000
INCREMENT BY 1
MINVALUE 200000
NOMAXVALUE 
CACHE 20
NOCYCLE;
CREATE OR REPLACE TRIGGER game_g_id_TRG BEFORE
  INSERT ON Games FOR EACH ROW WHEN (NEW.g_id IS NULL) BEGIN :NEW.g_id := seq_game.NEXTVAL;
END;