CREATE TABLE Ta
(
idA INT IDENTITY(1,1),
a2 INT,
a3 INT,
UNIQUE(a2),
PRIMARY KEY(idA)
)

CREATE TABLE Tb
(
idB INT IDENTITY(1,1),
b2 INT,
b3 INT,
PRIMARY KEY(idB)
)

CREATE TABLE Tc
(
idC INT IDENTITY(1,1),
idA INT,
idB INT,
c2 INT,
PRIMARY KEY(idC),
CONSTRAINT FK_Tc_Ta FOREIGN KEY (idA) 
REFERENCES Ta,
FOREIGN KEY (idB) REFERENCES Tb
)


DROP TABLE Tc
DROP TABLE Ta
DROP TABLE Tb


SELECT * FROM  Ta
SELECT * FROM  Tb 
SELECT * FROM  Tc 

CREATE OR ALTER PROCEDURE addInto
AS
BEGIN

	DECLARE @a2 AS INT
	SET @a2 = 1
	WHILE @a2 <= 10000
		BEGIN
			INSERT INTO Ta
			VALUES(@a2,@a2)
			SET @a2 = @a2 + 1;
		END

	DECLARE @ct AS INT
	DECLARE @b3 AS INT
	SET @ct = 0
	SET @b3 = 3000
	WHILE @ct < 3000
		BEGIN
			INSERT INTO Tb
			VALUES(FLOOR(RAND()*(1000-1+1))+1, @b3)
			SET @ct = @ct + 1
			SET @b3 = @b3 - 1
		END
	
	DECLARE @a2_c AS INT
	DECLARE @b2_c AS INT
	DECLARE @ct_c AS INT
	SET @ct_c = 0
	WHILE @ct_c < 30000
		BEGIN
			SELECT @a2_c = idA
			FROM Ta
			ORDER BY NEWID()

			SELECT @b2_c = idB
			FROM Tb
			ORDER BY NEWID()

			INSERT INTO Tc
			VALUES(@a2_c, @b2_c,@ct_c)

			SET @ct_c = @ct_c + 1
		END
END
GO

EXEC addInto

SELECT COUNT(*) AS Anzahl_Tupels_Ta FROM Ta 
SELECT COUNT(*) AS Anzahl_Tupels_Tb FROM Tb
SELECT COUNT(*) AS Anzahl_Tupels_Tc FROM Tc
