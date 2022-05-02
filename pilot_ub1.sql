Create Table Zugtypen
(
	ID_Zugtyp INT,
	Beschreibung VARCHAR(50),
	PRIMARY KEY(ID_Zugtyp)
)

Create Table Zuge
(
	ID_Zug INT,
	Name VARCHAR(100),
	ID_Zugtyp INT,
	PRIMARY KEY(ID_Zug),
	CONSTRAINT FK_Zug_Zugtyp FOREIGN KEY(ID_Zugtyp) REFERENCES Zugtypen
)

Create Table Bahnhof
(
	ID_Bahnhof INT,
	Name VARCHAR(50),
	PRIMARY KEY(ID_Bahnhof)
)

Create Table Route_Bahnhof
(
	ID_Route_Bahnhof INT,
	ID_Bahnhof INT,
	Ankunfszeit TIME(0),
	Abfahrtszeit TIME(0),
	PRIMARY KEY(ID_Route_Bahnhof),
	CONSTRAINT FK_Route_Bahnhof_MM FOREIGN KEY(ID_Bahnhof) REFERENCES Bahnhof
)

Create Table Routen
(
	ID_Route INT,
	Name VARCHAR(50),
	ID_Zug INT,
	ID_Route_Bahnhof INT,
	PRIMARY KEY(ID_Route),
	CONSTRAINT FK_Route_Bahnhof FOREIGN KEY(ID_Route_Bahnhof) REFERENCES Route_Bahnhof,
	FOREIGN KEY(ID_Zug) REFERENCES Zuge
)


INSERT INTO Zugtypen
VALUES (1,'rosu diesel'),(2,'albastru carbune')

INSERT INTO Zuge
VALUES (1,'Locomotiva',1),(2,'Acelerat',2)

INSERT INTO Bahnhof
VALUES (1,'Medias'),(2,'Copsa Mica')

INSERT INTO Route_Bahnhof
VALUES (1,1,'10:00:00','10:10:00'),(2,2,'13:50:00','13:55:00')

INSERT INTO Routen
VALUES (1,'Sibiu-Medias',1,2),(2,'Sibiu-Sighisoara',2,1)

CREATE OR ALTER PROCEDURE neue_route(@ID_Route INT, @ID_Bahnhof INT, @Ankunfszeit TIME(0), @Abfahrtszeit TIME(0))
AS
BEGIN
	DECLARE @sql VARCHAR(MAX)
	DECLARE @bahnhof INT
	SELECT @bahnhof = @ID_Bahnhof
	FROM Routen
	WHERE ID_Route = @ID_Route

	IF @bahnhof = @ID_Bahnhof
		BEGIN
			UPDATE Route_Bahnhof
			SET Ankunfszeit = @Ankunfszeit,
			Abfahrtszeit = @Abfahrtszeit
			WHERE ID_Bahnhof = @ID_Bahnhof 
		END
	ELSE
		BEGIN
			INSERT INTO Route_Bahnhof
			VALUES(@ID_Bahnhof, @Ankunfszeit, @Abfahrtszeit)
			
		END

END
GO

