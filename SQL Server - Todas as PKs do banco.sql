/*** TODAS AS TABELAS DO BANCO DE DADOS SEGUIDO DE SUA CHAVE PRIM�RIA ***/
Select Object_Name(Object_Id),name as Campo from sys.identity_columns order by Object_Name(Object_Id)