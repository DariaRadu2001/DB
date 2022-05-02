--Ub3
DROP TABLE Logtabelle

CREATE TABLE Logtabelle
(
Datum DATE,
Zeit TIME,
Typ VARCHAR(10),
Name VARCHAR(20),
Anzahl INT
)

CREATE TABLE Sate
(
Id INT,
Name VARCHAR(30),
Anzahl_Bewohner INT,
PRIMARY KEY(Id)
)



CREATE OR ALTER TRIGGER DMLSate
ON Sate
AFTER insert,update,delete
AS
BEGIN
	DECLARE @rows INT
	SELECT @rows = @@ROWCOUNT
	SET NOCOUNT ON
	DECLARE @typ VARCHAR(30)
	IF EXISTS(SELECT * FROM inserted)
		BEGIN
			IF EXISTS(SELECT * FROM deleted)
				SELECT @typ = 'update'
			ELSE
				SELECT @typ = 'insert'
		END
	ELSE
		IF EXISTS(SELECT * FROM deleted)
			SELECT @typ = 'delete'
		ELSE
			SELECT @typ = 'eroare'

	INSERT INTO Logtabelle(Datum,Zeit,Typ,Name,Anzahl)
	VALUES(GETDATE(),CONVERT(TIME,GETDATE()),@typ,'Sate',@rows)
END

INSERT INTO Sate
VALUES(1,'Rasinari',7000),(4,'Sacel',2000),(5,'Mag',1000),(6,'Orlat',3000)

DELETE FROM Sate
WHERE Id = 1

UPDATE Sate
SET Anzahl_Bewohner = Anzahl_Bewohner + 10
WHERE Name = 'Sacel' OR Name = 'Orlat'

SELECT * FROM Logtabelle
SELECT * FROM Sate

DELETE FROM Logtabelle


------------------------------------------------------------------------------------------------------Ub4
CREATE TABLE Bewohner
(CNP INT,
Vorname Varchar(30),
Nachname Varchar(30),
Grosse INT,
Haarfarbe Varchar(30),
GebDatum Date,
Stadt Varchar(30),
Land Varchar(30),
PRIMARY KEY(CNP))

INSERT INTO Bewohner
VALUES('123','Daria','Radu','160','schwarz','2001/08/20','Cluj','Rumanien'),
('124','Oana','Badiu','175','braun','2002/03/18','Wien','Osterreich'),
('125','Eric','Iambor','186','schwarz','2001/12/28','Munchen','Deutschland'),
('126','Ale','Stoica','158','blond','2001/10/31','Sibiu','Rumanien'),
('127','Daria','Mihaila','159','hellbraun','2002/03/18','Dortmund','Deutschland')


DELETE FROM Bewohner


SELECT * FROM Bewohner
-----------------------------------------------------------
DECLARE 
@CNP INT,
@Gebdatum Date,
@Stadt Varchar(30),
@Land VARCHAR(30)
DECLARE cursorBewohner CURSOR FOR 
SELECT CNP, GebDatum, Stadt, Land FROM Bewohner
FOR UPDATE OF Stadt, Land
OPEN cursorBewohner
FETCH cursorBewohner INTO @CNP, @Gebdatum, @Stadt, @Land
WHILE @@FETCH_STATUS = 0 
BEGIN 
	DECLARE @alter INT
	SET @alter = dbo.getAge(@Gebdatum)
	
	exec change @CNP,@Gebdatum,@Stadt,@Land,@alter

FETCH cursorBewohner INTO @CNP, @Gebdatum, @Stadt, @Land
END 
CLOSE cursorBewohner
DEALLOCATE cursorBewohner
-----------------------------------------------------------
SELECT * FROM Bewohner



CREATE OR ALTER FUNCTION getAge(@Gebdatum DATE)
RETURNS INT
AS 
BEGIN
	DECLARE @ALTER INT
	DECLARE @heutigeDatum DATE
	SELECT @heutigeDatum = CURRENT_TIMESTAMP
	SELECT @ALTER = DATEDIFF(year, @Gebdatum, @heutigeDatum)

	RETURN @ALTER
END

CREATE OR ALTER PROCEDURE change(@CNP INT, @Gebdatum DATE, @Stadt VARCHAR(30), @Land VARCHAR(30), @alter INT)
AS
BEGIN
	IF(@alter >= 20)
	BEGIN
		PRINT('Bewohner ' + CONVERT(VARCHAR(4),@CNP) + ' ist grosser gleich als 20')
		IF @Land in ('Rumanien','Osterreich')
			BEGIN
				UPDATE Bewohner
				SET Land = 'Deutschland', Stadt = 'Berlin'
				WHERE CNP = @CNP
			END
		ELSE
			BEGIN
				UPDATE Bewohner
				SET Land = 'Schwizerland', Stadt = 'Zurich'
				WHERE CNP = @CNP
			END

	END
END
GO
