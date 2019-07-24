Declare @Object as Int;
DECLARE @hr  int
Declare @json as table(Json_Table nvarchar(max))

Exec @hr=sp_OACreate 'MSXML2.ServerXMLHTTP.6.0', @Object OUT;
IF @hr <> 0 EXEC sp_OAGetErrorInfo @Object
Exec @hr=sp_OAMethod @Object, 'open', NULL, 'get',
                 'http://overpass-api.de/api/interpreter?data=[out:json];area[name=%22Auckland%22]-%3E.a;(node(area.a)[amenity=cinema];way(area.a)[amenity=cinema];rel(area.a)[amenity=cinema];);out;', --Your Web Service Url (invoked)
                 'false'
IF @hr <> 0 EXEC sp_OAGetErrorInfo @Object
Exec @hr=sp_OAMethod @Object, 'send'
IF @hr <> 0 EXEC sp_OAGetErrorInfo @Object
Exec @hr=sp_OAMethod @Object, 'responseText', @json OUTPUT
IF @hr <> 0 EXEC sp_OAGetErrorInfo @Object

INSERT into @json (Json_Table) exec sp_OAGetProperty @Object, 'responseText'
-- select the JSON string
select * from @json
-- Parse the JSON string
SELECT * FROM OPENJSON((select * from @json), N'$.elements')
WITH (   
      [type] nvarchar(max) N'$.type'   ,
      [id]   nvarchar(max) N'$.id',
      [lat]   nvarchar(max) N'$.lat',
      [lon]   nvarchar(max) N'$.lon',
      [amenity]   nvarchar(max) N'$.tags.amenity',
      [name]   nvarchar(max) N'$.tags.name'     
)
EXEC sp_OADestroy @Object