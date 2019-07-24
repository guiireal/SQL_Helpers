-- COMANDO PARA ALTERAR USU�RIO SCL --
EXEC SP_CHANGE_USERS_LOGIN auto_fix, 'scl';

-- COMANDO PARA ALTERAR USU�RIO SGx --
EXEC SP_CHANGE_USERS_LOGIN auto_fix, 'sophia';

-- COMANDO PARA EXIBIR A ESTRUTURA DA TABELA --
EXEC SP_HELP [nomeDaTabela];

-- COMANDO QUE RENOMEIA UMA COLUNA --
EXEC SP_RENAME 'tabela.nomeDaColuna', 'novoNome', 'COLUMN';

-- COMANDO QUE VERIFICA O QUE EST� ACONTECENDO NA BASE --
EXEC SP_WHO2;

 -- Retorna um int com a quantidade de caracteres at� a condi��o de parada
CHARINDEX(' ', F.NOME, 1);

-- Inverte toda a string --
REVERSE(PF.FOTO);

-- Substitui o valor de uma String por outra string personaliz�vel --
REPLACE(F.NOME, ' ', '_');

-- Retirar acentua��o de uma string --
SELECT '���' COLLATE SQL_Latin1_General_CP1251_CS_AS;

-- DATA DAS RESTAURA��ES FEITAS DA BASE DE DADOS --
SELECT * FROM msdb.dbo.restorehistory WHERE destination_database_Name = 'NOME_DA_BASE';


