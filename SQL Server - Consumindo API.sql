-- CONFIGURAR ABERTURA DE PROCEDURES AUTOMATIZADAS --
EXEC sp_configure 'Ole Automation Procedures', 1;
GO

RECONFIGURE;
GO
-- CRIAÇÃO DOS SCRIPTS --
DECLARE @authHeader NVARCHAR(64);
DECLARE @contentType NVARCHAR(64);
DECLARE @postData NVARCHAR(2000);
DECLARE @responseText NVARCHAR(2000);
DECLARE @responseXML NVARCHAR(2000);
DECLARE @ret INT;
DECLARE @status NVARCHAR(32);
DECLARE @statusText NVARCHAR(32);
DECLARE @token INT;
DECLARE @url NVARCHAR(256);

SET @authHeader = 'BASIC 0123456789ABCDEF0123456789ABCDEF';
SET @contentType = 'application/x-www-form-urlencoded';
SET @postData = 'value1=Hello&value2=World';
SET @url = 'https://en43ylz3txlaz.x.pipedream.net';

-- Open the connection.
EXEC @ret = sp_OACreate 'MSXML2.ServerXMLHTTP', @token OUT;
IF @ret <> 0 RAISERROR('Unable to open HTTP connection.', 10, 1);

-- Send the request.
EXEC @ret = sp_OAMethod @token, 'open', NULL, 'POST', @url, 'false';
EXEC @ret = sp_OAMethod @token, 'setRequestHeader', NULL, 'Authentication', @authHeader;
EXEC @ret = sp_OAMethod @token, 'setRequestHeader', NULL, 'Content-type', @contentType;
EXEC @ret = sp_OAMethod @token, 'send', NULL, @postData;

-- Handle the response.
EXEC @ret = sp_OAGetProperty @token, 'status', @status OUT;
EXEC @ret = sp_OAGetProperty @token, 'statusText', @statusText OUT;
EXEC @ret = sp_OAGetProperty @token, 'responseText', @responseText OUT;

-- Show the response.
PRINT 'Status: ' + @status + ' (' + @statusText + ')';
PRINT 'Response text: ' + @responseText;

-- Close the connection.
EXEC @ret = sp_OADestroy @token;
IF @ret <> 0 RAISERROR('Unable to close HTTP connection.', 10, 1);