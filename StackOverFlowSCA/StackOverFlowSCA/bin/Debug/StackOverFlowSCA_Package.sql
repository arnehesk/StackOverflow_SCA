﻿/*
    Target database:    StackOverflowSCA_DEV (configurable)
    Target instance:    (any)
    Generated date:     9/21/2018 7:29:31 AM
    Generated on:       US-LT-ARNEHE3
    Package version:    (undefined)
    Migration version:  (n/a)
    Baseline version:   (n/a)
    SQL Change Automation version:  3.0.18262.1427
    Migrations pending: (variable)

    IMPORTANT! "SQLCMD Mode" must be activated prior to execution (under the Query menu in SSMS).

    BEFORE EXECUTING THIS SCRIPT, WE STRONGLY RECOMMEND YOU TAKE A BACKUP OF YOUR DATABASE.

    This SQLCMD script is designed to be executed through MSBuild (via the .sqlproj Deploy target) however
    it can also be run manually using SQL Management Studio.

    It was generated by the SQL Change Automation build task and contains logic to deploy the database, ensuring that
    each of the incremental migrations is executed a single time only in alphabetical (filename)
    order. If any errors occur within those scripts, the deployment will be aborted and the transaction
    rolled-back.

    NOTE: Automatic transaction management is provided for incremental migrations, so you don't need to
          add any special BEGIN TRAN/COMMIT/ROLLBACK logic in those script files.
          However if you require transaction handling in your Pre/Post-Deployment scripts, you will
          need to add this logic to the source .sql files yourself.
*/

----====================================================================================================================
---- SQLCMD Variables
---- This script is designed to be called by SQLCMD.EXE with variables specified on the command line.
---- However you can also run it in SQL Management Studio by uncommenting this section (CTRL+K, CTRL+U).
--:setvar DatabaseName "StackOverflowSCA_DEV"
--:setvar ReleaseVersion ""
--:setvar ForceDeployWithoutBaseline "False"
--:setvar DefaultFilePrefix "StackOverflowSCA_DEV"
--:setvar DeployPath ""
--:setvar DefaultDataPath ""
--:setvar DefaultLogPath ""
--:setvar DefaultBackupPath ""
----====================================================================================================================

:on error exit -- Instructs SQLCMD to abort execution as soon as an erroneous batch is encountered

:setvar PackageVersion "(undefined)"
:setvar IsShadowDeployment 0

GO
:setvar IsSqlCmdEnabled "True"
GO

IF N'$(DatabaseName)' = N'$' + N'(DatabaseName)' OR
   N'$(ReleaseVersion)' = N'$' + N'(ReleaseVersion)' OR
   N'$(ForceDeployWithoutBaseline)' = N'$' + N'(ForceDeployWithoutBaseline)'
      RAISERROR('(This will not throw). Please make sure that all SQLCMD variables are defined before running this script.', 0, 0);
GO

SET IMPLICIT_TRANSACTIONS, NUMERIC_ROUNDABORT OFF;
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, NOCOUNT, QUOTED_IDENTIFIER ON;
SET XACT_ABORT ON; -- Abort the current batch immediately if a statement raises a run-time error and rollback any open transaction(s)

IF N'$(IsSqlCmdEnabled)' <> N'True' -- Is SQLCMD mode not enabled within the execution context (eg. SSMS)
    BEGIN
        IF IS_SRVROLEMEMBER(N'sysadmin') = 1
            BEGIN -- User is sysadmin; abort execution by disconnect the script from the database server
                RAISERROR(N'This script must be run in SQLCMD Mode (under the Query menu in SSMS). Aborting connection to suppress subsequent errors.', 20, 127, N'UNKNOWN') WITH LOG;
            END
        ELSE
            BEGIN -- User is not sysadmin; abort execution by switching off statement execution (script will continue to the end without performing any actual deployment work)
                RAISERROR(N'This script must be run in SQLCMD Mode (under the Query menu in SSMS). Script execution has been halted.', 16, 127, N'UNKNOWN') WITH NOWAIT;
            END
    END
GO
IF @@ERROR != 0
    BEGIN
        SET NOEXEC ON; -- SQLCMD is NOT enabled so prevent any further statements from executing
    END
GO
-- Beyond this point, no further explicit error handling is required because it can be assumed that SQLCMD mode is enabled

IF SERVERPROPERTY('EngineEdition') = 5 AND DB_NAME() != N'$(DatabaseName)'
  RAISERROR(N'Azure SQL Database does not support switching between databases. Connect to [$(DatabaseName)] and then re-run the script.', 16, 127);








------------------------------------------------------------------------------------------------------------------------
------------------------------------------       PRE-DEPLOYMENT SCRIPTS       ------------------------------------------
------------------------------------------------------------------------------------------------------------------------

SET IMPLICIT_TRANSACTIONS, NUMERIC_ROUNDABORT OFF;
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, NOCOUNT, QUOTED_IDENTIFIER ON;

PRINT '----- executing pre-deployment script "Pre-Deployment\01_Create_Database.sql" -----';
GO

------------------------- BEGIN PRE-DEPLOYMENT SCRIPT: "Pre-Deployment\01_Create_Database.sql" ---------------------------
IF (DB_ID(N'$(DatabaseName)') IS NULL)
BEGIN
	PRINT N'Creating $(DatabaseName)...';
END
GO
IF (DB_ID(N'$(DatabaseName)') IS NULL)
BEGIN
	CREATE DATABASE [$(DatabaseName)]; -- MODIFY THIS STATEMENT TO SPECIFY A COLLATION FOR YOUR DATABASE
END

GO
-------------------------- END PRE-DEPLOYMENT SCRIPT: "Pre-Deployment\01_Create_Database.sql" ----------------------------

SET IMPLICIT_TRANSACTIONS, NUMERIC_ROUNDABORT OFF;
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, NOCOUNT, QUOTED_IDENTIFIER ON;









