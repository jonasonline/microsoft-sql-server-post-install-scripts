USE [msdb]
GO

DECLARE @jobId BINARY(16)
EXEC msdb.dbo.sp_add_job @job_name=N'Cycle_Errorlog', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@category_name=N'[misc]', 
		@owner_login_name=N'SA', @job_id = @jobId OUTPUT
select @jobId
GO

DECLARE @ServerName nvarchar(100)
SET @ServerName = CAST(SERVERPROPERTY('servername') as nvarchar(100))

EXEC msdb.dbo.sp_add_jobserver @job_name=N'Cycle_Errorlog', @server_name = @ServerName
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_add_jobstep @job_name=N'Cycle_Errorlog', @step_name=N'Cycle errorlog', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_fail_action=2, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'exec sp_cycle_errorlog', 
		@database_name=N'master', 
		@flags=0
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_update_job @job_name=N'Cycle_Errorlog', 
		@enabled=1, 
		@start_step_id=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@description=N'', 
		@category_name=N'[Misc]', 
		@owner_login_name=N'SA', 
		@notify_email_operator_name=N'', 
		@notify_netsend_operator_name=N'', 
		@notify_page_operator_name=N''
GO
USE [msdb]
GO
DECLARE @schedule_id int
DECLARE @CurrentDate as varchar(20)
SET @CurrentDate = convert(char(8),current_timestamp,112)

EXEC msdb.dbo.sp_add_jobschedule @job_name=N'Cycle_Errorlog', @name=N'Cycle errorlog', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=@CurrentDate, 
		@active_end_date=99991231, 
		@active_start_time=60000, 
		@active_end_time=235959, @schedule_id = @schedule_id OUTPUT
select @schedule_id
GO
