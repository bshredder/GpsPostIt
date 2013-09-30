IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GpiGroup_aspnet_Membership]') AND parent_object_id = OBJECT_ID(N'[dbo].[GpiGroup]'))
ALTER TABLE [dbo].[GpiGroup] DROP CONSTRAINT [FK_GpiGroup_aspnet_Membership]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GpiGroupUser_aspnet_Membership]') AND parent_object_id = OBJECT_ID(N'[dbo].[GpiGroupUser]'))
ALTER TABLE [dbo].[GpiGroupUser] DROP CONSTRAINT [FK_GpiGroupUser_aspnet_Membership]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GpiGroupUser_GpiGroup]') AND parent_object_id = OBJECT_ID(N'[dbo].[GpiGroupUser]'))
ALTER TABLE [dbo].[GpiGroupUser] DROP CONSTRAINT [FK_GpiGroupUser_GpiGroup]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GpiPinTag_GpiPin]') AND parent_object_id = OBJECT_ID(N'[dbo].[GpiPinTag]'))
ALTER TABLE [dbo].[GpiPinTag] DROP CONSTRAINT [FK_GpiPinTag_GpiPin]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GpiPin_aspnet_Membership]') AND parent_object_id = OBJECT_ID(N'[dbo].[GpiPin]'))
ALTER TABLE [dbo].[GpiPin] DROP CONSTRAINT [FK_GpiPin_aspnet_Membership]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GpiPinRating_aspnet_Membership]') AND parent_object_id = OBJECT_ID(N'[dbo].[GpiPinRating]'))
ALTER TABLE [dbo].[GpiPinRating] DROP CONSTRAINT [FK_GpiPinRating_aspnet_Membership]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GpiPinRating_GpiPin]') AND parent_object_id = OBJECT_ID(N'[dbo].[GpiPinRating]'))
ALTER TABLE [dbo].[GpiPinRating] DROP CONSTRAINT [FK_GpiPinRating_GpiPin]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiGetGroupsForUser]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GpiGetGroupsForUser]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiCreateGroup]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GpiCreateGroup]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiAddUserToGroup]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GpiAddUserToGroup]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiRemoveUserFromGroup]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GpiRemoveUserFromGroup]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiGetUsersInGroup]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GpiGetUsersInGroup]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiRemoveGroup]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GpiRemoveGroup]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiGetUserIdFromUserName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GpiGetUserIdFromUserName]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiAuthorPin]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GpiAuthorPin]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiDeleteAllPinsOfAnUser]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GpiDeleteAllPinsOfAnUser]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiGetAttachment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GpiGetAttachment]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiGetPins]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GpiGetPins]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiDeletePins]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GpiDeletePins]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiLoginUser]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GpiLoginUser]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiLogoutUser]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GpiLogoutUser]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiGetPinsFromPinIdList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GpiGetPinsFromPinIdList]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiModifyPin]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GpiModifyPin]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiRatePin]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GpiRatePin]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiGetClientInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GpiGetClientInfo]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiWriteErrorLog]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GpiWriteErrorLog]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiGetErrorLogs]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GpiGetErrorLogs]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiErrorLog]') AND type in (N'U'))
DROP TABLE [dbo].[GpiErrorLog]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiGroup]') AND type in (N'U'))
DROP TABLE [dbo].[GpiGroup]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiLogon]') AND type in (N'U'))
DROP TABLE [dbo].[GpiLogon]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiGroupUser]') AND type in (N'U'))
DROP TABLE [dbo].[GpiGroupUser]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiPinTag]') AND type in (N'U'))
DROP TABLE [dbo].[GpiPinTag]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiClientInfo]') AND type in (N'U'))
DROP TABLE [dbo].[GpiClientInfo]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiAttachment]') AND type in (N'U'))
DROP TABLE [dbo].[GpiAttachment]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiPin]') AND type in (N'U'))
DROP TABLE [dbo].[GpiPin]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CalculateDistanceInKilometers]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[CalculateDistanceInKilometers]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiPinRating]') AND type in (N'U'))
DROP TABLE [dbo].[GpiPinRating]
