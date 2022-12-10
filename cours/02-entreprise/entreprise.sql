DES
-- pour faire un commentaire en SQL

-- ouvrir la console sous XAMPP : menu SHELL du panel de contrôle puis saisir :
--               cd c:\xampp\mysql\bin
--               mysql.exe -u root --password

-- ouvrir la console sous MAMP : Applications > Utilitaires > Terminal et saisir :
--        /Applications/MAMP/Library/bin/mysql -uroot -proot



-- ****************************
-- Requêtes générales
-- ****************************

-- Créer et utiliser une BDD :
CREATE DATABASE entreprise;
-- crée une BDD appelée "entreprise"
-- Les requêtes ne sont pas sensibles à la casse, mais on met les mots clés SQL en majuscules par convention.

SHOW DATABASES;
-- permet d'afficher les BDD disponibles

USE entreprise;
-- utiliser la BDD "entreprise"

-- on copie / colle le contenu de la BDD (sources)

-- Voir les tables :
SHOW TABLES; -- permet d'afficher les tables de la BDD

DESC employes;
-- pour observer la structure de la table "employes"

-- Supprimer des éléments :
DROP DATABASE nom_de_la_base;
-- pour supprimer une BDD

DROP TABLE nom_de_la_table;
-- pour supprimer une table

TRUNCATE nom_de_la_table;
-- pour vider une table sans la supprimer


-- ****************************
-- Requêtes de sélection
-- ****************************

-- SELECT
SELECT nom, prenom
FROM employes;
-- affiche le nom et le prénom des employés. SELECT sélectionne les champs indiqués, FROM de la table employes.

SELECT service
FROM employes;
-- affiche le service des employés

-- DISTINCT
SELECT DISTINCT service
FROM employes;
-- affiche les différents services dédoublonnés occupés par les employés

-- * pour ALL
SELECT *
FROM employes;
-- affiche TOUS les champs de la table

-- clause WHERE
SELECT nom, prenom
FROM employes
WHERE service = 'informatique';
-- affiche le nom et le prénom des employés pour lesquels e service est "informatique"

-- BETWEEN
SELECT nom, prenom, date_embauche
FROM employes
WHERE date_embauche BETWEEN '2006-01-01' AND '2010-12-31';
-- affiche le nom et le prénom des employés embauchés entre 2006 et 2010

-- LIKE
SELECT prenom
FROM employes
WHERE prenom LIKE 's%';
-- affiche le prénom des employés qui commence par "s". 

SELECT prenom
FROM employes
WHERE prenom LIKE '%-%';
-- affiche le prénom des employés qui contient un trait d'union. LIKE est utile dans les formulaires de recherche de produits par exemple.

-- Opérateurs de comparaison :
--          =
--          <
--          >
--          <=
--          >=
--          != ou <>  pour différent de
SELECT nom, prenom
FROM employes
WHERE service != 'informatique';
-- affiche le nom et le prénom des employés n'étant pas du service informatique
SELECT prenom, service, salaire
FROM employes
WHERE salaire > 3000;
-- affiche les employés ayant un salaire supérieur à 3000. On ne met pas de quote car il s'agit d'un chiffre (INT pour integer = entier).

-- ORDER BY
SELECT prenom, salaire
FROM employes
ORDER BY salaire;
-- affiche le prénom et le salaire des employés par ordre croissant de salaire : ASC par défaut pour l'ordre croissant, sinon DESC à préciser pour l'ordre décroissant.
SELECT prenom, salaire
FROM employes
ORDER BY salaire ASC, prenom DESC;
-- classe les prénoms par ordre de salaire croissant puis pour les salaires identiques par prénom décroissant.

-- LIMIT
SELECT nom, prenom, service, salaire
FROM employes
ORDER BY salaire DESC LIMIT 0,1;  -- affiche l'employé dont le salaire est le plus élevé : le premier chiffre = OFFSET, c'est-à-dire le point de départ (on compte à partir de 0). Le second chiffre = le nombre de lignes que l'on prend, ici 1 ligne. Notez que l'on peut écrire LIMIT 1 directement.

