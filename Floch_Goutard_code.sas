libname Projet "/home/u59484868/SAS2021/Projet";

/**********************************************************************************/
/* 1 - Importation des données */
/***********************************************************************************/

/* Import de la table player_info */
data PROJET.player_info;
          %let _EFIERR_ = 0; /* set the ERROR detection macro variable */
          infile "/home/u59484868/SAS2021/Projet/player_info.csv" delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=2 ;
             informat player_id $9. ;
             informat firstName $16. ;
             informat lastName $21. ;
             informat nationality $5. ;
             informat birthCity $29. ;
             informat primaryPosition $4. ;
             informat birthDate anydtdtm40. ;
             informat birthStateProvince $4. ;
             informat height $9. ;
             informat height_cm $6. ;
             informat weight $3. ;
             informat shootsCatches $3. ;
             format player_id $9. ;
             format firstName $16. ;
             format lastName $21. ;
             format nationality $5. ;
             format birthCity $29. ;
             format primaryPosition $4. ;
             format birthDate datetime. ;
             format birthStateProvince $4. ;
             format height $9. ;
             format height_cm $6. ;
             format weight $3. ;
             format shootsCatches $3. ;
          input
                      player_id  $
                      firstName  $
                      lastName  $
                      nationality  $
                      birthCity  $
                      primaryPosition  $
                      birthDate
                      birthStateProvince  $
                      height  $
                      height_cm  $
                      weight  $
                      shootsCatches  $
          ;
          if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
run;
 
 
/* recodage des valeurs manquantes */ 
data PROJET.player_info;
	set PROJET.player_info;
	array char _character_;
	array num _numeric_ ;  
	do over CHAR; 
		if CHAR="NA" then call missing(CHAR);
	end;
run;
 
/* conversion des champs en format numérique, ajout du poids en kg et de shootsCatches en indicatrice */
data PROJET.player_info (DROP =height_cm weight);
	set PROJET.player_info;
	attrib
		new_height_cm format=best12.
		new_weight format=best12.
		weight_kg  format=best12.
		shootsCatches_ind label="1 pour gauchers et 0 pour droitiers" format=best12.
		IMC label="IMC (kg/m2)" format=best12.
	;
new_height_cm = input(height_cm, best12.) ; 
new_weight = input(weight, best12.) ;
weight_kg = input(round(weight/2.2046,0.3), best12.) ;
IMC = (weight_kg/((new_height_cm/100)**2));
/* gauchers (1) comme référence et (0) pour droitiers*/
if shootsCatches = "L" then shootsCatches_ind = 1;
else if shootsCatches = "R" then shootsCatches_ind = 0;
else shootsCatches_ind = .;
run; 

/* Import table game_skater_stats */
 data PROJET.game_skater_stats;
          %let _EFIERR_ = 0; /* set the ERROR detection macro variable */
          infile "/home/u59484868/SAS2021/Projet/game_skater_stats.csv" delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=2 ;
             informat game_id $10. ;
             informat player_id $9. ;
             informat team_id $3. ;
             informat timeOnIce $6.;
             informat assists $2. ;
             informat goals $2. ;
             informat shots $3.;
             informat hits $3.;
             informat powerPlayGoals $3.;
             informat powerPlayAssists $3.;
             informat penaltyMinutes $3.;
             informat faceOffWins $3.;
             informat faceoffTaken $3.;
             informat takeaways $3.;
             informat giveaways $3.;
             informat shortHandedGoals $3.;
             informat shortHandedAssists $3.;
             informat blocked $3.;
             informat plusMinus $3.;
             informat evenTimeOnIce $5.;
             informat shortHandedTimeOnIce $5.;
             informat powerPlayTimeOnIce $5.;
          ;
          input
          	game_id  $
          	player_id  $
          	team_id  $
          	timeOnIce  $
          	assists  $
          	goals  $
          	shots  $
          	hits  $
          	powerPlayGoals  $
          	powerPlayAssists  $
          	penaltyMinutes  $
          	faceOffWins  $
          	faceoffTaken  $
          	takeaways  $
          	giveaways  $
          	shortHandedGoals  $
          	shortHandedAssists  $
          	blocked  $
          	plusMinus  $
          	evenTimeOnIce  $
          	shortHandedTimeOnIce  $
          	powerPlayTimeOnIce  $
          ;
          if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