------------------------------------------------------------------------------------------------------------------------
------------------------------------------       INCREMENTAL MIGRATIONS       ------------------------------------------
------------------------------------------------------------------------------------------------------------------------

SET IMPLICIT_TRANSACTIONS, NUMERIC_ROUNDABORT OFF;
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, NOCOUNT, QUOTED_IDENTIFIER ON;

GO
PRINT '# Beginning transaction';

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

SET XACT_ABORT ON;

BEGIN TRANSACTION;

GO
IF DB_ID('$(DatabaseName)') IS NULL
  RAISERROR ('The database [$(DatabaseName)] could not be found. Please ensure that there is a Pre-Deployment script within your project that contains a CREATE DATABASE statement (e.g. Pre-Deployment\01_Create_Database.sql).', 16, 127);

GO
IF DB_NAME() != '$(DatabaseName)'
    USE [$(DatabaseName)];

GO
IF (NOT EXISTS (SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[__MigrationLog]') AND [type] = 'U'))
  BEGIN
    IF OBJECT_ID(N'[dbo].[__MigrationLogCurrent]', 'V') IS NOT NULL
      DROP VIEW [dbo].[__MigrationLogCurrent];
    CREATE TABLE [dbo].[__MigrationLog] (
      [migration_id] UNIQUEIDENTIFIER NOT NULL,
      [script_checksum] NVARCHAR (64) NOT NULL,
      [script_filename] NVARCHAR (255) NOT NULL,
      [complete_dt] DATETIME2 NOT NULL,
      [applied_by] NVARCHAR (100) NOT NULL,
      [deployed] TINYINT CONSTRAINT [DF___MigrationLog_deployed] DEFAULT (1) NOT NULL,
      [version] VARCHAR (255) NULL,
      [package_version] VARCHAR (255) NULL,
      [release_version] VARCHAR (255) NULL,
      [sequence_no] INT IDENTITY (1, 1) NOT NULL CONSTRAINT [PK___MigrationLog] PRIMARY KEY CLUSTERED ([migration_id], [complete_dt], [script_checksum]));
    CREATE NONCLUSTERED INDEX [IX___MigrationLog_CompleteDt]
      ON [dbo].[__MigrationLog]([complete_dt]);
    CREATE NONCLUSTERED INDEX [IX___MigrationLog_Version]
      ON [dbo].[__MigrationLog]([version]);
    CREATE UNIQUE NONCLUSTERED INDEX [UX___MigrationLog_SequenceNo]
      ON [dbo].[__MigrationLog]([sequence_no]);
    EXECUTE ('
	CREATE VIEW [dbo].[__MigrationLogCurrent]
			AS
			WITH currentMigration AS
			(
			  SELECT
				 migration_id, script_checksum, script_filename, complete_dt, applied_by, deployed, ROW_NUMBER() OVER(PARTITION BY migration_id ORDER BY sequence_no DESC) AS RowNumber
			  FROM [dbo].[__MigrationLog]
			)
			SELECT  migration_id, script_checksum, script_filename, complete_dt, applied_by, deployed
			FROM currentMigration
			WHERE RowNumber = 1
	');
    IF OBJECT_ID(N'sp_addextendedproperty', 'P') IS NOT NULL
      BEGIN
        PRINT N'Creating extended properties';
        EXECUTE sp_addextendedproperty N'MS_Description', N'This table is required by SQL Change Automation projects to keep track of which migrations have been executed during deployment. Please do not alter or remove this table from the database.', 'SCHEMA', N'dbo', 'TABLE', N'__MigrationLog', NULL, NULL;
        EXECUTE sp_addextendedproperty N'MS_Description', N'The executing user at the time of deployment (populated using the SYSTEM_USER function).', 'SCHEMA', N'dbo', 'TABLE', N'__MigrationLog', 'COLUMN', N'applied_by';
        EXECUTE sp_addextendedproperty N'MS_Description', N'The date/time that the migration finished executing. This value is populated using the SYSDATETIME function.', 'SCHEMA', N'dbo', 'TABLE', N'__MigrationLog', 'COLUMN', N'complete_dt';
        EXECUTE sp_addextendedproperty N'MS_Description', N'This column contains a number of potential states:

0 - Marked As Deployed: The migration was not executed.
1- Deployed: The migration was executed successfully.
2- Imported: The migration was generated by importing from this DB.

"Marked As Deployed" and "Imported" are similar in that the migration was not executed on this database; it was was only marked as such to prevent it from executing during subsequent deployments.', 'SCHEMA', N'dbo', 'TABLE', N'__MigrationLog', 'COLUMN', N'deployed';
        EXECUTE sp_addextendedproperty N'MS_Description', N'The unique identifier of a migration script file. This value is stored within the <Migration /> Xml fragment within the header of the file itself.

Note that it is possible for this value to repeat in the [__MigrationLog] table. In the case of programmable object scripts, a record will be inserted with a particular ID each time a change is made to the source file and subsequently deployed.

In the case of a migration, you may see the same [migration_id] repeated, but only in the scenario where the "Mark As Deployed" button/command has been run.', 'SCHEMA', N'dbo', 'TABLE', N'__MigrationLog', 'COLUMN', N'migration_id';
        EXECUTE sp_addextendedproperty N'MS_Description', N'If you have enabled SQLCMD Packaging in your SQL Change Automation project, or if you are using Octopus Deploy, this will be the version number that your database package was stamped with at build-time.', 'SCHEMA', N'dbo', 'TABLE', N'__MigrationLog', 'COLUMN', N'package_version';
        EXECUTE sp_addextendedproperty N'MS_Description', N'If you are using Octopus Deploy, you can use the value in this column to look-up which release was responsible for deploying this migration.
If deploying via PowerShell, set the $ReleaseVersion variable to populate this column.
If deploying via Visual Studio, this column will always be NULL.', 'SCHEMA', N'dbo', 'TABLE', N'__MigrationLog', 'COLUMN', N'release_version';
        EXECUTE sp_addextendedproperty N'MS_Description', N'A SHA256 representation of the migration script file at the time of build.  This value is used to determine whether a migration has been changed since it was deployed. In the case of a programmable object script, a different checksum will cause the migration to be redeployed.
Note: if any variables have been specified as part of a deployment, this will not affect the checksum value.', 'SCHEMA', N'dbo', 'TABLE', N'__MigrationLog', 'COLUMN', N'script_checksum';
        EXECUTE sp_addextendedproperty N'MS_Description', N'The name of the migration script file on disk, at the time of build.
If Semantic Versioning has been enabled, then this value will contain the full relative path from the root of the project folder. If it is not enabled, then it will simply contain the filename itself.', 'SCHEMA', N'dbo', 'TABLE', N'__MigrationLog', 'COLUMN', N'script_filename';
        EXECUTE sp_addextendedproperty N'MS_Description', N'An auto-seeded numeric identifier that can be used to determine the order in which migrations were deployed.', 'SCHEMA', N'dbo', 'TABLE', N'__MigrationLog', 'COLUMN', N'sequence_no';
        EXECUTE sp_addextendedproperty N'MS_Description', N'The semantic version that this migration was created under. In SQL Change Automation projects, a folder can be given a version number, e.g. 1.0.0, and one or more migration scripts can be stored within that folder to provide logical grouping of related database changes.', 'SCHEMA', N'dbo', 'TABLE', N'__MigrationLog', 'COLUMN', N'version';
        EXECUTE sp_addextendedproperty N'MS_Description', N'This view is required by SQL Change Automation projects to determine whether a migration should be executed during a deployment. The view lists the most recent [__MigrationLog] entry for a given [migration_id], which is needed to determine whether a particular programmable object script needs to be (re)executed: a non-matching checksum on the current [__MigrationLog] entry will trigger the execution of a programmable object script. Please do not alter or remove this table from the database.', N'SCHEMA', N'dbo', N'VIEW', N'__MigrationLogCurrent', NULL, NULL;
      END
  END

IF NOT EXISTS (SELECT col.COLUMN_NAME FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS tab, INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE AS col WHERE col.CONSTRAINT_NAME = tab.CONSTRAINT_NAME AND col.TABLE_NAME = tab.TABLE_NAME AND col.TABLE_SCHEMA = tab.TABLE_SCHEMA AND tab.CONSTRAINT_TYPE = 'PRIMARY KEY' AND col.TABLE_SCHEMA = 'dbo' AND col.TABLE_NAME = '__MigrationLog' AND col.COLUMN_NAME = 'complete_dt')
  BEGIN
    RAISERROR (N'The SQL Change Automation [dbo].[__MigrationLog] table has an incorrect primary key specification. This may be due to the fact that the <SqlChangeAutomationSchemaVersion/> element in your .sqlproj file contains the wrong version number for your database. Please check earlier versions of your .sqlproj file to determine what is the appropriate version for your database (possibly 1.7 or 1.3.1).', 16, 127, N'UNKNOWN')
      WITH NOWAIT;
    RETURN;
  END

IF COL_LENGTH(N'[dbo].[__MigrationLog]', N'sequence_no') IS NULL
  BEGIN
    RAISERROR (N'The SQL Change Automation [dbo].[__MigrationLog] table is missing the [sequence_no] column. This may be due to the fact that the <SqlChangeAutomationSchemaVersion/> element in your .sqlproj file contains the wrong version number for your database. Please check earlier versions of your .sqlproj file to determine what is the appropriate version for your database (possibly 1.7 or 1.3.1).', 16, 127, N'UNKNOWN')
      WITH NOWAIT;
    RETURN;
  END

IF (NOT EXISTS (SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[__MigrationLogCurrent]') AND [type] = 'V'))
  BEGIN
    EXECUTE ('
	CREATE VIEW [dbo].[__MigrationLogCurrent]
			AS
			WITH currentMigration AS
			(
			  SELECT
				 migration_id, script_checksum, script_filename, complete_dt, applied_by, deployed, ROW_NUMBER() OVER(PARTITION BY migration_id ORDER BY sequence_no DESC) AS RowNumber
			  FROM [dbo].[__MigrationLog]
			)
			SELECT  migration_id, script_checksum, script_filename, complete_dt, applied_by, deployed
			FROM currentMigration
			WHERE RowNumber = 1
	');
  END

GO
IF (NOT EXISTS (SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[__SchemaSnapshot]')))
  BEGIN
    CREATE TABLE [dbo].[__SchemaSnapshot] (
      [Snapshot] VARBINARY (MAX),
      [LastUpdateDate] DATETIME2 CONSTRAINT [__SchemaSnapshotDateDefault] DEFAULT SYSDATETIME());
    IF OBJECT_ID(N'sp_addextendedproperty', 'P') IS NOT NULL
      BEGIN
        EXECUTE sp_addextendedproperty N'MS_Description', N'This table is used by SQL Change Automation projects to store a snapshot of the schema at the time of the last deployment. Please do not alter or remove this table from the database.', 'SCHEMA', N'dbo', 'TABLE', N'__SchemaSnapshot', NULL, NULL;
      END
  END

GO
TRUNCATE TABLE [dbo].[__SchemaSnapshot];

GO
DECLARE @baselineRequired AS BIT;

SET @baselineRequired = 0;

IF (EXISTS (SELECT * FROM sys.objects AS o WHERE o.is_ms_shipped = 0 AND NOT (o.name LIKE '%__MigrationLog%' OR o.name LIKE '%__SchemaSnapshot%')) AND (SELECT count(*) FROM [dbo].[__MigrationLog]) = 0)
  SET @baselineRequired = 1;

IF @baselineRequired = 1
  BEGIN
    PRINT '----- baselined: Migrations\1.0.0-Baseline\001_20180920-2137_arneh.eskandari.sql (marked as deployed) -----';
    INSERT [$(DatabaseName)].[dbo].[__MigrationLog] ([migration_id], [script_checksum], [script_filename], [complete_dt], [applied_by], [deployed], [version], [package_version], [release_version])
    VALUES                                         (CAST ('a05eaa36-6193-4cb2-a5a2-a62c651299d4' AS UNIQUEIDENTIFIER), '111A26FDE8DF171770B0A416DA210834D4D540C6F3C8EDFC6F6A438F5D30F944', 'Migrations\1.0.0-Baseline\001_20180920-2137_arneh.eskandari.sql', SYSDATETIME(), SYSTEM_USER, 0, NULL, '$(PackageVersion)', CASE '$(ReleaseVersion)' WHEN '' THEN NULL ELSE '$(ReleaseVersion)' END);
  END

GO
SET IMPLICIT_TRANSACTIONS, NUMERIC_ROUNDABORT OFF;
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, NOCOUNT, QUOTED_IDENTIFIER ON;

GO
IF DB_NAME() != '$(DatabaseName)'
    USE [$(DatabaseName)];

GO
IF NOT EXISTS (SELECT 1 FROM [$(DatabaseName)].[dbo].[__MigrationLogCurrent] WHERE [migration_id] = CAST ('a05eaa36-6193-4cb2-a5a2-a62c651299d4' AS UNIQUEIDENTIFIER))
  PRINT '

***** EXECUTING MIGRATION "Migrations\1.0.0-Baseline\001_20180920-2137_arneh.eskandari.sql", ID: {a05eaa36-6193-4cb2-a5a2-a62c651299d4} *****';

GO
IF EXISTS (SELECT 1 FROM [$(DatabaseName)].[dbo].[__MigrationLogCurrent] WHERE [migration_id] = CAST ('a05eaa36-6193-4cb2-a5a2-a62c651299d4' AS UNIQUEIDENTIFIER))
  SET NOEXEC ON;

GO
EXECUTE ('
IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N''RED-GATE\Joshua.Rodriguez'')
CREATE LOGIN [RED-GATE\Joshua.Rodriguez] FROM WINDOWS
');

GO
EXECUTE ('CREATE USER [RED-GATE\Joshua.Rodriguez] FOR LOGIN [RED-GATE\Joshua.Rodriguez]
');

GO
EXECUTE ('PRINT N''Creating schemas''
');

GO
EXECUTE ('CREATE SCHEMA [RedGateLocal]
AUTHORIZATION [dbo]
');

GO
EXECUTE ('PRINT N''Creating [dbo].[Comments]''
');

GO
EXECUTE ('CREATE TABLE [dbo].[Comments]
(
[Id] [int] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[PostId] [int] NOT NULL,
[Score] [int] NULL,
[Text] [nvarchar] (700) NOT NULL,
[UserId] [int] NULL
)
');

GO
EXECUTE ('PRINT N''Creating primary key [PK_Comments__Id] on [dbo].[Comments]''
');

GO
EXECUTE ('ALTER TABLE [dbo].[Comments] ADD CONSTRAINT [PK_Comments__Id] PRIMARY KEY CLUSTERED  ([Id])
');

GO
EXECUTE ('PRINT N''Creating [dbo].[GetComments]''
');

GO
EXECUTE ('--SET QUOTED_IDENTIFIER ON|OFF
--SET ANSI_NULLS ON|OFF
--RED-GATE\arneh.eskandari
--GO
CREATE PROCEDURE [dbo].[GetComments]
    
-- WITH ENCRYPTION, RECOMPILE, EXECUTE AS CALLER|SELF|OWNER| ''user_name''
AS
    SELECT Text  
    FROM    dbo.Comments;
');

GO
EXECUTE ('PRINT N''Creating [dbo].[Posts]''
');

GO
EXECUTE ('CREATE TABLE [dbo].[Posts]
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
');

GO
EXECUTE ('PRINT N''Creating primary key [PK_Posts__Id] on [dbo].[Posts]''
');

GO
EXECUTE ('ALTER TABLE [dbo].[Posts] ADD CONSTRAINT [PK_Posts__Id] PRIMARY KEY CLUSTERED  ([Id])
');

GO
EXECUTE ('PRINT N''Creating [dbo].[GetPosts]''
');

GO
EXECUTE ('--SET QUOTED_IDENTIFIER ON|OFF
--SET ANSI_NULLS ON|OFF
--RED-GATE\arneh.eskandari
--GO
CREATE PROCEDURE [dbo].[GetPosts]
  
-- WITH ENCRYPTION, RECOMPILE, EXECUTE AS CALLER|SELF|OWNER| ''user_name''
AS
    SELECT  AnswerCount ,
            Body ,
            ClosedDate ,
            CreationDate ,
            CommentCount
    FROM    dbo.Posts;
');

GO
EXECUTE ('PRINT N''Creating [RedGateLocal].[DeploymentMetadata]''
');

GO
EXECUTE ('CREATE TABLE [RedGateLocal].[DeploymentMetadata]
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
');

GO
EXECUTE ('PRINT N''Creating primary key [PK__Deployme__3214EC075EAE2CAA] on [RedGateLocal].[DeploymentMetadata]''
');

GO
EXECUTE ('ALTER TABLE [RedGateLocal].[DeploymentMetadata] ADD CONSTRAINT [PK__Deployme__3214EC075EAE2CAA] PRIMARY KEY CLUSTERED  ([Id])
');

GO
EXECUTE ('PRINT N''Creating [dbo].[Badges]''
');

GO
EXECUTE ('CREATE TABLE [dbo].[Badges]
(
[Id] [int] NOT NULL,
[Name] [nvarchar] (40) NOT NULL,
[UserId] [int] NOT NULL,
[Date] [datetime] NOT NULL
)
');

GO
EXECUTE ('PRINT N''Creating primary key [PK_Badges__Id] on [dbo].[Badges]''
');

GO
EXECUTE ('ALTER TABLE [dbo].[Badges] ADD CONSTRAINT [PK_Badges__Id] PRIMARY KEY CLUSTERED  ([Id])
');

GO
EXECUTE ('PRINT N''Creating [dbo].[DMSSTAT_RSTATS]''
');

GO
EXECUTE ('CREATE TABLE [dbo].[DMSSTAT_RSTATS]
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
');

GO
EXECUTE ('PRINT N''Creating index [IX_DMSSTAT_RSTATS] on [dbo].[DMSSTAT_RSTATS]''
');

GO
EXECUTE ('CREATE NONCLUSTERED INDEX [IX_DMSSTAT_RSTATS] ON [dbo].[DMSSTAT_RSTATS] ([runid], [ruleid])
');

GO
EXECUTE ('PRINT N''Creating [dbo].[DMSSTAT_TSTATS]''
');

GO
EXECUTE ('CREATE TABLE [dbo].[DMSSTAT_TSTATS]
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
');

GO
EXECUTE ('PRINT N''Creating index [IX_DMSSTAT_TSTATS_A] on [dbo].[DMSSTAT_TSTATS]''
');

GO
EXECUTE ('CREATE NONCLUSTERED INDEX [IX_DMSSTAT_TSTATS_A] ON [dbo].[DMSSTAT_TSTATS] ([runid], [ruleid])
');

GO
EXECUTE ('PRINT N''Creating [dbo].[LinkTypes]''
');

GO
EXECUTE ('CREATE TABLE [dbo].[LinkTypes]
(
[Id] [int] NOT NULL,
[Type] [varchar] (50) NOT NULL
)
');

GO
EXECUTE ('PRINT N''Creating primary key [PK_LinkTypes__Id] on [dbo].[LinkTypes]''
');

GO
EXECUTE ('ALTER TABLE [dbo].[LinkTypes] ADD CONSTRAINT [PK_LinkTypes__Id] PRIMARY KEY CLUSTERED  ([Id])
');

GO
EXECUTE ('PRINT N''Creating [dbo].[PostLinks]''
');

GO
EXECUTE ('CREATE TABLE [dbo].[PostLinks]
(
[Id] [int] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[PostId] [int] NOT NULL,
[RelatedPostId] [int] NOT NULL,
[LinkTypeId] [int] NOT NULL
)
');

GO
EXECUTE ('PRINT N''Creating primary key [PK_PostLinks__Id] on [dbo].[PostLinks]''
');

GO
EXECUTE ('ALTER TABLE [dbo].[PostLinks] ADD CONSTRAINT [PK_PostLinks__Id] PRIMARY KEY CLUSTERED  ([Id])
');

GO
EXECUTE ('PRINT N''Creating [dbo].[PostTypes]''
');

GO
EXECUTE ('CREATE TABLE [dbo].[PostTypes]
(
[Id] [int] NOT NULL,
[Type] [nvarchar] (50) NOT NULL
)
');

GO
EXECUTE ('PRINT N''Creating primary key [PK_PostTypes__Id] on [dbo].[PostTypes]''
');

GO
EXECUTE ('ALTER TABLE [dbo].[PostTypes] ADD CONSTRAINT [PK_PostTypes__Id] PRIMARY KEY CLUSTERED  ([Id])
');

GO
EXECUTE ('PRINT N''Creating [dbo].[Users]''
');

GO
EXECUTE ('CREATE TABLE [dbo].[Users]
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
');

GO
EXECUTE ('PRINT N''Creating primary key [PK_Users_Id] on [dbo].[Users]''
');

GO
EXECUTE ('ALTER TABLE [dbo].[Users] ADD CONSTRAINT [PK_Users_Id] PRIMARY KEY CLUSTERED  ([Id])
');

GO
EXECUTE ('PRINT N''Creating [dbo].[VoteTypes]''
');

GO
EXECUTE ('CREATE TABLE [dbo].[VoteTypes]
(
[Id] [int] NOT NULL,
[Name] [varchar] (50) NOT NULL
)
');

GO
EXECUTE ('PRINT N''Creating primary key [PK_VoteType__Id] on [dbo].[VoteTypes]''
');

GO
EXECUTE ('ALTER TABLE [dbo].[VoteTypes] ADD CONSTRAINT [PK_VoteType__Id] PRIMARY KEY CLUSTERED  ([Id])
');

GO
EXECUTE ('PRINT N''Creating [dbo].[Votes]''
');

GO
EXECUTE ('CREATE TABLE [dbo].[Votes]
(
[Id] [int] NOT NULL,
[PostId] [int] NOT NULL,
[UserId] [int] NULL,
[BountyAmount] [int] NULL,
[VoteTypeId] [int] NOT NULL,
[CreationDate] [datetime] NOT NULL
)
');

GO
EXECUTE ('PRINT N''Creating primary key [PK_Votes__Id] on [dbo].[Votes]''
');

GO
EXECUTE ('ALTER TABLE [dbo].[Votes] ADD CONSTRAINT [PK_Votes__Id] PRIMARY KEY CLUSTERED  ([Id])
');

GO
EXECUTE ('PRINT N''Creating extended properties''
');

GO
EXECUTE ('EXEC sp_addextendedproperty N''MS_Description'', N''This table records deployments with migration scripts. Learn more: http://rd.gt/230GBP3'', ''SCHEMA'', N''RedGateLocal'', ''TABLE'', N''DeploymentMetadata'', NULL, NULL
');

GO
SET NOEXEC OFF;

GO
IF N'$(IsSqlCmdEnabled)' <> N'True'
  SET NOEXEC ON;

GO
IF NOT EXISTS (SELECT 1 FROM [$(DatabaseName)].[dbo].[__MigrationLogCurrent] WHERE [migration_id] = CAST ('a05eaa36-6193-4cb2-a5a2-a62c651299d4' AS UNIQUEIDENTIFIER))
  PRINT '***** FINISHED EXECUTING MIGRATION "Migrations\1.0.0-Baseline\001_20180920-2137_arneh.eskandari.sql", ID: {a05eaa36-6193-4cb2-a5a2-a62c651299d4} *****
';

GO
IF NOT EXISTS (SELECT 1 FROM [$(DatabaseName)].[dbo].[__MigrationLogCurrent] WHERE [migration_id] = CAST ('a05eaa36-6193-4cb2-a5a2-a62c651299d4' AS UNIQUEIDENTIFIER))
  INSERT [$(DatabaseName)].[dbo].[__MigrationLog] ([migration_id], [script_checksum], [script_filename], [complete_dt], [applied_by], [deployed], [version], [package_version], [release_version])
  VALUES                                         (CAST ('a05eaa36-6193-4cb2-a5a2-a62c651299d4' AS UNIQUEIDENTIFIER), '111A26FDE8DF171770B0A416DA210834D4D540C6F3C8EDFC6F6A438F5D30F944', 'Migrations\1.0.0-Baseline\001_20180920-2137_arneh.eskandari.sql', SYSDATETIME(), SYSTEM_USER, 1, NULL, '$(PackageVersion)', CASE '$(ReleaseVersion)' WHEN '' THEN NULL ELSE '$(ReleaseVersion)' END);

GO
SET IMPLICIT_TRANSACTIONS, NUMERIC_ROUNDABORT OFF;
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, NOCOUNT, QUOTED_IDENTIFIER ON;

GO
IF DB_NAME() != '$(DatabaseName)'
    USE [$(DatabaseName)];

GO
IF NOT EXISTS (SELECT 1 FROM [$(DatabaseName)].[dbo].[__MigrationLogCurrent] WHERE [migration_id] = CAST ('448b814a-e547-43f2-9f3d-2dc5e024b2af' AS UNIQUEIDENTIFIER))
  PRINT '

***** EXECUTING MIGRATION "Migrations\1.1.0-Changes\001_20180920-2208_arneh.eskandari.sql", ID: {448b814a-e547-43f2-9f3d-2dc5e024b2af} *****';

GO
IF EXISTS (SELECT 1 FROM [$(DatabaseName)].[dbo].[__MigrationLogCurrent] WHERE [migration_id] = CAST ('448b814a-e547-43f2-9f3d-2dc5e024b2af' AS UNIQUEIDENTIFIER))
  SET NOEXEC ON;

GO
EXECUTE ('
PRINT N''Altering [dbo].[Users]''
');

GO
EXECUTE ('ALTER TABLE [dbo].[Users] ADD
[Facebook] [nvarchar] (50) NULL
');

GO
SET NOEXEC OFF;

GO
IF N'$(IsSqlCmdEnabled)' <> N'True'
  SET NOEXEC ON;

GO
IF NOT EXISTS (SELECT 1 FROM [$(DatabaseName)].[dbo].[__MigrationLogCurrent] WHERE [migration_id] = CAST ('448b814a-e547-43f2-9f3d-2dc5e024b2af' AS UNIQUEIDENTIFIER))
  PRINT '***** FINISHED EXECUTING MIGRATION "Migrations\1.1.0-Changes\001_20180920-2208_arneh.eskandari.sql", ID: {448b814a-e547-43f2-9f3d-2dc5e024b2af} *****
';

GO
IF NOT EXISTS (SELECT 1 FROM [$(DatabaseName)].[dbo].[__MigrationLogCurrent] WHERE [migration_id] = CAST ('448b814a-e547-43f2-9f3d-2dc5e024b2af' AS UNIQUEIDENTIFIER))
  INSERT [$(DatabaseName)].[dbo].[__MigrationLog] ([migration_id], [script_checksum], [script_filename], [complete_dt], [applied_by], [deployed], [version], [package_version], [release_version])
  VALUES                                         (CAST ('448b814a-e547-43f2-9f3d-2dc5e024b2af' AS UNIQUEIDENTIFIER), 'CF115F54D64051AAAC08D5E34FA708E0AB879C6AC01B6196D9E689F36304F619', 'Migrations\1.1.0-Changes\001_20180920-2208_arneh.eskandari.sql', SYSDATETIME(), SYSTEM_USER, 1, NULL, '$(PackageVersion)', CASE '$(ReleaseVersion)' WHEN '' THEN NULL ELSE '$(ReleaseVersion)' END);

GO
SET IMPLICIT_TRANSACTIONS, NUMERIC_ROUNDABORT OFF;
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, NOCOUNT, QUOTED_IDENTIFIER ON;

GO
IF DB_NAME() != '$(DatabaseName)'
    USE [$(DatabaseName)];

GO
IF NOT EXISTS (SELECT 1 FROM [$(DatabaseName)].[dbo].[__MigrationLogCurrent] WHERE [migration_id] = CAST ('4eedae43-5b7f-47b8-a892-29922dc81949' AS UNIQUEIDENTIFIER))
  PRINT '

***** EXECUTING MIGRATION "Migrations\1.1.0-Changes\002_20180921-0723_arneh.eskandari.sql", ID: {4eedae43-5b7f-47b8-a892-29922dc81949} *****';

GO
IF EXISTS (SELECT 1 FROM [$(DatabaseName)].[dbo].[__MigrationLogCurrent] WHERE [migration_id] = CAST ('4eedae43-5b7f-47b8-a892-29922dc81949' AS UNIQUEIDENTIFIER))
  SET NOEXEC ON;

GO
EXECUTE ('
PRINT N''Altering [dbo].[Users]''
');

GO
EXECUTE ('ALTER TABLE [dbo].[Users] ADD
[LinkedIn] [nvarchar] (50) NULL
');

GO
SET NOEXEC OFF;

GO
IF N'$(IsSqlCmdEnabled)' <> N'True'
  SET NOEXEC ON;

GO
IF NOT EXISTS (SELECT 1 FROM [$(DatabaseName)].[dbo].[__MigrationLogCurrent] WHERE [migration_id] = CAST ('4eedae43-5b7f-47b8-a892-29922dc81949' AS UNIQUEIDENTIFIER))
  PRINT '***** FINISHED EXECUTING MIGRATION "Migrations\1.1.0-Changes\002_20180921-0723_arneh.eskandari.sql", ID: {4eedae43-5b7f-47b8-a892-29922dc81949} *****
';

GO
IF NOT EXISTS (SELECT 1 FROM [$(DatabaseName)].[dbo].[__MigrationLogCurrent] WHERE [migration_id] = CAST ('4eedae43-5b7f-47b8-a892-29922dc81949' AS UNIQUEIDENTIFIER))
  INSERT [$(DatabaseName)].[dbo].[__MigrationLog] ([migration_id], [script_checksum], [script_filename], [complete_dt], [applied_by], [deployed], [version], [package_version], [release_version])
  VALUES                                         (CAST ('4eedae43-5b7f-47b8-a892-29922dc81949' AS UNIQUEIDENTIFIER), '81DB38EF782E9622BA28E49DC93E5BBF5EDDEFC69208DF0966C0A4238A953CE7', 'Migrations\1.1.0-Changes\002_20180921-0723_arneh.eskandari.sql', SYSDATETIME(), SYSTEM_USER, 1, NULL, '$(PackageVersion)', CASE '$(ReleaseVersion)' WHEN '' THEN NULL ELSE '$(ReleaseVersion)' END);

GO
SET IMPLICIT_TRANSACTIONS, NUMERIC_ROUNDABORT OFF;
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, NOCOUNT, QUOTED_IDENTIFIER ON;

GO
IF DB_NAME() != '$(DatabaseName)'
    USE [$(DatabaseName)];

GO
IF NOT EXISTS (SELECT 1 FROM [$(DatabaseName)].[dbo].[__MigrationLogCurrent] WHERE [migration_id] = CAST ('0f4bcf1a-0ed7-527b-86fd-287c491bf2fd' AS UNIQUEIDENTIFIER) AND [script_checksum] = '516F6FD6BC7E396EBAE0D098A9C99DA34DE9FE4EA345927772323C9499C0AA58')
  PRINT '

***** EXECUTING MIGRATION "Programmable Objects\dbo\Stored Procedures\GetComments.sql", ID: {0f4bcf1a-0ed7-527b-86fd-287c491bf2fd} *****';

GO
IF EXISTS (SELECT 1 FROM [$(DatabaseName)].[dbo].[__MigrationLogCurrent] WHERE [migration_id] = CAST ('0f4bcf1a-0ed7-527b-86fd-287c491bf2fd' AS UNIQUEIDENTIFIER) AND [script_checksum] = '516F6FD6BC7E396EBAE0D098A9C99DA34DE9FE4EA345927772323C9499C0AA58')
  SET NOEXEC ON;

GO
EXECUTE ('IF OBJECT_ID(''[dbo].[GetComments]'') IS NOT NULL
	DROP PROCEDURE [dbo].[GetComments];

');

GO
SET QUOTED_IDENTIFIER ON

GO
SET ANSI_NULLS ON

GO
EXECUTE ('--SET QUOTED_IDENTIFIER ON|OFF
--SET ANSI_NULLS ON|OFF
--RED-GATE\arneh.eskandari
--GO
CREATE PROCEDURE [dbo].[GetComments]

-- WITH ENCRYPTION, RECOMPILE, EXECUTE AS CALLER|SELF|OWNER| ''user_name''
AS
SELECT Text,
       Score
FROM dbo.Comments;
');

GO
SET NOEXEC OFF;

GO
IF N'$(IsSqlCmdEnabled)' <> N'True'
  SET NOEXEC ON;

GO
IF NOT EXISTS (SELECT 1 FROM [$(DatabaseName)].[dbo].[__MigrationLogCurrent] WHERE [migration_id] = CAST ('0f4bcf1a-0ed7-527b-86fd-287c491bf2fd' AS UNIQUEIDENTIFIER) AND [script_checksum] = '516F6FD6BC7E396EBAE0D098A9C99DA34DE9FE4EA345927772323C9499C0AA58')
  PRINT '***** FINISHED EXECUTING MIGRATION "Programmable Objects\dbo\Stored Procedures\GetComments.sql", ID: {0f4bcf1a-0ed7-527b-86fd-287c491bf2fd} *****
';

GO
IF NOT EXISTS (SELECT 1 FROM [$(DatabaseName)].[dbo].[__MigrationLogCurrent] WHERE [migration_id] = CAST ('0f4bcf1a-0ed7-527b-86fd-287c491bf2fd' AS UNIQUEIDENTIFIER) AND [script_checksum] = '516F6FD6BC7E396EBAE0D098A9C99DA34DE9FE4EA345927772323C9499C0AA58')
  INSERT [$(DatabaseName)].[dbo].[__MigrationLog] ([migration_id], [script_checksum], [script_filename], [complete_dt], [applied_by], [deployed], [version], [package_version], [release_version])
  VALUES                                         (CAST ('0f4bcf1a-0ed7-527b-86fd-287c491bf2fd' AS UNIQUEIDENTIFIER), '516F6FD6BC7E396EBAE0D098A9C99DA34DE9FE4EA345927772323C9499C0AA58', 'Programmable Objects\dbo\Stored Procedures\GetComments.sql', SYSDATETIME(), SYSTEM_USER, 1, NULL, '$(PackageVersion)', CASE '$(ReleaseVersion)' WHEN '' THEN NULL ELSE '$(ReleaseVersion)' END);

GO
SET IMPLICIT_TRANSACTIONS, NUMERIC_ROUNDABORT OFF;
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, NOCOUNT, QUOTED_IDENTIFIER ON;

GO
IF DB_NAME() != '$(DatabaseName)'
    USE [$(DatabaseName)];

GO
IF NOT EXISTS (SELECT 1 FROM [$(DatabaseName)].[dbo].[__MigrationLogCurrent] WHERE [migration_id] = CAST ('3cc36a5e-1462-5305-a78a-684731053a1d' AS UNIQUEIDENTIFIER) AND [script_checksum] = '11A3A11C5AEB1C32F1441B1A5632617CDD290623DCA83755C68AD05A6A2F5D45')
  PRINT '

***** EXECUTING MIGRATION "Programmable Objects\dbo\Stored Procedures\GetPosts.sql", ID: {3cc36a5e-1462-5305-a78a-684731053a1d} *****';

GO
IF EXISTS (SELECT 1 FROM [$(DatabaseName)].[dbo].[__MigrationLogCurrent] WHERE [migration_id] = CAST ('3cc36a5e-1462-5305-a78a-684731053a1d' AS UNIQUEIDENTIFIER) AND [script_checksum] = '11A3A11C5AEB1C32F1441B1A5632617CDD290623DCA83755C68AD05A6A2F5D45')
  SET NOEXEC ON;

GO
EXECUTE ('IF OBJECT_ID(''[dbo].[GetPosts]'') IS NOT NULL
	DROP PROCEDURE [dbo].[GetPosts];

');

GO
SET QUOTED_IDENTIFIER ON

GO
SET ANSI_NULLS ON

GO
EXECUTE ('--SET QUOTED_IDENTIFIER ON|OFF
--SET ANSI_NULLS ON|OFF
--RED-GATE\arneh.eskandari
--GO
CREATE PROCEDURE [dbo].[GetPosts]
  
-- WITH ENCRYPTION, RECOMPILE, EXECUTE AS CALLER|SELF|OWNER| ''user_name''
AS
    SELECT  AnswerCount ,
            Body ,
            ClosedDate ,
            CreationDate ,
            CommentCount
    FROM    dbo.Posts;
');

GO
SET NOEXEC OFF;

GO
IF N'$(IsSqlCmdEnabled)' <> N'True'
  SET NOEXEC ON;

GO
IF NOT EXISTS (SELECT 1 FROM [$(DatabaseName)].[dbo].[__MigrationLogCurrent] WHERE [migration_id] = CAST ('3cc36a5e-1462-5305-a78a-684731053a1d' AS UNIQUEIDENTIFIER) AND [script_checksum] = '11A3A11C5AEB1C32F1441B1A5632617CDD290623DCA83755C68AD05A6A2F5D45')
  PRINT '***** FINISHED EXECUTING MIGRATION "Programmable Objects\dbo\Stored Procedures\GetPosts.sql", ID: {3cc36a5e-1462-5305-a78a-684731053a1d} *****
';

GO
IF NOT EXISTS (SELECT 1 FROM [$(DatabaseName)].[dbo].[__MigrationLogCurrent] WHERE [migration_id] = CAST ('3cc36a5e-1462-5305-a78a-684731053a1d' AS UNIQUEIDENTIFIER) AND [script_checksum] = '11A3A11C5AEB1C32F1441B1A5632617CDD290623DCA83755C68AD05A6A2F5D45')
  INSERT [$(DatabaseName)].[dbo].[__MigrationLog] ([migration_id], [script_checksum], [script_filename], [complete_dt], [applied_by], [deployed], [version], [package_version], [release_version])
  VALUES                                         (CAST ('3cc36a5e-1462-5305-a78a-684731053a1d' AS UNIQUEIDENTIFIER), '11A3A11C5AEB1C32F1441B1A5632617CDD290623DCA83755C68AD05A6A2F5D45', 'Programmable Objects\dbo\Stored Procedures\GetPosts.sql', SYSDATETIME(), SYSTEM_USER, 1, NULL, '$(PackageVersion)', CASE '$(ReleaseVersion)' WHEN '' THEN NULL ELSE '$(ReleaseVersion)' END);

GO
PRINT '# Committing transaction';

COMMIT TRANSACTION;

GO







------------------------------------------------------------------------------------------------------------------------
------------------------------------------       POST-DEPLOYMENT SCRIPTS      ------------------------------------------
------------------------------------------------------------------------------------------------------------------------

SET IMPLICIT_TRANSACTIONS, NUMERIC_ROUNDABORT OFF;
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, NOCOUNT, QUOTED_IDENTIFIER ON;
IF DB_NAME() != '$(DatabaseName)'
    USE [$(DatabaseName)];

PRINT '----- executing post-deployment script "Post-Deployment\01_Finalize_Deployment.sql" -----';
GO

---------------------- BEGIN POST-DEPLOYMENT SCRIPT: "Post-Deployment\01_Finalize_Deployment.sql" ------------------------
/*
Post-Deployment Script Template
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.
 Use SQLCMD syntax to include a file in the post-deployment script.
 Example:      :r .\myfile.sql
 Use SQLCMD syntax to reference a variable in the post-deployment script.
 Example:      :setvar TableName MyTable
               SELECT * FROM [$(TableName)]
--------------------------------------------------------------------------------------
*/

GO
----------------------- END POST-DEPLOYMENT SCRIPT: "Post-Deployment\01_Finalize_Deployment.sql" -------------------------

SET IMPLICIT_TRANSACTIONS, NUMERIC_ROUNDABORT OFF;
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, NOCOUNT, QUOTED_IDENTIFIER ON;
IF DB_NAME() != '$(DatabaseName)'
    USE [$(DatabaseName)];


IF SERVERPROPERTY('EngineEdition') != 5 AND HAS_PERMS_BY_NAME(N'sys.xp_logevent', N'OBJECT', N'EXECUTE') = 1
BEGIN
  DECLARE @databaseName AS nvarchar(2048), @eventMessage AS nvarchar(2048)
  SET @databaseName = REPLACE(REPLACE(DB_NAME(), N'\', N'\\'), N'"', N'\"')
  SET @eventMessage = N'Redgate SQL Change Automation: { "deployment": { "description": "Redgate SQL Change Automation deployed $(ReleaseVersion) to ' + @databaseName + N'", "database": "' + @databaseName + N'" }}'
  EXECUTE sys.xp_logevent 55000, @eventMessage
END
PRINT 'Deployment completed successfully.'
GO




SET NOEXEC OFF; -- Resume statement execution if an error occurred within the script pre-amble
