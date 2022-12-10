CREATE TABLE article (
  id_article int(3) NOT NULL auto_increment,
  titre varchar(10) NOT NULL,
  couleur varchar(10) NOT NULL,
  prix int(3) NOT NULL,
  stock int(3) NOT NULL,
  id_fourn int(3) default NULL,
  PRIMARY KEY  (id_article)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ;

INSERT INTO article (id_article, titre, couleur, prix, stock, id_fourn) VALUES
(1, 'tshirt', 'bleu', 10, 20, 1),
(2, 'chemise', 'noir', 50, 600, 1),
(3, 'chaussette', 'blanc', 30, 300, 1),
(6, 'chaussure', 'noir', 35, 250, 2),
(7, 'parapluie', 'orange', 35, 120, 3);


CREATE TABLE fournisseur (
  id_fournisseur int(3) NOT NULL auto_increment,
  nom varchar(10) NOT NULL,
  ville varchar(10) NOT NULL,
  PRIMARY KEY  (id_fournisseur)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


INSERT INTO fournisseur (id_fournisseur, nom, ville) VALUES
(1, 'nom1', 'paris'),
(2, 'nom2', 'marseille'),
(3, 'nom3', 'lille');