run;

/* recodage des valeurs manquantes */ 
data PROJET.game_skater_stats;
	set PROJET.game_skater_stats;
	array char _character_;
	array num _numeric_ ;  
 	do over CHAR; 
    	if CHAR="NA" then call missing(CHAR);
	end;
run;

/* conversion des champs en format numérique */
data PROJET.game_skater_stats (DROP = timeOnIce assists goals shots hits powerPlayGoals powerPlayAssists penaltyMinutes faceOffWins faceoffTaken takeaways giveaways shortHandedGoals shortHandedAssists blocked plusMinus evenTimeOnIce shortHandedTimeOnIce powerPlayTimeOnIce);
	set PROJET.game_skater_stats;
	new_timeOnIce = input(timeOnIce, best12.) ; 
	new_assists = input(assists, best12.) ; 
	new_goals = input(goals, best12.);
	new_shots = input(shots, best12.);
	new_hits = input(hits, best12.);
	new_powerPlayGoals = input(powerPlayGoals, best12.);
	new_powerPlayAssists = input(powerPlayAssists, best12.);
	new_penaltyMinutes = input(penaltyMinutes, best12.);
	new_faceOffWins = input(faceOffWins, best12.);
	new_faceoffTaken = input(faceoffTaken, best12.);
	new_takeaways = input(takeaways, best12.);
	new_giveaways = input(giveaways, best12.);
	new_shortHandedGoals = input(shortHandedGoals, best12.);
	new_shortHandedAssists = input(shortHandedAssists, best12.);
	new_blocked = input(blocked, best12.);
	new_plusMinus = input(plusMinus, best12.);
	new_evenTimeOnIce = input(evenTimeOnIce, best12.);
	new_shortHandedTimeOnIce = input(shortHandedTimeOnIce, best12.);
	new_powerPlayTimeOnIce = input(powerPlayTimeOnIce, best12.);
run; 

/* on remplace les 0 par 1 dans les colonnes new_timeOnIce shortHandedTimeOnIce et powerPlayTimeOnIce */
data PROJET.game_skater_stats2 (DROP = new_timeOnIce new_shortHandedTimeOnIce new_powerPlayTimeOnIce);
   set PROJET.game_skater_stats;
   attrib 
   timeOnIce format = best12.
   shortHandedTimeOnIce format= best12.
   powerPlayTimeOnIce format= best12.
   ;
   if new_timeOnIce = 0 then timeOnIce = 1;
   else timeOnIce = new_timeOnIce;
   if new_shortHandedTimeOnIce = 0 then shortHandedTimeOnIce = 1 ;
   else shortHandedTimeOnIce = new_shortHandedTimeOnIce ;
   if new_powerPlayTimeOnIce = 0 then powerPlayTimeOnIce = 1 ;
   else powerPlayTimeOnIce = new_powerPlayTimeOnIce ;
run ;

/* on ramène les données au temps de jeu en heure */
data PROJET.game_skater_stats3;
	set PROJET.game_skater_stats2;
	attrib
	assists_pertime_hour format=best12.
	goals_pertime_hour format=best12.
	shots_pertime_hour format=best12.
	hits_pertime_hour format=best12.
	powerPlayGoals_pertime_hour format=best12.
	powerPlayAssists_pertime_hour format=best12.
	faceOffWins_pertime_hour format=best12.
	faceoffTaken_pertime_hour format=best12.
	takeaways_pertime_hour format=best12.
	giveaways_pertime_hour format=best12.
	shortHandedGoals_pertime_hour format=best12.
	shortHandedAssists_pertime_hour format=best12.
	blocked_pertime_hour format=best12.
	;
	assists_pertime_hour = (new_assists/timeOnIce)*60*60 ; 
	goals_pertime_hour = (new_goals/timeOnIce)*60*60;
	shots_pertime_hour = (new_shots/timeOnIce)*60*60;
	hits_pertime_hour = (new_hits/timeOnIce)*60*60;
	powerPlayGoals_pertime_hour = (new_powerPlayGoals/powerPlayTimeOnIce)*60*60;
	powerPlayAssists_pertime_hour = (new_powerPlayAssists/powerPlayTimeOnIce)*60*60;
	faceOffWins_pertime_hour = (new_faceOffWins/timeOnIce)*60*60;
	faceoffTaken_pertime_hour = (new_faceoffTaken/timeOnIce)*60*60;
	takeaways_pertime_hour = (new_takeaways/timeOnIce)*60*60;
	giveaways_pertime_hour = (new_giveaways/timeOnIce)*60*60;
	shortHandedGoals_pertime_hour = (new_shortHandedGoals/shortHandedTimeOnIce)*60*60;
	shortHandedAssists_pertime_hour = (new_shortHandedAssists/shortHandedTimeOnIce)*60*60;
	blocked_pertime_hour = (new_blocked/timeOnIce)*60*60;
