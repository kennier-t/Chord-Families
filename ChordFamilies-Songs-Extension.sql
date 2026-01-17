-- =============================================
-- Chord Families - Songs and Folders Extension
-- SQL Server
-- Execute this script AFTER ChordFamilies-Database.sql
-- =============================================

USE ChordFamilies;
GO

-- =============================================
-- Create Tables for Songs and Folders
-- =============================================

-- Table: Folders
CREATE TABLE Folders (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    CreatedDate DATETIME2 DEFAULT GETDATE()
);
GO

-- Table: Songs
CREATE TABLE Songs (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(200) NOT NULL,
    SongDate NVARCHAR(50) NULL,
    Notes NVARCHAR(MAX) NULL,
    SongKey NVARCHAR(20) NULL,
    Capo NVARCHAR(20) NULL,
    BPM NVARCHAR(20) NULL,
    Effects NVARCHAR(200) NULL,
    ContentText NVARCHAR(MAX) NOT NULL,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    ModifiedDate DATETIME2 DEFAULT GETDATE()
);
GO

-- Table: SongChordDiagrams (stores selected chord IDs for each song)
CREATE TABLE SongChordDiagrams (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    SongId INT NOT NULL,
    ChordId INT NOT NULL,
    DisplayOrder INT NOT NULL,
    CONSTRAINT FK_SongChordDiagrams_Songs FOREIGN KEY (SongId) REFERENCES Songs(Id) ON DELETE CASCADE,
    CONSTRAINT FK_SongChordDiagrams_Chords FOREIGN KEY (ChordId) REFERENCES Chords(Id) ON DELETE CASCADE
);
GO

-- Table: SongFolderMapping (Many-to-Many junction table)
CREATE TABLE SongFolderMapping (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    SongId INT NOT NULL,
    FolderId INT NOT NULL,
    CONSTRAINT FK_SongFolderMapping_Songs FOREIGN KEY (SongId) REFERENCES Songs(Id) ON DELETE CASCADE,
    CONSTRAINT FK_SongFolderMapping_Folders FOREIGN KEY (FolderId) REFERENCES Folders(Id) ON DELETE CASCADE,
    CONSTRAINT UQ_SongFolderMapping UNIQUE (SongId, FolderId)
);
GO

-- =============================================
-- Create Views
-- =============================================

-- View: All songs with folder names
CREATE VIEW vw_SongsWithFolders AS
SELECT 
    s.Id,
    s.Title,
    s.SongDate,
    s.Notes,
    s.SongKey,
    s.Capo,
    s.BPM,
    s.Effects,
    s.ContentText,
    s.CreatedDate,
    s.ModifiedDate,
    STUFF((
        SELECT ', ' + f.Name
        FROM SongFolderMapping sfm
        INNER JOIN Folders f ON sfm.FolderId = f.Id
        WHERE sfm.SongId = s.Id
        FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 2, '') AS Folders
FROM Songs s;
GO

-- View: Song chord diagrams
CREATE VIEW vw_SongChordDiagrams AS
SELECT 
    scd.SongId,
    scd.ChordId,
    c.Name AS ChordName,
    scd.DisplayOrder
FROM SongChordDiagrams scd
INNER JOIN Chords c ON scd.ChordId = c.Id;
GO

PRINT '================================================';
PRINT 'Songs and Folders tables created successfully!';
PRINT '================================================';
GO
