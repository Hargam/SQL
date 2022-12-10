Create database formation ;
use formation ; 

create table filiere (
n_filiere int primary key auto_increment,
intitule varchar(255),
capacite int,
nbrannees int 
);

create table stagiaire (
n_stagiaire int primary key auto_increment,
nom varchar(255),
prenom varchar(255),
datenaiss date,
dateinscri date,
adresse varchar(255),
tel varchar(255),
n_filiere int,
foreign key (n_filiere) references filiere(n_filiere)
);

create table module(
n_module int primary key auto_increment,
intitulemod varchar(255),
massehoraire int
);

create table notation (
n_notation int primary key auto_increment,
n_stagiaire int, 
n_module int,
note float,
foreign key (n_stagiaire) references stagiaire (n_stagiaire),
foreign key (n_module) references module(n_module)
);

INSERT INTO filiere ( intitule, capacite, nbrannees) VALUES 
( "Sciences", 48, 2 ), ( "Beaux arts", 100, 3 ), ( "Medecines", 50, 4 ) ;
INSERT INTO module ( intitulemod, massehoraire) VALUES 
( "Mathématiques", 1030), ( "Arts Plastiques", 800), ( "Sciences & Vie", 546) ;
INSERT INTO stagiaire ( nom, prenom, datenaiss,dateinscri,adresse,Tel,n_filiere) VALUES 
( "Queen", "Diana","1998-08-10","2020-08-10", "10 Rue de crimee 75019 Paris",0134455657,1 ), 
( "King", "Alain","2003-09-10","2021-09-10", "10 Av Moderne 75019 Paris",0634455657,2 ),
( "Prince", "Lucas","2006-08-10","2021-12-10", "10 Pl Republique 75010 Paris",134455657,3 );
INSERT INTO notation ( n_module, n_stagiaire, note) VALUES ( 1,1,20 ), (3,2,15),(2,3,17),(3,2,20) ;


-- 1-La procédure permettant de lister les stagiaires d’une filière donnée
-- cas 1 : intitulé de la filiere 
delimiter $$ 
create procedure proc11 (in f varchar(255)) 
begin 
select stagiaire.* from stagiaire inner join filiere on stagiaire.n_filiere = filiere.n_filiere where filiere.intitule = f ;
end $$ 

call proc11 ("Medecines") ; 

-- cas 2 : numéro de la filiere 
delimiter $$ 
create procedure proc12 (in nf int) 
begin 
select stagiaire.* from stagiaire where n_filiere = nf ;
end $$ 

call proc12 (2) ;

-- 2-La procédure permettant d’afficher les stagiaires ayant la date de naissance dans la tranche précisé par L’utilisateur
delimiter $$ 
create procedure proc2 (in datedebut date, in datefin date) 
begin 
select * from stagiaire where datenaiss between datedebut and datefin ; 
end $$ 

call proc2('2003-01-01','2004-01-01') ; 

-- 3-Augmenter d’un point les notes des stagiaires dans le module « Mathématiques» 
delimiter $$ 
create procedure proc3(in nom varchar(255)) 
begin 
update notation 
set note = note + 1 where n_module = (select n_module from module where intitulemod = nom) and note < 20  ;
end $$

call proc3('Sciences & Vie') ; 

-- 4-La liste des stagiaires dont le nom commence par une lettre spécifiée par l’utilisateur
delimiter $$ 
create procedure proc4 (in c varchar(1)) 
begin 
select * from stagiaire where nom like concat(c , '%'); 
end $$ 

call proc4('p') ; 

-- 5-Le bulletin de notes d’un stagiaire donné (nom stagiaire, prenom ,nom module, note du module) 
delimiter $$ 
create procedure proc5(in stg int) 
begin 
select s.nom , s.prenom, m.intitulemod, n.note 
from stagiaire s , module m , notation n 
where s.n_stagiaire = n.n_stagiaire and m.n_module = n.n_module and s.n_stagiaire = stg ; 
end $$ 
call proc5(3) ; 
drop procedure proc5 ; 
-- 6-Liste des stagiaires non notés pour le module « Mathématiques » 
delimiter $$ 
create procedure proc6 () 
begin 
select distinct s.* from stagiaire s 
inner join notation n on s.n_stagiaire = n.n_stagiaire 
inner join module m on n.n_module = m.n_module 
where m.intitulemod != 'Mathématiques' ;
end $$

call proc6() ; 

delimiter $$ 
create procedure proc62 ()
begin 
select * from stagiaire where n_stagiaire not in (select n_stagiaire from notation where n_module in (select n_module from module where intitulemod= 'Mathématiques')) ;
end $$ 

call proc62() ; 


-- 7-Avant de supprimer un stagiaire, vérifier s’il existe et vérifier s’il a des notes.

