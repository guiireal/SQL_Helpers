
Rode o primeiro comando na base:

•	ALTER DATABASE [nome_da_base] SET RECOVERY SIMPLE

  Rode o select abaixo para obter o nome do arquivo ldf do sql:

•	SELECT * FROM sys.database_files

  Rode o comando abaixo com o nome do log obtido acima:

•	DBCC SHRINKFILE ('sophia_log', 1)

