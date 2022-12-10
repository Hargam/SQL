---------------------------------------------- PROCEDURE STOCKEE -----------------------------------------------------------------
--# Une procédure est similaire é une fonction (d'ailleurs il n'y a pas de distinction dans les autres langages). La seule différence présente sous Mysql réside dans le fait qu'aprés le traitement une fonction retourne une valeur alors que la procédure ne retourne rien.
DELIMITER | --# (afin de changer le ; en | pour éviter les conflits)
SELECT * FROM employes |
----------------------------
--# Création dune procédure stockée qui affiche la date du JOUR au format Franéais.
DROP PROCEDURE IF EXISTS date_du_jour |
CREATE PROCEDURE date_du_jour()
BEGIN
	SELECT DATE_FORMAT(CURDATE(), '%d/%m/%Y') AS 'aujourdhui';
END |
CALL date_du_jour() |


----------------------------
--# Liste des commandes/requetes relatives aux procédures:
	DROP PROCEDURE test| # supprime
	SHOW PROCEDURE STATUS| #montre les PROCEDUREs existantes	
	SHOW PROCEDURE STATUS \G| #montre les PROCEDUREs existantes	
--# 	Arguments/
			IN:
--# 				Paramétre par défaut;
--# 				Valeur passée é la procédure,
--# 				peut-étre modifiée dans la procédure
--# 				mais reste inchangé é l'extérieur de lappel. 
			OUT:
--# 				Aucune valeur passée é la procédure,
--# 				peut étre modifiée dans la procédure,
--# 				et la valeur est changée é l'extérieur de la procédure. 
			INOUT:
--# 				Caractéristiques des paramétres IN et OUT:
--# 				Une valeur est fournie é la procédure,
--# 				et peut étre modifiée et retournée. 
----------------------------
DROP PROCEDURE IF EXISTS addition |
CREATE PROCEDURE addition(IN valeur1 INT, IN valeur2 INT)	--# In: rentre - Out: sort - le param result sert é conserver le resultat
BEGIN
	SELECT valeur1+valeur2;
END|
CALL addition(16,3)|
----------------------------
-- Presentation facultative.
-- CREATE PROCEDURE addition_avec_variable(IN valeur1 INT, IN valeur2 INT, OUT total INT)	--# In: rentre - Out: sort - le param result sert é conserver le resultat
-- BEGIN
-- 		SELECT valeur1+valeur2 INTO total;	--#  INTO permet de garder le resultat dans result qui correspond é la variable quon enverra
-- END|
-- CALL addition_avec_variable(1,8,@r)|
-- SELECT @r|
----------------------------
--# - Exercice 1/ Faire une procédure stockée qui affiche les informations sur les employes
DROP PROCEDURE IF EXISTS affichage_des_employes |
CREATE PROCEDURE affichage_des_employes()
BEGIN
	SELECT * FROM employes;
END|
CALL affichage_des_employes |
----------------------------
--# - Exercice 2/ Faire une PROCEDURE qui prend en param le prenom d'un employe et qui affiche le service de l'employé
DROP PROCEDURE IF EXISTS affiche_service_employes |
CREATE PROCEDURE affiche_service_employes(IN pren VARCHAR(10))
BEGIN
	SELECT service FROM employes WHERE prenom=pren;
END|
CALL affiche_service_employes('julien')|
----------------------------
--# - Exercice 3/ Faire une PROCEDURE qui prend en param l'id d'un employes et qui affiche la ville dans laquelle travail cet employé
DROP PROCEDURE IF EXISTS affichage_des_employes_avec_ville |
CREATE PROCEDURE affichage_des_employes_avec_ville(IN id INT)
BEGIN
	SELECT e.prenom, e.nom, l.ville
	FROM employes e, localite l
	WHERE e.id_employes=id
	AND e.id_secteur = l.id_secteur ;
	SELECT * FROM employes WHERE id_employes=id;
END|
CALL affichage_des_employes_avec_ville(7369)|
----------------------------
--# Avantages liés é l'utilisation des Procédures Stockées:
--# 	.1. moins de risque de se tromper: on rappel x fois la méme procédure et on ne retape pas x fois la méme requete (une seule écriture, plusieurs exec)
--# 	.2. Si on reviens 3 mois + tard, vous voyez un resultat vous voulez savoir de quoi il est issu il est plus aiser de voir le nom de la procédure (plus explicite) que relire tte la jointure.
--# 	.3. Dans votre entreprise, si qqun na jamais fais de SQL mais quil a besoin daccéder aux données, taper "CALL affichage_des_employes_avec_ville()" ira plus vite que lui expliquer comment fonctionne une jointure. Cest plus simple pour un stagiaire.
--# 	.4. Le nombre dinstruction et de calcul intermédiaire nest pas limité dans une procédure, vous pouvez vous servir du resultat dune requete sur une autre requete
--# 	.5. permet é un SITE/LOGICIEL/APPLI IPHONE dutiliser la méme procédure sans avoir é réécrire la requete

--# * Dessiner le [SCHEMA14_avantages_procedure] *

