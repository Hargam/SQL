-- *******************************
-- création de la BDD
-- *******************************

CREATE DATABASE bibliotheque;
SHOW DATABASES;  -- pour vérifier
USE bibliotheque; -- pour se connecter

-- on copie/colle dans la console le contenu du fichier source bibliotheque_sources.sql

SHOW TABLES;  -- pour vérifier la présence des tables


-- ****************
-- Exercices
-- ****************

-- 1. Quel est l'id_abonne de Laura ?
SELECT id_abonne FROM abonne WHERE prenom = 'Laura';

-- 2. L'abonné d'id_abonne 2 est venu emprunté un livre à quelles dates (date_sortie) ?
SELECT date_sortie FROM emprunt WHERE id_abonne = 2;

-- 3. Combien d'emprunts ont été effectués en tout ?
SELECT COUNT(id_emprunt) FROM emprunt;

-- 4. Combien de livres sont sortis le 2011-12-19 ?
SELECT COUNT(id_emprunt) FROM emprunt WHERE date_sortie = '2011-12-19';

-- 5. Une Vie est de quel auteur ?
SELECT auteur FROM livre WHERE titre = 'Une Vie';

-- 6. De combien de livres d'Alexandre Dumas dispose-t-on ?
SELECT COUNT(id_livre) FROM livre WHERE auteur = 'Alexandre Dumas';

-- 7. Quel id_livre est le plus emprunté ?
SELECT id_livre, COUNT(id_emprunt) AS nombre FROM emprunt GROUP BY id_livre ORDER BY nombre DESC LIMIT 0,1;


-- ****************************
-- Requêtes imbriquées
-- ****************************
-- Une requête imbriquée permet de réaliser une requête sur plusieurs tables quand on sélectionne des champs qui proviennent de la même table dans le SELECT. Afin de réaliser une requête imbriquée, il faut obligatoirement un champ COMMUN entre chaque table (par le jeu des clés primaires / clés étrangères).

-- Un champ NULL se teste avec IS NULL :
SELECT id_livre FROM emprunt WHERE date_rendu IS NULL;  -- affiche les livres non rendus (ceux pour lesquels le champ date_rendu a une valeur NULL)

-- Titre des livres non rendus (soit avec une date_sortie à NULL) :
SELECT titre FROM livre WHERE id_livre IN (SELECT id_livre FROM emprunt WHERE date_rendu IS NULL); -- on affiche le titre des livres pour lesquels l'id_livre est dans la liste (IN) des id_livre dont la date de rendu est NULL.

-- IN est utilisé dans le cas où il y a plusieurs résultats. On utilise = quand on est certain de n'avoir qu'un seul résultat. Exemple : on souhaite afficher le n° des livres que Chloé a emprunté.
SELECT id_livre FROM emprunt WHERE id_abonne = (SELECT id_abonne FROM abonne WHERE id_abonne = 3);
SELECT id_livre FROM emprunt WHERE id_abonne = (SELECT id_abonne FROM abonne WHERE prenom = 'Chloe'); -- on affiche l'id_livre pour lequel l'id_abonne est égal à l'id_abonne de la table abonne pour lequel le prénom est Chloé.

-- Notez que l'on peut faire plusieurs requêtes imbriquées successives quand il y a plus de 2 tables.


-- ******************
-- Exercices
-- ******************
-- 1. Afficher le prénom des abonnés ayant emprunté un livre le 2011-12-19
SELECT prenom FROM abonne WHERE id_abonne IN (SELECT id_abonne FROM emprunt WHERE date_sortie = '2011-12-19'); 

-- 2. Afficher le prénom des abonnés ayant emprunté un livre d'Alphonse Daudet
SELECT prenom FROM abonne WHERE id_abonne IN (SELECT id_abonne FROM emprunt WHERE id_livre IN (SELECT id_livre FROM livre WHERE auteur = 'Alphonse Daudet'));

-- 3. Afficher le titre des livres que Chloé a empruntés
SELECT titre FROM livre WHERE id_livre IN (SELECT id_livre FROM emprunt WHERE id_abonne IN (SELECT id_abonne FROM abonne WHERE prenom = 'Chloe'));

