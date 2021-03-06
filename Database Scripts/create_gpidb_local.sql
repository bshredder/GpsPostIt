USE [master]
GO
/****** Object:  Database [GpsPostIt]    Script Date: 06/21/2007 20:55:52 ******/
CREATE DATABASE [GpsPostIt] ON  PRIMARY 
( NAME = N'GpsPostIt', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL.2\MSSQL\DATA\GpsPostIt.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'GpsPostIt_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL.2\MSSQL\DATA\GpsPostIt_log.ldf' , SIZE = 1536KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
 COLLATE SQL_Latin1_General_CP1_CI_AS
GO
EXEC dbo.sp_dbcmptlevel @dbname=N'GpsPostIt', @new_cmptlevel=90
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [GpsPostIt].[dbo].[sp_fulltext_database] @action = 'disable'
end
GO
ALTER DATABASE [GpsPostIt] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [GpsPostIt] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [GpsPostIt] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [GpsPostIt] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [GpsPostIt] SET ARITHABORT OFF 
GO
ALTER DATABASE [GpsPostIt] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [GpsPostIt] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [GpsPostIt] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [GpsPostIt] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [GpsPostIt] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [GpsPostIt] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [GpsPostIt] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [GpsPostIt] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [GpsPostIt] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [GpsPostIt] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [GpsPostIt] SET  ENABLE_BROKER 
GO
ALTER DATABASE [GpsPostIt] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [GpsPostIt] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [GpsPostIt] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [GpsPostIt] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [GpsPostIt] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [GpsPostIt] SET  READ_WRITE 
GO
ALTER DATABASE [GpsPostIt] SET RECOVERY FULL 
GO
ALTER DATABASE [GpsPostIt] SET  MULTI_USER 
GO
ALTER DATABASE [GpsPostIt] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [GpsPostIt] SET DB_CHAINING OFF 