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
CREATE NONCLUSTERED INDEX [IX_DMSSTAT_TSTATS_A] ON [dbo].[DMSSTAT_TSTATS] ([runid], [ruleid])
GO
