USE [msdb]
GO

/****** Object:  Trigger [dbo].[Agent_Job_Error]    Script Date: 09/15/2010 11:33:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[Agent_Job_Error]
ON [dbo].[sysjobhistory] 
FOR INSERT
AS
BEGIN

DECLARE @Subject_String NVARCHAR(MAX), 
@Body_String NVARCHAR(MAX),
@Step_status INT,
@Step_Name NVARCHAR(MAX),
@Step_Id INT,
@Job_Name NVARCHAR(MAX)

SET @Step_status = (select run_status from inserted)
SET @Step_Id = (select step_id from inserted)

IF(@Step_status in(0,2,3) AND @Step_Id > 0)
BEGIN

SET @Subject_String = 'SQL Server Agent, Job Error(' + CAST(SERVERPROPERTY('ServerName') AS NVARCHAR(MAX)) + ')'

SELECT @Step_Name = a.step_name, @Job_Name = b.name from inserted a
join dbo.sysjobs b on a.job_id = b.job_id

SET @Body_String = 'The job ' + @Job_Name + ' encountered errors in step ' + @Step_Name

EXEC msdb.dbo.sp_send_dbmail
    @profile_name = 'Automated database mail',
    @recipients = '{{email}}',
    @body = @Body_String,
    @subject = @Subject_String;
END
END


GO
