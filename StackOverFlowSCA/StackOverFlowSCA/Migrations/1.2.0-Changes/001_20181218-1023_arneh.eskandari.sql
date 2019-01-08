-- <Migration ID="bd929552-fe8a-453e-9f0a-632e1359002f" />
GO

PRINT N'Altering [dbo].[Users]'
GO
ALTER TABLE [dbo].[Users] ADD
[Instagram] [nvarchar] (50) NULL
GO
UPDATE dbo.Users SET Instagram = 'Default' WHERE Instagram IS NULL
