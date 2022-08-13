USE Northwind
GO

--01: Die 20 Bestellungen mit der höchsten Fracht aus 1997
SELECT TOP 20 *
FROM Orders
WHERE YEAR(OrderDate) = 1997
ORDER BY Freight DESC
GO

--02: Produktliste (Produkt ID, Produktname, Preis, Kategoriename) aller Produkte die noch geführt werden (also nicht Discontinued), sortiert nach Kategorie- und Produktname
SELECT ProductID, ProductName, UnitPrice, CategoryName
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE Discontinued = 0
ORDER BY CategoryName, ProductName
GO

--03: Eine View von Bestelldetails: Bestellnr., Kundenname, Bestelldatum, Versanddatum, Name Versandunternehmen, Name Mitarbeiter, Fracht; aus der View einmal alle Daten abrufen
CREATE VIEW Bestelldetails AS
SELECT 
	OrderId, 
	c.CompanyName AS Kunde,
	OrderDate, 
	ShippedDate, 
	s.CompanyName AS Versandunternehmen, 
	FirstName + ' ' + LastName AS Mitarbeiter, 
	Freight
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN Shippers s ON s.ShipperID = o.ShipVia
JOIN Employees e ON e.EmployeeID = o.EmployeeID
GO

SELECT * FROM Bestelldetails
GO

--04: Anzahl der Bestellungen über 50 Fracht, je Jahr und Monat, sortiert nach Jahr und Monat
SELECT YEAR(OrderDate) AS Year, MONTH(OrderDate) AS Month, COUNT(*) AS Anzahl
FROM Orders
WHERE Freight > 50
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY Year, Month
GO

--05: Liste aller Kategorien (Kategoriename), inklusive der Anzahl der Produkte
SELECT CategoryName, COUNT(p.ProductId) AS AnzahlProdukte
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
GROUP BY CategoryName
GO

--06: Eine Funktion, die alle Bestellungen in ein bestimmtes Land innerhalb eines gewissen Jahr und Monats auflistet; mit Hilfe der Funktion einmal Daten für die USA vom März 1997 abrufen
CREATE FUNCTION Bestellungsuche(@country varchar(100), @year int, @month int)
RETURNS TABLE
AS RETURN
SELECT *
FROM Orders
WHERE ShipCountry = @country AND YEAR(OrderDate) = @year AND MONTH(OrderDate) = @month
GO

SELECT * FROM Bestellungsuche('USA', 1997, 3)
GO

--07: Liste der 5 Kunden (Kundenname, Land) mit den meisten Bestellungen 1997
SELECT TOP 5 CompanyName, Country, COUNT(o.OrderID) AS AnzahlBestellungen
FROM Customers c
JOIN Orders o ON o.CustomerID = c.CustomerID
WHERE YEAR(OrderDate) = 1997
GROUP BY CompanyName, Country
ORDER BY AnzahlBestellungen DESC
GO

--08: Eine Liste der Produkte (Name), die im Dezember 1996 bestellt wurden
SELECT DISTINCT p.ProductName
FROM Products p
JOIN [Order Details] od ON od.ProductID = p.ProductID
JOIN Orders o ON o.OrderID = od.OrderID
WHERE YEAR(OrderDate) = 1996 AND MONTH(OrderDate) = 12
GO

--09: Eine View von Kategoriestatistiken: KategorieId, KategorieName, Anzahl Produkte gesamt, Anzahl Stück Lagernd, Anzahl Stück in Nachbestellung; aus der View einmal alle Daten abrufen
CREATE VIEW Kategoriestatistik AS
SELECT 
	c.CategoryID, 
	c.CategoryName,
	COUNT(p.ProductID) AS AnzahlProdukte, 
	SUM(p.UnitsInStock) AS StückLagernd, 
	SUM(p.UnitsOnOrder) AS StückNachbestellt
FROM Categories c
JOIN Products p ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryID, c.CategoryName
GO

SELECT * FROM Kategoriestatistik
GO

--10: Eine Liste aller Bestellungen (Id und Datum), inklusive dem Gesamtwert der Bestellung (OrderId, Gesamtwert; Gesamtwert = Stückpreis mal Anzahl - Rabatt), absteigend sortiert nach dem Gesamtert
SELECT o.OrderId, OrderDate, SUM(UnitPrice * Quantity * (1-Discount)) AS Gesamtwert
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY o.OrderID, o.OrderDate
ORDER BY Gesamtwert DESC
GO

