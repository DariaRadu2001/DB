CREATE OR ALTER PROCEDURE roll_back(@Version INT)
AS
BEGIN
	DECLARE @procedura AS VARCHAR(50)
	DECLARE @current_version AS INT
	DECLARE @sqlQuery AS VARCHAR(MAX)	
	DECLARE @Tabel AS VARCHAR(50)
	DECLARE @Tabel2 AS VARCHAR(50)
	DECLARE @Coloana AS VARCHAR(50)
	DECLARE @TypColoana AS VARCHAR(50)
	DECLARE @AltesTyp AS VARCHAR(50)
	DECLARE @Nume AS VARCHAR(50)
	DECLARE @ValoareConstraint AS VARCHAR(50)

	SELECT @current_version = Idx 
	FROM crtVersion

	--fac rollback
	WHILE(@current_version > @Version)
		BEGIN
			SELECT @procedura = Procedura
			FROM Versionen 
			WHERE Idx = @current_version

			PRINT(@current_version)

			IF @procedura = 'neuesTabele'
				BEGIN
				SELECT @Tabel = Tabel
				FROM Versionen 
				WHERE Idx = @current_version
				SET @sqlQuery = 'EXEC dropTabele '+''''+@Tabel+''''
				PRINT(@sqlQuery)
				EXEC(@sqlQuery)

				END

			IF @procedura = 'neueSpalte'
				BEGIN
				SELECT @Tabel = Tabel
				FROM Versionen 
				WHERE Idx = @current_version

				SELECT @Coloana = Coloana
				FROM Versionen 
				WHERE Idx = @current_version

				SET @sqlQuery = 'EXEC dropSpalte '+''''+@Tabel+''''+','+''''+@Coloana+''''
				PRINT(@sqlQuery)
				EXEC(@sqlQuery)

				END

			IF @procedura = 'anderesTyp'
				BEGIN
				SELECT @Tabel = Tabel
				FROM Versionen 
				WHERE Idx = @current_version

				SELECT @Coloana = Coloana
				FROM Versionen 
				WHERE Idx = @current_version

				SELECT @AltesTyp = AltesTyp
				FROM Versionen 
				WHERE Idx = @current_version

				SET @sqlQuery = 'EXEC altesTyp '+''''+@Tabel+''''+','+''''+@Coloana+''''+','+''''+@AltesTyp+''''
				PRINT(@sqlQuery)
				EXEC(@sqlQuery)

				END

			IF @procedura = 'defaultConstraint'
				BEGIN
				SELECT @Tabel = Tabel
				FROM Versionen 
				WHERE Idx = @current_version

				SELECT @Nume = Nume
				FROM Versionen 
				WHERE Idx = @current_version

				SET @sqlQuery = 'EXEC noConstraint '+''''+@Tabel+''''+','+''''+@Nume+''''
				PRINT(@sqlQuery)
				EXEC(@sqlQuery)

				END

			IF @procedura = 'integritatsregel'
				BEGIN
				SELECT @Tabel = Tabel
				FROM Versionen 
				WHERE Idx = @current_version

				SELECT @Tabel2 = Tabel2
				FROM Versionen 
				WHERE Idx = @current_version

				SET @sqlQuery = 'EXEC dropIntegritatsregel '+''''+@Tabel+''''+','+''''+@Tabel2+''''
				PRINT(@sqlQuery)
				EXEC(@sqlQuery)


				END

				UPDATE crtVersion
				SET idx = @current_version - 1

				SELECT @current_version = Idx 
				FROM crtVersion

			
		END


	WHILE(@current_version < @Version)
		BEGIN
			SELECT @procedura = Procedura
			FROM Versionen 
			WHERE Idx = @current_version + 1

			PRINT(@current_version + 1)

			IF @procedura = 'neuesTabele'
				BEGIN
				SELECT @Tabel = Tabel
				FROM Versionen 
				WHERE Idx = @current_version + 1

				SELECT @Coloana = Coloana
				FROM Versionen 
				WHERE Idx = @current_version + 1

				SELECT @TypColoana = TypColoana
				FROM Versionen 
				WHERE Idx = @current_version + 1

				SET @sqlQuery = 'EXEC neuesTabele '+''''+@Tabel+''''+','+''''+@Coloana+''''+','+''''+@TypColoana+''''+',''FALSE'''
				PRINT(@sqlQuery)
				EXEC(@sqlQuery)

				END

			IF @procedura = 'neueSpalte'
				BEGIN
				SELECT @Tabel = Tabel
				FROM Versionen 
				WHERE Idx = @current_version + 1

				SELECT @Coloana = Coloana
				FROM Versionen 
				WHERE Idx = @current_version + 1

				SELECT @TypColoana = TypColoana
				FROM Versionen 
				WHERE Idx = @current_version + 1

				SET @sqlQuery = 'EXEC neueSpalte '+''''+@Tabel+''''+','+''''+@Coloana+''''+','+''''+@TypColoana+''''+',''FALSE'''
				PRINT(@sqlQuery)
				EXEC(@sqlQuery)

				END

			IF @procedura = 'anderesTyp'
				BEGIN
				SELECT @Tabel = Tabel
				FROM Versionen 
				WHERE Idx = @current_version + 1

				SELECT @Coloana = Coloana
				FROM Versionen 
				WHERE Idx = @current_version + 1

				SELECT @TypColoana = TypColoana
				FROM Versionen 
				WHERE Idx = @current_version + 1

				SET @sqlQuery = 'EXEC anderesTyp '+''''+@Tabel+''''+','+''''+@Coloana+''''+','+''''+@TypColoana+''''+',''FALSE'''
				PRINT(@sqlQuery)
				EXEC(@sqlQuery)

				END

			IF @procedura = 'defaultConstraint'
				BEGIN
				SELECT @Tabel = Tabel
				FROM Versionen 
				WHERE Idx = @current_version + 1

				SELECT @Nume = Nume
				FROM Versionen 
				WHERE Idx = @current_version + 1

				SELECT @ValoareConstraint = ValoareConstraint
				FROM Versionen 
				WHERE Idx = @current_version + 1

				SELECT @Coloana = Coloana
				FROM Versionen 
				WHERE Idx = @current_version + 1

				SELECT @TypColoana = TypColoana
				FROM Versionen 
				WHERE Idx = @current_version + 1

				SET @sqlQuery = 'EXEC defaultConstraint '+''''+@Tabel+''''+','+''''+@Nume+''''+','+''''+@ValoareConstraint+''''+','+''''+@Coloana+''''+','+''''+@TypColoana+''''+',''FALSE'''
				PRINT(@sqlQuery)
				EXEC(@sqlQuery)

				END

			IF @procedura = 'integritatsregel'
				BEGIN
				SELECT @Tabel = Tabel
				FROM Versionen 
				WHERE Idx = @current_version + 1

				SELECT @Tabel2 = Tabel2
				FROM Versionen 
				WHERE Idx = @current_version + 1

				SELECT @Coloana = Coloana
				FROM Versionen 
				WHERE Idx = @current_version + 1

				SET @sqlQuery = 'EXEC integritatsregel '+''''+@Tabel+''''+','+''''+@Tabel2+''''+','+''''+@Coloana+''''+',''FALSE'''
				PRINT(@sqlQuery)
				EXEC(@sqlQuery)


				END
				
				UPDATE crtVersion
				SET idx = @current_version + 1

				SELECT @current_version = Idx 
				FROM crtVersion

			
		END
	END
GO