--# 	.6. Si la requete doit évolué elle ne sera changé qué un seul endroit (dans la procédure) et non sur le SITE/LOGICIEL/APPLI IPHONE
--# 	.7. permet de laisser le travail décriture de requete é la personne qui gére la bdd (lécriture de la procédure stockée se fais dans le sgbd et non pas dans le code comme les requetes par exemple), ainsi le développeur peut se concentrer sur le développement du LOGICIEL UNIQUEMENT.
--# 	.8. diminution du temps dexécution : on ne répéte pas le cycle: Analyse / Interpretation / Exécution car elle est déjé enreg sur le serveur.
--# 	Lintérét est multiple : 
--# 	* simplification : code plus simple é comprendre
--# 	* rapidité : moins dinformations sont échangées entre le serveur et le client
--# 	* performance : économise au serveur linterprétation de la requéte car elle est précompilée
--# 	* sécurité : les applications et les utilisateurs nont aucun accés direct aux tables, mais passent par des procédures stockées prédéfinies
----------------------------
--# - Exercice 4/ Cette année, chaque salarié va toucher 10% de son salaire en plus et une prime de 700é. Faite une procédure permettant de calculer le nouveau salaire annuel de chaque salarié en affichant chaque étape.
DROP PROCEDURE IF EXISTS calcul_salaire_employes |
CREATE PROCEDURE calcul_salaire_employes(IN prenomrecu VARCHAR(10))
BEGIN
	DECLARE s INT;
	SELECT ROUND(salaire*12),  ROUND(salaire*12*1.10),  ROUND(salaire*12*1.1+700)  FROM employes WHERE prenom=prenomrecu; --#  ca ou la suite...
	SELECT salaire*12 FROM employes WHERE prenom=prenomrecu INTO s;
	SELECT s as 'resultat 1';
	SET s=s*1.10;
	SELECT s as 'resultat 2';
	SET s=s+700;
	SELECT s as 'resultat 3';
END|
CALL calcul_salaire("fabrice")|
----------------------------
DROP PROCEDURE IF EXISTS condition_couleur |
CREATE PROCEDURE condition_couleur(IN val VARCHAR(10))
BEGIN
	IF val = 'bleu' THEN
			SELECT 'il s\'agit du bleu';
	ELSEIF val = 'rouge' THEN
			SELECT 'il s\'agit du rouge';
	ELSE
			SELECT 'autre couleur';
	END IF; --#  END IF; obligatoirement en 2 mot !
END|
CALL condition_couleur('bleu')|
----------------------------
--# - Exercice 5/ Je vous donne un prénom, vous devez mafficher son salaire et de quel groupe il fait parti.
--# * ce passage est é écrire au tableau *
--# Entre 3000 et + = G1
--# Entre 2000 et 3000 = G2
--# Entre 0 et 2000 = G3
DROP PROCEDURE IF EXISTS groupe_employes |
CREATE PROCEDURE groupe_employes(IN pren VARCHAR(10))
BEGIN
	DECLARE s INT DEFAULT 0; --# ou DECLARE s int DEFAULT 0;
	SELECT * FROM employes WHERE prenom=pren;
	SELECT salaire FROM employes WHERE prenom = pren INTO s;
	IF s > 3000  THEN SELECT CONCAT_WS(' - ','le salarie fait partie du Groupe 1', s) AS resultat;
	ELSEIF s < 2000 THEN SELECT CONCAT_WS(' - ','le salarie fait partie du Groupe 3', s) AS resultat;
	ELSE SELECT CONCAT_WS(' - ','le salarie fait partie du Groupe 2', s) AS resultat;
	END IF;
END |
CALL groupe_employes('benoit')|
CALL groupe_employes('laura')|
--# Modification possible des PROCEDURE stockée dans PMA en se placant sur la bdd concernée: ALTER.
--# Exercice : (é lancer ou pas, selon l'avancement) Faire en sorte de sortir le groupe d'un employé en fonction de son salaire et gérer le cas oé l'employé n'existe pas.
DELIMITER //
DROP PROCEDURE IF EXISTS groupe_employes //
DROP PROCEDURE groupe_employes //
CREATE PROCEDURE groupe_employes(IN pren VARCHAR(10))
BEGIN
	DECLARE s INT DEFAULT 0;
	SELECT * FROM employes WHERE prenom=pren;
	SELECT salaire FROM employes WHERE prenom = pren INTO s;
	IF s > 3000  THEN
		SELECT CONCAT(pren, '  fait partie du Groupe 1 avec ', s, ' de salaire mensuel') AS resultat;
	ELSEIF s >= 2000 AND s <= 3000 THEN
		SELECT CONCAT(pren, '  fait partie du Groupe 2 avec ', s, ' de salaire mensuel') AS resultat;
	ELSEIF s < 2000 AND s > 0 THEN
		SELECT CONCAT(pren, '  fait partie du Groupe 3 avec ', s, ' de salaire mensuel') AS resultat;
	ELSE
		SELECT CONCAT('employe inconnu', ' - ', s) AS resultat;
	END IF;
END //

CALL groupe_employes('amandine')//
CALL groupe_employes('laura')//
CALL groupe_employes('benoit')//
CALL groupe_employes('bonjour')//
---------------------------------------------- FIN PROCEDURE STOCKEE ----------------------------------------------