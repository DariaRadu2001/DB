/*
RAISERROR(mesaj, severity, state)
severity:	0–10 Informational messages
			11–18 Errors
			19–25 Fatal errors
state: 
		The state is an integer from 0 through 255. If you raise the same user-defined error at multiple locations, 
		you can use a unique state number for each location to make it easier to find which section of the code is causing the errors. 
		For most implementations, you can use 1.
*/

/*
INFORMATION_SCHEMA.TABLES
The INFORMATION_SCHEMA.TABLES view allows you to get information about all tables and views within a database.
By default it will show you this information for every single table and view that is in the database.
Explanation
This view can be called from any of the databases in an instance of SQL Server and will return the results for the data within that particular database.
*/

/*
INFORMATION_SCHEMA.COLUMNS
The INFORMATION_SCHEMA.COLUMNS view allows you to get information about all columns for all tables and views within a database.
By default it will show you this information for every single table and view that is in the database.
*/

/*
1.
den Typ einer Spalte (Attribut) ändert (modify type of column)

*/

CREATE OR ALTER PROCEDURE anderesTyp(@Tabele VARCHAR(20) , @Spalte VARCHAR(20), @Typ VARCHAR(20), @Bool VARCHAR(10))
AS
BEGIN
	IF @Bool = 'TRUE'
	BEGIN
		DECLARE @altesTyp AS VARCHAR(MAX)
		SELECT @altesTyp = DATA_TYPE 
						FROM INFORMATION_SCHEMA.COLUMNS
						WHERE 
						TABLE_NAME = @Tabele AND COLUMN_NAME = @Spalte 
		DECLARE @lange AS VARCHAR(MAX)
		SELECT @lange = CHARACTER_MAXIMUM_LENGTH 
						FROM INFORMATION_SCHEMA.COLUMNS
						WHERE 
						TABLE_NAME = @Tabele AND COLUMN_NAME = @Spalte
		DECLARE @sqlQuery2 AS VARCHAR(MAX)
			
		SET @sqlQuery2 = 'INSERT INTO Versionen (Procedura,Tabel,Coloana,TypColoana,AltesTyp)
						VALUES(''anderesTyp'''+','+''''+@Tabele+''''+','+''''+@Spalte+''''+','+''''+@Typ+''''+','+ ''''+ @altesTyp + ''''+')'
		
		IF @lange > 0
		BEGIN	
			SET @sqlQuery2 = 'INSERT INTO Versionen (Procedura,Tabel,Coloana,TypColoana,AltesTyp)
							VALUES(''anderesTyp'''+','+''''+@Tabele+''''+','+''''+@Spalte+''''+','+''''+@Typ+''''+','+ ''''+ @altesTyp+'('+@lange+')'+ ''''+')'
		END

		PRINT(@sqlQuery2)
		EXEC(@sqlQuery2)

			UPDATE crtVersion
			SET crtVersion.idx = crtVersion.idx + 1
		
	END

	DECLARE @sqlQuery AS VARCHAR(MAX)
	SET @sqlQuery = 'ALTER TABLE '+ @Tabele + ' ALTER COLUMN ' + @Spalte +' '+ @Typ
	PRINT(@sqlQuery)
	EXEC(@sqlQuery)
	
END
GO

CREATE OR ALTER PROCEDURE altesTyp(@Tabele VARCHAR(20) , @Spalte VARCHAR(20), @Typ VARCHAR(20))
AS
BEGIN
	DECLARE @sqlQuery AS VARCHAR(MAX)
	SET @sqlQuery = 'ALTER TABLE '+ @Tabele + ' ALTER COLUMN ' + @Spalte +' '+ @Typ
	PRINT(@sqlQuery)
	EXEC(@sqlQuery)
END
GO



