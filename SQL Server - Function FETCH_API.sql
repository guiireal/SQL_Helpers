CREATE FUNCTION [dbo].[FETCH_API](@TYPE VARCHAR(10), @URL VARCHAR(255))
RETURNS VARCHAR(8000)
BEGIN
	DECLARE @Object AS INT;
	DECLARE @ResponseText AS VARCHAR(8000);


	EXEC sp_OACreate 'MSXML2.XMLHTTP', @Object OUT;
	EXEC sp_OAMethod @Object, 'open', NULL, @TYPE,
					 @URL, --Your Web Service Url (invoked)
					 'false'
	EXEC sp_OAMethod @Object, 'send'
	EXEC sp_OAMethod @Object, 'responseText', @ResponseText OUTPUT
	EXEC sp_OADestroy @Object
	RETURN @ResponseText
END;


