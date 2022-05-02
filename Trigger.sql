CREATE TABLE Artikel
(
Id INT,
Titel VARCHAR(30),
Journal VARCHAR(30),
ISSUE INT,
JAHR INT,
ANFANGSSEITE INT,
EndSeite INT,
PRIMARY KEY(Id)
)

--E BN ACUM
CREATE OR ALTER TRIGGER insertArtikel
ON Artikel
INSTEAD OF INSERT
AS
BEGIN
	SET NOCOUNT ON;
		INSERT INTO Artikel(Id,Titel,Journal,ISSUE,JAHR,ANFANGSSEITE,EndSeite)
		SELECT *
		FROM inserted
		WHERE (EndSeite - ANFANGSSEITE + 1) < 20
END

SELECT *
FROM Artikel

INSERT INTO Artikel
Values(6, 'Artikel 1', 'Scie', 3, 2000, 30, 330),(7, 'Artikel 1', 'Scie', 3, 2000, 30, 33)

DROP TRIGGER insertArtikel

ALTER TABLE Artikel
ADD CONSTRAINT insertArtikel
CHECK ((EndSeite - ANFANGSSEITE + 1)<20)

ALTER TABLE Artikel
DROP CONSTRAINT insertArtikel