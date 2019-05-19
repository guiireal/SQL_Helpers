
-- 1) Colocar o nome do banco que deseja limpar o log no comando USE
-- 2) Pegar o campo Name do arquivo de Log com o comando abaixo
USE ; 
SELECT * FROM sysfiles 
GO
 
-- 3) Colocar o nome do banco que deseja limpar o log nas variáves 
-- 4) Colocar o nome do arquivo de log na variável da linha SHRINKFILE
USE ;
GO
ALTER DATABASE 
SET RECOVERY SIMPLE;
GO
DBCC SHRINKFILE (, 1);
GO
ALTER DATABASE 
SET RECOVERY FULL;
GO