CREATE FUNCTION dbo.SEPARACAO(@frase       VARCHAR(MAX),
							  @delimitador VARCHAR(MAX) = ',')

RETURNS @partes TABLE (item      VARCHAR(MAX),
                       sequencia INTEGER)

BEGIN
  DECLARE @parte     VARCHAR(MAX)
  DECLARE @sequencia INTEGER

  SET @sequencia = 0;

  WHILE CHARINDEX(@delimitador, @frase, 0) <> 0
  BEGIN
    SET @parte = SUBSTRING(@frase, 1, CHARINDEX(@delimitador, @frase, 0) - 1);
    SET @frase = SUBSTRING(@frase, CHARINDEX(@delimitador, @frase, 0) + LEN(REPLACE(@delimitador, ' ', '_')), LEN(@frase));

    IF LEN(@parte) > 0
    BEGIN
      INSERT INTO @partes(item, sequencia)
      VALUES(@parte, @sequencia + 1);

      SET @sequencia = @sequencia + 1;
    END;
  END;

  IF LEN(@frase) > 0
  BEGIN
    INSERT INTO @partes(item, sequencia)
    VALUES(@frase, @sequencia + 1);
  END;

  RETURN;
END;
go