run; 
/* Dans un premier temps, pour chaque joueur par match et par équipe, on a ramené les statistiques au temps de jeu correspondant. 
Par exemple, le nombre de buts est divisé par le temps sur glace.
Le nombre de buts en supériorité numérique est divisé par le temps sur glace en supériorité numérique. 
Or, certains joueurs n'ont pas joué du tout et d'autre n'ont pas joué en supériorité numérique (ou infériorité numérique),
on ne peut donc pas, dans ce cas là, diviser le nombre de but en supériorité numérique par 0. 
On a alors remplacé tous les 0 des colonnes correspondantes (timeOnIce shortHandedTimeOnIce et powerPlayTimeOnIce) par 1.
De cette façon, on divisera le nombre de but en supériorité numérique par 1 et non 0, ce qui ne changera pas le résultat mais ne posera pas de problème. 
On multiplie ensuite deux fois par 60 afin d'exprimer ces statistique par heure.*/

/* Import table game_goalie_stats */
PROC IMPORT datafile="/home/u59484868/SAS2021/Projet/game_goalie_stats.csv"
	DBMS=csv replace
	OUT=PROJET.game_goalie_stats;
	DELIMITER= ',';
	GETNAMES=YES;
	GUESSINGROWS=2000;
RUN;

/* recodage des valeurs manquantes */ 
data PROJET.game_goalie_stats;
	set PROJET.game_goalie_stats;
	array char _character_;
	array num _numeric_ ;  
	do over CHAR; 
		if CHAR="NA" then call missing(CHAR);
	end;
run;

/* conversion des champs en format numérique */
data PROJET.game_goalie_stats (DROP = savePercentage powerPlaySavePercentage evenStrengthSavePercentage);
	set PROJET.game_goalie_stats;
	new_savePercentage = input(savePercentage, best12.) ; 
	new_powerPlaySavePercentage = input(powerPlaySavePercentage, best12.) ; 
	new_evenStrengthSavePercentage = input(evenStrengthSavePercentage, best12.) ; 
run; 

/* Import table game */
PROC IMPORT datafile="/home/u59484868/SAS2021/Projet/game.csv"
	DBMS=csv replace
	OUT=PROJET.game;
	DELIMITER= ',';
	GETNAMES=YES;
	GUESSINGROWS=2000;
RUN;

/* recodage des valeurs manquantes */ 
data PROJET.game;
	set PROJET.game;
	array char _character_;
	array num _numeric_ ;  
	do over CHAR; 
		if CHAR="NA" then call missing(CHAR);
	end;
run;

/**********************************************************************************/
/* 2 - Gestion des doublons */
/***********************************************************************************/

/* on regarde s'il y a des doublons pour chaque table */
PROC SQL;
   create table PROJET.player_info_doublons as select player_id, count(*)
   from PROJET.player_info
   group by player_id
   having count(*) > 1;
QUIT; /* pas de doublons pour player_info */

PROC SQL;
   create table PROJET.game_skater_stats_doublons as select game_id, player_id, team_id,count(*)
   from PROJET.game_skater_stats3
   group by game_id, player_id, team_id
   having count(*) > 1; /* présence de doublons pour game_skater_stats */
QUIT;

PROC SORT DATA=PROJET.game_skater_stats3 NODUPKEY OUT = PROJET.game_skater_stats_final;
BY game_id player_id team_id;
RUN; /* plus de doublons pour game_skater_stats */

PROC SQL;
   create table PROJET.game_goalie_stats_doublons as select game_id, player_id, team_id, count(*)
   from PROJET.game_goalie_stats
   group by game_id, player_id, team_id
   having count(*) > 1; /* présence de doublons pour game_goalie_stats */
QUIT;