-- Attention à l'ordre : SELECT...FROM...ORDER BY...LIMIT...


-- l'alias avec AS (colonne nommée)
SELECT nom
, prenom, salaire * 12 AS salaire_annuel FROM employes;
-- l'alias permet de renommer la colonne "salaire * 12" en "salaire_annuel"

-- SUM
SELECT SUM(salaire * 12)
FROM employes;
-- affiche la SOMME des salaires annuels. Notez que les () sont collées au nom de la fonction.

-- MIN et MAX
SELECT MIN(salaire)
FROM employes;
-- affiche le salaire le plus bas
SELECT MAX(salaire)
FROM employes;
-- affiche le salaire le plus haut

SELECT prenom, MIN(salaire)
FROM employes;
-- cette requête sort une erreur car on ne peut pas croiser MIN ou MAX avec d'autres champs. Il faut faire la requête suivante :
SELECT prenom, salaire
FROM employes
ORDER BY salaire ASC LIMIT 0,1;

-- AVG (average = moyenne)
SELECT AVG
(salaire) FROM employes;
-- affiche la moyenne des salaires

-- ROUND
SELECT ROUND(AVG(salaire), 1)
FROM employes;
-- affiche la moyenne des salaires arrondie à 1 chiffre après la virgule

-- COUNT
SELECT COUNT(id_employes)
FROM employes
WHERE sexe = 'f';
-- on affiche le nombre d'employées de sexe féminin

-- IN
SELECT prenom, service
FROM employes
WHERE service IN ('comptabilite', 'informatique');
-- affiche le prénom et le service des employés travaillant dans le service comptabilité OU informatique

-- NOT IN
SELECT prenom, service
FROM employes
WHERE service NOT IN ('comptabilite', 'informatique');
-- affiche les employés qui à l'inverse ne sont pas des services comptabilité et informatique

-- AND et OR
SELECT prenom, salaire, service
FROM employes
WHERE service= 'commercial' AND salaire <= 2000;
-- affiche le prénom des employés du service commercial ET de salaire inférieur ou égal à 2000

SELECT prenom, salaire, service
FROM employes
WHERE service = 'production' AND salaire = 1900 OR salaire = 2300;
-- revient à écrire :
SELECT prenom, salaire, service
FROM employes
WHERE (service = 'production' AND salaire = 1900) OR salaire = 2300;
-- affiche les employés du service production ET gagnant 1900, ou alors dans tous les services gagnant 2300 

-- GROUP BY
SELECT service, COUNT(id_employes) AS nombre
FROM employes
GROUP BY service;
-- affiche le nombre d'employés PAR service. GROUP BY s'utilise obligatoirement avec les fonctions qui retournent un agrégat quand on les croise avec un autre champ : SUM, AVG, COUNT, MIN, MAX.

-- GROUP BY ... HAVING
SELECT service, COUNT(id_employes) AS nombre
FROM employes
GROUP BY service
HAVING nombre > 1;
-- affiche les services AYANT plus de 1 employé. HAVING remplace le WHERE à l'intérieur d'un GROUP BY.

-- Attention à l'ordre des mots clés :
-- SELECT...FROM...WHERE...GROUP BY...ORDER BY...LIMIT...


-- ************************************
-- Requêtes d'insertion
-- ************************************

-- INSERT INTO
INSERT INTO employes
  (prenom, nom, sexe, service, date_embauche, salaire)
VALUES
  ('alexis', 'richy', 'm', 'informatique', '2011-12-28', 1800);
-- Insertion d'un employé dans la table employes. L'ordre des champs et des valeurs entre les 2 paires de () doit être le même. L'id_employes n'étant pas précisé, il sera auto-incrémenté par la BDD.

-- Insertion sans préciser le nom des champs :
INSERT INTO employes
VALUES
  (NULL, 'John', 'Doe', 'm', 'communication', '2019-12-15', 2000);