delimiter $$ 
create procedure proc7(in num int) -- numero de stagiaire 
begin 
if exists (select * from stagiaire where n_stagiaire = num) 
	then if exists (select * from notation where n_stagiaire = num)
		then 
			 delete from notation where n_stagiaire = num ; 
			 delete from stagiaire where n_stagiaire = num ; 
		
        else 
			delete from stagiaire where n_stagiaire = num ;
        end if ; 
	else select 'stagiaire n existe pas' ; 
end if ; 
end $$ 

call proc7(8) ; 

-- 8-Procédure qui supprime une filière avec l’ensemble des stagiaires affectés à cette Filière. 

delimiter $$
create procedure proc8 (in fil int) 
begin 
declare num int ; 
select n_stagiaire into num from stagiaire where n_filiere = fil ; 
if exists (select * from filiere where n_filiere = fil) 
	then if exists (select * from stagiaire where n_stagiaire = num)
		then if exists (select * from notation where n_stagiaire = num ) 
			then delete from notation where n_stagiaire = num ; 
				delete from stagiaire where n_stagiaire = num ;
                delete from filiere where n_filiere = fil ; 
			else delete from stagiaire where n_stagiaire = num ;
                 delete from filiere where n_filiere = fil ; 
			end if ; 
		else delete from filiere where n_filiere = fil ; 
        end if ;
	else select 'filiere n existe pas' ;
	end if ; 
end $$ 

delimiter $$ 
create procedure proc8(in fil int) -- fil : numero de filière 
begin 
	declare liste_etudiant int; -- liste des étudiants de la filière fil
	declare i INT Default 0 ; -- coumpteur de la boucle
    declare dim int; -- taille de la liste
	select n_stagiaire, count(*) into liste_etudiant, dim from stagiaire where n_filiere = fil ;
      delete_loop: LOOP
         SET i=i+1;
         -- call proc7(liste_etudiant(i));
         select i; -- pour test
         select(liste_etudiant(i));
         IF i=dim THEN
            LEAVE delete_loop;
         END IF;
   END LOOP delete_loop;
   -- supprimer la filère après suppression des stagiaires
   -- delete from filiere where n_filiere = fil;    
end $$ 
call proc8(2) ;

-- 9-Affecter une note pour un stagiaire ; vérifier l’existence du stagiaire et du module. Vérifier si le stagiaire est déjà noté pour ce module.

delimiter $$ 
create procedure proc9 (in num_stagiaire int, in num_module int, in note2 int ) 
begin 
if exists (select * from stagiaire where n_stagiaire = num_stagiaire) 
	then if exists (select * from module where n_module = num_module ) 
		then if exists (select * from notation where n_stagiaire = num_stagiaire and n_module = num_module ) 
			then select 'deja noté' ; 
			else insert into notation (n_stagiaire, n_module, note) values (num_stagiaire, num_module, note2);
            end if ; 
		else select 'module n existe pas' ; end if ; 
	else select 'stagiaire n existe pas' ; end if ;  
end $$ 
call proc9(3,3,16) ; 

-- 11-Afficher les informations des stagiaires qui ont plus de deux notes.
delimiter $$ 
create procedure proc11 () 
begin 
select * from stagiaire where n_stagiaire in (select n_stagiaire from notation group by n_stagiaire having count(*) > 2) ; 
end $$ 

-- 12-Supprimer les stagiaires non notés dans le module ‘Sciences & Vie’
delimiter $$ 
create procedure proc12 () 
begin 
delete from notation 
where n_module not in (select n_module from module where intitulemod = 'Sciences & Vie') ;
delete from stagiaire 
where n_stagiaire not in (select n_stagiaire from notation where n_module in (select n_module from module where  intitulemod = 'Sciences & Vie'))  ;

end $$ 

-- 13-afficher dans une colonne nommée « observation » la valeur ‘Echec’ ou ‘racheté’ ou ‘admis’ en fonction de la moyenne obtenue par le stagiaire


delimiter $$ 
create procedure proc13()
begin 
select 
case 
when avg(note) < 9 then 'echec' 
when avg(note) >= 9 and avg(note) < 10 then 'rachteé'
when avg(note) > 10 then 'admis'
else 'erreur' 
end as observation , avg(note) from notation group by n_stagiaire ;  
end $$ 


call proc13() ; 


-- 14- Créer une procédure « compter » qui permet d'afficher le nombre de stagiaires inscrits dans une filière donnée
delimiter $$ 
create procedure proc14(in num int)
begin
select count(*) from stagiaire where n_filiere = num ; 
end $$ 
-- 15-effectuer la même opération pour l’ensemble des filières

delimiter $$ 
create procedure proc15()
begin
select n_filiere, count(*) from stagiaire group by n_filiere ; 
end $$ 












-- 14- Créer une procédure « compter » qui permet d'afficher le nombre de stagiaires inscrits dans une filière donnée

-- 15-effectuer la même opération pour l’ensemble des filières

