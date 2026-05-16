#Projet Graph NBA avec Neo4j

Ce projet consiste à construire une **base de données graphe NBA** avec Neo4j.

Les données CSV sont transformées en un graphe connecté contenant :
- Joueurs
- Équipes
- Matchs
- Classements 

------

#Objectif du projet

Ce projet permet de :
- Modéliser des données NBA en graphe
- Apprendre Cypher (langage Neo4j)
- Créer des relations entre entités
- Optimiser les requêtes avec des index
- Faire de l’analyse de données sportives

------

#Structure des données(On a pas fait le chargement complet de chaque fichier vue la lenteur de l'operation)

## 1. Teams.csv
Contient les informations des équipes :
- TEAM_ID
- CITY
- NICKNAME
- ABBREVIATION

------

## 2. Players.csv
Contient les joueurs :
- PLAYER_ID
- PLAYER_NAME
- TEAM_ID

-------

## 3. Game_date.csv
Contient les matchs :
- GAME_ID
- GAME_DATE_EST
- SEASON
- HOME_TEAM_ID
- VISITOR_TEAM_ID
- PTS_home
- PTS_away
- GAME_STATUS_TEXT

------

## 4. ranking.csv
Contient les classements des équipes :
- TEAM_ID
- SEASON_ID
- W / L
- W_PCT
- CONFERENCE
- STANDINGSDATE

-----

# Modèle du graphe

## Nœuds (Nodes)
- `Player`
- `Team`
- `Game`
- `Standing`

------

## Relations
- `(Player)-[:PLAYS_FOR]->(Team)`
- `(Game)-[:HOME_TEAM]->(Team)`
- `(Game)-[:AWAY_TEAM]->(Team)`
- `(Team)-[:HAS_STANDING]->(Standing)`


## Relations

| Relation | Description |
|----------|-------------|
| `(Player)-[:PLAYS_FOR]->(Team)` | Un joueur appartient toujours à une équipe : cette relation indique dans quelle équipe évolue chaque joueur à un instant donné. |
| `(Game)-[:HOME_TEAM]->(Team)` | Un match a une équipe qui joue à domicile : elle identifie l’équipe qui reçoit et bénéficie de l’avantage du terrain. |
| `(Game)-[:AWAY_TEAM]->(Team)` | Un match a une équipe visiteuse : elle représente l’équipe qui se déplace pour affronter l’équipe à domicile. |
| `(Team)-[:HAS_STANDING]->(Standing)` | Une équipe possède des performances par saison : cette relation relie une équipe à son classement et ses résultats sur une saison donnée. |

------

#  Fonctionnalités

✔ Création du graphe à partir de CSV  
✔ Modélisation propre des données NBA  
✔ Relations entre joueurs, équipes et matchs  

------

#  Étapes du script Cypher

## 1. Suppression de l’ancien graphe
Nettoie toute la base avant import.

## 2. Création des index
Accélère les recherches sur :
- team_id
- player_id
- game_id

## 3. Import des nœuds
- Teams
- Players
- Games

## 4. Création des relations
- Joueur → Équipe
- Match → Équipe domicile
- Match → Équipe extérieure
- Équipe → Classement

## 5. Affichage du graphe
Visualisation complète dans Neo4j Browser

------

# Script Cypher complet

(voir fichier : `nba_graph.cypher`)

-------

# Exemples de requêtes

## Afficher le graphe complet
```cypher
MATCH (n)-[r]->(m)
RETURN n,r,m
LIMIT 200;
