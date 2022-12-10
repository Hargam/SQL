-- **************************
-- Exercices
-- **************************
ALTER TABLE article
    ->     ADD CONSTRAINT article_idfk_1 FOREIGN KEY (id_fourn) REFERENCES fournisseur (id_fournisseur)
    ->     ON UPDATE CASCADE ON DELETE SET NULL ;




CREATE DATABASE taxis;

USE taxis;

-- On importe le fichier contenant les tables (sources).

-- ******

-- 1. Qui (prenom) conduit la voiture d'id 503 en requête de jointure ?
SELECT c.prenom
FROM conducteur c
INNER JOIN association_vehicule_conducteur a
ON c.id_conducteur = a.id_conducteur
WHERE a.id_vehicule = 503;

-- 2. Qui conduit quel modèle (prenom, modele) ?
SELECT c.prenom, v.modele
FROM conducteur c
INNER JOIN association_vehicule_conducteur a
ON c.id_conducteur = a.id_conducteur
INNER JOIN vehicule v
ON a.id_vehicule = v.id_vehicule; 


-- 3. Ajoutez vous dans la table conducteur.
INSERT INTO conducteur (prenom, nom) VALUES ('John', 'Wayne');
--    Afficher TOUS les conducteurs (prenom) ainsi que les modèles de véhicules.
SELECT c.prenom, v.modele
FROM conducteur c
LEFT JOIN association_vehicule_conducteur a
ON c.id_conducteur = a.id_conducteur
LEFT JOIN vehicule v
ON v.id_vehicule = a.id_vehicule;

-- 4. Ajoutez un véhicule dans la table correspondante.
INSERT INTO vehicule (modele, marque, couleur, immatriculation) VALUES('Mustang', 'Ford', 'Black', 'AZ-123-ER');
--    Afficher TOUS les modèles de véhicules, y compris ceux qui n'ont pas de chauffeur, et le prénom des conducteurs.
SELECT v.modele, c.prenom
FROM vehicule v
LEFT JOIN association_vehicule_conducteur a
ON v.id_vehicule = a.id_vehicule
LEFT JOIN conducteur c
ON a.id_conducteur = c.id_conducteur;


-- 5. Afficher TOUS les conducteurs (prenom) et TOUS les modèles de véhicules.
(
SELECT c.prenom, v.modele
FROM conducteur c
LEFT JOIN association_vehicule_conducteur a
ON c.id_conducteur = a.id_conducteur
LEFT JOIN vehicule v
ON v.id_vehicule = a.id_vehicule
)
UNION
(
SELECT c.prenom, v.modele
FROM vehicule v
LEFT JOIN association_vehicule_conducteur a
ON v.id_vehicule = a.id_vehicule
LEFT JOIN conducteur c
ON a.id_conducteur = c.id_conducteur
);



