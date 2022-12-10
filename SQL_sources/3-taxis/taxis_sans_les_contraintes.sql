CREATE TABLE association_vehicule_conducteur (
  id_association int(3) NOT NULL auto_increment,
  id_vehicule int(3) default NULL,
  id_conducteur int(3) default NULL,
  PRIMARY KEY  (id_association)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ;

INSERT INTO association_vehicule_conducteur (id_association, id_vehicule, id_conducteur) VALUES
(1, 501, 1),
(2, 502, 2),
(3, 503, 3),
(4, 504, 4),
(5, 501, 3);


CREATE TABLE conducteur (
  id_conducteur int(3) NOT NULL auto_increment,
  prenom varchar(30) NOT NULL,
  nom varchar(30) NOT NULL,
  PRIMARY KEY  (id_conducteur)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ;

INSERT INTO conducteur (id_conducteur, prenom, nom) VALUES
(1, 'Julien', 'Avigny'),
(2, 'Morgane', 'Alamia'),
(3, 'Philippe', 'Pandre'),
(4, 'Amelie', 'Blondelle'),
(5, 'Alex', 'Richy');


CREATE TABLE vehicule (
  id_vehicule int(3) NOT NULL auto_increment,
  marque varchar(30) NOT NULL,
  modele varchar(30) NOT NULL,
  couleur varchar(30) NOT NULL,
  immatriculation varchar(9) NOT NULL,
  PRIMARY KEY  (id_vehicule)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ;

INSERT INTO vehicule (id_vehicule, marque, modele, couleur, immatriculation) VALUES
(501, 'Peugeot', '807', 'noir', 'AB-355-CA'),
(502, 'Citroen', 'C8', 'bleu', 'CE-122-AE'),
(503, 'Mercedes', 'Cls', 'vert', 'FG-953-HI'),
(504, 'Volkswagen', 'Touran', 'noir', 'SO-322-NV'),
(505, 'Skoda', 'Octavia', 'gris', 'PB-631-TK'),
(506, 'Volkswagen', 'Passat', 'gris', 'XN-973-MM');

