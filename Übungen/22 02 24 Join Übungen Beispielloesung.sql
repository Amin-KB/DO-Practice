--Gemeinsame Übung: Wie viele Einheiten wurden 1997 pro Kategorie bestellt - absteigend sortiert nach Stückzahl

SELECT ca.CategoryName, SUM(od.Quantity) AS AnzahlStueck
FROM Categories ca
	JOIN Products pr ON ca.CategoryID = pr.CategoryID
	JOIN [Order Details] od ON pr.ProductID = od.ProductID
	JOIN Orders os ON od.OrderID = os.OrderID
WHERE YEAR(os.OrderDate) = 1997
GROUP BY ca.CategoryName
ORDER BY AnzahlStueck DESC

--Übungen ohne Joins

--01 Summe der Fracht (Freight) je nach Versandart (ShipVia), sortiert Absteigend nach Summe, aus dem Jahr 1996

SELECT ShipVia, SUM(Freight) AS SummeFracht
FROM Orders
WHERE YEAR(OrderDate) = 1996
GROUP BY ShipVia
ORDER BY SummeFracht DESC

--02 Wieviele Produkte sind im Durchschnitt in jeder Prouktkategorie lagernd (KategorieId, Durchschn. Lagerstand) - nur Produkte berücksichtigen die nicht Discontinued sind

SELECT CategoryId, AVG(UnitsInStock) AS LagerstandDurchschnitt
FROM Products
WHERE Discontinued = 0
GROUP BY CategoryId

--03 Wie davor, aber nur noch Kategorien anzeigen, wo der Durchschnitt über 35 liegt

SELECT CategoryId, AVG(UnitsInStock) AS LagerstandDurchschnitt
FROM Products
WHERE Discontinued = 0
GROUP BY CategoryId
HAVING AVG(UnitsInStock) > 35

--Übungen mit Joins

--04 Wie davor, aber jetzt statt der KategorieId, den Kategorienamen anzeigen

SELECT c.CategoryName, AVG(p.UnitsInStock) AS LagerstandDurchschnitt
FROM 
	Products p
	JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE p.Discontinued = 0
GROUP BY c.CategoryName
HAVING AVG(UnitsInStock) > 35

--05 Liste aller Produkte (ProductID, ProductName, UnitPrice) inklusive Kategorienamen (CategoryName) und Supplier-Firmenname (CompanyName)

SELECT p.ProductID, p.ProductName, p.UnitPrice, c.CategoryName, s.CompanyName
FROM
	Products p
	JOIN Suppliers s ON p.SupplierID = s.SupplierID
	JOIN Categories c ON c.CategoryID = p.CategoryID

--06 Liste aller [Order Detail]s (alle Spalten aus OD außer ProductId, stattdessen ProductName)

SELECT od.OrderID, p.ProductName, od.Quantity, od.UnitPrice, od.Discount
FROM 
	[Order Details] od
	JOIN Products p ON od.ProductID = p.ProductID

--07 Liste der Mitarbeiter (*), inklusive der Region (RegionDescription) in der sie Arbeiten 

SELECT r.RegionDescription, e.*
FROM
	Employees e
	JOIN EmployeeTerritories et ON e.EmployeeID = et.EmployeeID
	JOIN Territories t ON et.TerritoryID = t.TerritoryID
	JOIN Region r ON r.RegionID = t.RegionID

--08 Liste aller Bestellungen (*) vom Shipper mit Namen (CompanyName) "Speedy Express"

SELECT *, s.CompanyName
FROM 
	Orders o
	JOIN Shippers s ON o.ShipVia = s.ShipperID

--09 Welche Customers (*) haben noch nie etwas bestellt?

SELECT *
FROM 
	Customers c
	LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL

--10 Gibt es Territorien ohne Regionen? (*)

SELECT *
FROM 
	Territories t
	LEFT JOIN Region r ON t.RegionID = r.RegionID
WHERE r.RegionID IS NULL

--11 Verschiffte Fracht (Freight) pro Employee (LastName, FirstName, Id)

SELECT e.LastName, e.FirstName, e.EmployeeID, SUM(o.Freight) AS VerschiffteFracht
FROM 
	Orders o
	JOIN Employees e ON o.EmployeeID = e.EmployeeID
GROUP BY e.LastName, e.FirstName, e.EmployeeID

--12 Wie oft wurde welches Produkt im Jahr 1997 bestellt? Sortiert nach Anzahl Absteigend

--SUM Quantity oder COUNT OrderId ist beides OK (aber nur eines von beiden)
SELECT p.ProductId, COUNT(o.OrderID) AS AnzahlBestellungen
FROM
	Products p
	JOIN [Order Details] od ON od.ProductID = p.ProductID
	JOIN Orders o ON o.OrderID = od.OrderID
GROUP BY p.ProductID
ORDER BY AnzahlBestellungen DESC

