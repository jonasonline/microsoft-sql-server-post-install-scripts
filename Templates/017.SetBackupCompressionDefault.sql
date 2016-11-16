USE master;
GO
EXEC sp_configure 'backup compression default', '1';
RECONFIGURE WITH OVERRIDE;
