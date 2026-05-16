// SUPPRIMER L'ANCIENNE GRAPHE

MATCH (n)
DETACH DELETE n;


// INDEX 

CREATE INDEX team_id_idx IF NOT EXISTS
FOR (t:Team)
ON (t.team_id);

CREATE INDEX player_id_idx IF NOT EXISTS
FOR (p:Player)
ON (p.player_id);

CREATE INDEX game_id_idx IF NOT EXISTS
FOR (g:Game)
ON (g.game_id);

// IMPORT TEAM

LOAD CSV WITH HEADERS FROM 'file:///Teams.csv' AS row

MERGE (t:Team { team_id: toInteger(row.TEAM_ID) })

SET t.name = row.NICKNAME,
    t.city = row.CITY,
    t.abbreviation = row.ABBREVIATION;


// IMPORT PLAYER

LOAD CSV WITH HEADERS FROM 'file:///Players.csv' AS row

MERGE (p:Player { player_id: toInteger(row.PLAYER_ID) })

SET p.name = row.PLAYER_NAME;


// IMPORT GAME

LOAD CSV WITH HEADERS FROM 'file:///Game_date.csv' AS row

MERGE (g:Game { game_id: toInteger(row.GAME_ID) })

SET g.date = row.GAME_DATE_EST,
    g.season = toInteger(row.SEASON),
    g.status = row.GAME_STATUS_TEXT,
    g.home_team_wins = toInteger(row.HOME_TEAM_WINS),
    g.home_points = toInteger(row.PTS_home),
    g.away_points = toInteger(row.PTS_away);


// PLAYER -> TEAM

LOAD CSV WITH HEADERS FROM 'file:///Players.csv' AS row

MATCH (p:Player { player_id: toInteger(row.PLAYER_ID) })
MATCH (t:Team { team_id: toInteger(row.TEAM_ID) })

MERGE (p)-[:PLAYS_FOR]->(t);

// GAME -> HOME TEAM

LOAD CSV WITH HEADERS FROM 'file:///Game_date.csv' AS row

MATCH (g:Game { game_id: toInteger(row.GAME_ID) })
MATCH (t:Team { team_id: toInteger(row.HOME_TEAM_ID) })

MERGE (g)-[:HOME_TEAM]->(t);


// GAME -> AWAY TEAM

LOAD CSV WITH HEADERS FROM 'file:///Game_date.csv' AS row

MATCH (g:Game { game_id: toInteger(row.GAME_ID) })
MATCH (t:Team { team_id: toInteger(row.VISITOR_TEAM_ID) })

MERGE (g)-[:AWAY_TEAM]->(t);


// TEAM STANDING 

LOAD CSV WITH HEADERS FROM 'file:///ranking.csv' AS row

MATCH (t:Team { team_id: toInteger(row.TEAM_ID) })

MERGE (s:Standing {
    team_id: toInteger(row.TEAM_ID),
    season_id: toInteger(row.SEASON_ID),
    date: row.STANDINGSDATE
})

SET s.team_name = row.TEAM,
    s.conference = row.CONFERENCE,
    s.wins = toInteger(row.W),
    s.losses = toInteger(row.L),
    s.win_pct = toFloat(row.W_PCT),
    s.home_record = row.HOME_RECORD,
    s.road_record = row.ROAD_RECORD;

MERGE (t)-[:HAS_STANDING]->(s);


// AFFICHAGE COMPLET

MATCH (n)-[r]->(m)
RETURN n,r,m
LIMIT 200;
