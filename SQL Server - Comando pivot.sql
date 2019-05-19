SELECT ANO
		 , [1] AS JANEIRO
         , [2] AS FEVEREIRO
         , [3] AS MARÇO
		 , [4] AS ABRIL
         , [5] AS MAIO
         , [6] AS JUNHO
         , [7] AS JULHO
         , [8] AS AGOSTO
         , [9] AS SETEMBRO
         , [10] AS OUTUBRO
		 , [11] AS NOVEMBRO
         , [12] AS DEZEMBRO
FROM VENDAANUAIS PIVOT (SUM(VALOR) 
FOR MES IN ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12]))P
ORDER BY 1;



SELECT * FROM SOPHIA.ACADEMIC WHERE 

SELECT 
	MATRICULA, 
	DISCIPLINA, 
	MEDIA1
FROM 
	SOPHIA.ACADEMIC
WHERE 
	MATRICULA = 6


SELECT
	MATRICULA,
	[14] AS PORT,
	[16] AS MAT,
	[18] AS GEO,
	[24] AS INGLES,
	[30] AS HIST,
	[32] AS CIEN,
	[38] AS CIEN
FROM 
	SOPHIA.ACADEMIC
	PIVOT ( 
		MAX(MEDIA1)
		FOR DISCIPLINA IN ([14],[16],[18],[24],[30],[32],[38])
	) AS pvt
/*WHERE 
	MATRICULA = 6*/
ORDER BY 
	1

/*DEVE SER CRIADO UMA TABELA TEMPORARIA APENAS COM AS INFORMAÇÕES NECESSÁRIAS*/

DECLARE @NOTAS AS TABLE (
	MATRICULA INT,
	DISCIPLINA INT,
	MEDIA1 VARCHAR(10)
)


UPDATE 
	NOTAS
SET 
	NOTAS.MATRICULA = AO.venc
FROM 
	@NOTAS AS NOTAS
	INNER JOIN SOPHIA.ACADEMIC AS AO ON AL.codigo_origem = AO.codigo
WHERE
	AL.codigo_origem = 1





/************** EXEMPLO FUNCIONAL *******************/
DECLARE @registros as table (
    idRegistro int,
    Campo varchar(50),
    Valor varchar(50),
	Teste varchar(50)
)

INSERT INTO @registros VALUES (1, 'Nome', 'Zonaro', '1');
INSERT INTO @registros VALUES (1, 'Email', 'zonaro@outlook.com', '1');
INSERT INTO @registros VALUES (1, 'campoX', 'valorX', '1');
INSERT INTO @registros VALUES (2, 'Nome', 'Fulano', '1');
INSERT INTO @registros VALUES (2, 'tel', '1188889999', '1');
INSERT INTO @registros VALUES (2, 'campoY', 'valorY', '1');

SELECT * FROM @registros

SELECT 
	idRegistro,
	nome,
	Email,
	tel 
FROM @registros	
PIVOT (
    MAX(Valor)
    FOR Campo IN
    ([Nome], [Email], [tel], [campoX], [campoY])
) AS pvt
ORDER BY idRegistro

/***************************************************/


/***************************************************/
DECLARE @CONTAS TABLE (
  ANO SMALLINT,
  BANCO VARCHAR(100),
  TIPO VARCHAR(100),
  VALOR MONEY
)

INSERT INTO @CONTAS VALUES
(2009,'BANCO ALVORADA S/A','INVESTIMENTOS',6175979775.42),
(2010,'BANCO ALVORADA S/A','INVESTIMENTOS',6486892688.53),
(2011,'BANCO ALVORADA S/A','INVESTIMENTOS',7905663406.86),
(2012,'BANCO ALVORADA S/A','INVESTIMENTOS',9613906084.01),
(2009,'BANCO ARBI S/A','INVESTIMENTOS',8102644.84),
(2009,'BANCO ARBI S/A','OUTROS',174343.35),
(2010,'BANCO ARBI S/A','INVESTIMENTOS',7935411.15),
(2010,'BANCO ARBI S/A','OUTROS',119885.82),
(2011,'BANCO ARBI S/A','INVESTIMENTOS',8202652.29),
(2011,'BANCO ARBI S/A','OUTROS',114215.13),
(2012,'BANCO ARBI S/A','INVESTIMENTOS',8407843.72),
(2012,'BANCO ARBI S/A','OUTROS',81746.25)

SELECT ANO, BANCO, TIPO, VALOR FROM @CONTAS

SELECT U.BANCO, U.TIPO, U.[2009], U.[2010], U.[2011], U.[2012]
FROM @CONTAS AS C
PIVOT (
  SUM(C.VALOR) FOR
  C.ANO IN ([2009], [2010], [2011], [2012])
) AS U

/*****************************************************/