-- 4. Afficher le titre des livres que Chloé n'a pas encore empruntés
SELECT titre FROM livre WHERE id_livre NOT IN (SELECT id_livre FROM emprunt WHERE id_abonne IN (SELECT id_abonne FROM abonne WHERE prenom = 'Chloe')); -- le NOT se situe sur le premier IN pour exclure les livres non encore empruntés. Si on le met sur le second IN, on exclut l'abonné Chloé (autrement dit on prendrait les autres abonnés).

-- 5. Afficher le titre des livres que Chloé n'a pas encore rendus
SELECT titre FROM livre WHERE id_livre IN 
(SELECT id_livre FROM emprunt WHERE date_rendu IS NULL AND id_abonne IN
(SELECT id_abonne FROM abonne WHERE prenom = 'Chloe'));


-- 6. Combien de livres Benoît a empruntés ?
SELECT COUNT(id_livre) AS nombre FROM emprunt WHERE id_abonne IN (SELECT id_abonne FROM abonne WHERE prenom = 'Benoit');



-- ****************************
-- Jointure interne
-- ****************************
-- Une jointure est une requête permettant de faire des relations entre différentes tables grâce aux champs en commun. De plus elle permet de sélectionner des champs qui proviennent de tables différentes dans le SELECT.

-- Différences entre jointure et requête imbriquée :
-- Une jointure est possible dans tous les cas.
-- Alors qu'une requête imbriquée n'est possible seulement si les champs affichés (ceux du SELECT) sont issus de la même table. 
-- Dans ce cas, bien qu'une jointure soit possible, la requête imbriquée s'exécute plus rapidement (non mesurable dans la console).

-- Afficher les dates de sortie, de rendu et le prénom pour l'abonné Guillaume:
SELECT a.prenom, e.date_sortie, e.date_rendu
FROM abonne a
INNER JOIN emprunt e
ON a.id_abonne = e.id_abonne
WHERE a.prenom = 'Guillaume';
-- 1e ligne : ce que je souhaite afficher
-- 2e ligne : la 1ère table d'où proviennent les informations
-- 3e ligne : la seconde table d'où proviennent les informations
-- 4e ligne : la jointure qui lie les deux champs en commun dans les 2 tables
-- 5e ligne : la condition complémentaire éventuelle ici sur le prénom

-- "a" et "e" s'appellent des alias de tables. Ils sont définis dans FROM et INNER JOIN après le nom de la table à laquelle ils appartiennent. 
-- La syntaxe a.prenom correspond à table.champ


-- *********************
-- Exercices
-- *********************
-- 1. Afficher le titre, date de sortie et date de rendu des livres écrits par Alphonse Daudet.
SELECT l.titre, e.date_sortie, e.date_rendu
FROM livre l
INNER JOIN emprunt e
ON l.id_livre = e.id_livre
WHERE l.auteur = 'Alphonse Daudet';

-- 2. Afficher qui (prénom) a emprunté "Une vie" sur 2011.
SELECT ab.prenom, em.date_sortie, li.titre
FROM abonne ab
INNER JOIN emprunt em
ON ab.id_abonne = em.id_abonne
INNER JOIN livre li
ON em.id_livre = li.id_livre
WHERE li.titre = 'Une vie' AND em.date_sortie LIKE '2011%';

SELECT ab.prenom, em.date_sortie, li.titre
FROM livre li
INNER JOIN emprunt em
ON li.id_livre = em.id_livre
INNER JOIN abonne ab
ON ab.id_abonne = em.id_abonne
WHERE li.titre = 'Une vie' AND em.date_sortie LIKE '2011%';

-- 3. Afficher le nombre de livres empruntés par chaque abonné (prénom).
SELECT COUNT(e.id_livre), a.prenom
FROM abonne a
INNER JOIN emprunt e
ON a.id_abonne = e.id_abonne
GROUP BY a.prenom; 

-- 4. Afficher qui (prénom) a emprunté quels livres (titre) et à quelles dates (date de sortie).
SELECT a.prenom, l.titre, e.date_sortie
FROM abonne a
INNER JOIN emprunt e
ON a.id_abonne = e.id_abonne
INNER JOIN livre l
ON e.id_livre = l.id_livre;



