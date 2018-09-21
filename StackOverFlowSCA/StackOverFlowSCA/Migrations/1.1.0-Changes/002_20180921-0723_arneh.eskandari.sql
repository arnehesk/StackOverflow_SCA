-- <Migration ID="4eedae43-5b7f-47b8-a892-29922dc81949" />
GO

PRINT N'Altering [dbo].[Users]'
GO
ALTER TABLE [dbo].[Users] ADD
[LinkedIn] [nvarchar] (50) NULL
GO
