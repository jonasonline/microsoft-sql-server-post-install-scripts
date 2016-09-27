USE [master]
GO
EXEC sys.sp_configure N'cost threshold for parallelism', N'20'
GO
RECONFIGURE WITH OVERRIDE
GO