/*
2.
ein default Constraint erstellt
*/
CREATE OR ALTER PROCEDURE defaultConstraint(@Tabele VARCHAR(20) , @Name VARCHAR(20), @Value VARCHAR(20), @Spalte VARCHAR(20), @Typspalte VARCHAR(20), @Bool VARCHAR(10))
AS
BEGIN
	IF @Bool = 'TRUE'
		BEGIN
			DECLARE @sqlQuery2 AS VARCHAR(MAX)
			SET @sqlQuery2 = 'INSERT INTO Versionen (Procedura,Tabel,Coloana,Nume,ValoareConstraint,TypColoana)
							VALUES(''defaultConstraint'''+','+''''+@Tabele+''''+','+''''+@Spalte+''''+','+''''+@Name+''''+','+''''+@Value+''''+','+''''+@Typspalte+''''+')'
			PRINT(@sqlQuery2)
			EXEC(@sqlQuery2)
		
			UPDATE crtVersion
			SET crtVersion.idx = crtVersion.idx + 1

		END
	DECLARE @sqlQuery AS VARCHAR(MAX)
	SET @sqlQuery = 'ALTER TABLE ' + @Tabele + 
					' ADD CONSTRAINT ' + @Name+
					' DEFAULT ' + 'CONVERT('+@Typspalte+','+''''+@Value+''''+')' + ' FOR '+ @Spalte
	PRINT(@sqlQuery)
	EXEC(@sqlQuery)
END
GO

CREATE OR ALTER PROCEDURE noConstraint(@Tabele VARCHAR(20), @ConstraintName VARCHAR(20))
AS
BEGIN
	DECLARE @sqlQuery AS VARCHAR(MAX)
	SET @sqlQuery = 
		'BEGIN TRY  
			 ALTER TABLE '+ @Tabele +
			' DROP ' + @ConstraintName +    
		' END TRY  
		BEGIN CATCH  
			RAISERROR(''Keines Constraint'',10,1)
		END CATCH' 
	PRINT(@sqlQuery)
	EXEC(@sqlQuery)
END
GO

/*
3.
eine neue Tabelle erstellt (create table)
*/
CREATE OR ALTER PROCEDURE neuesTabele(@TabeleName VARCHAR(20) , @SpalteName VARCHAR(20), @Typ VARCHAR(20), @Bool VARCHAR(10))
AS
BEGIN
	IF @Bool = 'TRUE'
		BEGIN
			DECLARE @sqlQuery2 AS VARCHAR(MAX)
			SET @sqlQuery2 = 'INSERT INTO Versionen (Procedura,Tabel,Coloana,TypColoana)
				VALUES(''neuesTabele'''+','+''''+@TabeleName+''''+','+''''+@SpalteName+''''+','+''''+@Typ+''''+')'
			PRINT(@sqlQuery2)
			EXEC(@sqlQuery2)

			UPDATE crtVersion
			SET crtVersion.idx = crtVersion.idx + 1

		END

	DECLARE @sqlQuery AS VARCHAR(MAX)
	SET @sqlQuery = 'IF EXISTS (SELECT * 
					FROM INFORMATION_SCHEMA.TABLES
					WHERE TABLE_NAME = '+''''+@TabeleName+''''+')
					BEGIN
					RAISERROR(''Die Tabele existiert'',10,1)
					END
					ELSE CREATE TABLE '+ @TabeleName + '(' + @SpalteName +' '+ @Typ +',PRIMARY KEY ('+@SpalteName+'))';
	PRINT(@sqlQuery)
	EXEC(@sqlQuery)
END
GO



CREATE OR ALTER PROCEDURE dropTabele(@TabeleName VARCHAR(20))
AS
BEGIN
	DECLARE @sqlQuery AS VARCHAR(MAX)
	DECLARE @warnung AS VARCHAR(30)
	SET @sqlQuery = 'IF EXISTS (SELECT * 
					FROM INFORMATION_SCHEMA.TABLES
					WHERE TABLE_NAME = '+''''+@TabeleName+''''+')
					BEGIN
					DROP TABLE ' + @TabeleName +
					' END
					ELSE RAISERROR(''Keine Tabele'',10,1)'
	PRINT(@sqlQuery)
	EXEC(@sqlQuery)
END
GO

