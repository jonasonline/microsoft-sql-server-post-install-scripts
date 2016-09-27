USE [msdb]
GO
EXEC msdb.dbo.sp_add_alert @name=N'Error_825_Alert', 
		@message_id=825, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=0, 
		@include_event_description_in=1, 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'Error_825_Alert', @operator_name=N'Maintenance_SQLOperator', @notification_method = 1
GO