PROC SORT DATA=PROJET.game_goalie_stats NODUPKEY OUT = PROJET.game_goalie_stats_final;
BY game_id player_id team_id;
RUN; /* plus de doublons pour game_goalie_stats */

PROC SQL;
   create table PROJET.game_doublons as select game_id, count(*)
   from PROJET.game
   group by game_id
   having count(*) > 1;
QUIT; /* pas de doublons pour player_info */

/* on supprime les tables doublons générées précédement */
PROC DATASETS library = PROJET;
    delete player_info_doublons game_skater_stats_doublons game_goalie_stats_doublons game_doublons;
run;

/**********************************************************************************/
/* 3 - Sélection des données */
/***********************************************************************************/
/* on garde uniquement les stats de goalie et skaters pour les matchs en saison régulière */
PROC SQL;
   CREATE TABLE PROJET.game_skater_stats_final AS
   SELECT *
   FROM PROJET.game_skater_stats_final
   WHERE game_id IN 
   		(SELECT game_id 
   		FROM PROJET.game
   		WHERE type = "R");
QUIT;

PROC SQL;
   CREATE TABLE PROJET.game_goalie_stats_final AS
   SELECT *
   FROM PROJET.game_goalie_stats_final
   WHERE game_id IN 
   		(SELECT game_id 
   		FROM PROJET.game
   		WHERE type = "R");
QUIT;

/* on cherche a expliquer primaryPosition donc on supprime tous les joueurs pour lesquels cette ligne serait vide */
PROC SQL;
   CREATE TABLE PROJET.player_info_final AS
   SELECT *
   FROM PROJET.player_info
   WHERE primaryPosition IS NOT NULL;
QUIT; /* aucune valeur nulle dans la colonne primaryPosition */

/* On supprime les lignes pour lesquelles le temps du joueur sur la glace est plus grande que la durée du match, soit 3900 secondes (65minutes).
En effet, la duree d'un match est de 60 min (3600sec) mais il est possible d'avoir une prolongation en mort subite, 
soit 5 minutes max en NHL (300sec). 
Cependant, il est rare voire impossible qu'un joueur reste aussi longtemps sur le terrain. Peut-être que les durées proches de 3900 sont aberrantes.
De plus, on ne souhaite pas garder les joueurs qui ont joué moins de 232 secondes ce qui correspond à la valeur minimum retenue 
par le boxplot du temps passé sur la glace des patineurs.*/
PROC SGPLOT data=PROJET.game_skater_stats_final;
VBOX timeOnIce;
RUN;
PROC TABULATE data=PROJET.game_skater_stats_final;
var timeOnIce;
table timeOnIce * (MIN P10 Q1 MEDIAN MEAN Q3 P90 MAX);
RUN;
PROC SQL;
   create table PROJET.game_skater_stats_final as select *
   from PROJET.game_skater_stats_final
   where (timeOnIce <= 3900 AND timeOnIce > 233);
QUIT;

/* On fait la même chose avec goalie_stats */
PROC SGPLOT data=PROJET.game_goalie_stats_final;
VBOX timeOnIce;
RUN;
PROC TABULATE data=PROJET.game_goalie_stats_final;
var timeOnIce;
table timeOnIce * (MIN P10 Q1 MEDIAN MEAN Q3 P90 MAX);
RUN;
PROC SQL;
   create table PROJET.game_goalie_stats_final as select *
   from PROJET.game_goalie_stats_final
   where (timeOnIce <= 3900 AND timeOnIce > 232);
QUIT;

/**********************************************************************************/
/* 4 - Statistiques descriptives et gestion des valeurs aberrantes */
/***********************************************************************************/

/* on joint game_skater_stats et player_info */
PROC SQL;
   CREATE TABLE PROJET.skaterStats_playerInfos AS
   SELECT skater.*, player.*
   FROM PROJET.game_skater_stats_final as skater INNER JOIN PROJET.player_info_final as player ON skater.player_id = player.player_id;
QUIT;

/* on joint game_goalie_stats et player_info */
PROC SQL;
   CREATE TABLE PROJET.goalieStats_playerInfos AS
   SELECT goalie.*, player.*
   FROM PROJET.game_goalie_stats_final as goalie INNER JOIN PROJET.player_info_final as player ON goalie.player_id = player.player_id;
QUIT;

