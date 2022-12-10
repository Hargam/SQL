-- ************************************
-- Les transactions
-- ************************************
-- Une transaction permet de lancer des requêtes, telles que des modifications,et de les annuler si besoin, grâce au moteur de stockage InnoDB qui propose une option d'annulation / confirmation des requêtes.

START TRANSACTION;  -- démarre une zone de transaction

SELECT * FROM employes;

SELECT * FROM employes;
UPDATE employes SET service = 'juridique' WHERE id_employes = 739;

SELECT * FROM employes;

ROLLBACK; -- donne l'ordre de tout annuler depuis le START TRANSACTION (l'employé retrouve son service)

COMMIT;   -- au contraire COMMIT valide l'ensemble des opérations 

-- Que l'on choisisse ROLLBACK ou COMMIT, cela termine la TRANSACTION. Ca veut dire que les prochaines requêtes ne pourront pas être annulées à moins que de remettre un START TRANSACTION.

-- Si ni ROLLBACK, ni COMMIT ne sont effectués et que l'on ferme la session, MySQL annulera les opérations et effectuera un ROLLBACK.
