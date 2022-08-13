--1) Erstellen Sie eine Tabelle "Produkt" mit folgenden Spalten

--Id: Primärschlüssel, automatischer Wert
--Name: Soll internationale Zeichen erlauben, maximal 200 Zeichen, angabe erforderlich
--Nettopreis: Einzelpreise können bis in die zehntausende reichen, soll auf zwei Kommastellen genau sein, angabe erforderlich
--Mehrwertssteuer: Kleiner ganzzahliger Wert, angabe erforderlich, standardwert = 20
--Beschreibung: beliebig langer Text mit internationalen Zeichen, angabe optional
--BildPfad: text ohne internationale Zeichen, maximal 320 zeichen, angabe optional

CREATE TABLE Produkt
(
	Id int identity primary key,
	Name nvarchar(200) not null,
	Nettopreis decimal(7,2) not null,
	Mehrwertssteuer tinyint not null constraint DF_Produkt_Mehrwertssteuer default 20,
	Beschreibung nvarchar(max) null,
	BildPfad varchar(320) null
)


--2) Pflegen Sie folgende Produkte in die Tabelle ein:

--Fluxkompensator
--15000 €, 20% MWst.
--Kernstück einer Zeitmaschine, die das Zeitreisen erst möglich macht.

INSERT INTO Produkt(Name, Nettopreis, Mehrwertssteuer, Beschreibung, BildPfad)
VALUES 	('Fluxkompensator', 15000, 20, 'Kernstück einer Zeitmaschine, die das Zeitreisen erst möglich macht.', NULL)

--Dingelhopper
--3 €, 20% MWst.

INSERT INTO Produkt(Name, Nettopreis)
VALUES ('Dingelhopper', 3)

--W-Lan Kabel
--13,37 €
--Pure Magie
--C:/bilder/wlankabel.png

INSERT INTO Produkt
VALUES('W-Lan Kabel', 13.37, DEFAULT, 'Pure Magie', 'C:/bilder/wlankabel.png')



--3) Erhöhen Sie die Nettopreise für alle Produkte die 10 Euro oder weniger kosten um 15%

UPDATE Produkt
SET Nettopreis = Nettopreis * 1.15
WHERE Nettopreis <= 10

--4) Fügen Sie für alle Produkte, die kein Produktbild haben, den Standard-Bildpfad C:/bilder/default.png ein

UPDATE Produkt
SET BildPfad = 'C:/bilder/default.png'
WHERE BildPfad IS NULL

--5) Löschen Sie alle Produkte, die keine Produktbeschreibung haben

DELETE FROM Produkt
WHERE Beschreibung IS NULL