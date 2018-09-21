-- <Migration ID="448b814a-e547-43f2-9f3d-2dc5e024b2af" />
GO

PRINT N'Altering [dbo].[Users]'
GO
ALTER TABLE [dbo].[Users] ADD
[Facebook] [nvarchar] (50) NULL
GO