/*
4.
eine neue Spalte für eine Tabelle erstellt (add a column)
*/
CREATE OR ALTER PROCEDURE neueSpalte(@Tabele VARCHAR(20) , @SpalteName VARCHAR(20), @Typ VARCHAR(20), @Bool VARCHAR(10))
AS
BEGIN
	IF @Bool = 'TRUE'
		BEGIN
			DECLARE @sqlQuery2 AS VARCHAR(MAX)
			SET @sqlQuery2 = 'INSERT INTO Versionen (Procedura,Tabel,Coloana,TypColoana)
				VALUES(''neueSpalte'''+','+''''+@Tabele+''''+','+''''+@SpalteName+''''+','+''''+@Typ+''''+')'
			PRINT(@sqlQuery2)
			EXEC(@sqlQuery2)

			UPDATE crtVersion
			SET crtVersion.idx = crtVersion.idx + 1
		END

	DECLARE @sqlQuery AS VARCHAR(MAX)
	SET @sqlQuery = 
				'IF EXISTS (SELECT * 
				FROM INFORMATION_SCHEMA.COLUMNS
				WHERE table_name = '+ +''''+ @Tabele +'''' + ' AND ' + 'column_name = ' + ''''+ @SpalteName +''''+' )' 
				+ 'BEGIN
				RAISERROR(''Die Spalte existiert'', 10, 1)
				END
				ELSE 
				ALTER TABLE '+ @Tabele + ' ADD ' + @SpalteName +' '+@Typ
	PRINT(@sqlQuery)
	EXEC(@sqlQuery)
END
GO

CREATE OR ALTER PROCEDURE dropSpalte(@Tabele VARCHAR(20) , @SpalteName VARCHAR(20))
AS
BEGIN
	DECLARE @sqlQuery AS VARCHAR(MAX)
	DECLARE @warnung AS VARCHAR(30)
	SET @sqlQuery = 'IF EXISTS (SELECT * 
				FROM INFORMATION_SCHEMA.COLUMNS
				WHERE table_name = '+ +''''+ @Tabele +'''' + ' AND ' + 'column_name = ' + ''''+ @SpalteName +''''+' )' 
				+ 'BEGIN
				ALTER TABLE '+ @Tabele +
				' DROP COLUMN ' + @SpalteName+ 
				' END
				ELSE 
				RAISERROR(''Keine Spalte gefunden'', 10, 1)'
	PRINT(@sqlQuery)
	EXEC(@sqlQuery)
END
GO




/*
5.
eine Referenz-Integritätsregel erstellt (foreign key constraint)
*/
CREATE OR ALTER PROCEDURE integritatsregel(@Tabele VARCHAR(20), @Tabele2 VARCHAR(20), @Key VARCHAR(20), @Bool VARCHAR(10))
AS
BEGIN
	IF @Bool = 'TRUE'
		BEGIN
			DECLARE @sqlQuery2 AS VARCHAR(MAX)
			SET @sqlQuery2 = 'INSERT INTO Versionen (Procedura,Tabel,Tabel2,Coloana)
				VALUES(''integritatsregel'''+','+''''+@Tabele+''''+','+''''+@Tabele2+''''+','+''''+@Key+''''+')'
			PRINT(@sqlQuery2)
			EXEC(@sqlQuery2)

			UPDATE crtVersion
			SET crtVersion.idx = crtVersion.idx + 1
		END

	DECLARE @sqlQuery AS VARCHAR(MAX)
	SET @sqlQuery = 'BEGIN TRY 
					ALTER TABLE ' + @Tabele + ' ADD CONSTRAINT FK_' + @Tabele + @Tabele2 +
					' FOREIGN KEY (' + @Key + ') REFERENCES ' + @Tabele2 +
					' END TRY  
					BEGIN CATCH  
					RAISERROR(''Die Integritatsregel existiert'',10,1)
					END CATCH' 
	PRINT(@sqlQuery)
	EXEC(@sqlQuery)
END
GO

CREATE OR ALTER PROCEDURE dropIntegritatsregel(@Tabele VARCHAR(20), @Tabele2 VARCHAR(20))
AS
BEGIN
	DECLARE @sqlQuery AS VARCHAR(MAX)
	SET @sqlQuery = 'BEGIN TRY
					ALTER TABLE ' + @Tabele + ' DROP CONSTRAINT FK_' + @Tabele + @Tabele2 +
					' END TRY  
					BEGIN CATCH  
					RAISERROR(''Kein Integritatsregel'',10,1)
					END CATCH' 
	PRINT(@sqlQuery)
	EXEC(@sqlQuery)
END
GO

/*
SET @sqlQuery2 = 'INSERT INTO crtVersion (Idx)
							SELECT Idx
							FROM Versionen'
			EXEC(@sqlQuery2)
*/