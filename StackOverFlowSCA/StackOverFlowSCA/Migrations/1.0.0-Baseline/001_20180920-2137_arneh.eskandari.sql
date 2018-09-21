-- <Migration ID="a05eaa36-6193-4cb2-a5a2-a62c651299d4" />
GO

IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'RED-GATE\Joshua.Rodriguez')
CREATE LOGIN [RED-GATE\Joshua.Rodriguez] FROM WINDOWS
GO
CREATE USER [RED-GATE\Joshua.Rodriguez] FOR LOGIN [RED-GATE\Joshua.Rodriguez]
GO
PRINT N'Creating schemas'
GO
CREATE SCHEMA [RedGateLocal]
AUTHORIZATION [dbo]
GO
PRINT N'Creating [dbo].[Comments]'
GO
CREATE TABLE [dbo].[Comments]
(
[Id] [int] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[PostId] [int] NOT NULL,
[Score] [int] NULL,
[Text] [nvarchar] (700) NOT NULL,
[UserId] [int] NULL
)
GO
PRINT N'Creating primary key [PK_Comments__Id] on [dbo].[Comments]'
GO
ALTER TABLE [dbo].[Comments] ADD CONSTRAINT [PK_Comments__Id] PRIMARY KEY CLUSTERED  ([Id])
GO
PRINT N'Creating [dbo].[GetComments]'
GO
--SET QUOTED_IDENTIFIER ON|OFF
--SET ANSI_NULLS ON|OFF
--RED-GATE\arneh.eskandari
--GO
CREATE PROCEDURE [dbo].[GetComments]
    
-- WITH ENCRYPTION, RECOMPILE, EXECUTE AS CALLER|SELF|OWNER| 'user_name'
AS
    SELECT Text  
    FROM    dbo.Comments;
GO
PRINT N'Creating [dbo].[Posts]'
GO
CREATE TABLE [dbo].[Posts]
(
[Id] [int] NOT NULL,
[AcceptedAnswerId] [int] NULL,
[AnswerCount] [int] NULL,
[Body] [nvarchar] (max) NOT NULL,
[ClosedDate] [datetime] NULL,
[CommentCount] [int] NULL,
[CommunityOwnedDate] [datetime] NULL,
[CreationDate] [datetime] NOT NULL,
[FavoriteCount] [int] NULL,
[LastActivityDate] [datetime] NOT NULL,
[LastEditDate] [datetime] NULL,
[LastEditorDisplayName] [nvarchar] (40) NULL,
[LastEditorUserId] [int] NULL,
[OwnerUserId] [int] NULL,
[ParentId] [int] NULL,
[PostTypeId] [int] NOT NULL,
[Score] [int] NOT NULL,
[Tags] [nvarchar] (150) NULL,
[Title] [nvarchar] (250) NULL,
[ViewCount] [int] NOT NULL
)
GO
PRINT N'Creating primary key [PK_Posts__Id] on [dbo].[Posts]'
GO
ALTER TABLE [dbo].[Posts] ADD CONSTRAINT [PK_Posts__Id] PRIMARY KEY CLUSTERED  ([Id])
GO
PRINT N'Creating [dbo].[GetPosts]'
GO
--SET QUOTED_IDENTIFIER ON|OFF
--SET ANSI_NULLS ON|OFF
--RED-GATE\arneh.eskandari
--GO
CREATE PROCEDURE [dbo].[GetPosts]
  
-- WITH ENCRYPTION, RECOMPILE, EXECUTE AS CALLER|SELF|OWNER| 'user_name'
AS
    SELECT  AnswerCount ,
            Body ,
            ClosedDate ,
            CreationDate ,
            CommentCount
    FROM    dbo.Posts;
