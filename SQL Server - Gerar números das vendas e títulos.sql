:INICIOATUA

  :<COMATUA = 'Corrigindo base de dados'>:  
  
    /* Comando 0123 */
    :INICIOCOM
        :<NSERIE = []>:
        :<NSIS = []>:
        :<TIPOBASE = SQLSERVER>:
        :<TIPOCOM = SQL>:
        :<RECONNECT = NO>:
        :<EXECUTE = []>:
        :<SQL = [<*declare @codigo int
select  @codigo = max(codigo) from CHEQUES
dBCC CHECKIDENT('GEN_CHEQUE', RESEED, @codigo)
*>]>:
    :FIMCOM

    /* Comando 0123 */
    :INICIOCOM
        :<NSERIE = []>:
        :<NSIS = []>:
        :<TIPOBASE = SQLSERVER>:
        :<TIPOCOM = SQL>:
        :<RECONNECT = NO>:
        :<EXECUTE = []>:
        :<SQL = [<*declare @codigo int
select  @codigo = max(codigo) from TITULOS
dBCC CHECKIDENT('GEN_TITULO', RESEED, @codigo)
*>]>:
    :FIMCOM
	
	 /* Comando 0123 */
    :INICIOCOM
        :<NSERIE = []>:
        :<NSIS = []>:
        :<TIPOBASE = SQLSERVER>:
        :<TIPOCOM = SQL>:
        :<RECONNECT = NO>:
        :<EXECUTE = []>:
        :<SQL = [<*declare @codigo int
select  @codigo = max(codigo) from VENDAS
dBCC CHECKIDENT('GEN_VENDA', RESEED, @codigo)
*>]>:
    :FIMCOM
	
	 /* Comando 0123 */
    :INICIOCOM
        :<NSERIE = []>:
        :<NSIS = []>:
        :<TIPOBASE = SQLSERVER>:
        :<TIPOCOM = SQL>:
        :<RECONNECT = NO>:
        :<EXECUTE = []>:
        :<SQL = [<*declare @codigo int
select  @codigo = max(codigo) from MATRICULA
dBCC CHECKIDENT('GEN_MATRICULA', RESEED, @codigo)
*>]>:
    :FIMCOM	

:FIMATUA