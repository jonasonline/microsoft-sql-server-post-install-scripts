USE [msdb]
GO
EXEC msdb.dbo.sp_set_sqlagent_properties @cpu_poller_enabled=1
GO
