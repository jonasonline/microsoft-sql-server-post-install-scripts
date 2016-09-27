USE [master]
CREATE DATABASE [MaintenanceDB]
GO
USE [master]
GO
ALTER DATABASE [MaintenanceDB] SET RECOVERY SIMPLE WITH NO_WAIT
GO
USE [MaintenanceDB]
GO
EXEC dbo.sp_changedbowner @loginame = N'sa', @map = false
GO
