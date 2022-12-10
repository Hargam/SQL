---------------------------------------------- TRIGGERS -----------------------------------------------------------------
-- Un TRIGGER permet de faire un traitement tout comme une procédure ou une fonction mais on ne peut pas l'exécuter. En revanche nous pouvons préciser l'action qui permettra de le déclencher.
--# Les TRIGGERS sont déclenchés afin d'automatiser certaines taches à la suite de certaines actions.
DELIMITER | --# Changement du DELIMITER pour éviter un conflit avec la console.
SHOW TRIGGERS \G| --# montre les TRIGGERS
DROP TRIGGER exemple1| --# supprime un TRIGGER
SHOW TRIGGERS LIKE 'emp%'\G | --# Permet de voir un TRIGGER en particulier.
--# Les TRIGGERS sont souvent utilisés pour : Créer des rapports d'audit sur l'utilisation de la BDD Palier aux manques de certains moteurs de stockage (Intégrité référentielle) Accroître la sécurité des données, etc.
----------------------------
--# Présentation/ Créer une table "employes_informations" : * Dessiner le [SCHEMA15_informations] *
--# fichier à partager : entreprise/employes_information.sql
--# METTRE UN ENREGISTREMENT DANS LA TABLE information avec le nombre d'employes actuel ainsi que la dernière date d'embauche du dernier employes. Nous allons effectuer un TRIGGER qui va avoir pour but de continuer à mettre à jour ces informations sans qu'on est à faire de requête supplémentaire.
DROP TRIGGER IF EXISTS t_miseajour_informations_employes |
CREATE TRIGGER t_miseajour_informations_employes AFTER INSERT ON employes	--# apres chaque insertion sur employes
FOR EACH ROW --#  FOR EACH ROW - pour chaque ligne (chaque enregistrement)
BEGIN
 UPDATE employes_informations SET nombre = nombre + 1, derniere_date_embauche = NEW.date_embauche;
END |
--#  champ = champ + 1 (on a le droit dacceder à la derniere valeur)
--# OLD. permet daccéder à la valeur actuelle (uniquement dans le cas d'un UPDATE ou d'un DELETE).
--# NEW. permet daccéder à la valeur futur (uniquement dans le cas d'un UPDATE ou d'un INSERT). 
----------------------------
--# Exercice 1/ création de la table de "employes_sauvegarde" : Exactement la même table que la table employes avec les mêmes champs mais vide !
--# ps: plusieurs moyens de la créer (console, pma, pma export/import, pma opération pour la copier/coller "structure seule")
--# fichier à partager : entreprise/employes_sauvegarde.sql
--# exercice : Faite en sorte dinscrire des données dans "employes_sauvegarde" pour toute nouvelle insertion dans la table employes (en plus de la maj sur la table employes_informations) : entreprise/employes_sauvegarde.sql
DROP TRIGGER IF EXISTS t_employes_sauvegarde |
CREATE TRIGGER t_employes_sauvegarde AFTER INSERT ON employes
FOR EACH ROW
BEGIN
INSERT INTO employes_sauvegarde (id_employes, prenom, nom, sexe, service, date_embauche, salaire, id_secteur) VALUES (NEW.id_employes, NEW.prenom, NEW.nom, NEW.sexe, NEW.service, NEW.date_embauche, NEW.salaire, NEW.id_secteur);
UPDATE employes_informations SET nombre = nombre + 1, derniere_date_embauche = NEW.date_embauche;
END |
--# Attention la version de MYSQL ne supporte pas plusieurs TRIGGERS pour la même action et sur une même table, Il faut donc supprimer le TRIGGER précédent et regrouper le code précédent au sein du nouveau TRIGGER.
--# Il est également possible de faire (pas prudent): insert into employes_sauvegarde SELECT * FROM employes WHERE id_employes=NEW.id_employes;
----------------------------
--# Exercice 2/ Création d'une table "employes_supprime" : Exactement la même table que la table employes avec les mêmes champs mais vide !
--# fichier à partager : entreprise/employes_supprime.sql
--# exercice : Faite en sorte d'enregistrer tous les employes supprimés (qui ne sont pas des commerciaux). Cela nous servira de corbeille (comme dans windows) : entreprise/employes_supprime.sql
DROP TRIGGER IF EXISTS t_employes_corbeille |
CREATE TRIGGER t_employes_corbeille AFTER DELETE ON employes
FOR EACH ROW
BEGIN
 IF OLD.service != 'commercial' then
	INSERT INTO employes_supprime(id_employes, prenom, nom, sexe, service, date_embauche, salaire, id_secteur) VALUES (OLD.id_employes, OLD.prenom, OLD.nom, OLD.sexe, OLD.service, OLD.date_embauche, OLD.salaire, OLD.id_secteur);
 END IF;