/* STATS UNIVARIEES */
/* Nombre d'observations par poste */
PROC SGPLOT DATA = PROJET.player_info_final;
   VBAR primaryPosition;
RUN;
 
/* STATS BIVARIEES */
/* Proportion de gaucher et droitier par poste */
ods output CrossTabFreqs=freq;
proc freq DATA=PROJET.player_info_final;
	TABLES primaryPosition*shootsCatches_ind ;
	run;
	proc sgplot data = freq;
	vbar primaryPosition/response=rowpercent group=shootsCatches_ind;
	title 'Proportion de gaucher et droitier par poste';
run;
/* ou (en fonction de par rapport à quoi on veut le pourcentage) */
proc freq data=PROJET.player_info_final;
   tables shootsCatches_ind*primaryPosition/ plots=FreqPlot(twoway=cluster scale=Percent) out=Freq2Out;
   title 'Proportion de gaucher et droitier par poste' ;
run;

/* un poste se distingue : celui de RW (ailié droit). 
En effet, il y a plus de gauchers que de droitiers pour les postes C (centre), D (défense) et LW (ailié gauche) alors que pour RW (ailié droit) il y a plus de droitiers.*/

/* Temps passé sur la glace en fonction du poste */
PROC SGPLOT data=PROJET.skaterStats_playerInfos;
   VBOX timeOnIce / category = primaryPosition ;
   title 'Temps passé sur la glace (en secondes) en fonction du poste';
RUN; 
PROC TABULATE data=PROJET.skaterStats_playerInfos;
var timeOnIce;
table timeOnIce * (MIN P10 Q1 MEDIAN MEAN Q3 P90 MAX);
RUN;
/* Les défenseurs passent en général plus de temps sur la glace que les autres (centre, ailiés gauche et droite). */
PROC SGPLOT data=PROJET.goalieStats_playerInfos;
   VBOX timeOnIce ;
   title 'Temps passé sur la glace (en secondes) pour un goal';
RUN; 
PROC TABULATE data=PROJET.goalieStats_playerInfos;
var timeOnIce;
table timeOnIce * (MIN P10 Q1 MEDIAN MEAN Q3 P90 MAX);
RUN;
* Pour les goals, énormement d'observations sont indiquées comme aberrantes par le boxplot.
Le temps passé sur la glace varie beaucoup moins que pour les autres postes (ailiers gauche ou droite, centres, défenseurs). 
25% des goals restent plus de 3529 secondes sur la glace par match, soit quasiment tout le match...
10% des goals restent moins de 2395 secondes sur la glace par match, soit environ 40 minutes.*/

/* IMC en fonction du poste */
PROC SGPLOT data=PROJET.player_info_final;
   VBOX IMC / category = primaryPosition ;
   title 'IMC en fonction du poste';
RUN; 
/* Les goals ont en général un IMC plus faible que les autres postes (C, D, RW, LW). */

/* Nombre de tirs (par heure) en fonction du poste */
PROC SGPLOT data=PROJET.skaterStats_playerInfos;
   VBOX shots_pertime_hour / category = primaryPosition ;
   title 'Nombre de tirs (par heure) en fonction du poste';
RUN; 
PROC TABULATE data=PROJET.skaterStats_playerInfos;
class primaryPosition ;
var  shots_pertime_hour  ;
table primaryPosition * shots_pertime_hour  * (MIN P10 Q1 MEDIAN MEAN Q3 P90 MAX);
RUN;
/* En général, les défenseurs tirent moins sur un temps de jeu de 60 minutes que les ailiers gauche/droits et les centres.
En effet, 75% des défenseurs tirent moins de 6 fois en 60 minutes de temps sur glace 
contre 11, 10 et 9 fois pour les ailiers droit, gauche et centre respectivement. */

/* Nombre de buts (par heure) en fonction du poste */
PROC SGPLOT data=PROJET.skaterStats_playerInfos;
   title 'Nombre de buts (par heure) en fonction du poste';
   VBOX goals_pertime_hour / category = primaryPosition ;
RUN; 
PROC TABULATE data=PROJET.skaterStats_playerInfos;
class primaryPosition ;
var  goals_pertime_hour  ;
table primaryPosition * goals_pertime_hour  * (MIN P10 Q1 MEDIAN MEAN Q3 P90 MAX);
RUN;

