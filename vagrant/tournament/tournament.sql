-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

DROP VIEW IF EXISTS standings;
DROP VIEW IF EXISTS match_count;
DROP VIEW IF EXISTS w_or_l;
DROP VIEW IF EXISTS winners;
DROP VIEW IF EXISTS losers;

DROP TABLE IF EXISTS Matches;
DROP TABLE IF EXISTS Players;



CREATE TABLE Players(PlayerID SERIAL, Name text, primary key (PlayerID));
CREATE TABLE Matches(Match SERIAL, Winner int REFERENCES players(playerid), Loser int REFERENCES players(playerid));



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

/*INSERT INTO Matches (winner, loser) VALUES*/ 
	/*(2, 1),
	(3, 4),
	(5, 6),
	(8, 7),
	(9, 10),
	(12, 11),
	(13, 14),
	(15, 16),
	(3, 2),
	(5, 8),
	(12, 9),
	(13, 15),
	(1, 4),
	(7, 6),
	(11, 10),
	(14, 16),
	(3, 5),
	(13, 12),
	(1, 2),
	(7, 8),
	(11, 9),
	(14, 15),
	(4, 6),
	(16, 10),
	(3, 13),
	(1, 5),
	(11, 7),
	(12, 14),
	(2, 4),
	(8, 9),
	(16, 15),
	(6, 10);*/


SELECT * FROM Players;
SELECT * FROM Matches;
select * from standings;