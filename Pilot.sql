--UB1 --create
Create Table Zugtyp
(
ID_Zugtyp INT IDENTITY(1,1),
Beschreibung Varchar(100),
Primary Key(ID_Zugtyp)
)

Create Table Zug
(
ID_Zug INT IDENTITY(1,1),
ID_Zugtyp INT,
Name Varchar(50),
Primary Key(ID_Zug),
Constraint FK_Typ_Zug Foreign Key(ID_Zugtyp) References Zugtyp
)

Create Table Bahnhof
(
ID_Bahnhof INT IDENTITY(1,1),
Name Varchar(50),
Primary Key(ID_Bahnhof)
)

Create Table Routen
(
ID_Route INT IDENTITY(1,1),
ID_Zug INT,
Name Varchar(50),
Primary Key(ID_Route),
Constraint FK_Route_Zug Foreign Key(ID_Zug) References Zug
)

CREATE Table Route_Bahnhof
(
ID_Route INT,
ID_Bahnhof INT,
Ankunfszeit TIME(0),
Abfartszeit TIME(0),
Primary Key(ID_Route, ID_Bahnhof),
Constraint FK_Route_Bahnhofe Foreign Key(ID_Route) References Routen,
							 Foreign Key(ID_Bahnhof) References Bahnhof
)

DROP TABLE Route_Bahnhof
DROP TABLE Routen
DROP TABLE Bahnhof
DROP TABLE Zug
DROP TABLE Zugtyp

--UB2 --procedure
CREATE OR ALTER PROCEDURE neueRoute(@ID_Route INT, @ID_Bahnhof INT, @Ankunfszeit TIME(0), @Abfartszeit TIME(0))
AS
BEGIN
	IF EXISTS(SELECT ID_Route, ID_Bahnhof
			FROM Route_Bahnhof
			WHERE ID_Route = @ID_Route And ID_Bahnhof = @ID_Bahnhof)
			BEGIN
				UPDATE Route_Bahnhof
				SET Ankunfszeit = @Ankunfszeit, Abfartszeit = @Abfartszeit
				WHERE ID_Route = @ID_Route And ID_Bahnhof = @ID_Bahnhof
			END

	ELSE
	    BEGIN
			INSERT INTO Route_Bahnhof
			VALUES(@ID_Route, @ID_Bahnhof, @Ankunfszeit, @Abfartszeit)
		END

END
GO
--situatie cand avem Bahnfoful in routa
SELECT * FROM Route_Bahnhof
EXEC neueRoute '1','1','14:30:00','15:00:00'

--Insert
SELECT * FROM Route_Bahnhof
EXEC neueRoute '4','1','23:30:00','23:40:00'
SELECT * FROM Route_Bahnhof

--UB3 14.50 -- function
CREATE OR ALTER FUNCTION AnzahlZuge(@Time TIME(0))
RETURNS @tableBahnhofe table (ID_Bahnhof INT)
AS
BEGIN
	INSERT INTO @tableBahnhofe
	SELECT ID_Bahnhof
	FROM Route_Bahnhof 
	WHERE @Time >= Ankunfszeit AND @Time <= Abfartszeit
	GROUP BY ID_Bahnhof
	HAVING COUNT(*)>1
	RETURN
END
GO
SELECT * FROM Route_Bahnhof
SELECT * FROM dbo.AnzahlZuge('14:50:00') --1,2
SELECT * FROM dbo.AnzahlZuge('17:40:00') --nimic

--UB4 --view
CREATE VIEW wenigsteBahnhofe
AS
	SELECT TOP(1) WITH TIES ID_Route
	FROM Route_Bahnhof
	GROUP BY ID_Route
	HAVING COUNT(*)<=5 
	ORDER BY COUNT(*) ASC

GO
DROP VIEW wenigsteBahnhofe
SELECT * from wenigsteBahnhofe

--UB5 --view+Function
CREATE OR ALTER FUNCTION NRBahnhofe()
Returns INT
AS
	Begin
	Declare @nr int
	SELECT @nr = count(*)
	from Bahnhof
	return @nr
	end
go
print dbo.NRBahnhofe()

Create or Alter View AlleRouten
AS
	Select Distinct R.Name
	From Routen R
	Inner Join Route_Bahnhof RB
	on R.ID_Route = RB.ID_Route
	INNER JOIN Bahnhof B
	ON RB.ID_Bahnhof = B.ID_Bahnhof
	Group by R.ID_Route, R.Name
	having count(*) = dbo.NRBahnhofe()
Go

SELECT * from AlleRouten

--UB6 --cursor
DECLARE 
@ID_Route INT,
@ID_Bahnhof INT,
@ID_Zug INT,
@Name_Bahnhof Varchar(50),
@Ankunfszeit TIME(0),
@Abfartszeit TIME(0)
DECLARE cursorZug CURSOR FOR 
SELECT ID_Route, ID_Bahnhof, Ankunfszeit, Abfartszeit FROM Route_Bahnhof
FOR READ ONLY
OPEN cursorZug
FETCH cursorZug INTO @ID_Route,@ID_Bahnhof,@Ankunfszeit,@Abfartszeit 
WHILE @@FETCH_STATUS = 0 
BEGIN 
	SELECT @Name_Bahnhof = Name
	from Bahnhof
	WHERE ID_Bahnhof = @ID_Bahnhof
	
	SELECT @ID_Zug = ID_Zug
	from Routen
	WHERE ID_Route = @ID_Route
	DECLARE @sql VARCHAR(MAX)

	PRINT ' '+ CAST(@ID_Zug AS VARCHAR) +' kommt in dem Bahnhof ' + CAST(@Name_Bahnhof AS VARCHAR) +' um ' + CAST(@Ankunfszeit AS VARCHAR) +' an und er verlässt den Bahnhof um ' + CAST(@Abfartszeit AS VARCHAR)

	if DATEDIFF(MINUTE, @Ankunfszeit, @Abfartszeit) >= 60
		BEGIN
			print 'Der Zug '+ CAST(@ID_Zug AS VARCHAR) +' bleibt mehr als eine Stunde in dem Bahnhof ' + CAST(@Name_Bahnhof AS VARCHAR)
		END
	

FETCH cursorZug INTO @ID_Route,@ID_Bahnhof,@Ankunfszeit,@Abfartszeit 
END 
CLOSE cursorZug
DEALLOCATE cursorZug


--UB7 --trigger
CREATE OR ALTER Trigger SM
on Route_Bahnhof
INSTEAD OF INSERT
AS
BEGIN
	SET NOCOUNT ON;
	Declare @Time1 Time
	Declare @Time2 Time
	set @Time1 = '3:00:00'
	SET @Time1 = '5:00:00'
	DECLARE @Ankunf Time(0)
	DECLARE @Abfart Time(0)
	Select @Ankunf = Ankunfszeit ,@Abfart = Abfartszeit
	from inserted

	if (@Ankunf>'5:00:00.0' OR @Ankunf<'3:00:00.0') AND (@Abfart>'5:00:00.0' OR @Abfart<'3:00:00.0')
		begin
			insert into Route_Bahnhof
			SELECT *
			FROM inserted
			
		end

	else
		begin
			raiserror('nu',10,1)
		end
		
END

Select * from Route_Bahnhof

insert into Route_Bahnhof
Values('2','2','13:10:00','14:40:00')
