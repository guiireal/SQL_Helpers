CREATE FUNCTION [dbo].[DIVIDIR_STRING] (@String VARCHAR(255), 
									    @Separador VARCHAR(255), 
	                                    @PosBusca INT) 
RETURNS VARCHAR(255) AS 
BEGIN
    DECLARE @Index int, @Max int, @Retorno VARCHAR(255)
    DECLARE @Partes as TABLE (Id_Parte INT IDENTITY(1,1), Texto VARCHAR(255))
    SET @Index = CHARINDEX(@Separador,@String)

    WHILE (@Index > 0) BEGIN    
        INSERT INTO @Partes SELECT SUBSTRING(@String,1,@Index-1)
        SET @String = RTRIM(LTRIM(SUBSTRING(@String, @Index + LEN(@Separador), LEN(@String))))
        SET @Index = CHARINDEX(@Separador, @String)
    END

    IF (@String != '') INSERT INTO @Partes SELECT @String
        SELECT @Max = COUNT(*) FROM @Partes
    IF (@PosBusca = 0) 
	    SET @Retorno = CAST(@Max AS VARCHAR(5))
    IF (@PosBusca < 0) 
	    SET @PosBusca = @Max + 1 + @PosBusca
    IF (@PosBusca > 0) 
	    SELECT @Retorno = Texto FROM @Partes WHERE Id_Parte = @PosBusca
    RETURN RTRIM(LTRIM(@Retorno))
END
GO
