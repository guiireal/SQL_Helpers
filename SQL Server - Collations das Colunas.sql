SELECT
    tps.name AS [type], col.*
FROM 
    sys.columns col
INNER JOIN	
	sys.types tps ON col.system_type_id = tps.system_type_id
WHERE
    object_id = OBJECT_ID('VECEMPRE')
	

ALTER TABLE EMPRESA
  ALTER COLUMN CNPJ
    VARCHAR(50) COLLATE Latin1_General_CI_AS NULL