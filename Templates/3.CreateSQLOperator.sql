USE [msdb]
GO

/****** Object:  Operator [Maintenance_SQLOperator]    Script Date: 08/23/2010 14:02:23 ******/
EXEC msdb.dbo.sp_add_operator @name=N'Maintenance_SQLOperator', 
		@enabled=1, 
		@weekday_pager_start_time=90000, 
		@weekday_pager_end_time=180000, 
		@saturday_pager_start_time=90000, 
		@saturday_pager_end_time=180000, 
		@sunday_pager_start_time=90000, 
		@sunday_pager_end_time=180000, 
		@pager_days=0, 
		@email_address=N'{{email}}', 
		@category_name=N'[Uncategorized]'
GO
