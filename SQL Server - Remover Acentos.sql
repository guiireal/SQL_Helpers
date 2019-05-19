Create Function fnTiraAcento (@cExpressao varchar(100))
Returns varchar(1000)
as
Begin
   Declare @cRetorno varchar(1000)
   
   Set @cRetorno = @cExpressao collate sql_latin1_general_cp1251_cs_as
   
   Return @cRetorno
   
End