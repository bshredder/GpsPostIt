use master
GO
USE [GpsPostIt]
GO
EXEC dbo.sp_changedbowner @loginame = N'GpiAdmin', @map = false
GO
