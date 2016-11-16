EXECUTE sp_configure 'show advanced', 1;
RECONFIGURE;
EXECUTE sp_configure 'Database Mail XPs',1;
RECONFIGURE;
GO

USE [msdb]
GO
EXEC msdb.dbo.sp_set_sqlagent_properties @email_save_in_sent_folder=1, @alert_replace_runtime_tokens=1
GO
EXEC master.dbo.xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'SOFTWARE\Microsoft\MSSQLServer\SQLServerAgent', N'UseDatabaseMail', N'REG_DWORD', 1
GO

USE [msdb]
GO

EXECUTE msdb.dbo.sysmail_add_profile_sp
       @profile_name = 'Automated database mail',
       @description = 'Profile used for administrative mail.' ;
       
EXECUTE msdb.dbo.sysmail_add_account_sp
    @account_name = 'SQL Server production mail',
    @description = 'Mail account for administrative mail.',
    @email_address = '{{email}}',
    @display_name = 'Automated Mailer',
    @mailserver_name = '{{mailserver}}' ;

EXECUTE msdb.dbo.sysmail_add_profileaccount_sp
    @profile_name = 'Automated database mail',
    @account_name = 'SQL Server production mail',
    @sequence_number = 1;

EXECUTE msdb.dbo.sysmail_add_principalprofile_sp
    @profile_name = 'Automated database mail',
    @principal_name = 'public',
    @is_default = 1;
GO

EXECUTE msdb.dbo.sp_send_dbmail
    @subject = 'Test Database Mail Message',
    @recipients = '{{email}}',
    @query = 'SELECT @@SERVERNAME';
GO

USE [msdb]
GO
EXEC master.dbo.xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'SOFTWARE\Microsoft\MSSQLServer\SQLServerAgent', N'DatabaseMailProfile', N'REG_SZ', N'Company automated database mail'
GO
