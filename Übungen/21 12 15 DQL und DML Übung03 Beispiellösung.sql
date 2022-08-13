USE Northwind
GO

--01. Order Details: Alle Order Details die einen Discount haben

SELECT * 
FROM [Order Details] 
WHERE Discount > 0

--02. Order Details: Alle Order Details, sortiert OrderId aufsteigend, Quantity absteigend, Unit Price absteigend

SELECT * 
FROM [Order Details] 
ORDER BY OrderId, Quantity DESC, UnitPrice DESC

--03. Suppliers: Alle suppliers aus den USA die "trade" im Namen haben

SELECT * 
FROM Suppliers
WHERE Country = 'USA' AND CompanyName LIKE '%trade%'

--04. Suppliers: Alle Suppliers die keine Region eingetragen haben

SELECT * 
FROM Suppliers
WHERE Region IS NULL

--05. Products: Die 5 Produkte von denen am Meisten auf Lager ist

SELECT TOP(5) *
FROM Products
ORDER BY UnitsInStock DESC

--06. Products: Alle Produkte (Id, Name, Kategorie, Preis) aus den Kategorien 4, 6, oder 8, die nicht discontinued sind und mehr als 20 kosten, sortiert nach Categorie Aufsteigend, Preis Absteigend, Name Aufsteigend

SELECT ProductId, ProductName, CategoryId, UnitPrice 
FROM Products
WHERE CategoryID IN (4,6,8) AND Discontinued = 0	AND UnitPrice > 20
--WHERE (CategoryID = 4 OR CategoryID = 6 OR CategoryID = 8) AND Discontinued = 0	AND UnitPrice > 20
ORDER BY CategoryID, UnitPrice DESC, ProductName 

--07. Products: Alle Produkte löschen die Discontinued sind und keine UnitsInStock mehr haben

DELETE FROM Products
WHERE Discontinued = 1 AND UnitsInStock = 0

--08. Products: Bei allen Produkten wo die UnitsOnOrder 0 sind, die UnitsOnOrder auf den selben Wert wie das ReorderLevel setzen

UPDATE Products
SET UnitsOnOrder = ReorderLevel
WHERE UnitsOnOrder = 0

--09. Products: Bei allen Produkten die günstiger als 20 sind, den Preis um 5% erhöhen

UPDATE Products
SET UnitPrice = UnitPrice * 1.05
WHERE UnitPrice < 20

--10. Categories: Eine neue Kategorie einfügen: Name ist "Literature", Beschreibung ist "Books and Magazines", kein Bild

INSERT INTO Categories(CategoryName, Description, Picture) VALUES ('Literature', 'Books and Magazines', NULL)

--INSERT INTO Categories VALUES ('Literature', 'Books and Magazines', NULL)
--INSERT INTO Categories(CategoryName, Description) VALUES ('Literature', 'Books and Magazines')