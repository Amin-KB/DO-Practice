USE Northwind
GO

--01. Products: Alle Produkte die Discontinued sind
SELECT *
FROM Products
WHERE Discontinued = 'true'

--02. Products: Produktliste (Name) mit Preis, billigste zuerst
SELECT ProductName, UnitPrice
FROM Products
ORDER BY UnitPrice

--03. Products: Produktliste (Name, ID) und Preis von allen Produkten die Billiger als 20 sind.
SELECT ProductName, ProductID, UnitPrice
FROM Products
WHERE UnitPrice < 20

--04. Products: Produktliste (Name) und Preis von allen Produkten die zwischen 15 und 20 (inklusive) kosten.
SELECT ProductName, UnitPrice
FROM Products
WHERE UnitPrice BETWEEN 15 AND 20
--WHERE UnitPrice >= 15 AND UnitPrice <= 20 

--05. Products: Die zehn Teuersten Produkte, Name und Preis anzeigen
SELECT TOP(10) ProductName, UnitPrice
FROM Products
ORDER BY UnitPrice DESC

--06. Products: Liste von Produkten die aktuell sind (nicht discontinued) und bei denen weniger UnitsInStock sind als UnitsOnOrder. 

SELECT *
FROM Products
WHERE Discontinued = 0 AND UnitsInStock < UnitsOnOrder

--07. Orders: Bestellung mit der schwersten Fracht

SELECT TOP(1) *
FROM Orders
ORDER BY Freight DESC

--08. Orders: Liste aller Bestellungen 1997

SELECT *
FROM Orders
WHERE YEAR(OrderDate) = 1997
--WHERE OrderDate >=  '19970101' AND OrderDate <= '19971231'


--09. Orders: Liste aller Bestellungen im Februar 1998
SELECT *
FROM Orders
WHERE YEAR(OrderDate) = 1998 AND MONTH(OrderDate) = 2

--10. Orders: Liste aller Bestellungen in die USA zwischen (inklusive) Mai 1997 und November 1997
SELECT *
FROM Orders
WHERE ShipCountry = 'USA' AND OrderDate BETWEEN '19970501' AND '19971130'

--11. Employees: Alle Mitarbeiter (ID, Vorname, Nachname) die 1993 angestellt wurden

SELECT EmployeeID, FirstName, LastName
FROM Employees
WHERE YEAR(HireDate) = 1993

--12. Orders: In welche Städte wurde schon verschickt?

SELECT DISTINCT ShipCity, ShipCountry
FROM Orders