IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'RED-GATE\Joshua.Rodriguez')
CREATE LOGIN [RED-GATE\Joshua.Rodriguez] FROM WINDOWS
GO
CREATE USER [RED-GATE\Joshua.Rodriguez] FOR LOGIN [RED-GATE\Joshua.Rodriguez]
GO
