/****** Object:  Login [gpi_adm]    Script Date: 06/21/2007 21:12:44 ******/
IF  EXISTS (SELECT * FROM sys.server_principals WHERE name = N'GpiAdmin')
DROP LOGIN [GpiAdmin]