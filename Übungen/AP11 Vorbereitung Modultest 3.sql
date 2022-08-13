--01: Die 20 Bestellungen mit der höchsten Fracht aus 1997

--02: Produktliste (Produkt ID, Produktname, Preis, Kategoriename) aller Produkte die noch geführt werden (also nicht Discontinued), sortiert nach Kategorie- und Produktname

--03: Eine View von Bestelldetails: Bestellnr., Kundenname, Bestelldatum, Versanddatum, Name Versandunternehmen, Name Mitarbeiter, Fracht; aus der View einmal alle Daten abrufen

--04: Anzahl der Bestellungen über 50 Fracht, je Jahr und Monat, sortiert nach Jahr und Monat

--05: Liste aller Kategorien (Kategoriename), inklusive der Anzahl der Produkte

--06: Eine Funktion, die alle Bestellungen in ein bestimmtes Land innerhalb eines gewissen Jahr und Monats auflistet; mit Hilfe der Funktion einmal Daten für die USA vom März 1997 abrufen

--07: Liste der 5 Kunden (Kundenname, Land) mit den meisten Bestellungen 1997

--08: Eine Liste der Produkte (Name), die im Dezember 1996 bestellt wurden

--09: Eine View von Kategoriestatistiken: KategorieId, KategorieName, Anzahl Produkte gesamt, Anzahl Stück Lagernd, Anzahl Stück in Nachbestellung; aus der View einmal alle Daten abrufen

--10: Eine Liste aller Bestellungen (Id und Datum), inklusive dem Gesamtwert der Bestellung (OrderId, Gesamtwert; Gesamtwert = Stückpreis mal Anzahl - Rabatt), absteigend sortiert nach dem Gesamtert

--11: Liste der Mitarbeiter inkl. dem jeweililgen Gesamtumsatz aus dem Jahr 1996 (Vorname, Nachname, Gesamtumstaz), sortiert nach Nachname und Vorname

--12: Eine Funktion, die alle Produkte aus einer bestimmten Kategorie (Kategoriename) liefert, deren preis zwischen einem Mindest- und Maximalpreis liegt; mit Hilfe der Funktion einmal Daten für Beverages abrufen, die zwischen 30 und 50 kosten

--13: Liste jener Kunden, deren Gesamtumsatz aus 1997 über 15000 liegt (Kundenname, Umsatz)

--14: Liste jener Employees (Vorname, Nachname), die 1998 Bestellungen sowohl nach Argentinien (Argentina) als auch nach Brasilien (Brazil) bearbeitet haben

--15: Eine Funktion, die von einem Produkt (über die ProduktId) bestimmt, ob es nachbestellt werden soll oder nicht; ein Produkt soll nachbestellt werden, wenn die unitsinstock kleiner sind als das reorderlevel, es nicht discontinued ist, und nicht schon unitsonorder sind; Aufrufen der Funktion für das Produkt mit der Id 30