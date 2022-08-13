use pubs
go

----DML
--Tabelle Authors
--Einfügen folgender Autoren: 
	--ID: 486-34-5498, Max Muster, +43123456789, Fakestreet 123, 12345 Fakewtown, FS, Hat Vertrag
	--ID: 819-12-7895, John Doe, +1 555 5555, keine Adresse, hat keinen Vertrag
	--ID: 768-78-1234, Maria Muster, keine Telefonnummer, 12345 Faketown, FS, Hat Vertrag

INSERT INTO authors VALUES ('486-34-5498', 'muster', 'max', '+43123456789', 'fakestreet 123', 'faketown', 'FS', '12345', 1)

INSERT INTO authors(au_id, au_lname, au_fname, phone, contract) VALUES ('819-12-7895', 'doe', 'john', '+1 555 5555', 0)

INSERT INTO authors VALUES ('768-78-1235', 'musterfrau', 'maria', default, null, 'faketown', 'FS', '12345', 1)

--Tabelle Titles

--Erhöhung der Preise aller Bücher die unter 5 kosten um 3 
update titles 
set price = price + 3 
where price < 5

--Verringerung der Preise aller Bücher die mindestens 15 kosten um 15%
update titles
set price = price * 0.85
where price >= 15

--Löschen aller Bücher ohne Preis
delete from titles 
where price is null

----DQL
--Tabelle Employee
--Auflisten aller Mitarbeiter (Name, JobId; Name soll im Format Nachname, Vorname sein) die vor 1991 eingestellt wurden
select lname + ', ' + fname as EmployeeName, job_id 
from employee 
where year(hire_date) < 1991

--Alle Mitarbeiter die keinen Mittleren Namen haben (minit)
select * 
from employee
where minit = ''

--Tabelle Titles
--Alle Bücher deren Jahresverkäufe (ytd_sales) unter 3000 liegen

select * 
from titles 
where ytd_sales < 3000

--Alle Bücher die das wort "comp" im Namen (title) oder in den Kommentaren (Notes) haben
select * 
from titles 
where title like '%comp%' or notes like '%comp%'

--Alle Bücher mit den Typen "business", "popular comp", "psychology"
select *
from titles
where type in ('business', 'popular_comp', 'psychology')

--Der Titel und die ID der 5 teuersten Bücher
select top(5) title, title_id
from titles
order by price desc

--Tabelle Sales

--Eine Liste der verschiedenen PayTerms, alphabetisch sortiert
select distinct payterms 
from sales 
order by payterms asc

--Alle Verkäufe im Zeitraum April Mai bis Oktober 1993, sortiert nach Anzahl (qty) 
select *
from sales
where ord_date between '19930501' and '19931031'
order by qty
