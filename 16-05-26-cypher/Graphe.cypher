// ==========================
// SUPPRESSION (OPTIONNEL)
// ==========================

MATCH (n)
DETACH DELETE n;


// ==========================
// CONTRAINTES
// ==========================

CREATE CONSTRAINT team_id IF NOT EXISTS
FOR (t:Team)
REQUIRE t.team_id IS UNIQUE;

CREATE CONSTRAINT player_id IF NOT EXISTS
FOR (p:Player)
REQUIRE p.player_id IS UNIQUE;

CREATE CONSTRAINT game_id IF NOT EXISTS
FOR (g:Game)
REQUIRE g.game_id IS UNIQUE;


// ==========================
// IMPORT TEAM
// ==========================

LOAD CSV WITH HEADERS FROM 'file:///Teams.csv' AS row

MERGE (t:Team {
    team_id: toInteger(row.TEAM_ID)
})

SET t.name = row.NICKNAME,
    t.city = row.CITY,
    t.abbreviation = row.ABBREVIATION;


// ==========================
// IMPORT PLAYER
// ==========================

LOAD CSV WITH HEADERS FROM 'file:///Players.csv' AS row

MERGE (p:Player {
    player_id: toInteger(row.PLAYER_ID)
})

SET p.name = row.PLAYER_NAME;


// ==========================
// IMPORT GAME
// ==========================

LOAD CSV WITH HEADERS FROM 'file:///Game_date.csv' AS row

MERGE (g:Game {
    game_id: toInteger(row.GAME_ID)
})

SET g.date = row.GAME_DATE_EST,
    g.season = toInteger(row.SEASON),
    g.status = row.GAME_STATUS_TEXT;


// ==========================
// RELATION PLAYER -> TEAM
// ==========================

LOAD CSV WITH HEADERS FROM 'file:///Players.csv' AS row

MATCH (p:Player {
    player_id: toInteger(row.PLAYER_ID)
})

MATCH (t:Team {
    team_id: toInteger(row.TEAM_ID)
})

MERGE (p)-[:PLAYS_FOR]->(t);


// ==========================
// RELATION GAME -> HOME TEAM
// ==========================

LOAD CSV WITH HEADERS FROM 'file:///Game_date.csv' AS row

MATCH (g:Game {
    game_id: toInteger(row.GAME_ID)
})

MATCH (t:Team {
    team_id: toInteger(row.HOME_TEAM_ID)
})

MERGE (g)-[:HOME_TEAM]->(t);


// ==========================
// RELATION GAME -> AWAY TEAM
// ==========================

LOAD CSV WITH HEADERS FROM 'file:///Game_date.csv' AS row

MATCH (g:Game {
    game_id: toInteger(row.GAME_ID)
})

MATCH (t:Team {
    team_id: toInteger(row.VISITOR_TEAM_ID)
})

MERGE (g)-[:AWAY_TEAM]->(t);


// ==========================
// RELATION PLAYER -> GAME
// ==========================

LOAD CSV WITH HEADERS FROM 'file:///Game_details.csv' AS row

MATCH (p:Player {
    player_id: toInteger(row.PLAYER_ID)
})

MATCH (g:Game {
    game_id: toInteger(row.GAME_ID)
})

MERGE (p)-[:PLAYED_IN]->(g);


// ==========================
// AFFICHAGE COMPLET
// ==========================

MATCH (n)-[r]->(m)
RETURN n,r,m
LIMIT 500;