-- ****************************
-- Jointure externe
-- ****************************

-- Une jointure externe est une requête sans correspondance exigée entre les valeurs requêtées dans les différentes tables. Par exemple, si vous vous insérez dans la table "abonne" et que vous n'avez rien emprunté, avec une jointure INTERNE vous n'apparaissez pas. En revanche, avec une jointure externe, vous apparaîtrez avec la mention NULL pour les emprunts que vous n'avez pas encore effectués.

-- On s'ajoute dans la table abonné :
INSERT INTO abonne (prenom) VALUES ('moi');

-- Nous faisons une jointure INTERNE entre les tables "abonne" et "emprunt" :
SELECT a.prenom, e.id_livre
FROM abonne a
INNER JOIN emprunt e
ON a.id_abonne = e.id_abonne;

+-----------+----------+
| prenom    | id_livre |
+-----------+----------+
| Guillaume |      100 |
| Benoit    |      101 |
| Chloe     |      100 |
| Laura     |      103 |
| Guillaume |      104 |
| Benoit    |      105 |
| Chloe     |      105 |
| Benoit    |      100 |
+-----------+----------+
-- Dans la requête de jointure INTERNE, l'abonné "moi" n'apparaît pas car il n'a rien emprunté.

-- Pour y remédier, et afficher les abonnés qui n'ont rien emprunté, on utilise une jointure EXTERNE :
SELECT a.prenom, e.id_livre
FROM abonne a 
LEFT JOIN emprunt e
ON a.id_abonne = e.id_abonne;
-- La clause LEFT JOIN permet de récupérer toutes les données dans la table considérée à GAUCHE de JOIN dans la requête (donc la table "abonne" ici), même s'il n'y a pas de correspondance dans l'autre table (autrement dit pas d'emprunt).

SELECT a.prenom, e.id_livre
FROM emprunt e 
RIGHT JOIN abonne a 
ON a.id_abonne = e.id_abonne;

-- *******
-- Voici un exemple avec un livre supprimé de la bibliothèque (Une vie) :
DELETE FROM livre WHERE id_livre = 100;

-- Exercice :
-- 1° Afficher la liste des emprunts (id_emprunt) avec le titre des livres qui existent encore.
SELECT e.id_emprunt, l.titre
FROM emprunt e
INNER JOIN livre l
ON e.id_livre = l.id_livre;


-- 2° Afficher la liste de TOUS les emprunts avec le titre des livres, y compris les emprunts pour lesquels il n'y a plus de livre en bibliothèque.
SELECT l.titre, e.id_emprunt
FROM emprunt e
LEFT JOIN livre l -- LEFT JOIN car la table que l'on veut complète se situe à GAUCHE de JOIN
ON l.id_livre = e.id_livre;

SELECT l.titre, e.id_emprunt
FROM livre l
RIGHT JOIN emprunt e -- RIGHT JOIN car la table que l'on veut complète se situe à DROITE de JOIN
ON l.id_livre = e.id_livre;


-- ************************
-- UNION
-- ************************
-- UNION permet de fusionner 2 requêtes dans un même résultat. Pour cela, il est nécessaire que les 2 requêtes aient les mêmes champs dans le SELECT et dans le même ordre.

-- Exemple : si on désinscrit Guillaume, on peut afficher à la fois TOUS les livres empruntés, y compris par des lecteurs désinscrits (Guillaume), et TOUS les abonnés, y compris ceux qui n'ont rien emprunté (moi).

-- On supprime le profil de Guillaume :
DELETE FROM abonne WHERE prenom = 'Guillaume';

-- Requête sur les livres empruntés :
(
 SELECT a.prenom, e.id_livre
 FROM abonne a
 LEFT JOIN emprunt e
 ON a.id_abonne = e.id_abonne
)
UNION 
(
 SELECT a.prenom, e.id_livre
 FROM abonne a
 RIGHT JOIN emprunt e
 ON a.id_abonne = e.id_abonne
);


-- *************************************************
