﻿/*
    Target database:    StackOverflowSCA_DEV
    Target instance:    US-LT-ARNEHE3\MSSQLSERVER2017
    Generated date:     9/21/2018 7:29:43 AM
    Generated on:       US-LT-ARNEHE3
    Package version:    (undefined)
    Migration version:  (n/a)
    Baseline version:   (n/a)
    SQL Change Automation version:  3.0.18262.1427
    Migrations pending: 0

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
:setvar DatabaseName "StackOverflowSCA_DEV"
:setvar ReleaseVersion ""
:setvar ForceDeployWithoutBaseline "False"
:setvar DefaultFilePrefix "StackOverflowSCA_DEV"
:setvar DefaultDataPath "C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER2017\MSSQL\DATA\"
:setvar DefaultLogPath "C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER2017\MSSQL\DATA\"
:setvar DefaultBackupPath "C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER2017\MSSQL\Backup\"
----====================================================================================================================

:on error exit -- Instructs SQLCMD to abort execution as soon as an erroneous batch is encountered

:setvar PackageVersion "(undefined)"
:setvar IsShadowDeployment 0

GO
:setvar IsSqlCmdEnabled "True"
GO


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

-- As this script has been generated for a specific server instance/database combination, stop execution if there is a mismatch
IF (@@SERVERNAME != 'US-LT-ARNEHE3\MSSQLSERVER2017' OR '$(DatabaseName)' != 'StackOverflowSCA_DEV')
BEGIN
	RAISERROR(N'This script should only be executed on the following server/instance: [US-LT-ARNEHE3\MSSQLSERVER2017] (Database: [StackOverflowSCA_DEV]). Halting deployment.', 16, 127, N'UNKNOWN') WITH NOWAIT;
	RETURN;
END
GO







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


SET IMPLICIT_TRANSACTIONS, NUMERIC_ROUNDABORT OFF;
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, NOCOUNT, QUOTED_IDENTIFIER ON;

GO
IF DB_ID('$(DatabaseName)') IS NULL
  PRINT 'Creating [$(DatabaseName)]...';

GO
IF DB_ID('$(DatabaseName)') IS NULL
  CREATE DATABASE [$(DatabaseName)];

GO
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
TRUNCATE TABLE [dbo].[__SchemaSnapshot];

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