SELECT p.ProductId, SUM(od.Quantity) AS VerkaufteStueck
FROM
	Products p
	JOIN [Order Details] od ON od.ProductID = p.ProductID
	JOIN Orders o ON o.OrderID = od.OrderID
GROUP BY p.ProductID
ORDER BY VerkaufteStueck DESC

--13 Anzahl der Bestellungen je Shipper  (CompanyName, AzBestellungen)

SELECT s.CompanyName, COUNT(o.OrderId)
FROM
	Orders o
	JOIN Shippers s ON s.ShipperID = o.ShipVia
GROUP BY s.CompanyName

--14 Eine Liste aller Territorien und falls vorhanden, den zugehörigen Employees (TerritoryID, TerritoryDescription, EmployeeID, Name)

SELECT t.TerritoryID, t.TerritoryDescription, e.EmployeeID, e.FirstName + ' ' + e.LastName AS Mitarbeiter
FROM 
	Territories t
	LEFT JOIN EmployeeTerritories et ON t.TerritoryID = et.TerritoryID
	LEFT JOIN Employees e ON e.EmployeeID = et.EmployeeID

--15 Kundenname, Employee Name, BestellNr, BestellDatum, von alle Bestellungen die 1997 getätigt wurden und mit ShipVia 2 verschickt wurden

SELECT c.CompanyName, e.FirstName + '' + e.LastName AS Mitarbeiter, o.OrderID, o.OrderDate
FROM 
	Orders o
	JOIN Shippers s ON o.ShipVia = s.ShipperID
	JOIN Customers c ON c.CustomerID = o.CustomerID
	JOIN Employees e ON e.EmployeeID = o.EmployeeID 
WHERE YEAR(o.OrderDate) = 1997 AND o.ShipVia = 2
	

--16 Eine Liste von Kunden (CompanyName, CustomerId) und wie viele Bestellungen sie insgesamt aufgegeben haben (AzBestellungen), sortiert nach den meisten Bestellungen

SELECT c.CompanyName, c.CustomerID, COUNT(o.OrderID) AS AnzahlBestellungen
FROM
	Customers c
	JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CompanyName, c.CustomerID
ORDER BY AnzahlBestellungen DESC

--17 Eine Liste von Produkten (ProductName, CategoryID, UnitsInStock), die noch nie bestellt wurden

SELECT p.ProductName, p.CategoryID, p.UnitsInStock
FROM 
	Products p
	LEFT JOIN [Order Details] od ON p.ProductID = od.ProductID
WHERE od.OrderID IS NULL

--18 Eine Liste von Produkten zum Nachbestellen (=UnitsInStock ist kleiner als 10 und Produkte sind nicht discontinued), angezeigt werden sollen: ProductId, ProductName, CategoryName, UnitsOnOrder, Supplier CompanyName, Supplier ContactName, SupplierPhone)

SELECT p.ProductID, p.ProductName, c.CategoryName, p.UnitsOnOrder, s.CompanyName, s.ContactName, s.Phone
FROM 
	Products p
	JOIN Categories c ON p.CategoryID = c.CategoryID
	JOIN Suppliers s ON s.SupplierID = p.SupplierID
WHERE p.UnitsInStock < 10 AND p.Discontinued = 0

--19 Verschiffte Fracht (Freight) pro Jahr, Monat und Lieferdienst (Shipper)

SELECT YEAR(o.OrderDate) AS Jahr, MONTH(o.OrderDate) AS Monat, s.CompanyName, SUM(o.Freight) AS VerschiffteFracht
FROM
	Orders o
	JOIN Shippers s ON o.ShipVia = s.ShipperID
GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate), s.CompanyName

--20 Eine Liste die angibt, wie viele Produkte aus jeder Kategorie bestellt wurden (CategoryName, Anzahl d. bestellten Produkte d. Kategorie), sortiert aufsteigend nach der Anzahl

SELECT c.CategoryName, COUNT(od.Quantity) AS BestellteProdukte
FROM
	Products p
	JOIN Categories c ON p.CategoryID = c.CategoryID
	JOIN [Order Details] od ON p.ProductID = od.ProductID
GROUP BY c.CategoryName
ORDER BY BestellteProdukte

--21 Umsatz jedes Mitarbeiters (Vor- und Nachname), aufgeschlüsselt nach Jahren

SELECT
	e.LastName + ', ' + e.FirstName AS Mitarbeiter,
	YEAR(o.OrderDate) AS Jahr, 
	SUM((od.Quantity * od.UnitPrice) * (1-od.Discount)) AS Umsatz
FROM
	Employees e
	JOIN Orders o ON e.EmployeeID = o.EmployeeID
	JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY YEAR(o.OrderDate), e.FirstName, e.LastName
ORDER BY Mitarbeiter, Jahr