/* Nombre de passes décisives (par heure) en fonction du poste */
PROC SGPLOT data=PROJET.skaterStats_playerInfos;
   title 'Nombre de passes décisives (par heure) en fonction du poste';
   VBOX assists_pertime_hour / category = primaryPosition ;
RUN; 
PROC TABULATE data=PROJET.skaterStats_playerInfos;
class primaryPosition ;
var  assists_pertime_hour  ;
table primaryPosition * assists_pertime_hour  * (MIN P10 Q1 MEDIAN MEAN Q3 P90 MAX);
RUN;

/**********************************************************************************/
/* 5 - Analyse des données */
/***********************************************************************************/
/* Création de la table pour l'acp */
/* On calcule la moyenne de chaque variable par joueur*/
/* On obtient alors la moyenne de chaque variable par joueur par heure*/
PROC SQL;
CREATE TABLE PROJET.acp_player AS
SELECT DISTINCT primaryPosition, 
AVG(timeOnIce) AS moy_timeOnIce, 
AVG(assists_pertime_hour)AS moy_assists,
AVG(goals_pertime_hour) AS moy_goals, 
AVG(shots_pertime_hour) AS moy_shots, 
AVG(hits_pertime_hour)AS moy_hits,
AVG(powerPlayGoals_pertime_hour)AS moy_powerPlayGoals,
AVG(powerPlayAssists_pertime_hour) AS moy_powerPlayAssists,
AVG(new_penaltyMinutes) AS moy_penaltyMinutes,
AVG(faceOffTaken_pertime_hour) AS moy_faceOffTaken, 
AVG(faceOffWins_pertime_hour) AS moy_faceOffWins, 
AVG(giveaways_pertime_hour) AS moy_giveaways, 
AVG(takeaways_pertime_hour) AS moy_takeaways,
AVG(shortHandedGoals_pertime_hour) AS moy_shortHandedGoals, 
AVG(shortHandedAssists_pertime_hour) AS moy_shortHandedAssists,
AVG(blocked_pertime_hour) AS moy_blocked, 
ShootsCatches_ind,
new_height_cm, 
IMC
FROM PROJET.skaterstats_playerinfos
GROUP BY  player_id;
RUN;
QUIT;

/* On realise l'acp */
PROC PRINCOMP DATA=PROJET.acp_player PLOTS=PATTERN(VECTOR) OUT= PROJET.skater_acp OUTSTAT=PROJET.stat N=6 standard ;
VAR moy_timeOnIce 
moy_assists 
moy_goals  
moy_shots 
moy_hits 
moy_powerPlayGoals 
moy_powerPlayAssists 
moy_penaltyMinutes
moy_faceOffTaken
moy_faceOffWins
moy_giveaways
moy_takeaways
moy_shortHandedGoals
moy_shortHandedAssists
moy_blocked
ShootsCatches_ind
new_height_cm
IMC;
RUN ;
ods graphics on;
ods select patternPlot;

/* Représentation des individus sur les axes 1 et 2 */
PROC GPLOT data=PROJET.skater_acp;
   plot Prin2*Prin1=primaryPosition ;
   symbol1 h=0.5 i=none c=red v=dot;
   symbol2 h=0.5 i=none c=blue v=dot;
   symbol3 h=0.5 i=none c=green v=dot;
   symbol4 h=0.5 i=none c=orange v=dot;
RUN;
QUIT;
/* Les axes 1 et 2 expliquent environ 29% de l'information. 
On remarque une nette séparation entre les défenseurs et les centres sur l'axe 2. 
Cependant, les ailiers droits et les ailiers gauches sont regroupés et pas totalement séparés des centres et des défenseurs. 
Etant donné que le pourcentage d'information des axes 1 et 3 est proche de celui des axes 1 et 2, 
nous allons voir si la représentation des individus et des variables est meilleure sur ces axes.*/


/* Représentation des individus sur les axes 1 et 3 */
PROC GPLOT data=PROJET.skater_acp;
   plot Prin3*Prin1=primaryPosition ;
   symbol1 h=0.5 i=none c=red v=dot;
   symbol2 h=0.5 i=none c=blue v=dot;
   symbol3 h=0.5 i=none c=green v=dot;
   symbol4 h=0.5 i=none c=orange v=dot;
