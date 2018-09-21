-- <Migration ID="ad39ab10-be7d-4733-9d34-55d6b6e5f5ce" />
GO


SET DATEFORMAT YMD;


GO
IF (SELECT COUNT(*)
    FROM   [dbo].[LinkTypes]) = 0
    BEGIN
        PRINT (N'Add 3 rows to [dbo].[LinkTypes]');
        INSERT  INTO [dbo].[LinkTypes] ([Id], [Type])
        VALUES                        (1, 'Linked');
        INSERT  INTO [dbo].[LinkTypes] ([Id], [Type])
        VALUES                        (3, 'Duplicate');
        INSERT  INTO [dbo].[LinkTypes] ([Id], [Type])
        VALUES                        (4, 'Unlinked');
    END


GO
IF (SELECT COUNT(*)
    FROM   [dbo].[PostTypes]) = 0
    BEGIN
        PRINT (N'Add 8 rows to [dbo].[PostTypes]');
        INSERT  INTO [dbo].[PostTypes] ([Id], [Type])
        VALUES                        (1, N'Question');
        INSERT  INTO [dbo].[PostTypes] ([Id], [Type])
        VALUES                        (2, N'Answer');
        INSERT  INTO [dbo].[PostTypes] ([Id], [Type])
        VALUES                        (3, N'Wiki');
        INSERT  INTO [dbo].[PostTypes] ([Id], [Type])
        VALUES                        (4, N'TagWikiExerpt');
        INSERT  INTO [dbo].[PostTypes] ([Id], [Type])
        VALUES                        (5, N'TagWiki');
        INSERT  INTO [dbo].[PostTypes] ([Id], [Type])
        VALUES                        (6, N'ModeratorNomination');
        INSERT  INTO [dbo].[PostTypes] ([Id], [Type])
        VALUES                        (7, N'WikiPlaceholder');
        INSERT  INTO [dbo].[PostTypes] ([Id], [Type])
        VALUES                        (8, N'PrivilegeWiki');
    END


GO
IF (SELECT COUNT(*)
    FROM   [dbo].[VoteTypes]) = 0
    BEGIN
        PRINT (N'Add 15 rows to [dbo].[VoteTypes]');
        INSERT  INTO [dbo].[VoteTypes] ([Id], [Name])
        VALUES                        (1, 'AcceptedByOriginator');
        INSERT  INTO [dbo].[VoteTypes] ([Id], [Name])
        VALUES                        (2, 'UpMod');
        INSERT  INTO [dbo].[VoteTypes] ([Id], [Name])
        VALUES                        (3, 'DownMod');
        INSERT  INTO [dbo].[VoteTypes] ([Id], [Name])
        VALUES                        (4, 'Offensive');
        INSERT  INTO [dbo].[VoteTypes] ([Id], [Name])
        VALUES                        (5, 'Favorite');
        INSERT  INTO [dbo].[VoteTypes] ([Id], [Name])
        VALUES                        (6, 'Close');
        INSERT  INTO [dbo].[VoteTypes] ([Id], [Name])
        VALUES                        (7, 'Reopen');
        INSERT  INTO [dbo].[VoteTypes] ([Id], [Name])
        VALUES                        (8, 'BountyStart');
        INSERT  INTO [dbo].[VoteTypes] ([Id], [Name])
        VALUES                        (9, 'BountyClose');
        INSERT  INTO [dbo].[VoteTypes] ([Id], [Name])
        VALUES                        (10, 'Deletion');
        INSERT  INTO [dbo].[VoteTypes] ([Id], [Name])
        VALUES                        (11, 'Undeletion');
        INSERT  INTO [dbo].[VoteTypes] ([Id], [Name])
        VALUES                        (12, 'Spam');
        INSERT  INTO [dbo].[VoteTypes] ([Id], [Name])
        VALUES                        (13, 'InformModerator');
        INSERT  INTO [dbo].[VoteTypes] ([Id], [Name])
        VALUES                        (15, 'ModeratorReview');
        INSERT  INTO [dbo].[VoteTypes] ([Id], [Name])
        VALUES                        (16, 'ApproveEditSuggestion');
    END


GO