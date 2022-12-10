CREATE TABLE localite (
  id_localite int(5) NOT NULL auto_increment,
  id_secteur tinyint(3) unsigned NOT NULL,
  ville varchar(255) NOT NULL,
  chiffre_affaires int(10) NOT NULL,
  PRIMARY KEY  (id_localite)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;



INSERT INTO localite (id_localite, id_secteur, ville, chiffre_affaires) VALUES
(1, 10, 'paris', 525345),
(2, 20, 'marseille', 501236),
(3, 30, 'lyon', 377569),
(4, 40, 'bordeaux', 350988),
(5, 50, 'paris', 122689);