--11: Liste der Mitarbeiter inkl. dem jeweililgen Gesamtumsatz aus dem Jahr 1996 (Vorname, Nachname, Gesamtumstaz), sortiert nach Nachname und Vorname
SELECT FirstName, LastName, SUM(UnitPrice * Quantity * (1-Discount)) AS Gesamtwert
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Employees e ON e.EmployeeID = o.EmployeeID
GROUP BY FirstName, LastName
ORDER BY LastName, FirstName
GO

--12: Eine Funktion, die alle Produkte aus einer bestimmten Kategorie (Kategoriename) liefert, deren preis zwischen einem Mindest- und Maximalpreis liegt; mit Hilfe der Funktion einmal Daten für Beverages abrufen, die zwischen 30 und 50 kosten
CREATE OR ALTER FUNCTION Produktsuche(@category varchar(100), @minpreis int, @maxpreis int)
RETURNS TABLE
AS
RETURN
SELECT p.* 
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE UnitPrice BETWEEN @minpreis AND @maxpreis AND c.CategoryName = @category
GO

SELECT * FROM Produktsuche('Beverages', 30, 50)
GO

--13: Liste jener Kunden, deren Gesamtumsatz aus 1997 über 15000 liegt (Kundenname, Umsatz)
SELECT c.CompanyName, SUM(UnitPrice * Quantity * (1-Discount)) AS Gesamtumsatz
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE YEAR(OrderDate) = 1997
GROUP BY c.CompanyName
HAVING SUM(UnitPrice * Quantity * (1-Discount)) > 15000
GO

--14: Liste jener Employees (Vorname, Nachname), die 1998 Bestellungen sowohl nach Argentinien (Argentina) als auch nach Brasilien (Brazil) bearbeitet haben

--Liste jener Employees (Vorname, Nachname), die 1998 Bestellungen nach Brasilien geschickt haben
SELECT FirstName, LastName
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
WHERE YEAR(OrderDate) = 1998 AND ShipCountry = 'Brazil'
INTERSECT
--Liste jener Employees (Vorname, Nachname), die 1998 Bestellungen nach Argentinien geschickt haben
SELECT FirstName, LastName
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
WHERE YEAR(OrderDate) = 1998 AND ShipCountry = 'Argentina'
GO

--15: Eine Funktion, die von einem Produkt (über die ProduktId) bestimmt, ob es nachbestellt werden soll oder nicht; ein Produkt soll nachbestellt werden, wenn die unitsinstock kleiner sind als das reorderlevel, es nicht discontinued ist, und nicht schon unitsonorder sind; Aufrufen der Funktion für das Produkt mit der Id 30

CREATE OR ALTER FUNCTION ProduktNachbestellung(@produktid INT)
RETURNS BIT
AS
BEGIN
	DECLARE @ergebnis BIT

	DECLARE @unitsInStock INT
	DECLARE @reorderLevel INT
	DECLARE @discontinued BIT
	DECLARE @unitsOnOrder INT

	SELECT 
		@unitsInStock = UnitsInStock, 
		@reorderLevel = ReorderLevel, 
		@discontinued = Discontinued, 
		@unitsOnOrder = UnitsOnorder
	FROM Products
	WHERE ProductID = @produktid

	--hier die logik
	IF @unitsInStock < @reorderLevel AND @discontinued = 0 AND @unitsOnOrder = 0
		SET @ergebnis = 'true'
	ELSE
		SET @ergebnis = 'false'

	RETURN @ergebnis
END
GO

SELECT dbo.ProduktNachbestellung(30)
GO


--Welche Produkte sollen nachbestellt werden? (Nachbestellt heißt: wenn die unitsinstock kleiner sind als das reorderlevel, es nicht discontinued ist, und nicht schon unitsonorder sind)

SELECT COUNT(*)
FROM Products
WHERE UnitsInStock < ReorderLevel AND Discontinued = 'false' AND UnitsOnOrder = 0 AND ProductID = 30
GO

--Alternative Variante

CREATE OR ALTER FUNCTION ProduktNachbestellungV2(@produktid INT)
RETURNS BIT
AS
BEGIN
	DECLARE @ergebnis BIT
	DECLARE @anzahl INT

	SELECT @anzahl=COUNT(*)
	FROM Products
	WHERE UnitsInStock < ReorderLevel AND Discontinued = 'false' AND UnitsOnOrder = 0 AND ProductID = @produktid

	--hier die logik
	IF @anzahl = 1
		SET @ergebnis = 'true'
	ELSE
		SET @ergebnis = 'false'

	RETURN @ergebnis
END
GO

SELECT dbo.ProduktNachbestellungV2(30)
GO