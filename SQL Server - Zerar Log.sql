SELECT NAME FROM SYSFILES WHERE GROUPID = 0

ALTER DATABASE /* NOME DO BANCO */ SET RECOVERY SIMPLE

DBCC SHRINKFILE (/*LOG OBTIDO ACIMA*/, 1)
