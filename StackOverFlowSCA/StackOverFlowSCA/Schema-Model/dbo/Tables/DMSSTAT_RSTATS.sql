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
CREATE NONCLUSTERED INDEX [IX_DMSSTAT_RSTATS] ON [dbo].[DMSSTAT_RSTATS] ([runid], [ruleid])
GO
