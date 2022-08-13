--Gemeinsame Übung: Wie viele Einheiten wurden 1997 pro Kategorie bestellt - absteigend sortiert nach Stückzahl

SELECT ca.CategoryName, SUM(od.Quantity) as AnzahlStueck
FROM Categories ca
	JOIN Products pr ON ca.CategoryID = pr.CategoryID
	JOIN [Order Details] od ON pr.ProductID = od.ProductID
	JOIN Orders os ON od.OrderID = os.OrderID
WHERE YEAR(os.OrderDate) = 1997
GROUP BY ca.CategoryName
ORDER BY AnzahlStueck DESC

--Übungen ohne Joins

--01 Summe der Fracht (Freight) je nach Versandart (ShipVia), sortiert Absteigend nach Summe, aus dem Jahr 1996

--02 Wieviele Produkte sind im Durchschnitt in jeder Prouktkategorie lagernd (KategorieId, Durchschn. Lagerstand) - nur Produkte berücksichtigen die nicht Discontinued sind

--03 Wie davor, aber nur noch Kategorien anzeigen, wo der Durchschnitt über 35 liegt

--Übungen mit Joins

--04 Wie davor, aber jetzt statt der KategorieId, den Kategorienamen anzeigen

--05 Liste aller Produkte (ProductID, ProductName, UnitPrice) inklusive Kategorienamen (CategoryName) und Supplier-Firmenname (CompanyName)

--06 Liste aller [Order Detail]s (alle Spalten aus OD außer ProductId, stattdessen ProductName)

--07 Liste der Mitarbeiter (*), inklusive der Region (RegionDescription) in der sie Arbeiten 

--08 Liste aller Bestellungen (*) vom Shipper mit Namen (CompanyName) "Speedy Express"

--09 Welche Customers (*) haben noch nie etwas bestellt?

--10 Gibt es Territorien ohne Regionen? (*)

--11 Verschiffte Fracht (Freight) pro Employee (LastName, FirstName, Id)

--12 Wie oft wurde welches Produkt im Jahr 1997 bestellt? Sortiert nach Anzahl Absteigend

--13 Anzahl der Bestellungen je Shipper  (CompanyName, AzBestellungen)

--14 Eine Liste aller Territorien und falls vorhanden, den zugehörigen Employees (TerritoryID, TerritoryDescription, EmployeeID, Name)

--15 Kundenname, Employee Name, BestellNr, BestellDatum, von alle Bestellungen die 1997 getätigt wurden und mit ShipVia 2 verschickt wurden

--16 Eine Liste von Kunden (CompanyName, CustomerId) und wie viele Bestellungen sie insgesamt aufgegeben haben (AzBestellungen), sortiert nach den meisten Bestellungen

--17 Eine Liste von Produkten (ProductName, CategoryID, UnitsInStock), die noch nie bestellt wurden

--18 Eine Liste von Produkten zum Nachbestellen (=UnitsInStock ist kleiner als 10 und Produkte sind nicht discontinued), angezeigt werden sollen: ProductId, ProductName, CategoryName, UnitsOnOrder, Supplier CompanyName, Supplier ContactName, SupplierPhone)

--19 Verschiffte Fracht (Freight) pro Jahr, Monat und Lieferdienst (Shipper)

--20 Eine Liste die angibt, wie viele Produkte aus jeder Kategorie bestellt wurden (CategoryName, Anzahl d. bestellten Produkte d. Kategorie), sortiert aufsteigend nach der Anzahl

--21 Umsatz jedes Mitarbeiters (Vor- und Nachname), aufgeschlüsselt nach Jahren