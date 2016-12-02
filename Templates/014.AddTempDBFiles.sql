USE [master]
GO
ALTER DATABASE [tempdb] MODIFY FILE ( NAME = N'tempdev', SIZE = 1024000KB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [tempdb] MODIFY FILE ( NAME = N'templog', SIZE = 512000KB , FILEGROWTH = 65536KB )
GO

DECLARE @CPU_Count int = (SELECT cpu_count FROM sys.dm_os_sys_info), 
		@i int = 1,
		@LogicalName nvarchar(500),
		@BaseLogicalName nvarchar(500), 
		@BaseLogicalName_rev nvarchar(500), 
		@PhysicalName nvarchar(500),
		@BasePhysicalName nvarchar(500),
		@BasePhysicalName_rev nvarchar(500), 
		@SQLCommand nvarchar(2000),
		@MaxNumberOfFiles int = 8

DECLARE @NumberOfExistingTempdbFiles INT

SELECT @NumberOfExistingTempdbFiles = COUNT(*) FROM sys.master_files a
JOIN sys.databases b on a.database_id = b.database_id
WHERE b.name = 'tempdb' AND a.type = 0

SELECT @PhysicalName = REPLACE(physical_name, '.mdf', '.ndf') FROM sys.master_files WHERE name = 'tempdev'
SET @BasePhysicalName = N'tempdb_mssql_' + CAST(@NumberOfExistingTempdbFiles AS nvarchar(200)) + '.ndf'
SET @PhysicalName = REPLACE(@PhysicalName, 'tempdb.ndf', @BasePhysicalName)
SET @BaseLogicalName = N'temp' + CAST(@NumberOfExistingTempdbFiles AS nvarchar(200))
SET @LogicalName = @BaseLogicalName

DECLARE @NumberOfFilesToCreate INT = @CPU_Count
IF @NumberOfFilesToCreate > @MaxNumberOfFiles
BEGIN
	SET @NumberOfFilesToCreate = @MaxNumberOfFiles
END
SET @NumberOfFilesToCreate = @NumberOfFilesToCreate - @NumberOfExistingTempdbFiles
BEGIN
	WHILE @i <= @NumberOfFilesToCreate
	BEGIN
		SET @BaseLogicalName_rev = REPLACE(@BaseLogicalName, @NumberOfExistingTempdbFiles + @i -1, @i + @NumberOfExistingTempdbFiles)
		SET @BasePhysicalName_rev = REPLACE(@BasePhysicalName, @NumberOfExistingTempdbFiles + @i -1, @i + @NumberOfExistingTempdbFiles)
		SET @LogicalName = REPLACE(@LogicalName, @LogicalName, @BaseLogicalName_rev)
		SET @PhysicalName = REPLACE(@PhysicalName, @BasePhysicalName, @BasePhysicalName_rev)
		PRINT @LogicalName + ' ' + @PhysicalName
		SET @SQLCommand = 'ALTER DATABASE [tempdb] ADD FILE ( NAME = N''' + @LogicalName + ''', FILENAME = N''' + @PhysicalName + ''', SIZE = 1024000KB , FILEGROWTH = 65536KB )'
		EXEC (@SQLCommand)
		SET @i = @i +1
		SET @BaseLogicalName = @BaseLogicalName_rev 
		SET @BasePhysicalName = @BasePhysicalName_rev
	END
END 
