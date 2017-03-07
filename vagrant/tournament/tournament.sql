-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

--these drops have to be in a certain order because of dependencies

DROP DATABASE IF EXISTS tournament;
CREATE DATABASE tournament;
\c tournament

CREATE TABLE Players(PlayerID serial, Name text, primary key (PlayerID));

CREATE TABLE Matches(Match SERIAL, Winner int REFERENCES players(playerid), Loser int REFERENCES players(playerid));

--not used
CREATE VIEW w_or_l AS select matches.match, players.playerid, players.name from players JOIN matches on players.playerid = matches.winner or players.playerid = matches.loser;

--used in standings view as matches column
CREATE VIEW match_count AS SELECT winner AS matches FROM matches UNION SELECT loser FROM matches;

--not used
CREATE VIEW winners AS SELECT players.playerid, players.name, count(matches.winner) AS wins, count(matches.winner + matches.loser) AS matches FROM players LEFT JOIN matches ON players.playerid = matches.winner GROUP BY players.playerid ORDER BY wins DESC;

--used in setup view shows wins and number of matches played
--dependent on match_count
CREATE VIEW standings AS SELECT players.playerid, players.name, count(matches.winner) AS wins, count(match_count.matches) AS matches FROM players LEFT JOIN matches ON players.playerid = matches.winner LEFT JOIN match_count ON players.playerid = match_count.matches GROUP BY players.playerid ORDER BY wins DESC;

--not used
CREATE VIEW losers AS SELECT players.playerid, players.name, count(matches.loser) AS losses, count(matches.winner + matches.loser) AS matches FROM players LEFT JOIN matches ON players.playerid = matches.loser GROUP BY players.playerid ORDER BY losses DESC;

--used as setup for swisspairings;
--for swisspairings to work, a row column had to be setup here
CREATE VIEW setup AS  SELECT row_number() over (order by wins desc) AS row, playerid, name from standings;

--dependent on setup view
CREATE VIEW swisspairings AS SELECT a.playerid as id1, a.name as name1, b.playerid as id2, b.name as name2 from setup a, setup b WHERE a.row+1 = b.row and a.row % 2 = 1;

SELECT * FROM Players;
SELECT * FROM Matches;
select * from standings;
