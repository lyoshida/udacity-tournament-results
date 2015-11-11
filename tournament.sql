-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.


-- Creates the Player table
CREATE TABLE players (
  ID serial PRIMARY KEY,
  player_name varchar(255)
);

-- Create the Matches table
CREATE TABLE matches (
  ID serial PRIMARY KEY,
  player1 integer references Players(ID),
  player2 integer references Players(ID),
  winner integer references Players(ID)
);

-- Creates a table listing the number of wins for each player
CREATE VIEW WIN_BY_PLAYER_VIEW AS
SELECT winner, COUNT(winner) win_count
FROM matches
GROUP BY winner;

-- Creates a table (player id, player name, win count) to be used in the last
-- test 
CREATE VIEW WIN_BY_PLAYER_ORDERED_VIEW AS
SELECT players.id, players.player_name, coalesce(win_count,0) AS win_count 
FROM players
LEFT JOIN (
  SELECT winner, COUNT(winner) win_count
  FROM matches
  GROUP BY winner
) as WIN_TABLE
ON players.id = WIN_TABLE.winner
ORDER BY win_count DESC;

-- Lists number of matches grouped by player
CREATE VIEW COUNT_MATCHES_VIEW AS
SELECT player, count(*) total
FROM(
	SELECT player1 as player
	FROM matches
	UNION ALL
	SELECT player2
	FROM matches
) match_count
GROUP BY player;


-- Shows a table with player id, player name, matches won, matches played
CREATE VIEW WIN_VIEW AS
SELECT players.id, players.player_name, coalesce(WIN_BY_PLAYER_VIEW.win_count,0) as wins, coalesce(COUNT_MATCHES_VIEW.total,0) as no_matches FROM players
LEFT JOIN WIN_BY_PLAYER_VIEW
ON WIN_BY_PLAYER_VIEW.winner = players.id
LEFT JOIN COUNT_MATCHES_VIEW
ON COUNT_MATCHES_VIEW.player = players.id
GROUP BY players.id, WIN_BY_PLAYER_VIEW.win_count, COUNT_MATCHES_VIEW.total
ORDER BY WIN_BY_PLAYER_VIEW.win_count DESC;