GO
PRINT N'Creating [RedGateLocal].[DeploymentMetadata]'
GO
CREATE TABLE [RedGateLocal].[DeploymentMetadata]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (max) NOT NULL,
[Type] [varchar] (50) NOT NULL,
[Action] [varchar] (50) NOT NULL,
[By] [nvarchar] (128) NOT NULL CONSTRAINT [DF__DeploymentMe__By__2C3393D0] DEFAULT (original_login()),
[As] [nvarchar] (128) NOT NULL CONSTRAINT [DF__DeploymentMe__As__2D27B809] DEFAULT (suser_sname()),
[CompletedDate] [datetime] NOT NULL CONSTRAINT [DF__Deploymen__Compl__2E1BDC42] DEFAULT (getdate()),
[With] [nvarchar] (128) NOT NULL CONSTRAINT [DF__Deployment__With__2F10007B] DEFAULT (app_name()),
[BlockId] [varchar] (50) NOT NULL,
[InsertedSerial] [binary] (8) NOT NULL CONSTRAINT [DF__Deploymen__Inser__300424B4] DEFAULT (@@dbts+(1)),
[UpdatedSerial] [timestamp] NOT NULL,
[MetadataVersion] [varchar] (50) NOT NULL,
[Hash] [nvarchar] (max) NULL
)
GO
PRINT N'Creating primary key [PK__Deployme__3214EC075EAE2CAA] on [RedGateLocal].[DeploymentMetadata]'
GO
ALTER TABLE [RedGateLocal].[DeploymentMetadata] ADD CONSTRAINT [PK__Deployme__3214EC075EAE2CAA] PRIMARY KEY CLUSTERED  ([Id])
GO
PRINT N'Creating [dbo].[Badges]'
GO
CREATE TABLE [dbo].[Badges]
(
[Id] [int] NOT NULL,
[Name] [nvarchar] (40) NOT NULL,
[UserId] [int] NOT NULL,
[Date] [datetime] NOT NULL
)
GO
PRINT N'Creating primary key [PK_Badges__Id] on [dbo].[Badges]'
GO
ALTER TABLE [dbo].[Badges] ADD CONSTRAINT [PK_Badges__Id] PRIMARY KEY CLUSTERED  ([Id])
GO
PRINT N'Creating [dbo].[DMSSTAT_RSTATS]'
GO
CREATE TABLE [dbo].[DMSSTAT_RSTATS]
(
[runid] [varchar] (250) NOT NULL,
[ruleid] [varchar] (50) NOT NULL,
[ruleblock] [int] NOT NULL,
[rulenum] [int] NOT NULL,
[rulesubscript] [int] NOT NULL,
[ruletype] [varchar] (50) NOT NULL,
[rulecreated] [datetime] NOT NULL,
[ruleupdated] [datetime] NOT NULL,
[secondsactive] [int] NOT NULL,
[rulestatus] [char] (1) NOT NULL,
[rulesource] [varchar] (250) NULL,
[ruletarget] [varchar] (250) NULL,
[rowoperations] [int] NULL,
[coloperations] [int] NULL,
[rulePrevRPN] [int] NULL,
[ruleRPN] [int] NULL
)
GO
PRINT N'Creating index [IX_DMSSTAT_RSTATS] on [dbo].[DMSSTAT_RSTATS]'
GO
CREATE NONCLUSTERED INDEX [IX_DMSSTAT_RSTATS] ON [dbo].[DMSSTAT_RSTATS] ([runid], [ruleid])
GO
PRINT N'Creating [dbo].[DMSSTAT_TSTATS]'
GO
CREATE TABLE [dbo].[DMSSTAT_TSTATS]
(
[runid] [varchar] (250) NOT NULL,
[ruleid] [varchar] (50) NOT NULL,
[statscreated] [datetime] NOT NULL,
[statsupdated] [datetime] NOT NULL,
[ruletype] [varchar] (50) NOT NULL,
[ruleblock] [int] NOT NULL,
[rulenum] [int] NOT NULL,
[rulesubscript] [int] NOT NULL,
[controllerid] [varchar] (50) NULL,
[tabledatabase] [varchar] (250) NOT NULL,
[tableschema] [varchar] (250) NOT NULL,
[tablename] [varchar] (250) NOT NULL,
[tablecolumn] [varchar] (250) NULL,
[rowoperations] [int] NULL,
[coloperations] [int] NULL
)
GO
PRINT N'Creating index [IX_DMSSTAT_TSTATS_A] on [dbo].[DMSSTAT_TSTATS]'
GO
CREATE NONCLUSTERED INDEX [IX_DMSSTAT_TSTATS_A] ON [dbo].[DMSSTAT_TSTATS] ([runid], [ruleid])
GO
PRINT N'Creating [dbo].[LinkTypes]'
GO
CREATE TABLE [dbo].[LinkTypes]
(
[Id] [int] NOT NULL,
[Type] [varchar] (50) NOT NULL
)
GO
PRINT N'Creating primary key [PK_LinkTypes__Id] on [dbo].[LinkTypes]'
GO
ALTER TABLE [dbo].[LinkTypes] ADD CONSTRAINT [PK_LinkTypes__Id] PRIMARY KEY CLUSTERED  ([Id])
GO
PRINT N'Creating [dbo].[PostLinks]'
GO
CREATE TABLE [dbo].[PostLinks]
(
[Id] [int] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[PostId] [int] NOT NULL,
[RelatedPostId] [int] NOT NULL,
[LinkTypeId] [int] NOT NULL
)
GO
PRINT N'Creating primary key [PK_PostLinks__Id] on [dbo].[PostLinks]'
GO
ALTER TABLE [dbo].[PostLinks] ADD CONSTRAINT [PK_PostLinks__Id] PRIMARY KEY CLUSTERED  ([Id])
GO
PRINT N'Creating [dbo].[PostTypes]'
GO
CREATE TABLE [dbo].[PostTypes]
(
[Id] [int] NOT NULL,
[Type] [nvarchar] (50) NOT NULL
)
GO
PRINT N'Creating primary key [PK_PostTypes__Id] on [dbo].[PostTypes]'
GO
ALTER TABLE [dbo].[PostTypes] ADD CONSTRAINT [PK_PostTypes__Id] PRIMARY KEY CLUSTERED  ([Id])
GO
PRINT N'Creating [dbo].[Users]'
GO
CREATE TABLE [dbo].[Users]
(
[Id] [int] NOT NULL,
[AboutMe] [nvarchar] (max) NULL,
[Age] [int] NULL,
[CreationDate] [datetime] NOT NULL,
[DisplayName] [nvarchar] (40) NOT NULL,
[DownVotes] [int] NOT NULL,
[EmailHash] [nvarchar] (40) NULL,
[LastAccessDate] [datetime] NOT NULL,
[Location] [nvarchar] (100) NULL,
[Reputation] [int] NOT NULL,
[UpVotes] [int] NOT NULL,
[Views] [int] NOT NULL,
[WebsiteUrl] [nvarchar] (200) NULL,
[AccountId] [int] NULL
)
GO
PRINT N'Creating primary key [PK_Users_Id] on [dbo].[Users]'
GO
ALTER TABLE [dbo].[Users] ADD CONSTRAINT [PK_Users_Id] PRIMARY KEY CLUSTERED  ([Id])
GO
PRINT N'Creating [dbo].[VoteTypes]'
GO
CREATE TABLE [dbo].[VoteTypes]
(
[Id] [int] NOT NULL,
[Name] [varchar] (50) NOT NULL
)
GO
PRINT N'Creating primary key [PK_VoteType__Id] on [dbo].[VoteTypes]'
GO
ALTER TABLE [dbo].[VoteTypes] ADD CONSTRAINT [PK_VoteType__Id] PRIMARY KEY CLUSTERED  ([Id])
GO
PRINT N'Creating [dbo].[Votes]'
GO
CREATE TABLE [dbo].[Votes]
(
[Id] [int] NOT NULL,
[PostId] [int] NOT NULL,
[UserId] [int] NULL,
[BountyAmount] [int] NULL,
[VoteTypeId] [int] NOT NULL,
[CreationDate] [datetime] NOT NULL
)
GO
PRINT N'Creating primary key [PK_Votes__Id] on [dbo].[Votes]'
GO
ALTER TABLE [dbo].[Votes] ADD CONSTRAINT [PK_Votes__Id] PRIMARY KEY CLUSTERED  ([Id])
GO
PRINT N'Creating extended properties'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table records deployments with migration scripts. Learn more: http://rd.gt/230GBP3', 'SCHEMA', N'RedGateLocal', 'TABLE', N'DeploymentMetadata', NULL, NULL
GO
