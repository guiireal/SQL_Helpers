SELECT 'SELECT * FROM ' + TABELAS.Table_Name + ' WHERE ' + TABELAS.Column_Name + ' = ' + '''123504''' 
FROM
(
	SELECT T.name AS Table_Name ,
		   C.name AS Column_Name ,
		   P.name AS Data_Type ,
		   P.max_length AS Size ,
		   CAST(P.precision AS VARCHAR) + '/' + CAST(P.scale AS VARCHAR) AS Precision_Scale
	FROM   sys.objects AS T
		   JOIN sys.columns AS C ON T.object_id = C.object_id
		   JOIN sys.types AS P ON C.system_type_id = P.system_type_id
	WHERE C.name = 'Cd_empresa'
) AS TABELAS;


SELECT 'UPDATE ' + TABELAS.Table_Name + ' SET ' + TABELAS.Column_Name + ' = ' + '''123504'' WHERE ' + TABELAS.Column_Name + ' = ' + '''123504''' FROM
(
	SELECT T.name AS Table_Name ,
		   C.name AS Column_Name ,
		   P.name AS Data_Type ,
		   P.max_length AS Size ,
		   CAST(P.precision AS VARCHAR) + '/' + CAST(P.scale AS VARCHAR) AS Precision_Scale
	FROM   sys.objects AS T
		   JOIN sys.columns AS C ON T.object_id = C.object_id
		   JOIN sys.types AS P ON C.system_type_id = P.system_type_id
	WHERE C.name = 'Cd_empresa'
) AS TABELAS;

 SELECT TABLE_SCHEMA ,
       TABLE_NAME ,
       COLUMN_NAME ,
       ORDINAL_POSITION ,
       COLUMN_DEFAULT ,
       DATA_TYPE ,
       CHARACTER_MAXIMUM_LENGTH ,
       NUMERIC_PRECISION ,
       NUMERIC_PRECISION_RADIX ,
       NUMERIC_SCALE ,
       DATETIME_PRECISION
FROM   INFORMATION_SCHEMA.COLUMNS;