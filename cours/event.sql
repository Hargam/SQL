---------------------------------------------- EVENEMENTS -----------------------------------------------------------------
--# Les évenements permettent de :
--# 	- Programmer des requêtes de suppression pour délester de vieilles discussions pour votre forum.
--# 	- Calcul annuel dintérêt.
--# 	- Programmer des requêtes de sauvegarde automatiques chaque nuit.
--# 	- Différer lexécution dun traitement gourmand en ressources aux heures creuses de la prochaine nuit.
--# 	- Analyser et optimiser lensemble des tables mises à jour dans la journée
	
	
	SHOW GLOBAL VARIABLES LIKE 'event_scheduler'; --#  permet de voir si les événements sont activés ou désactivés.
	SET GLOBAL event_scheduler = 1 ; --#  on affecte 1 dans une variable et cela permet d'activer les événements sous Mysql.
	SHOW GLOBAL VARIABLES LIKE 'event_scheduler';
--# 	Attention, lorsque lon ferme la console et quon la rouvre, les événements sont toujours désactivés /!\
--# 	Pour les activers de manière permanente il faut se rendre à lendroit suivant : 
--# 	wamp > mysql > services > my.ini : dans la section [mysqld]	il faut ajouter la ligne: event_scheduler=1.
--# 	Si on ferme la console, les événéments continue de faire leur travail. Si on ferme le serveur WAMP les événéments ne continue pas de faire leur travail (cela dis, les serveurs sont fais pour rester allumés).
	---------------------------------------
		SHOW EVENTS \G $
--# 	Cet événement permet dinséré une ligne toute les minutes dans la table.
		DROP EVENT IF EXISTS enregistrement_employes $
		CREATE EVENT e_enregistrement_employes
		ON SCHEDULE  EVERY 1 MINUTE
		DO INSERT INTO employes (prenom) VALUES ('Ifocop');
--# 	Le mot clef EVERY indique que lévènement est récurrent. Il est suivi par lintervalle entre chaque répétition.
	---------------------------------------
--# 	Cet événement insérera 1 enregistrement (unique) dans 2 minute
		CREATE EVENT EXEMPLE_1_2
		ON SCHEDULE AT CURRENT_TIMESTAMP + INTERVAL 2 MINUTE
		DO INSERT INTO ARTICLE.DECLENCHEUR (INFORMATION_DECLENCHEUR) VALUES ('Exemple 1.2');
--# 	Le mot clef AT signifie que lévènement est à exécution unique. Il est suivi par la date et lheure de déclenchement. Après la date de déclenchement, lévènement est automatiquement supprimé. 
	---------------------------------------
--# 	Lancer (une seule fois) une PROCÉDURE STOCKÉE à 03h50 du 1er janvier 2010
		CREATE EVENT EXEMPLE_1_3
		ON SCHEDULE AT '2010-01-01 03:50:00'
		DO CALL INSERTION('Exemple 1.3');
		SHOW EVENTS WHERE NAME='EXEMPLE_1_3'\G
--# 	Cet exemple na pas pris en compte le décalage horaire avec GMT ! 
	---------------------------------------
--# 	Insérer une ligne dans la table DECLENCHEUR chaque jour à 04h00 du matin.
		CREATE EVENT EXEMPLE_1_4_a
		ON SCHEDULE EVERY 1 DAY STARTS '2016-06-12 04:00:00'
		DO INSERT INTO ARTICLE.DECLENCHEUR (INFORMATION_DECLENCHEUR) VALUES ('Exemple 1.4.a');
--# 	Le mot clef STARTS permet dindiquer quand lévènement est déclenché pour la première fois. Il est donc suivi par la date de la première exécution. 
	---------------------------------------
--# 	Pendant une minute, insérer une ligne dans la table DECLENCHEUR toutes les 8 secondes.
		CREATE EVENT EXEMPLE_1_5
		ON SCHEDULE  EVERY 8 SECOND
		ENDS CURRENT_TIMESTAMP + INTERVAL 1 MINUTE
		DO INSERT INTO ARTICLE.DECLENCHEUR (INFORMATION_DECLENCHEUR)
		VALUES ('Exemple 1.5');
