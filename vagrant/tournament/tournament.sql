-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

DROP TABLE IF EXISTS Players;
DROP TABLE IF EXISTS Matches;

CREATE TABLE Players(PlayerID SERIAL, Name text, primary key (PlayerID));
CREATE TABLE Matches(Match int,Winner int,Loser int);
INSERT INTO Players (Name) Values ('Jeff'), ('Amy'), ('Jason');	
\d

SELECT * FROM Players;
SELECT * FROM Matches;