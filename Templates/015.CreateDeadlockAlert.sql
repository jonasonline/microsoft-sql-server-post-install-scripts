USE [msdb]
GO

BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0

IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Misc]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Misc]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Capture_Deadlock_Response', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Misc]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Send Error Text]    Script Date: 09/03/2010 09:34:00 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Send Deadlock graph', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC msdb.dbo.sp_send_dbmail
    @profile_name = ''Automated database mail'',
    @recipients = ''{{email}}'',
    @body = N''$(ESCAPE_SQUOTE(WMI(TextData)))'' ,
    @subject =  ''Deadlock graph from $(ESCAPE_SQUOTE(WMI(ServerName)))'';


', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO



USE [msdb]
GO

DECLARE @Response_Job_ID uniqueidentifier
DECLARE @WMI_NAMESPACE_PATH varchar(500)


SET @Response_Job_ID = (SELECT job_id from msdb.dbo.sysjobs WHERE name = 'Capture_Deadlock_Response')
SET @WMI_NAMESPACE_PATH = N'\\.\root\Microsoft\SqlServer\ServerEvents\MSSQLSERVER'

IF(CAST(SERVERPROPERTY('InstanceName') as nvarchar(100)) <> 'MSSQLSERVER')
BEGIN
	SET @WMI_NAMESPACE_PATH = REPLACE(@WMI_NAMESPACE_PATH, 'MSSQLSERVER', CAST(SERVERPROPERTY('InstanceName') as nvarchar(100)))
END

EXEC msdb.dbo.sp_add_alert @name=N'Capture_Deadlock', 
		@enabled=1, 
		@delay_between_responses=600, 
		@include_event_description_in=1, 
		@wmi_namespace=@WMI_NAMESPACE_PATH,
		@wmi_query=N'SELECT * FROM DEADLOCK_GRAPH', 
		@job_id=@Response_Job_ID
GO


