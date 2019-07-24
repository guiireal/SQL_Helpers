-- COMANDO PARA ALTERAR USUÁRIO SCL --
EXEC SP_CHANGE_USERS_LOGIN auto_fix, 'scl';

-- COMANDO PARA ALTERAR USUÁRIO SGx --
EXEC SP_CHANGE_USERS_LOGIN auto_fix, 'sophia';

-- COMANDO PARA EXIBIR A ESTRUTURA DA TABELA --
EXEC SP_HELP [nomeDaTabela];

-- COMANDO QUE RENOMEIA UMA COLUNA --
EXEC SP_RENAME 'tabela.nomeDaColuna', 'novoNome', 'COLUMN';

-- COMANDO QUE VERIFICA O QUE ESTÁ ACONTECENDO NA BASE --
EXEC SP_WHO2;

 -- Retorna um int com a quantidade de caracteres até a condição de parada
CHARINDEX(' ', F.NOME, 1);

-- Inverte toda a string --
REVERSE(PF.FOTO);

-- Substitui o valor de uma String por outra string personalizável --
REPLACE(F.NOME, ' ', '_');

-- Retirar acentuação de uma string --
SELECT 'ÂÈÃ' COLLATE SQL_Latin1_General_CP1251_CS_AS;

-- DATA DAS RESTAURAÇÕES FEITAS DA BASE DE DADOS --
SELECT * FROM msdb.dbo.restorehistory WHERE destination_database_Name = 'NOME_DA_BASE';


