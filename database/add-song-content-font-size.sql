-- =============================================
-- Add Song Content Font Size Column Migration
-- SQL Server
-- =============================================

USE ChordFamilies;
GO

-- Add the nullable column for per-song font size
ALTER TABLE Songs ADD SongContentFontSizePt DECIMAL(5,2) NULL;
GO

PRINT 'Migration completed: Added SongContentFontSizePt column to Songs table';
GO

-- =============================================
-- Rollback (if needed)
-- =============================================
-- To rollback, run:
-- ALTER TABLE Songs DROP COLUMN SongContentFontSizePt;
-- GO