RUN;
QUIT;
/* Les axes 1 et 3 expliquent environ 26% de l'information. 
Avec cette représentation, l'axe 1 permet de bien distinguer les défenseurs (D) des centres (C).
L'axe 3 sépare globalement les ailiers (droits et gauches) des centres et défenseurs.
En mettant en correspondance les représentations des individus et des variables, on aurait tendance à dire que :
- Ce sont les défenseurs qui bloquent le plus de tirs. 
  En effet, la variable "moy_blocked" est celle la plus proche des points bleus qui correspondent aux défenseurs.
- Ce sont les centres qui font le plus de mises en jeu. 
  En effet, les variables "moy_faceOffWins" et "moy_faceoffTaken" sont celles proches des individus rouges, à savoir les centres.
- Ce sont les les ailiers (gauche ou droit) qui font le plus de passes décisives et qui encaissent le plus de minutes de pénalité. 
  En effet, les variables "moy_assists" et "moy_penaltyMinutes" sont proche des points vert (ailié gauche) et jaune (ailié droit).
--> Cette première approche graphique semble cohérente avec les rôles de chaque poste. */


/**********************************************************************************/
/* 7 - Regression logistique */
/***********************************************************************************/
/* Notre variable expliquée Y est primaryPosition. Elle est qualitative, nous allons donc faire 
des regressions logistiques binaires pour chaque facteur de primaryposition. */

/* On crée 4 tables différentes pour chaque régression.
Pour  chaque table, primaryPosition prendra 1 pour le poste en question et 0 sinon.
Par exemple, pour les patineurs défenseurs, primaryPosition prendra 1 si D et 0 si RW, LW ou C.*/ 

/* table des joueurs de centre (C) */
data PROJET.skaterstats_playerinfosC;
   set PROJET.skaterstats_playerinfos;
   ;
   if primaryPosition = 'C' then primaryPosition = 1 ;
   else primaryPosition = 0 ;
run ; 

/* table des joueurs défenseurs (D) */
data PROJET.skaterstats_playerinfosD;
   set PROJET.skaterstats_playerinfos;
   ;
   if primaryPosition = 'D' then primaryPosition = 1 ;
   else primaryPosition = 0 ;
run ; 

/* table des joueurs ailiers droits (RW) */
data PROJET.skaterstats_playerinfosRW;
   set PROJET.skaterstats_playerinfos;
   ;
   if primaryPosition = 'RW' then primaryPosition = 1 ;
   else primaryPosition = 0 ;
run ; 

/* table des joueurs ailiers gauches (LW) */
data PROJET.skaterstats_playerinfosLW;
   set PROJET.skaterstats_playerinfos;
   ;
   if primaryPosition = 'LW' then primaryPosition = 1 ;
   else primaryPosition = 0 ;
run ; 
 
/* Pour chaque régression logistique, on utilise la procédure de sélection automatique de variable STEPWISE (progressive).​
Elle est identique à la méthode FORWARD sauf qu'une variable introduite dans le modèle n'y reste pas forcément.​
Après avoir comparé avec les méthodes FORWARD et BACKWARD il n'y pas vraiment de différence au niveau des variables retenues.​
Nous avons donc décidé de garder la procédure STEPWISE. */ 

/*regression logistique pour D*/
proc logistic data=PROJET.skaterstats_playerinfosD DESCENDING;
model primaryPosition(event='1') = timeOnIce
assists_pertime_hour
goals_pertime_hour
shots_pertime_hour
hits_pertime_hour
powerPlayGoals_pertime_hour
powerPlayAssists_pertime_hour
new_penaltyMinutes
faceOffTaken_pertime_hour
faceOffWins_pertime_hour
giveaways_pertime_hour
takeaways_pertime_hour
shortHandedGoals_pertime_hour
shortHandedAssists_pertime_hour
blocked_pertime_hour
ShootsCatches_ind
new_height_cm
IMC / SELECTION=stepwise slentry=0.05 rsquare;
run;
/* Le D de Somers étant de 91.5%, les performances de prévision du modèle sont bonnes.
Les variables "goals_pertime_hour" et "blocked_pertime_hour" sont celles qui ont les valeurs estimées les plus extrêmes.
D'après les valeurs estimées du maximum de vraisemblance, le nombre de tirs bloqués à un effet positif sur la probabilité d'être défenseur.
A l'inverse, le nombre de buts marqués à un effet négatif sur la probabilité d'être défenseur.
Ces résultats confirment bien ceux de l'ACP et rejoignent le profil du poste de défenseur. */

