SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiClientInfo]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[GpiClientInfo](
	[PinId] [uniqueidentifier] NOT NULL,
	[HostAddress] [nvarchar](255) NULL,
	[HostName] [nvarchar](255) NULL,
	[RawUrl] [nvarchar](255) NULL,
	[HttpMethod] [nvarchar](255) NULL,
	[IsSecureConnection] [tinyint] NULL,
	[TotalBytes] [int] NULL,
	[RawUserAgentStr] [nvarchar](255) NULL,
	[UserAgentStr] [nvarchar](255) NULL,
	[Platform] [nvarchar](255) NULL,
	[BrowserMajorVersion] [int] NULL,
	[BrowserMinorVersion] [float] NULL,
	[MobileDeviceManufacturer] [nvarchar](255) NULL,
	[MobileDeviceModel] [nvarchar](255) NULL,
 CONSTRAINT [PK_GpiClientInfo] PRIMARY KEY CLUSTERED 
(
	[PinId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiAttachment]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[GpiAttachment](
	[PinId] [uniqueidentifier] NOT NULL,
	[Attachment] [text] NOT NULL,
	[AttachmentId] [char](255) NOT NULL CONSTRAINT [DF_tattachment_attachment_id]  DEFAULT (newid()),
	[Name] [nvarchar](255) NULL,
	[Type] [varchar](255) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[GpiAttachment]') AND name = N'IX_attachment_id')
CREATE NONCLUSTERED INDEX [IX_attachment_id] ON [dbo].[GpiAttachment] 
(
	[AttachmentId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[GpiAttachment]') AND name = N'IX_pin_id')
CREATE NONCLUSTERED INDEX [IX_pin_id] ON [dbo].[GpiAttachment] 
(
	[PinId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiLogon]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[GpiLogon](
	[InstanceID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_gpi_Logon_InstanceID]  DEFAULT (newsequentialid()),
	[UserId] [uniqueidentifier] NOT NULL,
	[ValidationToken_S] [varchar](max) NOT NULL,
	[ValidationToken] [varchar](max) NOT NULL,
	[LastActivity] [timestamp] NULL,
 CONSTRAINT [PK_gpi_Logon] PRIMARY KEY CLUSTERED 
(
	[InstanceID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiGetClientInfo]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'










-- =============================================
-- Author:		Sougata Sarkar
-- Create date: 12/3/2008
-- Description:	Gets client demographic 
--	information from the database.
-- =============================================
CREATE PROCEDURE [dbo].[GpiGetClientInfo] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRY
		SELECT * FROM GpiClientInfo
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION

		-- Raise an error with the details of the exception
		DECLARE @errMsg nvarchar(4000), @errSeverity int
		SELECT @errMsg = ERROR_MESSAGE(), @errSeverity = ERROR_SEVERITY()

		RAISERROR(@errMsg, @errSeverity, 1)
	END CATCH
END























' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiWriteErrorLog]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'






-- =============================================
-- Author:		Sougata Sarkar
-- Create date: 12/4/2008
-- Description:	Records error log information
--				into the database.
-- =============================================
CREATE PROCEDURE [dbo].[GpiWriteErrorLog] 
	-- Add the parameters for the stored procedure here
	@errorMessage as nvarchar(MAX),
	@hostAddress as nvarchar(255),
	@hostName as nvarchar(255),
	@rawUrl as nvarchar(255),
	@httpMethod as nvarchar(255),
	@isSecureConnection as tinyint,
	@totalBytes as int,
	@rawUserAgentStr as nvarchar(255),
	@userAgentStr as nvarchar(255),
	@platform as nvarchar(255),
	@browserMajorVersion as int,
	@browserMinorVersion as float,
	@mobileDeviceManufacturer as nvarchar(255),
	@mobileDeviceModel as nvarchar(255),
	@createTime as datetime,
	@createTimeInDb as datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	BEGIN TRY
		INSERT INTO GpiErrorLog(ErrorMessage, HostAddress, HostName, RawUrl, HttpMethod, IsSecureConnection, TotalBytes,
			RawUserAgentStr, UserAgentStr, Platform, BrowserMajorVersion, BrowserMinorVersion,
			MobileDeviceManufacturer, MobileDeviceModel, CreateTime, CreateTimeInDb) VALUES (@errorMessage, @hostAddress,
			@hostName, @rawUrl, @httpMethod, @isSecureConnection, @totalBytes, @rawUserAgentStr, @userAgentStr,
			@platform, @browserMajorVersion, @browserMinorVersion, @mobileDeviceManufacturer, @mobileDeviceModel,
			@createTime, @createTimeInDb);

	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION

		-- Raise an error with the details of the exception
		DECLARE @errMsg nvarchar(4000), @errSeverity int
		SELECT @errMsg = ERROR_MESSAGE(), @errSeverity = ERROR_SEVERITY()

		RAISERROR(@errMsg, @errSeverity, 1)
	END CATCH
END





















' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiGetErrorLogs]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'











-- =============================================
-- Author:		Sougata Sarkar
-- Create date: 12/3/2008
-- Description:	Gets error logs from the database.
-- =============================================
CREATE PROCEDURE [dbo].[GpiGetErrorLogs] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRY
		SELECT * FROM GpiErrorLog
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION

		-- Raise an error with the details of the exception
		DECLARE @errMsg nvarchar(4000), @errSeverity int
		SELECT @errMsg = ERROR_MESSAGE(), @errSeverity = ERROR_SEVERITY()

		RAISERROR(@errMsg, @errSeverity, 1)
	END CATCH
END
























' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CalculateDistanceInKilometers]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'

-- =============================================
-- Author:		Bill Schroeder
-- Create date: 12/7/2008
-- Description:	Returns distance in kilometers
--			between two pairs of latitude/longitude 
-- =============================================
CREATE FUNCTION [dbo].[CalculateDistanceInKilometers] 
(
	@Lat1 real, 
    @Long1 real,
    @Lat2 real,
    @Long2 real
)
RETURNS real
AS
BEGIN
    DECLARE @Lat1AsRadian real; 
	SET @Lat1AsRadian = @Lat1 * PI() / 180;
    DECLARE @Lat2AsRadian real;
	SET @Lat2AsRadian = @lat2 * PI() / 180;

    DECLARE @dLat real;
	SET @dLat = (@Lat2 - @Lat1) * PI() / 180;
    DECLARE @dLon real;
	SET @dLon = (@Long2 - @Long1) * PI() / 180;

    DECLARE @distance1 real;
	SET @distance1 = Sin(@dLat/2) * Sin(@dLat/2) + Cos(@Lat1AsRadian) * Cos(@Lat2AsRadian) * Sin(@dLon/2) * Sin(@dLon/2);
    DECLARE @distance2 real;
	SET @distance2 = 2 * Atn2(Sqrt(@distance1), Sqrt(1 - @distance1));

    /* Earth radius in KM = 6371 */
    DECLARE @Distance real;
	SET @Distance =  ( 6371 * @distance2 );
    
	RETURN @Distance
END

' 
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiErrorLog]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[GpiErrorLog](
	[LogId] [uniqueidentifier] NOT NULL CONSTRAINT [DF_GpiErrorLog_LogId]  DEFAULT (newsequentialid()),
	[ErrorMessage] [nvarchar](max) NULL,
	[HostAddress] [nvarchar](255) NULL,
	[HostName] [nvarchar](255) NULL,
	[RawUrl] [nvarchar](255) NULL,
	[HttpMethod] [nvarchar](255) NULL,
	[IsSecureConnection] [tinyint] NULL,
	[TotalBytes] [int] NULL,
	[RawUserAgentStr] [nvarchar](255) NULL,
	[UserAgentStr] [nvarchar](255) NULL,
	[Platform] [nvarchar](255) NULL,
	[BrowserMajorVersion] [int] NULL,
	[BrowserMinorVersion] [float] NULL,
	[MobileDeviceManufacturer] [nvarchar](255) NULL,
	[MobileDeviceModel] [nvarchar](255) NULL,
	[CreateTime] [datetime] NULL,
	[CreateTimeInDb] [datetime] NULL,
 CONSTRAINT [PK_GpiErrorLog] PRIMARY KEY CLUSTERED 
(
	[LogId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiPinTag]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[GpiPinTag](
	[TagName] [nvarchar](255) NOT NULL,
	[PinId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_gpi_Pin_Tag] PRIMARY KEY CLUSTERED 
(
	[TagName] ASC,
	[PinId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiPinRating]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[GpiPinRating](
	[RatingId] [uniqueidentifier] NOT NULL CONSTRAINT [DF_GpiPinRating_RatingId]  DEFAULT (newsequentialid()),
	[Evaluator] [uniqueidentifier] NOT NULL,
	[RatedPinId] [uniqueidentifier] NOT NULL,
	[NumStars] [smallint] NOT NULL CONSTRAINT [DF_GpiPinRating_NumStars]  DEFAULT ((0)),
 CONSTRAINT [PK_GpiPinRating] PRIMARY KEY CLUSTERED 
(
	[RatingId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[GpiPinRating]') AND name = N'IX_GpiPinRating')
CREATE NONCLUSTERED INDEX [IX_GpiPinRating] ON [dbo].[GpiPinRating] 
(
	[RatedPinId] ASC,
	[Evaluator] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiGroupUser]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[GpiGroupUser](
	[GroupName] [nvarchar](255) NOT NULL,
	[GroupCreator] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_GpiGroupUser] PRIMARY KEY CLUSTERED 
(
	[GroupName] ASC,
	[GroupCreator] ASC,
	[UserId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiGroup]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[GpiGroup](
	[Name] [nvarchar](255) NOT NULL,
	[Creator] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_GpiGroup] PRIMARY KEY CLUSTERED 
(
	[Name] ASC,
	[Creator] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiPin]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[GpiPin](
	[PinId] [uniqueidentifier] NOT NULL CONSTRAINT [DF__tpin__pin_id__0DAF0CB0]  DEFAULT (newsequentialid()),
	[Title] [nvarchar](255) NOT NULL,
	[Message] [nvarchar](max) NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[Latitude] [float] NOT NULL,
	[Longitude] [float] NOT NULL,
	[Author] [nvarchar](255) NOT NULL,
	[TagList] [nvarchar](max) NOT NULL,
	[AverageRating] [numeric](4, 2) NOT NULL CONSTRAINT [DF_GpiPin_AverageRating]  DEFAULT ((0)),
	[TotalEvaluations] [bigint] NOT NULL CONSTRAINT [DF_GpiPin_TotalEvaluations]  DEFAULT ((0)),
	[CreateTime] [datetime] NOT NULL,
	[ModifyTime] [datetime] NOT NULL,
	[CreateTimeInDb] [datetime] NOT NULL,
	[ModifyTimeInDb] [datetime] NOT NULL,
 CONSTRAINT [PK_tpin] PRIMARY KEY CLUSTERED 
(
	[PinId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[GpiPin]') AND name = N'IX_user_id')
CREATE NONCLUSTERED INDEX [IX_user_id] ON [dbo].[GpiPin] 
(
	[UserId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiGetUsersInGroup]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


















-- =============================================
-- Author:		Sougata Sarkar
-- Create date: 5/18/2009
-- Description:	Gets all users in a group.
-- =============================================
CREATE PROCEDURE [dbo].[GpiGetUsersInGroup] 
	-- Add the parameters for the stored procedure here
	@userId uniqueidentifier,
	@unsecuredServicesValidationToken nvarchar(MAX),
	@groupName nvarchar(255)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	-- Validate User
	IF NOT EXISTS (SELECT UserId FROM GpiLogon WHERE UserId = @userId and ValidationToken = @unsecuredServicesValidationToken)
	BEGIN
		RAISERROR(''NOT_LOGGED_IN'', 16, 1)
		RETURN;
	END

	BEGIN TRY
		BEGIN TRANSACTION

		SELECT u.UserName AS UserName, u.UserId AS UserId FROM GpiGroupUser gu, aspnet_Users u
			WHERE gu.GroupName = @groupName
			AND u.UserId = gu.UserId

		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION

		-- Raise an error with the details of the exception
		DECLARE @errMsg nvarchar(4000), @errSeverity int
		SELECT @errMsg = ERROR_MESSAGE(), @errSeverity = ERROR_SEVERITY()

		RAISERROR(@errMsg, @errSeverity, 1)
	END CATCH
END































' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiGetUserIdFromUserName]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'



-- =============================================
-- Author:		Sougata Sarkar
-- Create date: 6/28/2007
-- Description:	Gets user id from a user name.
-- =============================================
CREATE PROCEDURE [dbo].[GpiGetUserIdFromUserName] 
	-- Add the parameters for the stored procedure here
	@userName as nvarchar(255)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT TOP 1 u.UserId
        FROM    dbo.aspnet_Users u
        WHERE   LOWER(@userName) = u.LoweredUserName

        IF (@@ROWCOUNT = 0) -- Username not found
            RETURN -1
END




' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiAuthorPin]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'









-- =============================================
-- Author:		Sougata Sarkar
-- Create date: 6/28/2007
-- Description:	Inserts pin into database.
-- =============================================
CREATE PROCEDURE [dbo].[GpiAuthorPin] 
	-- Add the parameters for the stored procedure here
	@userId uniqueidentifier,
	@securedServicesValidationToken varchar(MAX),
	@title nvarchar(255), 
	@message nvarchar(MAX),
	@latitude float,
	@longitude float,
	@hasAttachment bit,
	@attachment text,
	@attachmentName nvarchar(MAX),
	@attachmentType varchar(MAX),
	@tags nvarchar(MAX),
	@createTime as datetime,
	@createTimeInDb as datetime,
	@hostAddress as nvarchar(255),
	@hostName as nvarchar(255),
	@rawUrl as nvarchar(255),
	@httpMethod as nvarchar(255),
	@isSecureConnection as tinyint,
	@totalBytes as int,
	@rawUserAgentStr as nvarchar(255),
	@userAgentStr as nvarchar(255),
	@platform as nvarchar(255),
	@browserMajorVersion as int,
	@browserMinorVersion as float,
	@mobileDeviceManufacturer as nvarchar(255),
	@mobileDeviceModel as nvarchar(255)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	-- Validate User
	IF NOT EXISTS(SELECT UserId FROM GpiLogon WHERE UserId = @userId AND ValidationToken_S = @securedServicesValidationToken)
	BEGIN
		RAISERROR(''NOT_LOGGED_IN'', 16, 1)
		RETURN;
	END

	BEGIN TRY
		BEGIN TRANSACTION
		-- Find author of pin by name
		DECLARE @author varchar(255);
		SET @author = ISNULL((SELECT TOP 1 LoweredUserName FROM aspnet_Users AS tu WHERE tu.UserId = @userId), ''unknown127'');
		--SET @author = ISNULL((SELECT TOP 1 LoweredUserName FROM aspnet_Users AS tu WHERE 1 <> 1), ''unknown127'');

		-- Insert pin into database
		DECLARE @tInsertedPin TABLE 
			(PinId uniqueidentifier,
			AttachmentId char(60),
			TagName nvarchar(400));

		DECLARE @tagList nvarchar(MAX)
		SET @tagList = REPLACE(@tags, '','', '' '')

		-- Generate an attachment Id if an attachment is present and insert attachment into database too,
		-- else just insert pin
		INSERT GpiPin (Title, Message, UserId, Latitude, Longitude, Author, TagList, CreateTime, ModifyTime, CreateTimeInDb, ModifyTimeInDb)
			OUTPUT inserted.PinId, CONVERT(char(36), inserted.PinId) + ''_'' + REPLACE(CONVERT(varchar, GETDATE(),111),''/'','''') + REPLACE(CONVERT(varchar, GETDATE(),14),'':'','''') INTO @tInsertedPin(PinId, AttachmentId)
			VALUES (@title, @message, @userId, @latitude, @longitude, @author, @tagList, @createTime, @createTime, @createTimeInDb, @createTimeInDb);
	
		IF @hasAttachment = 1
		BEGIN
			INSERT GpiAttachment
				SELECT TOP 1 PinId, @attachment, AttachmentId, @attachmentName, @attachmentType FROM @tInsertedPin 
		END
		
		-- Insert tags into database and link pins to tags
		DECLARE @tag nvarchar(400)
		DECLARE @pos int

		SET @tags = LTRIM(RTRIM(@tags)) + '',''
		SET @pos = CHARINDEX('','', @tags, 1)

		IF REPLACE(@tags, '','', '''') <> ''''
		BEGIN
			WHILE @pos > 0
			BEGIN
				SET @tag = LTRIM(RTRIM(LEFT(@tags, @pos - 1)))
				IF @tag <> ''''
				BEGIN
					UPDATE @tInsertedPin
						SET TagName = @tag
					INSERT GpiPinTag (PinId, TagName)
					SELECT TOP 1 PinId, TagName FROM @tInsertedPin  
					--SELECT TOP 1 ''npo'', TagName FROM @tInsertedPin
				END
				SET @tags = RIGHT(@tags, LEN(@tags) - @pos)
				SET @pos = CHARINDEX('','', @tags, 1)
			END
		END
		-- Every pin has a default tag called #any#
		INSERT GpiPinTag (PinId, TagName) SELECT TOP 1 PinId, ''#any#'' FROM @tInsertedPin
		
		COMMIT TRANSACTION

		-- Update client information outside of transaction since recording
		-- of client information may be lossy and should not cause a rollback if it
		-- should fail
		DECLARE @newPinId UNIQUEIDENTIFIER
		SET @newPinId = (SELECT TOP 1 PinId FROM @tInsertedPin)
		INSERT INTO GpiClientInfo(PinId, HostAddress, HostName, RawUrl, HttpMethod, IsSecureConnection, TotalBytes,
			RawUserAgentStr, UserAgentStr, Platform, BrowserMajorVersion, BrowserMinorVersion,
			MobileDeviceManufacturer, MobileDeviceModel) VALUES (@newPinId, @hostAddress,
			@hostName, @rawUrl, @httpMethod, @isSecureConnection, @totalBytes, @rawUserAgentStr, @userAgentStr,
			@platform, @browserMajorVersion, @browserMinorVersion, @mobileDeviceManufacturer, @mobileDeviceModel);

		SELECT TOP 1 PinId, @title AS Title, @message AS Message, @latitude AS Latitude, @longitude AS Longitude, @attachmentName AS AttachmentName, @attachmentType AS AttachmentType, AttachmentId, @author AS Author,
			@tagList AS TagList, 
			0 as AverageRating, 0 as TotalEvaluations, 
			@createTime AS CreateTime, @createTime AS ModifyTime, @createTimeInDb AS CreateTimeInDb, @createTimeInDb AS ModifyTimeInDb 
			FROM @tInsertedPin 
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION

		-- Raise an error with the details of the exception
		DECLARE @errMsg nvarchar(4000), @errSeverity int
		SELECT @errMsg = ERROR_MESSAGE(), @errSeverity = ERROR_SEVERITY()

		RAISERROR(@errMsg, @errSeverity, 1)
	END CATCH
END
























' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiAddUserToGroup]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'










-- =============================================
-- Author:		Sougata Sarkar
-- Create date: 5/18/2009
-- Description:	Adds an user to a group.
-- =============================================
CREATE PROCEDURE [dbo].[GpiAddUserToGroup] 
	-- Add the parameters for the stored procedure here
	@creator uniqueidentifier,
	@securedServicesValidationToken varchar(MAX),
	@userName nvarchar(255),
	@groupName nvarchar(255)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	-- Validate User
	IF NOT EXISTS(SELECT UserId FROM GpiLogon WHERE UserId = @creator AND ValidationToken_S = @securedServicesValidationToken)
	BEGIN
		RAISERROR(''NOT_LOGGED_IN'', 16, 1)
		RETURN;
	END

	-- Check that the creator owns the group
	IF NOT EXISTS(SELECT * FROM GpiGroup WHERE Creator = @creator AND Name = @groupName)
	BEGIN
		RAISERROR(''CANNOT_ADD_USER_TO_UNOWNED_GROUP'', 16, 1)
		RETURN;
	END

	-- Add the user to the group
	BEGIN TRY
		BEGIN TRANSACTION

		-- Get userId for this userName
		DECLARE @userId uniqueidentifier;
		SET @userId = (SELECT TOP 1 UserId FROM aspnet_Users WHERE UserName = @userName);
		IF @userId IS NULL
		BEGIN
			IF @@TRANCOUNT > 0
				ROLLBACK TRANSACTION

			RAISERROR(''USER_NOT_FOUND'', 16, 1)
			RETURN;		
		END	

		IF NOT EXISTS(SELECT * FROM GpiGroupUser WHERE GroupName = @groupName AND GroupCreator = @creator AND UserId = @userId)
		BEGIN
			INSERT GpiGroupUser (GroupName, GroupCreator, UserId) VALUES (@groupName, @creator, @userId);
		END
	
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION

		-- Raise an error with the details of the exception
		DECLARE @errMsg nvarchar(4000), @errSeverity int
		SELECT @errMsg = ERROR_MESSAGE(), @errSeverity = ERROR_SEVERITY()

		RAISERROR(@errMsg, @errSeverity, 1)
	END CATCH
END

























' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiRemoveUserFromGroup]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'











-- =============================================
-- Author:		Sougata Sarkar
-- Create date: 5/18/2009
-- Description:	Removes a user from a group.
-- =============================================
CREATE PROCEDURE [dbo].[GpiRemoveUserFromGroup] 
	-- Add the parameters for the stored procedure here
	@creator uniqueidentifier,
	@securedServicesValidationToken varchar(MAX),
	@userName nvarchar(255),
	@groupName nvarchar(255)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	-- Validate User
	IF NOT EXISTS(SELECT UserId FROM GpiLogon WHERE UserId = @creator AND ValidationToken_S = @securedServicesValidationToken)
	BEGIN
		RAISERROR(''NOT_LOGGED_IN'', 16, 1)
		RETURN;
	END

	-- Check that the creator owns the group
	IF NOT EXISTS(SELECT * FROM GpiGroup WHERE Creator = @creator AND Name = @groupName)
	BEGIN
		RAISERROR(''CANNOT_REMOVE_USER_FROM_UNOWNED_GROUP'', 16, 1)
		RETURN;
	END

	-- Add the user to the group
	BEGIN TRY
		BEGIN TRANSACTION

		-- Get userId for this userName
		DECLARE @userId uniqueidentifier;
		SET @userId = (SELECT TOP 1 UserId FROM aspnet_Users WHERE UserName = @userName);
		IF @userId IS NULL
		BEGIN
			IF @@TRANCOUNT > 0
				ROLLBACK TRANSACTION

			RAISERROR(''USER_NOT_FOUND'', 16, 1)
			RETURN;		
		END	

		DELETE FROM GpiGroupUser WHERE GroupName = @groupName AND GroupCreator = @creator AND UserId = @userId;
	
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION

		-- Raise an error with the details of the exception
		DECLARE @errMsg nvarchar(4000), @errSeverity int
		SELECT @errMsg = ERROR_MESSAGE(), @errSeverity = ERROR_SEVERITY()

		RAISERROR(@errMsg, @errSeverity, 1)
	END CATCH
END


























' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiGetPins]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

















-- =============================================
-- Author:		Sougata Sarkar
-- Create date: 6/28/2007
-- Description:	Gets pins from the database that
-- match a set of tags.
-- =============================================
CREATE PROCEDURE [dbo].[GpiGetPins] 
	-- Add the parameters for the stored procedure here
	@userId uniqueidentifier,
	@unsecuredServicesValidationToken nvarchar(MAX),
	@latitude float,
	@longitude float,
	@range float,
	@tags as nvarchar(MAX),
	@startTime as datetime,
	@endTime as datetime,
	@pagerStartPosition as bigint,
	@pageSize as smallint,
	@pagingDirection as smallint,
	@pinOrder as smallint,
	@validateUser as tinyint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	-- Validate User
	IF @validateUser = 1
	BEGIN
		IF NOT EXISTS (SELECT UserId FROM GpiLogon WHERE UserId = @userId and ValidationToken = @unsecuredServicesValidationToken)
		BEGIN
			RAISERROR(''NOT_LOGGED_IN'', 16, 1)
			RETURN;
		END
	END

	BEGIN TRY
		BEGIN TRANSACTION

		-- Parse tags
		DECLARE @tTags TABLE (TagName nvarchar(400));
		DECLARE @tag nvarchar(400)
		DECLARE @pos int
		DECLARE @noTags bit
		SET @noTags = 0

		SET @tags = LTRIM(RTRIM(@tags)) + '',''
		SET @pos = CHARINDEX('','', @tags, 1)

		IF REPLACE(@tags, '','', '''') <> ''''
		BEGIN
			WHILE @pos > 0
			BEGIN
				SET @tag = LTRIM(RTRIM(LEFT(@tags, @pos - 1)))
				IF @tag <> ''''
				BEGIN
					INSERT @tTags (TagName) values (@tag)  
				END
				SET @tags = RIGHT(@tags, LEN(@tags) - @pos)
				SET @pos = CHARINDEX('','', @tags, 1)
			END
		END
		ELSE
		BEGIN
			SET @noTags = 1
		END

		-- Determine how to page
		DECLARE @sLoc BIGINT
		DECLARE @eLoc BIGINT
		IF @pagingDirection = 0  -- page forward
		BEGIN
			SET @sLoc = @pagerStartPosition
			IF @pageSize = 0  -- greedy
				SET @eLoc = (SELECT COUNT(*) FROM GpiPin)
			ELSE
				SET @eLoc = @pagerStartPosition + @pageSize - 1
		END
		ELSE  -- page reverse
		BEGIN
			DECLARE @temp BIGINT
			SET @sLoc = @pagerStartPosition
			IF @pageSize = 0  -- greedy
				SET @eLoc = 1
			ELSE
				SET @eLoc = @pagerStartPosition - @pageSize + 1
			SET @temp = @sLoc
			SET @sLoc = @eLoc
			SET @eLoc = @temp			
		END;

		-- First, get count of pins
		DECLARE @totalPinCount BIGINT; 

		SET @totalPinCount = (SELECT COUNT(*) FROM GpiPin AS tp
								LEFT OUTER JOIN GpiAttachment AS ta ON tp.PinId = ta.PinId
								WHERE tp.ModifyTime > @startTime AND tp.ModifyTime < @endTime
									AND dbo.CalculateDistanceInKilometers(@latitude, @longitude, tp.Latitude, tp.Longitude) <= @range
									AND tp.PinId IN (SELECT tpt.PinId FROM GpiPinTag AS tpt WHERE TagName IN (SELECT TagName FROM @tTags)))

		-- Get the pins
		IF @pinOrder = 0 -- Highest Rated
		BEGIN
			WITH PinsRN AS
			(
				SELECT tp.PinId as PinId, tp.Latitude as Latitude, tp.Longitude as Longitude, tp.Title as Title, 
					tp.Message as Message, tp.TagList as TagList, 
					ta.Name as AttachmentName, 
					ta.Type as AttachmentType, ta.AttachmentId as AttachmentId,
					tp.AverageRating as AverageRating, tp.TotalEvaluations as TotalEvaluations, 
					tp.Author as Author, tp.CreateTime as CreateTime, tp.ModifyTime as ModifyTime, 
					tp.CreateTimeInDb as CreateTimeInDb, tp.ModifyTimeInDb as ModifyTimeInDb,
					ROW_NUMBER() OVER (ORDER BY tp.AverageRating DESC) AS PinNumber
					FROM GpiPin AS tp
					LEFT OUTER JOIN GpiAttachment AS ta ON tp.PinId = ta.PinId
					WHERE tp.ModifyTime > @startTime AND tp.ModifyTime < @endTime
							AND dbo.CalculateDistanceInKilometers(@latitude, @longitude, tp.Latitude, tp.Longitude) <= @range
							AND tp.PinId IN (SELECT tpt.PinId FROM GpiPinTag AS tpt WHERE TagName IN (SELECT TagName FROM @tTags))
			)	
			SELECT @totalPinCount AS TotalPinCount, * FROM PinsRN WHERE PinNumber BETWEEN @sLoc AND @eLoc
		END

		IF @pinOrder = 1 -- Most Recent
		BEGIN
			WITH PinsRN AS
			(
				SELECT tp.PinId as PinId, tp.Latitude as Latitude, tp.Longitude as Longitude, tp.Title as Title, 
					tp.Message as Message, tp.TagList as TagList, 
					ta.Name as AttachmentName, 
					ta.Type as AttachmentType, ta.AttachmentId as AttachmentId,
					tp.AverageRating as AverageRating, tp.TotalEvaluations as TotalEvaluations, 
					tp.Author as Author, tp.CreateTime as CreateTime, tp.ModifyTime as ModifyTime, 
					tp.CreateTimeInDb as CreateTimeInDb, tp.ModifyTimeInDb as ModifyTimeInDb,
					ROW_NUMBER() OVER (ORDER BY tp.ModifyTime DESC) AS PinNumber
					FROM GpiPin AS tp
					LEFT OUTER JOIN GpiAttachment AS ta ON tp.PinId = ta.PinId
					WHERE tp.ModifyTime > @startTime AND tp.ModifyTime < @endTime
						AND dbo.CalculateDistanceInKilometers(@latitude, @longitude, tp.Latitude, tp.Longitude) <= @range
						AND tp.PinId IN (SELECT tpt.PinId FROM GpiPinTag AS tpt WHERE TagName IN (SELECT TagName FROM @tTags))
			)
			SELECT @totalPinCount AS TotalPinCount, * FROM PinsRN WHERE PinNumber BETWEEN @sLoc AND @eLoc
		END

		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION

		-- Raise an error with the details of the exception
		DECLARE @errMsg nvarchar(4000), @errSeverity int
		SELECT @errMsg = ERROR_MESSAGE(), @errSeverity = ERROR_SEVERITY()

		RAISERROR(@errMsg, @errSeverity, 1)
	END CATCH
END






























' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiRatePin]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'





-- =============================================
-- Author:		Sougata Sarkar
-- Create date: 11/22/2008
-- Description:	Rates a pin.
-- =============================================
CREATE PROCEDURE [dbo].[GpiRatePin] 
	-- Add the parameters for the stored procedure here
	@userId uniqueidentifier,
	@securedServicesValidationToken varchar(MAX),
	@evaluator uniqueidentifier,
	@ratedPinId uniqueidentifier,
	@numStars smallint, 
	@rowsChanged as int output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	-- Validate User
	IF NOT EXISTS (SELECT UserId FROM GpiLogon WHERE UserId = @userId and ValidationToken_S = @securedServicesValidationToken)
	BEGIN
		SET @rowsChanged = 0
		RAISERROR(''NOT_LOGGED_IN'', 16, 1)
		RETURN;
	END

	BEGIN TRY
		BEGIN TRANSACTION
		
		-- Rate pin
		-- First check if this evaluator has already rated this pin
		DECLARE @alreadyRated TINYINT
		SET @alreadyRated = 0
		IF EXISTS (SELECT Evaluator, RatedPinId FROM GpiPinRating WHERE Evaluator = @evaluator AND RatedPinId = @ratedPinId)
		BEGIN
			SET @alreadyRated = 1
		END
		ELSE
		BEGIN
			SET @alreadyRated = 0
		END

		IF @alreadyRated = 0
		BEGIN
			INSERT INTO GpiPinRating(Evaluator, RatedPinId, NumStars) VALUES (@evaluator, @ratedPinId, @numStars)
			UPDATE GpiPin
				SET AverageRating = ((AverageRating * TotalEvaluations) + @numStars)/(TotalEvaluations + 1),
					TotalEvaluations = TotalEvaluations + 1
				WHERE PinId = @ratedPinId
		END
		ELSE
		BEGIN
			DECLARE @currentOpinion SMALLINT
			SET @currentOpinion = (SELECT TOP 1 NumStars FROM GpiPinRating WHERE Evaluator = @evaluator AND RatedPinId = @ratedPinId)
			UPDATE GpiPinRating SET NumStars = @numStars
			UPDATE GpiPin
				SET AverageRating = ((AverageRating * TotalEvaluations) - @currentOpinion + @numStars)/TotalEvaluations
				WHERE PinId = @ratedPinId 
		END
			
		SET @rowsChanged = @@ROWCOUNT

		SELECT tp.PinId as PinId, tp.Title as Title, tp.Message as Message, tp.Latitude as Latitude, 
				tp.Longitude as Longitude, tp.TagList as TagList, 
				ta.AttachmentId as AttachmentId, ta.Name as AttachmentName, ta.Type as AttachmentType, 
				tp.Author as author, tp.AverageRating as AverageRating, tp.TotalEvaluations as TotalEvaluations, 
				tp.CreateTime as CreateTime, tp.ModifyTime as ModifyTime, 
				tp.CreateTimeInDb as CreateTimeInDb, tp.ModifyTimeInDb as ModifyTimeInDb
			FROM GpiPin AS tp
			LEFT OUTER JOIN GpiAttachment AS ta ON tp.PinId = ta.PinId 
			WHERE tp.PinId = @ratedPinId
		
		COMMIT TRANSACTION

	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION

		-- Raise an error with the details of the exception
		DECLARE @errMsg nvarchar(4000), @errSeverity int
		SELECT @errMsg = ERROR_MESSAGE(), @errSeverity = ERROR_SEVERITY()

		RAISERROR(@errMsg, @errSeverity, 1)
	END CATCH
END


















' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiModifyPin]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'









-- =============================================
-- Author:		Sougata Sarkar
-- Create date: 6/28/2007
-- Description:	Modifies a pin in the database.
-- =============================================
CREATE PROCEDURE [dbo].[GpiModifyPin] 
	-- Add the parameters for the stored procedure here
	@userId uniqueidentifier,
	@securedServicesValidationToken varchar(MAX),
	@pinId uniqueidentifier,
	@title nvarchar(255), 
	@message nvarchar(MAX),
	@latitude float,
	@longitude float,
	@tags as nvarchar(MAX),
	@attachmentOperationType as tinyint,
	@attachmentId as varchar(max),
	@attachment text,
	@attachmentName nvarchar(max),
	@attachmentType varchar(max),
	@rowsChanged as int output,
	@modifyTime as datetime,
	@modifyTimeInDb as datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	-- Validate User
	IF NOT EXISTS (SELECT UserId FROM GpiLogon WHERE UserId = @userId and ValidationToken_S = @securedServicesValidationToken)
	BEGIN
		SET @rowsChanged = 0
		RAISERROR(''NOT_LOGGED_IN'', 16, 1)
		RETURN;
	END

	-- Validate that user is the author of the pin
	IF NOT EXISTS (SELECT UserId FROM GpiPin WHERE UserId = @userId AND PinId = @pinId)
	BEGIN
		SET @rowsChanged = 0
		RAISERROR(''CANNOT_MODIFY_UNOWNED_PIN'', 16, 1)
		RETURN
	END

	BEGIN TRY
		BEGIN TRANSACTION
		
		-- Modify pin in database
		DECLARE @tagList nvarchar(MAX)
		SET @tagList = REPLACE(@tags, '','', '' '')
		DECLARE @tag nvarchar(400)
		DECLARE @pos int

		UPDATE GpiPin
			SET Title = @title, Message = @message, Latitude = @latitude, Longitude = @longitude, TagList = @tagList,
				ModifyTime = @modifyTime, ModifyTimeInDb = @modifyTimeInDb
			WHERE PinId = @pinId
			
		SET @rowsChanged = @@ROWCOUNT

		-- Update tags
		DELETE FROM GpiPinTag WHERE PinId = @pinId

		SET @tags = LTRIM(RTRIM(@tags)) + '',''
		SET @pos = CHARINDEX('','', @tags, 1)

		IF REPLACE(@tags, '','', '''') <> ''''
		BEGIN
			WHILE @pos > 0
			BEGIN
				SET @tag = LTRIM(RTRIM(LEFT(@tags, @pos - 1)))
				IF @tag <> ''''
				BEGIN
					INSERT GpiPinTag (PinId, TagName) VALUES (@pinId, @tag)
				END
				SET @tags = RIGHT(@tags, LEN(@tags) - @pos)
				SET @pos = CHARINDEX('','', @tags, 1)
			END
		END
		-- Every pin has a default tag called #any#
		INSERT GpiPinTag (PinId, TagName) VALUES (@pinId, ''#any#'')

		-- Attachment operations begin here
		IF @attachmentOperationType = 1 -- Add attachment
		BEGIN
			-- If an attachment already exists then simply modify the attachment (for now)
			IF EXISTS (SELECT pinId FROM GpiAttachment WHERE PinId = @pinId)
			BEGIN
				SET @attachmentId = (SELECT TOP 1 AttachmentId FROM GpiAttachment WHERE PinId = @pinId)
				SET @attachmentOperationType = 2
			END
			ELSE
			BEGIN
				-- Insert attachment into database
				DECLARE @generatedAttachmentId nvarchar(MAX)
				SET @generatedAttachmentId = CONVERT(char(36), @pinId) + ''_'' + REPLACE(CONVERT(varchar, GETDATE(),111),''/'','''') + REPLACE(CONVERT(varchar, GETDATE(),14),'':'','''');
				INSERT GpiAttachment (PinId, Attachment, AttachmentId, Name, Type)
					VALUES (@pinId, @attachment, @generatedAttachmentId, @attachmentName, @attachmentType);
			END
		END

		IF @attachmentOperationType = 2 -- Modify attachment
		BEGIN
			UPDATE GpiAttachment
				SET Attachment = @attachment, Name = @attachmentName, Type = @attachmentType
				WHERE PinId = @pinId AND AttachmentId = @attachmentId
		END

		IF @attachmentOperationType = 3 -- Delete attachment
		BEGIN
			DELETE FROM GpiAttachment
				WHERE PinId = @pinId AND AttachmentId = @AttachmentId;
		END

		SELECT tp.PinId as PinId, tp.Title as Title, tp.Message as Message, tp.Latitude as Latitude, 
				tp.Longitude as Longitude, tp.TagList as TagList, 
				ta.AttachmentId as AttachmentId, ta.Name as AttachmentName, ta.Type as AttachmentType,
				tp.AverageRating as AverageRating, tp.TotalEvaluations as TotalEvaluations, 
				tp.Author as author, tp.CreateTime as CreateTime, tp.ModifyTime as ModifyTime, 
				tp.CreateTimeInDb as CreateTimeInDb, tp.ModifyTimeInDb as ModifyTimeInDb
			FROM GpiPin AS tp
			LEFT OUTER JOIN GpiAttachment AS ta ON tp.PinId = ta.PinId 
			WHERE tp.PinId = @pinId
		
		COMMIT TRANSACTION

	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION

		-- Raise an error with the details of the exception
		DECLARE @errMsg nvarchar(4000), @errSeverity int
		SELECT @errMsg = ERROR_MESSAGE(), @errSeverity = ERROR_SEVERITY()

		RAISERROR(@errMsg, @errSeverity, 1)
	END CATCH
END






















' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiDeletePins]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'








-- =============================================
-- Author:		Sougata Sarkar
-- Create date: 6/28/2007
-- Description:	Deletes pins from the database for
-- a set of specified pin Ids.
-- =============================================
CREATE PROCEDURE [dbo].[GpiDeletePins] 
	-- Add the parameters for the stored procedure here
	@userId as uniqueidentifier,
	@securedServicesValidationToken as varchar(max),
	@pinIds as varchar(max),
	@rowsDeleted as int output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Validate User
	IF NOT EXISTS (SELECT UserId FROM GpiLogon WHERE UserId = @userId and ValidationToken_S = @securedServicesValidationToken)
	BEGIN
		SET @rowsDeleted = 0;
		RAISERROR(''NOT_LOGGED_IN'', 16, 1)
		RETURN;
	END

	BEGIN TRY
		BEGIN TRANSACTION

		-- Delete pins from database
		DECLARE @tDeletedPins TABLE (PinId uniqueidentifier);
		DECLARE @pinId varchar(max);
		declare @pos int;

		SET @pinId = LTRIM(RTRIM(@pinIds))
		SET @pos = CHARINDEX('','', @pinIds, 1)

		IF REPLACE(@pinIds, '','', '''') <> ''''
		BEGIN
			WHILE @pos > 0
			BEGIN
				SET @pinId = LTRIM(RTRIM(LEFT(@pinIds, @pos - 1)))
				IF @pinId <> ''''
				BEGIN
					INSERT INTO @tDeletedPins (PinId) VALUES (cast(@pinId AS uniqueidentifier))
				END
				SET @pinIds = RIGHT(@pinIds, LEN(@pinIds) - @pos)
				SET @pos = CHARINDEX('','', @pinIds, 1)
			END
		END

		-- Validate that user is the author of the pin
		IF EXISTS (SELECT * FROM @tDeletedPins tp, GpiPin p WHERE tp.pinId = p.pinId AND p.UserId <> @userId)
		BEGIN
			SET @rowsDeleted = 0
			IF @@TRANCOUNT > 0
				ROLLBACK TRANSACTION
			RAISERROR(''CANNOT_DELETE_UNOWNED_PIN'', 16, 1)
			RETURN
		END

		DELETE FROM GpiAttachment
			WHERE PinId IN (SELECT PinId FROM @tDeletedPins);
		DELETE FROM GpiPinTag
			WHERE PinId IN (SELECT PinId FROM @tDeletedPins);
		DELETE FROM GpiPin
			WHERE PinId IN (SELECT PinId FROM @tDeletedPins);
		SET @rowsDeleted = @@ROWCOUNT
		
		COMMIT TRANSACTION

		RETURN @rowsDeleted
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION

		-- Raise an error with the details of the exception
		DECLARE @errMsg nvarchar(4000), @errSeverity int
		SELECT @errMsg = ERROR_MESSAGE(), @errSeverity = ERROR_SEVERITY()

		RAISERROR(@errMsg, @errSeverity, 1)
	END CATCH
END



' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiGetAttachment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'



-- =============================================
-- Author:		Sougata Sarkar
-- Create date: 6/28/2007
-- Description:	Gets attachments for a pin.
-- =============================================
CREATE PROCEDURE [dbo].[GpiGetAttachment] 
	-- Add the parameters for the stored procedure here
	@userId uniqueidentifier,
	@unsecuredServicesValidationToken varchar(MAX),
	@pinId as uniqueidentifier,
	@attachmentId as varchar(MAX)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	-- Validate User
	IF NOT EXISTS (SELECT UserId FROM GpiLogon WHERE UserId = @userId and ValidationToken = @unsecuredServicesValidationToken)
	BEGIN
		RAISERROR(''NOT_LOGGED_IN'', 16, 1)
		RETURN;
	END

	BEGIN TRY
		BEGIN TRANSACTION

		SELECT TOP 1 ta.Attachment as Attachment, ta.Name as AttachmentName, 
				ta.Type as AttachmentType, ta.AttachmentId as AttachmentId
			FROM GpiAttachment ta
			WHERE @pinId = ta.PinId
			AND @attachmentId = AttachmentId  

		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION

		-- Raise an error with the details of the exception
		DECLARE @errMsg nvarchar(4000), @errSeverity int
		SELECT @errMsg = ERROR_MESSAGE(), @errSeverity = ERROR_SEVERITY()

		RAISERROR(@errMsg, @errSeverity, 1)
	END CATCH
END












' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiGetPinsFromPinIdList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'






-- =============================================
-- Author:		Sougata Sarkar
-- Create date: 3/19/2007
-- Description:	Gets pin details when a set of
-- pin Ids are specified
-- =============================================
CREATE PROCEDURE [dbo].[GpiGetPinsFromPinIdList] 
	-- Add the parameters for the stored procedure here
	@userId uniqueidentifier,
	@unsecuredServicesValidationToken varchar(MAX),
	@pinIds as nvarchar(MAX)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	-- Validate User
	IF NOT EXISTS (SELECT UserId FROM GpiLogon WHERE UserId = @userId and ValidationToken = @unsecuredServicesValidationToken)
	BEGIN
		RAISERROR(''NOT_LOGGED_IN'', 16, 1)
		RETURN;
	END

	BEGIN TRY
		BEGIN TRANSACTION

		-- Get pin details
		DECLARE @DocHandle int

		EXEC sp_xml_preparedocument @DocHandle OUTPUT, @pinIds

		SELECT tp.Title AS Title, tp.Message AS Message, tp.Latitude AS Latitude, 
			tp.Longitude AS Longitude, tp.PinId AS PinId, 
			ta.Name AS AttachmentName, ta.Type AS AttachmentType, ta.AttachmentId AS AttachmentId, 
			tp.Author AS Author, tp.TagList AS TagList, tp.CreateTime AS CreateTime, 
			tp.ModifyTime AS ModifyTime, tp.CreateTimeInDb AS CreateTimeInDb, 
			tp.ModifyTimeInDb AS ModifyTimeInDb
		FROM 
			(GpiPin AS tp INNER JOIN OPENXML (@DocHandle, ''/Pins/Pin'', 1) WITH (id  uniqueidentifier) AS p ON tp.PinId = p.id)
			LEFT OUTER JOIN GpiAttachment AS ta ON tp.PinId = ta.PinId

		EXEC sp_xml_removedocument @DocHandle 

		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION

		-- Raise an error with the details of the exception
		DECLARE @errMsg nvarchar(4000), @errSeverity int
		SELECT @errMsg = ERROR_MESSAGE(), @errSeverity = ERROR_SEVERITY()

		RAISERROR(@errMsg, @errSeverity, 1)
	END CATCH
END



















' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiRemoveGroup]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'











-- =============================================
-- Author:		Sougata Sarkar
-- Create date: 5/18/2009
-- Description:	Removes a group.
-- =============================================
CREATE PROCEDURE [dbo].[GpiRemoveGroup] 
	-- Add the parameters for the stored procedure here
	@userId uniqueidentifier,
	@securedServicesValidationToken varchar(MAX),
	@name nvarchar(255)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	-- Validate User
	IF NOT EXISTS(SELECT UserId FROM GpiLogon WHERE UserId = @userId AND ValidationToken_S = @securedServicesValidationToken)
	BEGIN
		RAISERROR(''NOT_LOGGED_IN'', 16, 1)
		RETURN;
	END

	-- Remove the group
	BEGIN TRY
		BEGIN TRANSACTION

		DELETE FROM GpiGroupUser WHERE GroupName = @name AND GroupCreator = @userId
		DELETE FROM GpiGroup WHERE Name = @name AND Creator = @userId

		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION

		-- Raise an error with the details of the exception
		DECLARE @errMsg nvarchar(4000), @errSeverity int
		SELECT @errMsg = ERROR_MESSAGE(), @errSeverity = ERROR_SEVERITY()

		RAISERROR(@errMsg, @errSeverity, 1)
	END CATCH
END


























' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiGetGroupsForUser]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

















-- =============================================
-- Author:		Sougata Sarkar
-- Create date: 5/18/2009
-- Description:	Gets all groups that the user
-- has created.
-- =============================================
CREATE PROCEDURE [dbo].[GpiGetGroupsForUser] 
	-- Add the parameters for the stored procedure here
	@userId uniqueidentifier,
	@unsecuredServicesValidationToken nvarchar(MAX)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	-- Validate User
	IF NOT EXISTS (SELECT UserId FROM GpiLogon WHERE UserId = @userId and ValidationToken = @unsecuredServicesValidationToken)
	BEGIN
		RAISERROR(''NOT_LOGGED_IN'', 16, 1)
		RETURN;
	END

	BEGIN TRY
		BEGIN TRANSACTION

		SELECT Name AS Name, Creator AS Creator FROM GpiGroup WHERE Creator = @userId

		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION

		-- Raise an error with the details of the exception
		DECLARE @errMsg nvarchar(4000), @errSeverity int
		SELECT @errMsg = ERROR_MESSAGE(), @errSeverity = ERROR_SEVERITY()

		RAISERROR(@errMsg, @errSeverity, 1)
	END CATCH
END






























' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiCreateGroup]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'










-- =============================================
-- Author:		Sougata Sarkar
-- Create date: 5/18/2009
-- Description:	Adds a group.
-- =============================================
CREATE PROCEDURE [dbo].[GpiCreateGroup] 
	-- Add the parameters for the stored procedure here
	@userId uniqueidentifier,
	@securedServicesValidationToken varchar(MAX),
	@name nvarchar(255)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	-- Validate User
	IF NOT EXISTS(SELECT UserId FROM GpiLogon WHERE UserId = @userId AND ValidationToken_S = @securedServicesValidationToken)
	BEGIN
		RAISERROR(''NOT_LOGGED_IN'', 16, 1)
		RETURN;
	END

	-- Add the group
	BEGIN TRY
		BEGIN TRANSACTION

		IF NOT EXISTS(SELECT * FROM GpiGroup WHERE Name=@name AND Creator=@userId)
		BEGIN
			INSERT GpiGroup (Name, Creator) VALUES (@name, @userId);
		END
		ELSE
		BEGIN
			IF @@TRANCOUNT > 0
				ROLLBACK TRANSACTION
			RAISERROR(''DUPLICATE_GROUP'', 16, 1)
		END

		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION

		-- Raise an error with the details of the exception
		DECLARE @errMsg nvarchar(4000), @errSeverity int
		SELECT @errMsg = ERROR_MESSAGE(), @errSeverity = ERROR_SEVERITY()

		RAISERROR(@errMsg, @errSeverity, 1)
	END CATCH
END

























' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiDeleteAllPinsOfAnUser]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'






-- =============================================
-- Author:		Sougata Sarkar
-- Create date: 6/28/2007
-- Description:	Deletes all pins authored by
-- an user from the database.
-- =============================================
CREATE PROCEDURE [dbo].[GpiDeleteAllPinsOfAnUser] 
	-- Add the parameters for the stored procedure here
	@userId as uniqueidentifier,
	@rowsDeleted as int output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Validate User
	IF NOT EXISTS (SELECT UserId FROM aspnet_Membership WHERE UserId = @userId)
	BEGIN
		SET @rowsDeleted = 0;
		RETURN;
	END

	BEGIN TRY
		BEGIN TRANSACTION

		-- Delete pins from database
		DELETE FROM GpiAttachment
			WHERE PinId IN (SELECT PinId FROM GpiPin WHERE UserId=@userId);
		DELETE FROM GpiPinTag
			WHERE PinId IN (SELECT PinId FROM GpiPin WHERE UserId=@userId);
		DELETE FROM GpiPin
			WHERE UserId=@userId;
		SET @rowsDeleted = @@ROWCOUNT
		
		COMMIT TRANSACTION

		RETURN @rowsDeleted
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION

		-- Raise an error with the details of the exception
		DECLARE @errMsg nvarchar(4000), @errSeverity int
		SELECT @errMsg = ERROR_MESSAGE(), @errSeverity = ERROR_SEVERITY()

		RAISERROR(@errMsg, @errSeverity, 1)
	END CATCH
END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiLoginUser]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'









-- =============================================
-- Author:		Sougata Sarkar
-- Create date: 6/28/2007
-- Description:	Logs on user and generates a
--  pair of validation tokens.
-- =============================================
CREATE PROCEDURE [dbo].[GpiLoginUser]
	@userId uniqueidentifier,
	@unsecuredServicesValidationToken varchar(MAX),
	@securedServicesValidationToken varchar(MAX)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @returnValue int;

	BEGIN TRY
		BEGIN TRANSACTION

		-- If the user is already logged in, then generate a new
		-- pair of tokens and add another record to that effect.
		-- Exception is if the user is logged on 10 times; in this
		-- case, generate an error message
		DECLARE @logonCount INT
		SET @logonCount = (SELECT COUNT(*) FROM dbo.GpiLogon WHERE UserId = @userId)
		IF @logonCount = 10
			BEGIN
			RAISERROR (''TOO_MANY_LOGONS'', 16, 1)
			END
		ELSE
			BEGIN
			INSERT GpiLogon (UserId, ValidationToken, ValidationToken_S)
				VALUES (@userId, @unsecuredServicesValidationToken, @securedServicesValidationToken)
			SET @returnValue = @@ROWCOUNT
			END
	
		-- Commit the transaction
		COMMIT TRANSACTION

		RETURN @returnValue
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION

		-- Raise an error with the details of the exception
		DECLARE @errMsg nvarchar(4000), @errSeverity int
		SELECT @errMsg = ERROR_MESSAGE(), @errSeverity = ERROR_SEVERITY()

		RAISERROR(@errMsg, @errSeverity, 1)
	END CATCH
END









' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GpiLogoutUser]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'





-- =============================================
-- Author:		Sougata Sarkar
-- Create date: 6/28/2007
-- Description:	Logs out user.
-- =============================================
CREATE PROCEDURE [dbo].[GpiLogoutUser]
	@userId uniqueidentifier,
	@securedServicesValidationToken nvarchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DELETE FROM dbo.GpiLogon WHERE UserId = @userId AND ValidationToken_S = @securedServicesValidationToken;

	RETURN @@ROWCOUNT
END









' 
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GpiPinTag_GpiPin]') AND parent_object_id = OBJECT_ID(N'[dbo].[GpiPinTag]'))
ALTER TABLE [dbo].[GpiPinTag]  WITH CHECK ADD  CONSTRAINT [FK_GpiPinTag_GpiPin] FOREIGN KEY([PinId])
REFERENCES [dbo].[GpiPin] ([PinId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GpiPinRating_aspnet_Membership]') AND parent_object_id = OBJECT_ID(N'[dbo].[GpiPinRating]'))
ALTER TABLE [dbo].[GpiPinRating]  WITH CHECK ADD  CONSTRAINT [FK_GpiPinRating_aspnet_Membership] FOREIGN KEY([Evaluator])
REFERENCES [dbo].[aspnet_Membership] ([UserId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GpiPinRating_GpiPin]') AND parent_object_id = OBJECT_ID(N'[dbo].[GpiPinRating]'))
ALTER TABLE [dbo].[GpiPinRating]  WITH CHECK ADD  CONSTRAINT [FK_GpiPinRating_GpiPin] FOREIGN KEY([RatedPinId])
REFERENCES [dbo].[GpiPin] ([PinId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GpiGroupUser_aspnet_Membership]') AND parent_object_id = OBJECT_ID(N'[dbo].[GpiGroupUser]'))
ALTER TABLE [dbo].[GpiGroupUser]  WITH CHECK ADD  CONSTRAINT [FK_GpiGroupUser_aspnet_Membership] FOREIGN KEY([UserId])
REFERENCES [dbo].[aspnet_Membership] ([UserId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GpiGroupUser_GpiGroup]') AND parent_object_id = OBJECT_ID(N'[dbo].[GpiGroupUser]'))
ALTER TABLE [dbo].[GpiGroupUser]  WITH CHECK ADD  CONSTRAINT [FK_GpiGroupUser_GpiGroup] FOREIGN KEY([GroupName], [GroupCreator])
REFERENCES [dbo].[GpiGroup] ([Name], [Creator])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GpiGroup_aspnet_Membership]') AND parent_object_id = OBJECT_ID(N'[dbo].[GpiGroup]'))
ALTER TABLE [dbo].[GpiGroup]  WITH CHECK ADD  CONSTRAINT [FK_GpiGroup_aspnet_Membership] FOREIGN KEY([Creator])
REFERENCES [dbo].[aspnet_Membership] ([UserId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GpiPin_aspnet_Membership]') AND parent_object_id = OBJECT_ID(N'[dbo].[GpiPin]'))
ALTER TABLE [dbo].[GpiPin]  WITH CHECK ADD  CONSTRAINT [FK_GpiPin_aspnet_Membership] FOREIGN KEY([UserId])
REFERENCES [dbo].[aspnet_Membership] ([UserId])
