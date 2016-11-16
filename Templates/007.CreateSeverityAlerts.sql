USE [msdb]
GO
EXEC msdb.dbo.sp_add_alert @name=N'Severity_14_Alert', 
		@message_id=0, 
		@severity=14, 
		@enabled=1, 
		@delay_between_responses=0, 
		@include_event_description_in=1, 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'Severity_14_Alert', @operator_name=N'Maintenance_SQLOperator', @notification_method = 1
GO

USE [msdb]
GO
EXEC msdb.dbo.sp_add_alert @name=N'Severity_17_Alert', 
		@message_id=0, 
		@severity=17, 
		@enabled=1, 
		@delay_between_responses=900, 
		@include_event_description_in=1, 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'Severity_17_Alert', @operator_name=N'Maintenance_SQLOperator', @notification_method = 1
GO


USE [msdb]
GO
EXEC msdb.dbo.sp_add_alert @name=N'Severity_18_Alert', 
		@message_id=0, 
		@severity=18, 
		@enabled=1, 
		@delay_between_responses=0, 
		@include_event_description_in=1, 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'Severity_18_Alert', @operator_name=N'Maintenance_SQLOperator', @notification_method = 1
GO


USE [msdb]
GO
EXEC msdb.dbo.sp_add_alert @name=N'Severity_19_Alert', 
		@message_id=0, 
		@severity=19, 
		@enabled=1, 
		@delay_between_responses=0, 
		@include_event_description_in=1, 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'Severity_19_Alert', @operator_name=N'Maintenance_SQLOperator', @notification_method = 1
GO

USE [msdb]
GO
EXEC msdb.dbo.sp_add_alert @name=N'Severity_20_Alert', 
		@message_id=0, 
		@severity=20, 
		@enabled=1, 
		@delay_between_responses=0, 
		@include_event_description_in=1, 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'Severity_20_Alert', @operator_name=N'Maintenance_SQLOperator', @notification_method = 1
GO

USE [msdb]
GO
EXEC msdb.dbo.sp_add_alert @name=N'Severity_21_Alert', 
		@message_id=0, 
		@severity=21, 
		@enabled=1, 
		@delay_between_responses=0, 
		@include_event_description_in=1, 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'Severity_21_Alert', @operator_name=N'Maintenance_SQLOperator', @notification_method = 1
GO

USE [msdb]
GO
EXEC msdb.dbo.sp_add_alert @name=N'Severity_22_Alert', 
		@message_id=0, 
		@severity=22, 
		@enabled=1, 
		@delay_between_responses=0, 
		@include_event_description_in=1, 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'Severity_22_Alert', @operator_name=N'Maintenance_SQLOperator', @notification_method = 1
GO

USE [msdb]
GO
EXEC msdb.dbo.sp_add_alert @name=N'Severity_23_Alert', 
		@message_id=0, 
		@severity=23, 
		@enabled=1, 
		@delay_between_responses=0, 
		@include_event_description_in=1, 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'Severity_23_Alert', @operator_name=N'Maintenance_SQLOperator', @notification_method = 1
GO

USE [msdb]
GO
EXEC msdb.dbo.sp_add_alert @name=N'Severity_24_Alert', 
		@message_id=0, 
		@severity=24, 
		@enabled=1, 
		@delay_between_responses=0, 
		@include_event_description_in=1, 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'Severity_24_Alert', @operator_name=N'Maintenance_SQLOperator', @notification_method = 1
GO

USE [msdb]
GO
EXEC msdb.dbo.sp_add_alert @name=N'Severity_25_Alert', 
		@message_id=0, 
		@severity=25, 
		@enabled=1, 
		@delay_between_responses=0, 
		@include_event_description_in=1, 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'Severity_25_Alert', @operator_name=N'Maintenance_SQLOperator', @notification_method = 1
GO