/*regression logistique pour RW*/
proc logistic data=PROJET.skaterstats_playerinfosRW;
model primaryPosition(event='1') = timeOnIce
assists_pertime_hour
goals_pertime_hour
shots_pertime_hour
hits_pertime_hour
powerPlayGoals_pertime_hour
powerPlayAssists_pertime_hour
new_penaltyMinutes
faceOffTaken_pertime_hour
faceOffWins_pertime_hour
giveaways_pertime_hour
takeaways_pertime_hour
shortHandedGoals_pertime_hour
shortHandedAssists_pertime_hour
blocked_pertime_hour
ShootsCatches_ind
new_height_cm
IMC / SELECTION=stepwise slentry=0.05 rsquare ;
run;
/* Le D de Somers étant de 64.4%, les performances de prévision du modèle sont relativement bonnes, mais pourrait être meilleures.
La variable "shootsCatches_ind" est celle qui a la valeur estimée la plus extrême.
D'après les valeurs estimées du maximum de vraisemblance, le fait d'être gaucher à un effet négaitf sur la probabilité d'être ailier droit.
En d'autres termes, être droitier a un effet positif sur la probabilité d'être ailier droit.
Ce résultat confirme bien ceux obtenus dans les statistiques descriptives. */

/* regression logistique pour LW*/
proc logistic data=PROJET.skaterstats_playerinfosLW;
model primaryPosition(event='1') = timeOnIce
assists_pertime_hour
goals_pertime_hour
shots_pertime_hour
hits_pertime_hour
powerPlayGoals_pertime_hour
powerPlayAssists_pertime_hour
new_penaltyMinutes
faceOffTaken_pertime_hour
faceOffWins_pertime_hour
giveaways_pertime_hour
takeaways_pertime_hour
shortHandedGoals_pertime_hour
shortHandedAssists_pertime_hour
blocked_pertime_hour
ShootsCatches_ind
new_height_cm
IMC / SELECTION=stepwise slentry=0.05 rsquare;
run;
/* Le D de Somers étant de 65%, les performances de prévision du modèle sont relativement bonnes, 
mais pourraient être meilleures, comme c'est le cas pour les ailiers droits.
La variable "shootsCatches_ind" est celle qui a la valeur estimée la plus extrême.
D'après les valeurs estimées du maximum de vraisemblance, le fait d'être gaucher a un effet positif sur la probabilité d'être ailier droit.
Ce résultat confirme bien ceux obtenus dans les statistiques descriptives. */

/* regression logistique pour C */
proc logistic data=PROJET.skaterstats_playerinfosC;
model primaryPosition(event='1') = timeOnIce
assists_pertime_hour
goals_pertime_hour
shots_pertime_hour
hits_pertime_hour
powerPlayGoals_pertime_hour
powerPlayAssists_pertime_hour
new_penaltyMinutes
faceOffTaken_pertime_hour
faceOffWins_pertime_hour
giveaways_pertime_hour
takeaways_pertime_hour
shortHandedGoals_pertime_hour
shortHandedAssists_pertime_hour
blocked_pertime_hour
ShootsCatches_ind
new_height_cm
IMC/ SELECTION=stepwise slentry=0.05 rsquare;
run;
/* Le D de Somers étant de 84.3%, les performances de prévision du modèle sont bonnes.
Les variables "shootsCatches_ind" et "IMC" sont celles qui ont les valeurs estimées les plus extrêmes.
D'après les valeurs estimées du maximum de vraisemblance, le fait d'être gaucher à un effet positif sur le fait d'être centre.
En revanche, l'IMC a un effet négatif sur le probabilité d'être centre.
Ces résultats sont moins évident que pour les autres postes.
En effet, d'après les statistiques descriptives,les individus centres ont un indice de masse corporelle 
globalement plus faible que les postes d'ailiers droit, gauche, défenseurs et centre mais cette observation était légère sur les boxplots. 
De plus, d'après l'AFC on s'attendait surtout à voir resortir comme significative les variables en rapport avec les mise en jeu,
mais celles-ci n'ont pas été gardé dans le modèle après la procédure de sélection des variables. */
