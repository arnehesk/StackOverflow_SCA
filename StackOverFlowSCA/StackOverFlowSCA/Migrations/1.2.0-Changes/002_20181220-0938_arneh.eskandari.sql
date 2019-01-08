-- <Migration ID="26cf1e6b-77e7-4698-a067-897be731f75a" />
GO

PRINT N'Altering [dbo].[Users]'
GO
ALTER TABLE [dbo].[Users] ADD
[SocialMedia] [nvarchar] (50) NULL
GO
