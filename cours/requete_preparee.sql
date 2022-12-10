---------------------------------------------- REQUETE PREPAREE -----------------------------------------------------------------
--# Ce passage est à inscrire au tableau :
	--# Cycle: Analyse / Interpretation / Exécution (avec les requetes préparée on les analyse, interpréte, ensuite on effectue que la dernière étape sur les 3).
	
PREPARE req FROM 'SELECT * FROM employes WHERE service = "commercial"';

EXECUTE req;
	
PREPARE req2 FROM 'SELECT * FROM abonne WHERE prenom=?'; --#  Déclaré une req préparée (DANS LA SESSION EN COURS)

SET @prenom='laura'; --#  affecte une variable

EXECUTE req2 USING @prenom ; --#  utilise la req préparée

DROP PREPARE req2; --#  supprime req préparée


--# Durée de vie très courte, elles sont supprimées dès que l'on ferme la console !

--# MySQL dispose de 3 types de variables :
--#     locale (à l'intérieur d'une procédure, créée et typée avec DECLARE, sans @) ;
--#     utilisateur (valable pour la session, non déclarée, non typée, préfixée par @) ;
--#     système (portée globale ou session, pré-définie, préfixée par @@).
--# source: http://mysql.developpez.com/faq/?page=VARIABLES
---------------------------------------------- FIN REQUETE PREPAREE -----------------------------------------------------------------