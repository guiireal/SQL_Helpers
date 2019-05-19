ALTER FUNCTION dbo.PrimeiraLetra (@String VARCHAR(Max))
RETURNS VARCHAR(Max)
BEGIN
	DECLARE @Xml XML
	DECLARE @firstletter VARCHAR(3)
	DECLARE @delimiter VARCHAR(3)
 
	SET @delimiter=' '
	SET @Xml = CAST(('<a>'+REPLACE(@String, @delimiter, '</a><a>')+'</a>') AS XML)
 
	;With CTE AS (SELECT A.value('.', 'varchar(3)') AS [Column]
	FROM @Xml.nodes('a') AS FN(a) )
	SELECT @firstletter = STUFF((SELECT '' + LEFT([Column], 1)
	FROM CTE
	FOR XML PATH ('')), 1, 0, '')
 
	RETURN (@firstletter)
END
GO


