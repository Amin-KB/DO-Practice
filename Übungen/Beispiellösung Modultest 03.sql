--01: Alle Kunden (Id, EMail) mit nicht abgeschlossenen Projekten und einer Projektsumme über 10000

SELECT c.Id, c.Email
FROM Customer c
JOIN Project p ON c.Id = p.CustomerId
WHERE p.EndDate IS NULL AND p.ProjectSum > 10000
GO

--02: Eine Liste jener Konten (Name) die noch keine Zahlungen empfangen haben

SELECT a.Name
FROM Account a
LEFT JOIN Invoice i ON a.Id = i.AccountId
WHERE i.Id IS NULL
GO

--03: Eine Funktion, die alle Zahlungen innerhalb eines gewissen Zeitraums (von-bis Datum) auflistet (Zahlungs Id, Menge, Kontoname, Projektname, Zeitpunkt der Überweisung); Aufrufen der Funktion mit beliebigen Datumsangaben

CREATE FUNCTION GetPaymentsInPeriod(@periodStart datetime, @periodEnd datetime)
RETURNS TABLE
AS RETURN
SELECT i.Id, i.Amount, a.Name AS AccountName, p.Name AS ProjectName, i.DateReceived
FROM Invoice i
JOIN Account a ON i.AccountId = a.Id
JOIN Project p ON p.Id = i.ProjectId
WHERE i.DateReceived BETWEEN @periodStart AND @periodEnd
GO

SELECT * FROM GetPaymentsInPeriod('20180101','20180501')
GO

--04: Alle Projekte (Id, Name) die in 2019 gestartet wurden, bei denen in Summe mehr als 1500 überwiesen wurde, sortiert nach Projektnamen

SELECT p.Id, p.Name
FROM Project p
JOIN Invoice i ON i.ProjectId = p.Id
WHERE YEAR(p.StartDate) = 2019 --AND Amount > 1500 --Die SUMME der Überweisungen muss >1500 sein
GROUP BY p.Id, p.Name
HAVING SUM(i.Amount) > 1500
ORDER BY p.Name
GO

--05: Alle abgeschlossenene Projekte (Id, Name, Kostenschätzung, Summe d. Zahlungen), bei denen die Summe der Zahlungen kleiner als die Kostenschätzung sind

SELECT p.Id, p.Name, p.ProjectSum, SUM(i.Amount) AS SummeBetrag
FROM Project p
JOIN Invoice i ON p.Id = i.ProjectId
WHERE p.EndDate IS NOT NULL
GROUP BY p.Id, p.Name, p.ProjectSum
HAVING SUM(i.Amount) < p.ProjectSum
GO

--06: Eine View, zur Kundenstatistik (Kunden Id, Kundenname, Anzahl Projekte, Durchschnittliche Projektsumme, Summe Zahlungen); Abrufen der View

CREATE VIEW CustomerStat
AS
SELECT
	c.Id, 
	c.FirstName + ' ' + c.LastName AS Kundenname, 
	COUNT(p.Id) AS AnzahlProjekte, 
	AVG(p.ProjectSum) AS DurchschnProjektSumme, 
	SUM(i.Amount) AS GesamtÜberwiesen
FROM Customer c
JOIN Project p ON c.Id = p.CustomerId
JOIN Invoice i ON i.ProjectId = p.Id
GROUP BY c.Id, c.FirstName, c.LastName
GO

SELECT * FROM CustomerStat
GO

--07: Eine Liste aller vor Projekte (Name, Startdatum, Enddatum, Kostenschätzung) die vor 2020 zu Ende gegangen sind, und bei denen keine Zahlungen eingegangen ist

SELECT p.Name, p.StartDate, p.EndDate, p.ProjectSum
FROM Project p
LEFT JOIN Invoice i ON p.Id = i.ProjectId
WHERE YEAR(p.EndDate) < 2020 AND i.Id IS NULL
GO

--08: Die Summe der Projektsumme all jener Projekte die vor 2020 gestartet und vor 2020 zu Ende gegangen sind, und noch keine Zahlung erhalten haben, gruppiert nach Jahren d. Startdatums

SELECT YEAR(p.StartDate) AS Jahr, SUM(p.ProjectSum) AS Gesamtsumme
FROM Project p
LEFT JOIN Invoice i ON p.Id = i.ProjectId
WHERE YEAR(p.EndDate) < 2020 AND i.Id IS NULL AND YEAR(p.StartDate) < 2020
GROUP BY YEAR(p.StartDate)
GO

--09: Die Anzahl der Überweisungen je Kunde (Id, Nachname, Vorname), aufgeschlüsselt nach Konten (Name)

SELECT c.Id, c.LastName, c.FirstName, a.Name, COUNT(i.Id) AS AnzahlÜberweisungen
FROM Customer c
JOIN Project p ON c.Id = p.CustomerId
JOIN Invoice i ON p.Id = i.ProjectId
JOIN Account a ON i.AccountId = a.Id
GROUP BY c.Id, c.LastName, c.FirstName, a.Name
GO

--10: Alle Kunden (Id, Email) die ein Projekt sowohl in 2018 als auch 2019 gestartet haben

SELECT c.Id, c.Email
FROM Customer c
JOIN Project p ON c.Id = p.CustomerId
WHERE YEAR(p.StartDate) = 2018
INTERSECT
SELECT c.Id, c.Email
FROM Customer c
JOIN Project p ON c.Id = p.CustomerId
WHERE YEAR(p.StartDate) = 2019
GO

--11: Eine Funktion die alle Projekte (Name, Start- und Enddatum, Kundenname) die komplett innerhalb eines angegebenen Jahres abgewickelt wurden auflistet; Aufrufen der Funktion für das Jahr 2018

CREATE FUNCTION OneYearProjects(@year int)
RETURNS TABLE
AS RETURN
SELECT p.Name, p.StartDate, p.EndDate, c.LastName + ', ' + c.FirstName AS Kunde
FROM Project p
JOIN Customer c ON c.Id = p.CustomerId
WHERE YEAR(p.StartDate) = @year AND YEAR(p.EndDate) = @year
GO

SELECT * FROM OneYearProjects(2018)
GO

--12: Eine Funktion, die die Summe aller Zahlungen auf ein gewisses Konto zu einem gewissen Projekt angibt; Aufrufen der Funktion für das Konto 2 und Projekt 42

CREATE FUNCTION ProjectInvoiceSum(@accountId int, @projectId int)
RETURNS decimal
AS
BEGIN
	DECLARE @ergebnis decimal
		
	SELECT @ergebnis = SUM(i.Amount)
	FROM Invoice i
	WHERE i.AccountId = @accountId AND i.ProjectId = @projectId

	RETURN @ergebnis
END
GO

SELECT dbo.ProjectInvoiceSum(2, 42)
GO