USE [Fipecafi]
GO
/****** Object:  StoredProcedure [sophia].[RECALC_NOTAS]    Script Date: 23/09/2016 14:02:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [sophia].[RECALC_NOTAS] @ID_TURMA INT, @ID_DISCIPLINA INT, @NUM_ETAPA_INICIAL INT,@NUM_ETAPA_FINAL INT
AS
BEGIN
	-- SET NOCOUNT ON faz com que o SQL Server n�o fa�a o processamento de linhas afetadas
	SET NOCOUNT ON;
	--------------------------<< CONFIGURA��O ACAD�MICA >>--------------------------
	DECLARE @ID_CFG_ACAD INT;	
	DECLARE @ID_SERIE INT;
	DECLARE @PROCEDURE_RECALCULO VARCHAR(50);
	EXECUTE sp_executesql N'
		SELECT @ID_CFG_ACAD = t.CFG_ACAD,
		       @ID_SERIE = t.SERIE,
		       @PROCEDURE_RECALCULO = c.PROCEDURE_RECALCULO
		  FROM sophia.TURMAS t WITH (NOLOCK)
		 INNER JOIN sophia.CFG_ACAD c WITH (NOLOCK)
		    ON c.CODIGO = t.CFG_ACAD
		 WHERE t.CODIGO = @ID_TURMA',
	N'@ID_CFG_ACAD INT OUTPUT, @ID_SERIE INT OUTPUT, @PROCEDURE_RECALCULO VARCHAR(50) OUTPUT, @ID_TURMA INT',
	@ID_CFG_ACAD OUTPUT, @ID_SERIE OUTPUT, @PROCEDURE_RECALCULO OUTPUT, @ID_TURMA;

	IF (@PROCEDURE_RECALCULO <> '[sophia].[RECALC_NOTAS]')
		RETURN
	-------------------------->> CONFIGURA��O ACAD�MICA <<--------------------------
	---------------------<< PAR�METROS DO QUADRO CURRICULAR >>----------------------
	DECLARE @TEM_NOTAS SMALLINT;
	DECLARE @REPROVA SMALLINT;
	DECLARE @REPROVA_NOTA SMALLINT;
	EXECUTE sp_executesql N'
		SELECT @TEM_NOTAS = q.TEM_NOTAS, 
		       @REPROVA = q.REPROVA, 
		       @REPROVA_NOTA = q.REPROVA_NOTA
		  FROM sophia.QC q
		 WHERE q.TURMA = @ID_TURMA
		   AND q.DISCIPLINA = @ID_DISCIPLINA',
	N'@TEM_NOTAS SMALLINT OUTPUT, @REPROVA SMALLINT OUTPUT, @REPROVA_NOTA SMALLINT OUTPUT, @ID_TURMA INT, @ID_DISCIPLINA INT',
	@TEM_NOTAS OUTPUT, @REPROVA OUTPUT, @REPROVA_NOTA OUTPUT, @ID_TURMA, @ID_DISCIPLINA;
	--------------------->> PAR�METROS DO QUADRO CURRICULAR <<----------------------
	------------------------------<< ETAPAS NORMAIS >>------------------------------
	DECLARE @MAX_ETAPA INT;
	DECLARE @ATAS_REGULARES_PROCESSADAS INT;
	DECLARE @ATAS_REC_PROCESSADAS INT;
	DECLARE @NUM_ETAPA_FIM INT;
	DECLARE @NUM_ETAPA INT;
	DECLARE @ID_ETAPA INT;
	DECLARE @NOTA_MAX_ETAPA NUMERIC(15,4);
	DECLARE @ID_MATRICULA INT;
	DECLARE @ID_MATRICULA_OLD INT;
	DECLARE @NOTAS_SOMA NUMERIC (15,4);
	DECLARE @NOTAS_QUANTIDADE INT;
	DECLARE @SQL_ACADEMIC NVARCHAR(4000);
	DECLARE @ID_ACADEMIC INT;
	DECLARE @DISPENSA SMALLINT;
	DECLARE @MEDIA NUMERIC(15,2);
	DECLARE @NOTA NUMERIC(15,2);
	DECLARE @NOTA_RECUPERACAO NUMERIC(15,4);
	DECLARE @SQL NVARCHAR(4000);
	DECLARE @MEDIA_TURMA INT;
	DECLARE @TEM_REC SMALLINT;
	DECLARE @NOTA_ETAPA_ANTERIOR NUMERIC(15,4);
	DECLARE @NOVA_MEDIA NUMERIC(15,4);
	IF (@TEM_NOTAS = 1)
	BEGIN
		EXECUTE sp_executesql N'
			SELECT @MAX_ETAPA = MAX(e.NUMERO)
			  FROM sophia.ETAPAS e WITH (NOLOCK)
			 WHERE e.CFG_ACAD = @ID_CFG_ACAD
			   AND e.TIPO_ETAPA = 1',
		N'@MAX_ETAPA INT OUTPUT, @ID_CFG_ACAD INT',
		@MAX_ETAPA OUTPUT, @ID_CFG_ACAD;

		IF (@NUM_ETAPA_FINAL < @MAX_ETAPA)
			SET @NUM_ETAPA_FIM = @NUM_ETAPA_FINAL;
		ELSE
			SET @NUM_ETAPA_FIM = @MAX_ETAPA;

		IF (@NUM_ETAPA_INICIAL > 1)
			SET @NUM_ETAPA_INICIAL = 1;
		ELSE
		BEGIN
			SET @NUM_ETAPA = 1;
		END


		WHILE (@NUM_ETAPA <= @NUM_ETAPA_FIM) 
		BEGIN
			EXEC sp_executesql N'
				SELECT @ID_ETAPA = e.CODIGO,
				       @NOTA_MAX_ETAPA = e.NOTA_MAX,
					   @TEM_REC = e.TEM_REC
				  FROM sophia.ETAPAS e WITH (NOLOCK)
				 WHERE e.CFG_ACAD = @ID_CFG_ACAD
				   AND e.NUMERO = @NUM_ETAPA',
			N'@ID_ETAPA INT OUTPUT, @NOTA_MAX_ETAPA NUMERIC(15,4) OUTPUT, @TEM_REC SMALLINT OUTPUT, @ID_CFG_ACAD INT, @NUM_ETAPA INT',
			@ID_ETAPA OUTPUT, @NOTA_MAX_ETAPA OUTPUT, @TEM_REC OUTPUT, @ID_CFG_ACAD, @NUM_ETAPA;

			EXEC VERIFICA_ATAS_PROCESSADAS @ID_TURMA, @ID_DISCIPLINA, @ID_ETAPA, 0, @ATAS_REGULARES_PROCESSADAS OUTPUT
			EXEC VERIFICA_ATAS_PROCESSADAS @ID_TURMA, @ID_DISCIPLINA, @ID_ETAPA, 1, @ATAS_REC_PROCESSADAS OUTPUT

			SET @ID_MATRICULA = 0;
			SET @ID_MATRICULA_OLD = 0;
			SET @NOTAS_SOMA = 0;					
			SET @NOTAS_QUANTIDADE = 0;
			WHILE (@ID_MATRICULA IS NOT NULL)
			BEGIN
				SET @SQL_ACADEMIC = N'
					SELECT TOP 1 @ID_MATRICULA = a.MATRICULA,
					       @ID_ACADEMIC = a.CODIGO,
					       @DISPENSA = DISPENSA' + CAST(@NUM_ETAPA AS VARCHAR(2)) + '
                      FROM sophia.ACADEMIC a WITH (NOLOCK)
                     INNER JOIN sophia.MATRICULA m WITH (NOLOCK)
                        ON a.TURMA = @ID_TURMA
                       AND a.DISCIPLINA = @ID_DISCIPLINA
                       AND a.MATRICULA > @ID_MATRICULA_OLD
                       AND m.CODIGO = a.MATRICULA
                       AND m.STATUS = 0
                     ORDER BY a.MATRICULA'
				EXECUTE sp_executesql @SQL_ACADEMIC,
				N'@ID_MATRICULA INT OUTPUT, @ID_ACADEMIC INT OUTPUT, @DISPENSA SMALLINT OUTPUT, @ID_TURMA INT, @ID_DISCIPLINA INT, @ID_MATRICULA_OLD INT',
				@ID_MATRICULA OUTPUT, @ID_ACADEMIC OUTPUT, @DISPENSA OUTPUT, @ID_TURMA, @ID_DISCIPLINA, @ID_MATRICULA_OLD

				IF (@ID_MATRICULA = @ID_MATRICULA_OLD)
					BREAK
				SET @ID_MATRICULA_OLD = @ID_MATRICULA;
				SET @MEDIA = NULL;
				SET @NOTA = NULL;
				SET @NOTA_RECUPERACAO = NULL;
				IF (@DISPENSA = 0)
				BEGIN
					-- C�lculo da nota
					EXEC sophia.GET_NOTA @ID_ACADEMIC, @ID_ETAPA, 0, @ATAS_REGULARES_PROCESSADAS, 0, @NOTA OUTPUT;

					IF (@NOTA > @NOTA_MAX_ETAPA)
						SET @NOTA = NULL;
					-- C�lculo da recupera��o
					IF (@TEM_REC = 1) AND (@NOTA IS NOT NULL) 
					BEGIN
						EXEC sophia.GET_NOTA @ID_ACADEMIC, @ID_ETAPA, 1, @ATAS_REC_PROCESSADAS, 1 , @NOTA_RECUPERACAO OUTPUT;

						IF (@NOTA_RECUPERACAO > @NOTA_MAX_ETAPA)
						SET @NOTA_RECUPERACAO = NULL;

						IF ((@NUM_ETAPA = 1) OR (@NUM_ETAPA = 2) OR (@NUM_ETAPA = 3) OR (@NUM_ETAPA = 4)) AND (@NOTA_RECUPERACAO IS NOT NULL)
						BEGIN
							IF (@NOTA > @NOTA_RECUPERACAO)
							BEGIN
								SET @MEDIA = @NOTA
							END ELSE
							BEGIN
								IF (@NOTA_RECUPERACAO > 6)
								BEGIN
									SET @MEDIA = 6
								END ELSE
								BEGIN
									SET @MEDIA = @NOTA_RECUPERACAO
								END
							END
						END ELSE
						BEGIN
							SET @MEDIA = @NOTA;
						END;
					END
					ELSE -- FIM DE QUANDO NAO POSSUI REC
					BEGIN
						SET @ATAS_REC_PROCESSADAS = 1;
						SET @MEDIA = @NOTA;
					END;

					SET @NOTAS_SOMA = @NOTAS_SOMA + @MEDIA;
					SET @NOTAS_QUANTIDADE = @NOTAS_QUANTIDADE + 1;

					-- Atualiza ACADEMIC_LANC com a nota, recupera��o (se houver) e m�dia
					EXEC sp_executesql N'
						UPDATE sophia.ACADEMIC_LANC SET
							NOTA = @NOTA,
							REC = @NOTA_RECUPERACAO,
							MEDIA = @MEDIA
						WHERE ACADEMIC = @ID_ACADEMIC
						  AND ETAPA = @NUM_ETAPA',
					N'@NOTA NUMERIC(15,4), @NOTA_RECUPERACAO NUMERIC(15,4), @MEDIA NUMERIC(15,4), @ID_ACADEMIC INT, @NUM_ETAPA INT',
					@NOTA, @NOTA_RECUPERACAO, @MEDIA, @ID_ACADEMIC, @NUM_ETAPA

					-- Atualiza ACADEMIC com a nota da etapa
					IF (@ATAS_REGULARES_PROCESSADAS = 1)
					BEGIN
						SET @SQL = N'
						UPDATE sophia.ACADEMIC SET 
							NOTA' + CAST(@NUM_ETAPA AS VARCHAR(2)) + ' =  @NOTA
						WHERE CODIGO = @ID_ACADEMIC';
						EXEC sp_executesql @SQL,
						N'@NOTA NUMERIC(15,4), @ID_ACADEMIC INT',
						@NOTA, @ID_ACADEMIC;
					END
					-- Atualiza ACADEMIC com a nota da recupera��o
					IF (@ATAS_REC_PROCESSADAS = 1)
					BEGIN
						SET @SQL = N'
						UPDATE sophia.ACADEMIC SET 
							REC' + CAST(@NUM_ETAPA AS VARCHAR(2)) + ' =  @NOTA_RECUPERACAO
						WHERE CODIGO = @ID_ACADEMIC';
						EXEC sp_executesql @SQL, 
						N'@NOTA_RECUPERACAO NUMERIC(15,4), @ID_ACADEMIC INT',
						@NOTA_RECUPERACAO, @ID_ACADEMIC;
					END ELSE
					BEGIN
						SET @SQL = N'
						UPDATE sophia.ACADEMIC SET 
							REC' + CAST(@NUM_ETAPA AS VARCHAR(2)) + ' =  NULL,
							MEDIA' + CAST(@NUM_ETAPA AS VARCHAR(2)) + ' =  NULL
						WHERE CODIGO = @ID_ACADEMIC';
						EXEC sp_executesql @SQL, 
						N'@ID_ACADEMIC INT',
						@ID_ACADEMIC;
					END
					-- Atualiza ACADEMIC com a m�dia da etapa e j� atualiza a m�dia da turma
					IF (@ATAS_REGULARES_PROCESSADAS = 1) AND (@ATAS_REC_PROCESSADAS = 1)
					BEGIN
						SET @SQL = N'
						UPDATE sophia.ACADEMIC SET 
							MEDIA' + CAST(@NUM_ETAPA AS VARCHAR(2)) + ' =  @MEDIA
						WHERE CODIGO = @ID_ACADEMIC';
						EXEC sp_executesql @SQL, 
						N'@MEDIA NUMERIC(15,4), @ID_ACADEMIC INT',
						@MEDIA, @ID_ACADEMIC;
					-- Atualiza QC com a m�dia da turma
						SET @MEDIA_TURMA = ROUND(@NOTAS_SOMA/@NOTAS_QUANTIDADE, 1, 1);
						SET @SQL = N'
							UPDATE sophia.QC SET 
								MEDIA' + CAST(@NUM_ETAPA AS VARCHAR(2)) + ' = @MEDIA_TURMA
							WHERE TURMA = @ID_TURMA
							  AND DISCIPLINA = @ID_DISCIPLINA';
						EXEC sp_executesql @SQL,
						N'@MEDIA_TURMA NUMERIC(15,4), @ID_TURMA INT, @ID_DISCIPLINA INT',
						@MEDIA_TURMA, @ID_TURMA, @ID_DISCIPLINA;
					END
				END -- FIM ALUNOS DISPENSA
			END -- FIM QUANTIDADE MATRICULAS
			SET @NUM_ETAPA = @NUM_ETAPA + 1;
		END;
	END;
	------------------------------>> ETAPAS NORMAIS <<------------------------------
	------------------------------<< FIM DAS ETAPAS >>------------------------------
	DECLARE @ID_ETAPA_RECFINAL INT;
	DECLARE @NOTA_MAX_ETAPA_RECFINAL NUMERIC(15,4);
    DECLARE @MEDIA_FINAL NUMERIC (15,4);
    DECLARE @MEDIA_FINAL_LANC NUMERIC (15,4);
    DECLARE @MEDIA_FINALSTR VARCHAR(10);
    DECLARE @SITUACAO SMALLINT;
    DECLARE @TEM_PRE_CONSELHO SMALLINT;
    DECLARE @APR_PRE_CON_IDEM SMALLINT;
    DECLARE @APR_PRE_CON_MUDA VARCHAR(6);
    DECLARE @APR_PRE_CON_MUDA_MEDIA NUMERIC(15,4);
    DECLARE @CONSELHO SMALLINT;
	DECLARE @RECFINAL_PROCESSADO SMALLINT;
	DECLARE @MEDIA_APOS_RECFINAL_CRITERIO NUMERIC (15,4);
    DECLARE @ETAPA1_MEDIA NUMERIC(15,4);
    DECLARE @ETAPA1_DISPENSA SMALLINT;
    DECLARE @ETAPA2_MEDIA NUMERIC(15,4);
    DECLARE @ETAPA2_DISPENSA SMALLINT;
    DECLARE @ETAPA3_MEDIA NUMERIC(15,4);
    DECLARE @ETAPA3_DISPENSA SMALLINT;
    DECLARE @ETAPA4_MEDIA NUMERIC(15,4);
    DECLARE @ETAPA4_DISPENSA SMALLINT;
    DECLARE @NOTA_RECFINAL NUMERIC(15,4);
	DECLARE @MEDIA_ANUAL NUMERIC(15,4);
	DECLARE @MEDIA_APOS_RECFINAL NUMERIC(15,4);
	DECLARE @SOMA_PESOS NUMERIC(15,4);
	IF (@NUM_ETAPA_FINAL > 12) 
	BEGIN
		EXEC sp_executesql	N'
			SELECT @ID_ETAPA_RECFINAL = e.CODIGO,
				   @NOTA_MAX_ETAPA_RECFINAL = e.NOTA_MAX
			  FROM sophia.ETAPAS e WITH (NOLOCK)
			 WHERE e.CFG_ACAD = @ID_CFG_ACAD
			   AND e.TIPO_ETAPA = 3',
		N'@ID_ETAPA_RECFINAL INT OUTPUT, @NOTA_MAX_ETAPA_RECFINAL NUMERIC(15,4) OUTPUT, @ID_CFG_ACAD INT',
		@ID_ETAPA_RECFINAL OUTPUT, @NOTA_MAX_ETAPA_RECFINAL OUTPUT, @ID_CFG_ACAD; -- TIPO EXAME
		EXEC sp_executesql	N'
			SELECT @TEM_PRE_CONSELHO = c.TEM_PRE_CONSELHO,
			       @APR_PRE_CON_IDEM = c.APR_PRE_CON_IDEM,
			       @APR_PRE_CON_MUDA = c.APR_PRE_CON_MUDA
			  FROM sophia.CFG_ACAD c WITH (NOLOCK)
			 WHERE c.CODIGO = @ID_CFG_ACAD',
		N'@TEM_PRE_CONSELHO SMALLINT OUTPUT, @APR_PRE_CON_IDEM SMALLINT OUTPUT,	@APR_PRE_CON_MUDA VARCHAR(6) OUTPUT, @ID_CFG_ACAD INT',
		@TEM_PRE_CONSELHO OUTPUT, @APR_PRE_CON_IDEM OUTPUT,	@APR_PRE_CON_MUDA OUTPUT, @ID_CFG_ACAD;
		IF (ISNUMERIC(REPLACE(@APR_PRE_CON_MUDA, ',', '.')) = 1)
			SET @APR_PRE_CON_MUDA_MEDIA = CAST(REPLACE(@APR_PRE_CON_MUDA, ',', '.') AS NUMERIC(15,4));
		SET @RECFINAL_PROCESSADO = NULL;
		EXEC sp_executesql	N'
			SELECT @RECFINAL_PROCESSADO = CASE WHEN COUNT(an.CODIGO) = 0 THEN NULL
					WHEN SUM(CASE WHEN an.SITUACAO <> 5 THEN 1 ELSE 0 END) > 0 THEN NULL
					ELSE 1
					END
			  FROM sophia.ATA_NOTA an
			 WHERE an.TURMA = @ID_TURMA
			   AND an.DISCIPLINA = @ID_DISCIPLINA
			   AND an.ETAPA = 14',
		N'@RECFINAL_PROCESSADO SMALLINT OUTPUT, @ID_TURMA INT, @ID_DISCIPLINA INT',
		@RECFINAL_PROCESSADO OUTPUT, @ID_TURMA, @ID_DISCIPLINA;
		SET @MEDIA_APOS_RECFINAL_CRITERIO = 5.0;
		SET @ID_MATRICULA = 0;
		SET @ID_MATRICULA_OLD = 0;
		WHILE (@ID_MATRICULA IS NOT NULL)
		BEGIN
			SET @ID_ACADEMIC = NULL;
			SET @ETAPA1_MEDIA = NULL;
			SET @ETAPA1_DISPENSA = NULL;
			SET @ETAPA2_MEDIA = NULL;
			SET @ETAPA2_DISPENSA = NULL;
			SET @ETAPA3_MEDIA = NULL;
			SET @ETAPA3_DISPENSA = NULL;
			SET @ETAPA4_MEDIA = NULL;
			SET @ETAPA4_DISPENSA = NULL;
			SET @CONSELHO = NULL;
            
			EXECUTE sp_executesql N'
				SELECT TOP 1 @ID_MATRICULA = a.MATRICULA,
				       @ID_ACADEMIC = a.CODIGO,
				       @ETAPA1_MEDIA = a.MEDIA1,
				       @ETAPA1_DISPENSA = a.DISPENSA1,
				       @ETAPA2_MEDIA = a.MEDIA2,
				       @ETAPA2_DISPENSA = a.DISPENSA2,
				       @ETAPA3_MEDIA = a.MEDIA3,
				       @ETAPA3_DISPENSA = a.DISPENSA3,
				       @ETAPA4_MEDIA = a.MEDIA4,
				       @ETAPA4_DISPENSA = a.DISPENSA4,
				       @CONSELHO = a.CONSELHO
				  FROM sophia.ACADEMIC a WITH (NOLOCK)
				 INNER JOIN sophia.MATRICULA m WITH (NOLOCK)
				    ON a.TURMA = @ID_TURMA
				   AND a.DISCIPLINA = @ID_DISCIPLINA
				   AND a.MATRICULA > @ID_MATRICULA_OLD
				   AND m.CODIGO = a.MATRICULA
				   AND m.STATUS = 0
				 ORDER BY a.MATRICULA',
			N'@ID_MATRICULA INT OUTPUT, @ID_ACADEMIC INT OUTPUT, 
			@ETAPA1_MEDIA NUMERIC(15,4) OUTPUT, @ETAPA1_DISPENSA SMALLINT OUTPUT,
			@ETAPA2_MEDIA NUMERIC(15,4) OUTPUT, @ETAPA2_DISPENSA SMALLINT OUTPUT,
			@ETAPA3_MEDIA NUMERIC(15,4) OUTPUT, @ETAPA3_DISPENSA SMALLINT OUTPUT,
			@ETAPA4_MEDIA NUMERIC(15,4) OUTPUT, @ETAPA4_DISPENSA SMALLINT OUTPUT,
			@CONSELHO SMALLINT OUTPUT,
			@ID_TURMA INT, @ID_DISCIPLINA INT, @ID_MATRICULA_OLD INT',
			@ID_MATRICULA OUTPUT, @ID_ACADEMIC OUTPUT, 
			@ETAPA1_MEDIA OUTPUT, @ETAPA1_DISPENSA OUTPUT,
			@ETAPA2_MEDIA OUTPUT, @ETAPA2_DISPENSA OUTPUT,
			@ETAPA3_MEDIA OUTPUT, @ETAPA3_DISPENSA OUTPUT,
			@ETAPA4_MEDIA OUTPUT, @ETAPA4_DISPENSA OUTPUT,
			@CONSELHO OUTPUT,
			@ID_TURMA, @ID_DISCIPLINA, @ID_MATRICULA_OLD;
			IF (@ID_MATRICULA = @ID_MATRICULA_OLD)
				BREAK
			SET @ID_MATRICULA_OLD = @ID_MATRICULA;
			SET @NOTAS_SOMA = 0;
			SET @MEDIA_ANUAL = NULL;
			SET @SOMA_PESOS = 0;
			IF (@ETAPA1_DISPENSA = 0)
			BEGIN
				SET @NOTAS_SOMA = @NOTAS_SOMA + COALESCE(@ETAPA1_MEDIA, 0);
				SET @SOMA_PESOS = @SOMA_PESOS + 1;
			END;
			IF (@ETAPA2_DISPENSA = 0)
			BEGIN
				SET @NOTAS_SOMA = @NOTAS_SOMA + COALESCE(@ETAPA2_MEDIA, 0);
				SET @SOMA_PESOS = @SOMA_PESOS + 1;
			END;
			IF (@ETAPA3_DISPENSA = 0)
			BEGIN
				SET @NOTAS_SOMA = @NOTAS_SOMA + COALESCE(@ETAPA3_MEDIA, 0);
				SET @SOMA_PESOS = @SOMA_PESOS + 1;
			END;
			IF (@ETAPA4_DISPENSA = 0)
			BEGIN
				SET @NOTAS_SOMA = @NOTAS_SOMA + COALESCE(@ETAPA4_MEDIA, 0);
				SET @SOMA_PESOS = @SOMA_PESOS + 1;
			END;
			-- M�dia das etapas (MEDIA_ANUAL)
			IF ((@NOTAS_SOMA IS NOT NULL) AND (@SOMA_PESOS > 0))
			BEGIN
				SET @MEDIA_ANUAL = (@NOTAS_SOMA/@SOMA_PESOS);
			END;	 
			-- M�dia da REC FINAL
			EXEC sophia.GET_NOTA @ID_ACADEMIC, @ID_ETAPA_RECFINAL, 0, @RECFINAL_PROCESSADO, 1, @NOTA_RECFINAL OUTPUT;
			-- M�dia ap�s exame (MEDIA_APOS_EXAME)
			IF (@NOTA_RECFINAL IS NOT NULL)
			BEGIN
				SET @MEDIA_APOS_RECFINAL = ((@NOTA_RECFINAL + @MEDIA_ANUAL) / 2);
			END
			ELSE
			SET @MEDIA_APOS_RECFINAL = NULL;
			SET @MEDIA_FINAL = NULL;
			SET @MEDIA_FINALSTR = NULL;
			SET @SITUACAO = 0 -- saINDEFINIDO_SIT_ACAD
			IF (@REPROVA = 0)
			BEGIN
				SET @SITUACAO = 1; -- saAPROVADO_SIT_ACAD
			END
			--> Se estiver dispensado em todas as etapas, est� automaticamente aprovado
			ELSE IF ((@ETAPA1_DISPENSA = 1) AND (@ETAPA2_DISPENSA = 1) AND (@ETAPA3_DISPENSA = 1) AND (@ETAPA4_DISPENSA = 1))
			BEGIN
				SET @SITUACAO = 1; -- saAPROVADO_SIT_ACAD
			END
			--> Se tiver sido lan�ado nota para todas as etapas pode definir a situa��o do aluno
			ELSE IF (((@ETAPA1_MEDIA IS NOT NULL) OR (@ETAPA1_DISPENSA = 1)) AND 
					 ((@ETAPA2_MEDIA IS NOT NULL) OR (@ETAPA2_DISPENSA = 1)) AND 
					 ((@ETAPA3_MEDIA IS NOT NULL) OR (@ETAPA3_DISPENSA = 1)))
			BEGIN
				--> Aprovado direto, se a m�dia for maior ou igual a 6
				IF ((@MEDIA_ANUAL >= 6.0) OR (@REPROVA_NOTA = 0))
					SET @SITUACAO = 1 -- saAPROVADO_SIT_ACAD
				--> Sen�o estar� de exame at� que a nota de exame seja lan�ada
				ELSE
				BEGIN 
					IF ((@TEM_PRE_CONSELHO = 1) AND (@CONSELHO = 1))
					BEGIN
						SET @SITUACAO = 5 -- saAPROVADO_CONSELHO_SIT_ACAD
						IF (@APR_PRE_CON_IDEM = 0)
						BEGIN
							SET @MEDIA_FINALSTR = @APR_PRE_CON_MUDA
							IF (@APR_PRE_CON_MUDA_MEDIA IS NOT NULL)
							BEGIN 
								SET @MEDIA_FINAL = @APR_PRE_CON_MUDA_MEDIA;
								SET @MEDIA_ANUAL = @APR_PRE_CON_MUDA_MEDIA;
							END
						END
					END
					ELSE
					BEGIN
						IF (@RECFINAL_PROCESSADO IS NULL)
						BEGIN
							SET @SITUACAO = 3 -- saEM_EXAME_SIT_ACAD;
						END
						ELSE
						BEGIN
							IF (@MEDIA_ANUAL > @MEDIA_APOS_RECFINAL)
							BEGIN
								SET @MEDIA_FINAL = @MEDIA_ANUAL
							END ELSE
							BEGIN
								SET @MEDIA_FINAL = @MEDIA_APOS_RECFINAL
							END

							IF (@MEDIA_FINAL >= @MEDIA_APOS_RECFINAL_CRITERIO)
								SET @SITUACAO = 1; -- saAPROVADO_SIT_ACAD
							ELSE
								IF (@MEDIA_FINAL IS NOT NULL)
									SET @SITUACAO = 2; -- saREPROVADO_SIT_ACAD
								ELSE
									SET @SITUACAO = 0; --saINDEFINIDO_SIT_ACAD
						END
					END
				END
			END
			-- M�dia final (MEDIA_FINAL)
			IF ((@SITUACAO = 1) OR (@SITUACAO = 2)) 
			BEGIN
				SET @MEDIA_FINALSTR = REPLACE(CAST(CAST(ROUND(@MEDIA_FINAL, 1, 1) AS NUMERIC(8,1)) AS VARCHAR(10)), '.', ',');
			END
			--> Atualiza o registro do aluno
			EXEC sp_executesql	N'
				UPDATE sophia.ACADEMIC SET 
					EXAME = @NOTA_RECFINAL,
					MEDIA_ANUAL = @MEDIA_ANUAL,
					MEDIA_APOS_EXAME = @MEDIA_APOS_RECFINAL,
					MEDIA_FINAL = @MEDIA_FINAL,
					MEDIA_FINALSTR = @MEDIA_FINALSTR,
					SITUACAO = @SITUACAO
				WHERE CODIGO = @ID_ACADEMIC',
			N'@NOTA_RECFINAL NUMERIC(15,4), @MEDIA_ANUAL NUMERIC(15,4), 
			@MEDIA_APOS_RECFINAL NUMERIC(15,4), @MEDIA_FINAL NUMERIC(15,4),
			@MEDIA_FINALSTR VARCHAR(10), @SITUACAO SMALLINT, @ID_ACADEMIC INT',
			@NOTA_RECFINAL, @MEDIA_ANUAL, 
			@MEDIA_APOS_RECFINAL, @MEDIA_FINAL,
			@MEDIA_FINALSTR, @SITUACAO, @ID_ACADEMIC;
			EXEC sp_executesql N'
				UPDATE sophia.ACADEMIC_LANC	SET 
					NOTA = @NOTA,
					MEDIA = @MEDIA
				WHERE ACADEMIC = @ID_ACADEMIC
				  AND ETAPA = @NUM_ETAPA',
			N'@NOTA NUMERIC(15,4), @MEDIA NUMERIC(15,4), @ID_ACADEMIC INT, @NUM_ETAPA INT',
			@MEDIA_ANUAL, @MEDIA_ANUAL, @ID_ACADEMIC, 13;
			EXEC sp_executesql N'
				UPDATE sophia.ACADEMIC_LANC	SET 
					NOTA = @NOTA,
					MEDIA = @MEDIA
				WHERE ACADEMIC = @ID_ACADEMIC
				  AND ETAPA = @NUM_ETAPA',
			N'@NOTA NUMERIC(15,4), @MEDIA NUMERIC(15,4), @ID_ACADEMIC INT, @NUM_ETAPA INT',
			@NOTA_RECFINAL, @MEDIA_APOS_RECFINAL, @ID_ACADEMIC, 14
			SET @MEDIA_FINAL_LANC = COALESCE(@MEDIA_FINAL, @MEDIA_ANUAL)
			EXEC sp_executesql N'
				UPDATE sophia.ACADEMIC_LANC	SET 
					NOTA = @NOTA,
					MEDIA = @NOTA
				WHERE ACADEMIC = @ID_ACADEMIC
				  AND ETAPA = @NUM_ETAPA',
			N'@NOTA NUMERIC(15,4), @ID_ACADEMIC INT, @NUM_ETAPA INT',
			@MEDIA_FINAL_LANC, @ID_ACADEMIC, 16
		END
	END
	------------------------------>> FIM DAS ETAPAS <<------------------------------
END