--
-- Base de données: tic_evenements
--

CREATE TABLE IF NOT EXISTS journal (
  id_journal int(10) NOT NULL AUTO_INCREMENT,
  titre varchar(20) NOT NULL,
  texte text NOT NULL,
  PRIMARY KEY (id_journal)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

INSERT INTO journal (id_journal, titre, texte) VALUES
(1, 'sortie iphone 5', 'voici le telephone : iphone 5');

-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS journal_copie (
  id_journal int(10) NOT NULL AUTO_INCREMENT,
  titre varchar(20) NOT NULL,
  texte text NOT NULL,
  PRIMARY KEY (id_journal)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

