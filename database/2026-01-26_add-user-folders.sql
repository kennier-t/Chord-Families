-- =============================================
-- Migration: 2026-01-26_add-user-folders.sql
-- Add creator_id to Folders table to make folders user-specific
-- =============================================

USE ChordSmith;
GO

-- Add creator_id to Folders table
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.Folders') AND name = 'creator_id')
BEGIN
    ALTER TABLE dbo.Folders ADD creator_id INT NULL;
    ALTER TABLE dbo.Folders ADD CONSTRAINT FK_Folders_creator FOREIGN KEY (creator_id) REFERENCES dbo.Users(id);
END;
GO

-- Assign existing folders to the initial user 'kennier'
DECLARE @kennier_id INT = (SELECT TOP (1) id FROM Users WHERE username = 'kennier');
IF @kennier_id IS NOT NULL
BEGIN
    UPDATE dbo.Folders SET creator_id = @kennier_id WHERE creator_id IS NULL;
END;
GO

-- Make creator_id NOT NULL after assigning
ALTER TABLE dbo.Folders ALTER COLUMN creator_id INT NOT NULL;
GO

-- Add CASCADE to UserSongs FK
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_UserSongs_Song')
BEGIN
    ALTER TABLE dbo.UserSongs DROP CONSTRAINT FK_UserSongs_Song;
END;
ALTER TABLE dbo.UserSongs ADD CONSTRAINT FK_UserSongs_Song FOREIGN KEY (song_id) REFERENCES dbo.Songs(id) ON DELETE CASCADE;
GO

-- Add CASCADE to UserChords FK
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_UserChords_Chord')
BEGIN
    ALTER TABLE dbo.UserChords DROP CONSTRAINT FK_UserChords_Chord;
END;
ALTER TABLE dbo.UserChords ADD CONSTRAINT FK_UserChords_Chord FOREIGN KEY (chord_id) REFERENCES dbo.Chords(id) ON DELETE CASCADE;
GO

-- Add CASCADE to SongShares FK
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_SongShares_Song')
BEGIN
    ALTER TABLE dbo.SongShares DROP CONSTRAINT FK_SongShares_Song;
END;
ALTER TABLE dbo.SongShares ADD CONSTRAINT FK_SongShares_Song FOREIGN KEY (song_id) REFERENCES dbo.Songs(id) ON DELETE CASCADE;
GO

-- Add CASCADE to ChordShares FK
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_ChordShares_Chord')
BEGIN
    ALTER TABLE dbo.ChordShares DROP CONSTRAINT FK_ChordShares_Chord;
END;
ALTER TABLE dbo.ChordShares ADD CONSTRAINT FK_ChordShares_Chord FOREIGN KEY (chord_id) REFERENCES dbo.Chords(id) ON DELETE CASCADE;
GO

PRINT 'Migration completed: Folders are now user-specific, and delete cascades added';