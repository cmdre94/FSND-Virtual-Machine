-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

DROP VIEW IF EXISTS swisspairings;
DROP VIEW IF EXISTS setup;
DROP VIEW IF EXISTS standings;
DROP VIEW IF EXISTS match_count;
DROP VIEW IF EXISTS w_or_l;
DROP VIEW IF EXISTS winners;
DROP VIEW IF EXISTS losers;

DROP TABLE IF EXISTS setup;
DROP TABLE IF EXISTS Matches;
DROP TABLE IF EXISTS Players;



CREATE TABLE Players(PlayerID SERIAL, Name text, primary key (PlayerID));
CREATE TABLE Matches(Match SERIAL, Winner int REFERENCES players(playerid), Loser int REFERENCES players(playerid));
CREATE TABLE setup(playerid int, name text, row serial);


INSERT INTO setup SELECT * FROM players ORDER BY random;
INSERT INTO Players (Name) Values 
	('Andrew'),
	('Bart'),
	('Cris'),
	('Derick'),
	('Erick'),
	('Frank'),
	('Gina'),
	('Helena'),
	('Isaiah'),
	('Jeremiah'),
	('Kevin'),
	('Luke'),
	('Matt'),
	('Nancy'),
	('OJ'),
	('Paul');

CREATE VIEW w_or_l AS select matches.match, players.playerid, players.name from players JOIN matches on players.playerid = matches.winner or players.playerid = matches.loser;

CREATE VIEW match_count AS SELECT winner AS matches FROM matches UNION SELECT loser FROM matches;

CREATE VIEW winners AS SELECT players.playerid, players.name, count(matches.winner) AS wins, count(matches.winner + matches.loser) AS matches FROM players LEFT JOIN matches ON players.playerid = matches.winner GROUP BY players.playerid ORDER BY wins DESC;

CREATE VIEW standings AS SELECT players.playerid, players.name, count(matches.winner) AS wins, count(match_count.matches) FROM players LEFT JOIN matches ON players.playerid = matches.winner LEFT JOIN match_count ON players.playerid = match_count.matches GROUP BY players.playerid ORDER BY wins DESC;

CREATE VIEW losers AS SELECT players.playerid, players.name, count(matches.loser) AS losses, count(matches.winner + matches.loser) AS matches FROM players LEFT JOIN matches ON players.playerid = matches.loser GROUP BY players.playerid ORDER BY losses DESC;

CREATE VIEW swisspairings AS select a.playerid as id1, a.name as name1, b.playerid as id2, b.name as name2 from setup a, setup b where a.row+1 = b.row and a.row % 2 = 1;


SELECT * FROM Players;
SELECT * FROM Matches;
select * from standings;

/*CREATE VIEW swiss_pairings_1 as 
        select a.player_id as "player_1_id", a.name as "player_1_name", 
        b.player_id as "player_2_id", b.name as "player_2_name"
        from ranked_standings_1 a, ranked_standings_1 b 
        where a.rank+1 = b.rank and a.rank % 2 = 1;*/