/*
	TabelleFunktion
*/

CREATE OR ALTER FUNCTION 
GetModeleByShow (@PrezId int)
RETURNS @ModeleByShow table 
(M_ID int, Vor_Name varchar(20), Nach_Name varchar(20))
AS
BEGIN
INSERT INTO @ModeleByShow
SELECT DISTINCT M.M_ID,M.Vor_Name,M.Nach_Name
FROM Modele M  
INNER JOIN Runway R
ON R.M_ID = M.M_ID
INNER JOIN Prezentari P
ON R.Prez_ID = P.Prez_ID
WHERE P.Prez_ID = @PrezId
IF @@ROWCOUNT = 0
BEGIN
INSERT INTO @ModeleByShow
VALUES ('','Keine Modele gefunden','')
END
RETURN 
END
GO

select * from 
GetModeleByShow(3)

---------------------CURSOR
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
