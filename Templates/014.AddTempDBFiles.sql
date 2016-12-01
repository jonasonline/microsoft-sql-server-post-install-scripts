USE [master]

GO

ALTER DATABASE [tempdb] MODIFY FILE ( NAME = N'tempdev', SIZE = 1024000KB , FILEGROWTH = 65536KB )

GO

ALTER DATABASE [tempdb] MODIFY FILE ( NAME = N'templog', SIZE = 512000KB , FILEGROWTH = 65536KB )

GO

DECLARE @CPU_Count int = (SELECT cpu_count FROM sys.dm_os_sys_info), 
		@i int = 1, 
		@LogicalName nvarchar(500),
		@LogicalName_rev nvarchar(500), 
		@PhysicalName nvarchar(500), 
		@SQLCommand nvarchar(2000)

DECLARE @NumberOfExistingTempdbFiles INT

SELECT @NumberOfExistingTempdbFiles = COUNT(*) FROM sys.master_files a
JOIN sys.databases b on a.database_id = b.database_id
WHERE b.name = 'tempdb' AND a.type = 0

SELECT @PhysicalName = REPLACE(physical_name, '.mdf', '.ndf') FROM sys.master_files WHERE name = 'tempdev'
SET @PhysicalName = REPLACE(@PhysicalName, 'tempdb.ndf', 'tempdb_mssql_1.ndf')
SET @LogicalName = N'temp1'

DECLARE @NumberOfFilesToCreate INT = @CPU_Count

IF @NumberOfFilesToCreate > 8
BEGIN
	SET @NumberOfFilesToCreate = 8
END

IF @NumberOfExistingTempdbFiles < @NumberOfFilesToCreate
BEGIN
	WHILE @i < @NumberOfFilesToCreate OR @i <= 8
	BEGIN
		SET @LogicalName_rev = REPLACE(@LogicalName, @i, @i +1)
		SET @PhysicalName = REPLACE(@PhysicalName, @LogicalName, @LogicalName_rev)
		SET @SQLCommand = 'ALTER DATABASE [tempdb] ADD FILE ( NAME = N''' + @LogicalName_rev + ''', FILENAME = N''' + @PhysicalName + ''', SIZE = 1024000KB , FILEGROWTH = 65536KB )'
		EXEC (@SQLCommand)
		SET @i = @i +1
		SET @LogicalName = @LogicalName_rev 
	END
END 
