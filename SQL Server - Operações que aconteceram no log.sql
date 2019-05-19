SELECT [transaction ID], Operation, Context, AllocUnitName FROM fn_dblog (null, null)
where Operation = 'LOP_DELETE_ROWS'

SELECT 
    Operation,
 
    [Transaction ID],[Begin Time], [Transaction Name],[Transaction SID]
 
FROM
 
    fn_dblog(NULL, NULL)
 
WHERE
 
    [Transaction ID] = '0000:01983b4d' 
 
AND
 
    [Operation] = 'LOP_BEGIN_XACT'

	
USE MASTER
GO 
   
SELECT SUSER_SNAME(0x91AAC13B04C24C40A3398C460BFCB429)
SELECT DMExQryStats.last_execution_time AS [Executed At], DMExSQLTxt.text AS [Query] FROM sys.dm_exec_query_stats AS DMExQryStats CROSS APPLY sys.dm_exec_sql_text(DMExQryStats.sql_handle) AS DMExSQLTxt ORDER BY DMExQryStats.last_execution_time DESC 