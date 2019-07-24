drop procedure [dbo].[stpCreate_Trace]
go

CREATE PROCEDURE [dbo].[stpCreate_Trace]
AS
BEGIN
declare @rc int, @TraceID int, @maxfilesize bigint, @on bit, @intfilter int, @bigintfilter bigint
select @on = 1, @maxfilesize = 50

-- Criação do trace
exec @rc = sp_trace_create @TraceID output, 0, N'C:\Trace\SophiA_Analise', @maxfilesize, NULL

if (@rc != 0) goto error

exec sp_trace_setevent @TraceID, 10, 1, @on
exec sp_trace_setevent @TraceID, 10, 6, @on
exec sp_trace_setevent @TraceID, 10, 8, @on
exec sp_trace_setevent @TraceID, 10, 10, @on
exec sp_trace_setevent @TraceID, 10, 11, @on
exec sp_trace_setevent @TraceID, 10, 12, @on
exec sp_trace_setevent @TraceID, 10, 13, @on
exec sp_trace_setevent @TraceID, 10, 14, @on
exec sp_trace_setevent @TraceID, 10, 15, @on
exec sp_trace_setevent @TraceID, 10, 16, @on
exec sp_trace_setevent @TraceID, 10, 17, @on
exec sp_trace_setevent @TraceID, 10, 18, @on
exec sp_trace_setevent @TraceID, 10, 26, @on
exec sp_trace_setevent @TraceID, 10, 35, @on
exec sp_trace_setevent @TraceID, 10, 40, @on
exec sp_trace_setevent @TraceID, 10, 48, @on
exec sp_trace_setevent @TraceID, 10, 64, @on

exec sp_trace_setevent @TraceID, 12, 1, @on
exec sp_trace_setevent @TraceID, 12, 6, @on
exec sp_trace_setevent @TraceID, 12, 8, @on
exec sp_trace_setevent @TraceID, 12, 10, @on
exec sp_trace_setevent @TraceID, 12, 11, @on
exec sp_trace_setevent @TraceID, 12, 12, @on
exec sp_trace_setevent @TraceID, 12, 13, @on
exec sp_trace_setevent @TraceID, 12, 14, @on
exec sp_trace_setevent @TraceID, 12, 15, @on
exec sp_trace_setevent @TraceID, 12, 16, @on
exec sp_trace_setevent @TraceID, 12, 17, @on
exec sp_trace_setevent @TraceID, 12, 18, @on
exec sp_trace_setevent @TraceID, 12, 26, @on
exec sp_trace_setevent @TraceID, 12, 35, @on
exec sp_trace_setevent @TraceID, 12, 40, @on
exec sp_trace_setevent @TraceID, 12, 48, @on
exec sp_trace_setevent @TraceID, 12, 64, @on

exec sp_trace_setevent @TraceID, 13, 1, @on
exec sp_trace_setevent @TraceID, 13, 6, @on
exec sp_trace_setevent @TraceID, 13, 8, @on
exec sp_trace_setevent @TraceID, 13, 10, @on
exec sp_trace_setevent @TraceID, 13, 11, @on
exec sp_trace_setevent @TraceID, 13, 12, @on
exec sp_trace_setevent @TraceID, 13, 13, @on
exec sp_trace_setevent @TraceID, 13, 14, @on
exec sp_trace_setevent @TraceID, 13, 15, @on
exec sp_trace_setevent @TraceID, 13, 16, @on
exec sp_trace_setevent @TraceID, 13, 17, @on
exec sp_trace_setevent @TraceID, 13, 18, @on
exec sp_trace_setevent @TraceID, 13, 26, @on
exec sp_trace_setevent @TraceID, 13, 35, @on
exec sp_trace_setevent @TraceID, 13, 40, @on
exec sp_trace_setevent @TraceID, 13, 48, @on
exec sp_trace_setevent @TraceID, 13, 64, @on

exec sp_trace_setevent @TraceID, 14, 1, @on
exec sp_trace_setevent @TraceID, 14, 6, @on
exec sp_trace_setevent @TraceID, 14, 8, @on
exec sp_trace_setevent @TraceID, 14, 10, @on
exec sp_trace_setevent @TraceID, 14, 11, @on
exec sp_trace_setevent @TraceID, 14, 12, @on
exec sp_trace_setevent @TraceID, 14, 13, @on
exec sp_trace_setevent @TraceID, 14, 14, @on
exec sp_trace_setevent @TraceID, 14, 15, @on
exec sp_trace_setevent @TraceID, 14, 16, @on
exec sp_trace_setevent @TraceID, 14, 17, @on
exec sp_trace_setevent @TraceID, 14, 18, @on
exec sp_trace_setevent @TraceID, 14, 26, @on
exec sp_trace_setevent @TraceID, 14, 35, @on
exec sp_trace_setevent @TraceID, 14, 40, @on
exec sp_trace_setevent @TraceID, 14, 48, @on
exec sp_trace_setevent @TraceID, 14, 64, @on

exec sp_trace_setevent @TraceID, 15, 1, @on
exec sp_trace_setevent @TraceID, 15, 6, @on
exec sp_trace_setevent @TraceID, 15, 8, @on
exec sp_trace_setevent @TraceID, 15, 10, @on
exec sp_trace_setevent @TraceID, 15, 11, @on
exec sp_trace_setevent @TraceID, 15, 12, @on
exec sp_trace_setevent @TraceID, 15, 13, @on
exec sp_trace_setevent @TraceID, 15, 14, @on
exec sp_trace_setevent @TraceID, 15, 15, @on
exec sp_trace_setevent @TraceID, 15, 16, @on
exec sp_trace_setevent @TraceID, 15, 17, @on
exec sp_trace_setevent @TraceID, 15, 18, @on
exec sp_trace_setevent @TraceID, 15, 26, @on
exec sp_trace_setevent @TraceID, 15, 35, @on
exec sp_trace_setevent @TraceID, 15, 40, @on
exec sp_trace_setevent @TraceID, 15, 48, @on
exec sp_trace_setevent @TraceID, 15, 64, @on

/*set @bigintfilter = 3000000 -- 3 segundos
exec sp_trace_setfilter @TraceID, 13, 0, 4, @bigintfilter */

-- Set the trace status to start
exec sp_trace_setstatus @TraceID, 1

goto finish

error:
select ErrorCode=@rc

finish:
END

GO
-- Rodando a stored procedure para criar o trace.

exec dbo.stpCreate_Trace 




