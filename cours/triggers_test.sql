create database test ;
use test
;

delimiter $$ 
create trigger nom_trigger 
BEFORE/AFTER
/*moment*/
INSERT/

UPDATE/
DELETE /*evenement */
on nom_table 
for each
row
begin

  -- instructions du trigger 

  end
$$ 

create table employe
(
  nom varchar(255),
  age int,
  salaire float,
  numero_entreprise int
);

create table entreprise
(
  num int,
  nom_entreprise varchar(255),
  nbr_employe int
);

delimiter $$ 
create trigger trig1
after
insert 
on
entreprise
for
each
row
begin
  if condition then
;
-- instruction du trigger 
end $$ 

insert into entreprise
values
  (1, 'entreprise 1', 20)
;
-- instruction qui a déclenché le trigger 
insert into entreprise
values
  (2, 'entreprise 2', 20),
  (3, 'entreprise 3', 30)
;


create table employe_details
(
  nom varchar(255),
  age int,
  salaire float,
  numero_entreprise int,
  date_embauche date
);


delimiter $$ 
create trigger trig2 
after
insert 
on
employe
for
each
row
begin
  insert into employe_details
  values
    ('Karima', 30, 2000, 2, current_date
  ())
;
end $$ 


insert into employe
values
  ('Karima', 30, 2000, 2)
;


delimiter $$ 
create trigger trig3
before
insert 
on
employe
for
each
row
begin
  set new
  .nom = upper
  (new.nom);
  set new
  .salaire = new.salaire + 500
;
end $$ 

insert into employe
values
  ('Christiane', 30, 2500, 3)
;
insert into employe
values
  ('cyril', 30, 3000, 3)
;
insert into employe
values
  ('stephanie', 30, 2000, 3),
  ('jack', 30, 1000, 3)
;

drop trigger trig3 ; 




