--# 	Le mot clef ENDS permet dindiquer quand lévènement est déclenché pour la dernière fois. Il est donc suivi par la date de dernière exécution. Il pourra être automatiquement supprimé après la dernière exécution. 
	---------------------------------------
--# 	Permet de renommer un évent :
		ALTER EVENT EXEMPLE_1_5 RENAME TO NOUVEAU_EXEMPLE_1_5;
--# 	Modifiez la fréquence dun évent existant :
		ALTER EVENT EXEMPLE_1_1 ON SCHEDULE EVERY 10 MINUTE;
--# 	Suppression dun évent : 
		DROP EVENT IF EXISTS EXEMPLE_1_1;
--# 	Desactiver un évent :
		ALTER EVENT nom_evenement DISABLE;
--# 	Activer un évent (sous reserve que le gestionaire dévenement soit activé) :
		ALTER EVENT nom_evenement ENABLE;
--# 	Controler létat dun évent :
		SELECT EVENT_NAME, STATUS FROM INFORMATION_SCHEMA.EVENTS; ou SHOW events;
		SELECT EVENT_NAME, STATUS FROM INFORMATION_SCHEMA.EVENTS WHERE EVENT_NAME = 'EXEMPLE_1_2' AND EVENT_SCHEMA = 'article'; --#  nous navons pas mis de USE car on a préciser le nom de la BDD avant le nom de la table.
	 
	 
--# 	 Création dune BDD (tic_evenements) et dune table journal avec les champs suivants : id_journal, titre, texte.
--# 	 Insertion denregistrement.
	 
--# 	 Permet deffectuer une copie dans la table de sauvegarde.
		delimiter -
		CREATE EVENT journal_sauvegarde
			ON SCHEDULE EVERY 1 MINUTE
			DO INSERT INTO journal_copie SELECT * FROM journal; -
		--------------------------------------- 
--# 		Exemple à présenter:
--# 		>>> Exemple permettant de faire une sauvegarde de la table à chaque minute en créant une table de copie à partir dune autre (chaque jour à partir dune date de départ donnée) :
		DELIMITER $$
		DROP procedure IF EXISTS p_sauvegarde_employes $$
		CREATE procedure p_sauvegarde_employes()
		BEGIN
			SET @sql=concat('CREATE table copie_employes_' ,curdate()+0, '    SELECT * FROM employes'); --#  Attention lespace avant le S de SELECT est capital. # curdate()+0 ou round(now()+0).
			PREPARE req FROM @sql ;
			EXECUTE req ;
			-- DEALLOCATE PREPARE req ; --# cette ligne n'est pas obligatoire.
		END $$
		DELIMITER ;
		
		DELIMITER $$
		DROP procedure IF EXISTS p_sauvegarde_employes $$
		CREATE procedure p_sauvegarde_employes()
		BEGIN
			CREATE table copie_employes(SELECT * FROM employes);
		END $$
--# 		### Tenter dexécuter la procédure stockée avant de créer levent. Si la table copie est crée, cela fonctionne, mais il faut maintenant la supprimer afin de laisser levent travailler. Possibilité de mettre ROUND(now()+0) dans la procedure avec un every 1 minute dans levent pour tester cela plusieurs fois.
		
		DROP event IF EXISTS e_sauvegarde_employes;		
		CREATE EVENT e_sauvegarde_employes
			ON SCHEDULE EVERY 1 DAY STARTS '2012-11-01 15:10:00' --#  il faut adapter la date et lheure afin davoir le résultat en salle de cours dans linstant.
			DO CALL p_sauvegarde_employes();	
			
			SHOW TABLES $
			SELECT NOW() $
---------------------------------------------- FIN EVENEMENTS -----------------------------------------------------------------