END |
--# Tenter d'abord d'enregistrer tout les employés supprimé dans la table des employés_supprimé, puis, ensuite, dans un second temps de limiter ce traitement seulement aux employés qui ne sont pas des commerciaux.
----------------------------
--# Exemple 3/ Créer un TRIGGER qui met à jour la variable @somme avec le salaire total des employes sur une année.
--# Exemple fonctionnant dans la console car la variable est valable pour la session en cours (et dans l'onglet SQL de PMA il y a du rechargement de page).
--# Faire cet exemple avec les étudiants, ne pas le donner en exercice.
CREATE TRIGGER t_total_salaire_employes AFTER INSERT ON employes
FOR EACH ROW
BEGIN
	 SELECT sum(salaire) FROM employes INTO @somme;
END |
SELECT @somme;
INSERT INTO employes (prenom, salaire) VALUES ('test',1000);
SELECT @somme;
INSERT INTO employes (prenom, salaire) VALUES ('test',1000);
SELECT @somme;
----------------------------
--# Exercice 4/ Création de la table "employes_salaire" : * Dessiner le [SCHEMA16_salaire] *
--# fichier à partager : entreprise/employes_salaire.sql
--# exercice : Dès que le salaire d'un employes est CHANGÉ (et uniquement dans ce cas), nous voulons conserver l'historique des changement de salaire dans une table "employes_salaire" : entreprise/employes_salaire.sql
--# Imaginez que le comptable vous dise (en partant le vendredi soir), je sais que vous allez travailler tout le week-end sur la BDD et que vous allez changer des données, j'aimerais être au courant de tout les salaires qui ont changé lundi quand j'arriverais au bureau.
--# Dans ce cas là, par exemple, un TRIGGER est plus qu'interessant car il va travailler pour vous, ainsi vous n'aurez pas à prendre des notes et lancer des requêtes INSERT dès que vous effecturez un changement car le TRIGGER aura ce rôle.
DROP TRIGGER IF EXISTS t_employes_historique_salaire |
CREATE TRIGGER t_employes_historique_salaire AFTER UPDATE ON employes
FOR EACH ROW
BEGIN
    IF (NEW.salaire != OLD.salaire) THEN
        INSERT INTO employes_salaire
                (id_employes , ancien , nouveau , difference, date_modification ) 
        VALUES 
                (NEW.id_employes, OLD.salaire, NEW.salaire, (NEW.salaire-OLD.salaire),  NOW());
    END IF;
END |
----------------------------
--# Exercice 5/ Création dune table "employes_action" : * Dessiner le [SCHEMA17_action] *
--# fichier à partager : entreprise/employes_action.sql
--# Facultatif, A faire selon l'avancé du cours.
--# Le but de l'exercice est de repertorier les actions passés sur la table employes (INSERT, UPDATE, DELETE) : entreprise/employes_action.sql
delimiter /
DROP TRIGGER IF EXISTS t_modification_employes /
CREATE TRIGGER t_modification_employes
BEFORE UPDATE ON employes FOR EACH ROW
  BEGIN
    INSERT INTO employes_action
      (id_employes, requete, date_action)
    VALUES
      (NEW.id_employes, 'UPDATE', NOW());
  END;
/

DROP TRIGGER IF EXISTS t_suppression_employes /
CREATE TRIGGER t_suppression_employes
AFTER DELETE ON employes FOR EACH ROW
  BEGIN
    INSERT INTO employes_action
      (id_employes, requete, date_action)
    VALUES
      (OLD.id_employes, 'delete', NOW());
  END;
/

DROP TRIGGER IF EXISTS t_ajout_employes /
CREATE TRIGGER t_ajout_employes
AFTER INSERT ON employes FOR EACH ROW
  BEGIN
    INSERT INTO employes_action
      (id_employes, requete, date_action)
    VALUES
      (NEW.id_employes, 'insert', NOW());
  END;
/
---------------------------------------------- FIN TRIGGERS -----------------------------------------------------------------