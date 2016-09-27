USE [master]
GO

ALTER DATABASE [tempdb] MODIFY FILE ( NAME = N'tempdev', SIZE = 1024000KB , FILEGROWTH = 512000KB )
GO
ALTER DATABASE [tempdb] MODIFY FILE ( NAME = N'templog', SIZE = 512000KB , FILEGROWTH = 512000KB )
GO

DECLARE @CPU_Count int = (select cpu_count from sys.dm_os_sys_info), 
		@i int = 1, 
		@LogicalName nvarchar(50),
		@LogicalName_rev nvarchar(50), 
		@PhysicalName nvarchar(50), 
		@SQLCommand nvarchar(200)

select @PhysicalName = REPLACE(physical_name, '.mdf', '.ndf') from sys.master_files where name = 'tempdev'
SET @PhysicalName = REPLACE(@PhysicalName, 'tempdb.ndf', 'tempdev1.ndf')

SET @LogicalName = N'tempdev1'


while @i < @CPU_Count
BEGIN
	
	SET @LogicalName_rev = REPLACE(@LogicalName, @i, @i +1)
	SET @PhysicalName = REPLACE(@PhysicalName, @LogicalName, @LogicalName_rev)
	
	SET @SQLCommand = 'ALTER DATABASE [tempdb] ADD FILE ( NAME = N''' + @LogicalName_rev + ''', FILENAME = N''' + @PhysicalName + ''', SIZE = 1024000KB , FILEGROWTH = 512000KB )'
	EXEC (@SQLCommand)
	SET @i = @i +1
	
	SET @LogicalName = @LogicalName_rev 
	
END
