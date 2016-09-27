USE [master]
GO
EXEC sp_configure 'show advanced option', '1';  
RECONFIGURE WITH OVERRIDE
EXEC sp_configure N'cost threshold for parallelism', N'20'
GO
RECONFIGURE WITH OVERRIDE
GO
