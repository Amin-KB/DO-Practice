USE Northwind
GO

--01) Eine Funktion welche die Details einer Kategorie auflistet
-- Als Parameter wird die Kategorienummer gegeben, die Funktion liefert zurück wie viele Produkte in der Kategorie sind, sowie Preisstatistiken (Mindest, Maximal und Durchschnittspreis) der Produkte. Zusätzlich wird über einen zweiten Parameter gesteuert ob es sich um noch geführte Produkte handelt oder nicht.

CREATE FUNCTION CategoryDetails(@catid int, @discontinued bit)
RETURNS TABLE
AS
RETURN
SELECT
	COUNT(ProductId) AS AzProdukte,
	MIN(UnitPrice) AS MinPreis,
	MAX(UnitPrice) AS MaxPreis,
	AVG(UnitPrice) AS DurchschnPreis
FROM Products
WHERE Discontinued = @discontinued AND CategoryID = @catid
GO

SELECT * FROM CategoryDetails(5,1)
GO

--02) Funktion die alle Kunden (Firmenname, Telefonnr) aus einem gewissen Land (via Name) anzeigt, die in einem gewissen Jahr nocht nichts bestellt haben.

CREATE OR ALTER FUNCTION KundenOhneBestellungInJahr(@country varchar(100), @year int)
RETURNS TABLE
AS
RETURN
--Gib mir alle Kunden aus Spanien
SELECT CompanyName, Phone
FROM Customers
WHERE Country = @country
EXCEPT --außer
SELECT CompanyName, Phone --Alle Kunden aus Spanien, die im Jahr 1996 bestellt haben
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE c.Country = @country AND YEAR(o.OrderDate) = @year
GO

SELECT * FROM KundenOhneBestellungInJahr('Spain', 1997)

--03) View die alle Telefonnummern und die zugehörigen Firmennamen, und falls vorhanden, Personennamen aus der Datenbank zusammenfasst - gibt es keinen Personennamen, soll 'n/a' stehen.

CREATE VIEW Firmenkontakte
AS
SELECT CompanyName, Phone, ContactName
FROM Suppliers
UNION
SELECT CompanyName, Phone, ContactName
FROM Customers
UNION
SELECT CompanyName, Phone, 'n/a'
FROM Shippers
GO

SELECT * FROM Firmenkontakte
GO

--04) Eine Funktion, die aus der View über den firmennamen die Telefonnummer und die Person zurückliefert

CREATE FUNCTION GetCompanyContact(@companyName nvarchar(40))
RETURNS TABLE
AS 
RETURN
SELECT Phone, ContactName 
FROM Firmenkontakte
WHERE CompanyName = @companyName
GO

SELECT * FROM GetCompanyContact('Alfreds Futterkiste')
GO

--05) Eine Funktion, die Aufgrund einer Bestellnummer, die Bestellten Produkte auflistet (inkl. Produktname, Stückpreis, Menge, Rabatt, Zeilenpreis, Bruttozeilenpreis (= Zeilenpreis + 20%)

CREATE OR ALTER FUNCTION ProductsOfOrder(@orderid INT)
RETURNS TABLE
AS
RETURN
SELECT 
	p.ProductName, od.UnitPrice,
	od.Quantity, od.Discount,
	od.UnitPrice * od.Quantity * (1-od.Discount) as Zeilenpreis,
	od.UnitPrice * od.Quantity * (1-od.Discount) * 1.2 as Bruttozeilenpreis
FROM [Order Details] od
JOIN Products p ON p.ProductID = od.ProductID
WHERE od.OrderID = @orderid
GO

SELECT * FROM ProductsOfOrder(10255)
GO
--06) Eine Funktion, die aufgrund einer Bestellnummer, den Gesamtwert der Bestellung zurückliefert - mit einem Parameter wird entschieden ob der Brutto- oder Nettogesamtpreis ausgegeben wird (Bruttogesamtpreis = Nettogesamtpreis + 20%)

CREATE OR ALTER FUNCTION GesamtpreisBestellung(@orderid int, @nettopreis bit)
RETURNS DECIMAL
AS
BEGIN

DECLARE @result DECIMAL

IF @nettopreis = 0
	SELECT @result = SUM(od.UnitPrice * od.Quantity * (1-od.Discount))
	FROM [Order Details] od
	JOIN Products p ON p.ProductID = od.ProductID
	WHERE od.OrderID = @orderid
ELSE
	SELECT @result = SUM(od.UnitPrice * od.Quantity * (1-od.Discount)) * 1.2
	FROM [Order Details] od
	JOIN Products p ON p.ProductID = od.ProductID
	WHERE od.OrderID = @orderid

RETURN @result
END
GO

SELECT dbo.GesamtpreisBestellung(10255)