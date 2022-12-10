-- *****************************
-- Les vues
-- *****************************
-- Les vues ou encore appelées tables virtuelles, sont des objets de la BDD, constitués d'un nom et d'une requête de sélection. Une fois qu'une vue est définie, on peut l'utiliser comme n'importe quelle table, table qui serait constituée des données sélectionnées par la requête qui définit la vue.

USE entreprise;

-- Créer une vue :
CREATE VIEW vue_femme AS SELECT * FROM employes WHERE sexe = 'f'; -- crée une vue remplie par les données du SELECT précisé.

-- La vue est visible parmi les tables :
SHOW TABLES;

-- On peut effectuer une requête sur la vue :
SELECT prenom FROM vue_homme;  -- on peut effectuer toutes les opérations habituelles sur cette vue, y compris des INSERT, UPDATE ou DELETE.

-- S'il y a un changement dans la table d'origine, la vue est corrigée automatiquement, car elle enregistre la requête SELECT qui pointe vers la table d'origine. Idem, s'il y a un changement dans la vue, il s'impacte dans la table d'origine. 

-- Supprimer une vue :
DROP VIEW vue_homme; -- ne supprime pas les données dans la table d'origine


-- ************************************
-- Les tables temporaires
-- ************************************
-- Une table temporaire se construit à partir d'une requête et ré-enregistre les données existantes dans une autre table à instant T (duplication des données).

-- Créer une table temporaire :
CREATE TEMPORARY TABLE temp SELECT * FROM employes WHERE sexe = 'f'; -- crée une table temporaire appelée "temp" avec les données du SELECT. Cette table s'efface quand on quitte la session MySQL, et elle n'est pas visible dans la liste des tables avec SHOW TABLES.


-- Utiliser la talbe temporaire :
SELECT prenom FROM temp;  -- affiche les prénoms (féminins) de la table temp

-- Contrairement aux vues, s'il y a un changement dans la table d'origine, la table temporaire n'est pas impactée car elle en est une photographie à un instant T.