-- on peut insérer un employé sans préciser la liste des champs SI les valeurs données respectent l'ordre des champs de la BDD, y compris l'id_employes pour lequel nous mettons la mention NULL afin qu'il soit auto-incrémenté par la BDD.


-- ************************************
-- Requêtes de modification
-- ************************************

-- UPDATE
UPDATE employes SET salaire = 1871 WHERE id_employes = 699;
-- on modifie le salaire de l'employé d'identifiant 699 pour ne pas modifier tous les employés qui porteraient le même nom.

-- A NE PAS FAIRE : un UPDATE sans clause WHERE quand on veut ne modifier qu'un seul enregistrement :
UPDATE employes SET salaire = 1871;
-- ici on modifierait TOUTE la table.

-- REPLACE
REPLACE INTO employes
(id_employes, prenom, nom, sexe, service, date_embauche, salaire) VALUES
(2000, 'test', 'test', 'm', 'marketing', '2010-07-05', 2600); -- se comporte comme un INSERT INTO car l'identifiant n'existe pas 

REPLACE INTO employes
(id_employes, prenom, nom, sexe, service, date_embauche, salaire) VALUES
(2000, 'test', 'test', 'm', 'marketing', '2010-07-05', 2601);
-- se comporte comme un UPDATE car l'identifiant existe en BDD (il a été inséré juste avant).


-- ***********************************
-- Requêtes de suppression
-- ***********************************

-- DELETE
DELETE FROM employes WHERE id_employes = 900;
-- suppression de l'employé d'id 900 (Lagarde)

DELETE FROM employes WHERE id_employes = 388 OR id_employes = 990;
-- ici il s'agit d'un OR car un même employé ne peut pas avoir deux identifiants différents en même temps

-- A NE PAS FAIRE : un DELETE sans clause WHERE
DELETE FROM employes;
-- revient à vider la table comme avec TRUNCATE



-- ***************************
-- Exercices
-- ***************************
-- 1. Afficher le service de l'employé 547
SELECT service
FROM employes
WHERE id_employes = 547;

-- 2. Afficher la date d'embauche d'Amandine
SELECT date_embauche
FROM employes
WHERE prenom = 'Amandine';

-- 3. Afficher le nombre de commerciaux
SELECT COUNT(id_employes)
FROM employes
WHERE service = 'commercial';

-- 4. Afficher le salaire des commerciaux sur 1 année
SELECT SUM(salaire * 12)
FROM employes
WHERE service= 'commercial';

-- 5. Afficher le salaire moyen par service
SELECT service, AVG(salaire) AS moyenne
FROM employes
GROUP BY service;


-- 6. Afficher le nombre de recrutement sur 2010
SELECT COUNT(id_employes)
FROM employes
WHERE date_embauche BETWEEN '2010-01-01' AND '2010-12-31';

SELECT COUNT(id_employes)
FROM employes
WHERE date_embauche >= '2010-01-01' AND date_embauche <= '2010-12-31';

SELECT COUNT(id_employes)
FROM employes
WHERE date_embauche LIKE '2010%';


-- 7. Augmenter le salaire de chaque employés de 100
UPDATE employes SET salaire = salaire + 100;

-- 8. Afficher le nombre de services DIFFERENTS
SELECT COUNT(DISTINCT service)
FROM employes;

-- 9. Afficher le nombre d'employés par service
SELECT service, COUNT(id_employes) AS nombre
FROM employes
GROUP BY service;

-- 10. Afficher les informations de l'employé du service commercial gagnant le salaire le plus élevé
SELECT prenom, nom, salaire, service
FROM employes
WHERE service = 'commercial'
ORDER BY salaire DESC LIMIT 0,1;

-- 11. Afficher l'employé ayant été embauché en dernier
SELECT prenom
, nom, date_embauche FROM employes ORDER BY date_embauche DESC LIMIT 1;  -- LIMIT 1 signifie LIMIT 0,1 (soit la première ligne)


                                                       
