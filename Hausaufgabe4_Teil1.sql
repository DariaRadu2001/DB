--Ub1

--ich uberprufe, ob der Angestelte 16 Jahre alt ist und nicht grosser als 65
CREATE OR ALTER FUNCTION AlterValidation(@Datum Date)
RETURNS INT
AS 
BEGIN
	DECLARE @BOOL INT
	DECLARE @ALTER INT
	DECLARE @heutigeDatum DATE
	SELECT @heutigeDatum = CURRENT_TIMESTAMP
	SELECT @ALTER = DATEDIFF(year, @Datum, @heutigeDatum)

	IF @ALTER < 16 OR @ALTER > 65
		SET @BOOL = 0
	ELSE
		SET @BOOL = 1

	RETURN @BOOL
END

PRINT dbo.AlterValidation('2010/08/20')
PRINT dbo.AlterValidation('1950/08/20')
PRINT dbo.AlterValidation('2000/08/20')

CREATE OR ALTER FUNCTION DepValidation(@Departament VARCHAR(50))
RETURNS INT
AS 
BEGIN
	DECLARE @BOOL INT
	
	IF @Departament IN ('Design','Economic','Logistic','Curatenie','Manufactura')
		SET @BOOL = 1
	ELSE
		SET @BOOL = 0

	RETURN @BOOL
END

PRINT dbo.DepValidation('Design')
PRINT dbo.DepValidation('profesor')

CREATE OR ALTER FUNCTION CasaIDValidation(@C_ID INT)
RETURNS INT
AS 
BEGIN
	DECLARE @BOOL INT
	
	IF @C_ID IN (SELECT C_ID FROM Casa_de_moda)
		SET @BOOL = 1
	ELSE
		SET @BOOL = 0

	RETURN @BOOL
END

SELECT C_ID FROM Casa_de_moda
PRINT dbo.CasaIDValidation(1)
PRINT dbo.CasaIDValidation(100)

CREATE OR ALTER PROCEDURE EINFUGEN(@Name VARCHAR(20), @Geb_datum VARCHAR(20), @C_ID VARCHAR(20), @Ad_ID VARCHAR(20), @Departament VARCHAR(50))
AS
BEGIN
	DECLARE @sqlQuery AS VARCHAR(MAX)
	DECLARE @validAge AS INT
	DECLARE @validDep AS INT
	DECLARE @validCasa AS INT
	SET @validAge = dbo.AlterValidation(CONVERT(DATE,@Geb_datum))
	SET @validDep = dbo.DepValidation(@Departament)
	SET @validCasa = dbo.CasaIDValidation(CONVERT(INT,@C_ID))
	print(@validAge)
	print(@validDep)
	print(@validCasa)
	IF @validAge = 1 AND @validDep = 1 AND @validCasa = 1
		BEGIN
			SET @sqlQuery = 
			'INSERT INTO Angajati(Name, Geb_datum, C_ID, Ad_ID, Departament)
			 VALUES(' +''''+@Name+''''+','+''''+@Geb_datum+''''+','+''''+@C_ID+''''+','+''''+@Ad_ID+''''+','+''''+@Departament+''''+')'
		END	 
	ELSE
		BEGIN
			SET @sqlQuery = 'RAISERROR(''Sie haben falsche Daten eingefugt --> Das Tupel wurde nicht eingetragt'',10,1)'
		END
	--PRINT(@sqlQuery)
	EXEC(@sqlQuery)
END
GO

EXEC EINFUGEN 'ana','2010/08/20','1','1','eConomic' -- nu merge de la varsta
EXEC EINFUGEN 'daria','2010/08/20','1','1','eonomic' -- nu merge de la varsta + departament
EXEC EINFUGEN 'ria','2000/08/20','100','1','design' -- nu merge de la casa de moda
EXEC EINFUGEN 'carria','1940/08/20','19','1','desi' -- nu merge de la tot
EXEC EINFUGEN 'Elena Maria','2000/10/20','1','2','design' --merge

SELECT *
FROM Angajati

--Ub2
--View, das alle gekaufte Produkte von einer Rechnung gibt
CREATE OR ALTER VIEW ProdusPeFacutura AS 
SELECT P.P_ID, P.Nume
FROM  Produse P
INNER JOIN Cumparaturi C 
ON C.P_ID = P.P_ID
INNER JOIN Factura F
ON F.F_ID = C.F_ID
WHERE F.F_ID = 2


--Tabellenwertfunktion, gibt eine Tabelle mit alle 
CREATE OR ALTER FUNCTION 
GetProdusByMat (@Material VARCHAR(50))
RETURNS @ProdusByMat TABLE 
(P_ID INT, Nume VARCHAR(50))
AS
BEGIN
	INSERT INTO @ProdusByMat
	SELECT DISTINCT P.P_ID, P.Nume
	FROM Produse P  
	INNER JOIN Fabricatie F
	ON P.P_ID = F.P_ID
	INNER JOIN Materiale M
	ON M.M_ID = F.M_ID
	WHERE M.Nume = @Material
	IF @@ROWCOUNT = 0
		BEGIN
			INSERT INTO @ProdusByMat
			VALUES ('','Keine Produkte aus dem Stoff gefunden')
		END
	RETURN 
END
GO

--gibt mir die Produkte aus einer Rechnung die aus einem bestimmten Stoff erledigt sind
SELECT PF.P_ID AS ID, PF.Nume AS NUME_PRODUS
FROM ProdusPeFacutura PF
INNER JOIN GetProdusByMat('Denim') G
ON G.P_ID = PF.P_ID


select * from 
GetProdusByMat('Denim')

select * from 
Produse

select * from 
Materiale

select * from 
Fabricatie
