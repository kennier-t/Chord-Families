-- =============================================
-- Chord Families Database - Complete Setup Script
-- SQL Server
-- This script creates the database, tables, and all chord data
-- with many-to-many relationships between chords and families
-- =============================================

USE master;
GO

-- Drop database if exists
IF DB_ID('ChordFamilies') IS NOT NULL
BEGIN
    ALTER DATABASE ChordFamilies SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE ChordFamilies;
END
GO

-- Create database
CREATE DATABASE ChordFamilies;
GO

USE ChordFamilies;
GO

-- =============================================
-- Create Tables
-- =============================================

-- Table: Families
CREATE TABLE Families (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(50) NOT NULL UNIQUE,
    CreatedDate DATETIME2 DEFAULT GETDATE()
);
GO

-- Table: Chords
CREATE TABLE Chords (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(50) NOT NULL UNIQUE,
    BaseFret INT NOT NULL DEFAULT 1,
    IsOriginal BIT NOT NULL DEFAULT 0,
    CreatedDate DATETIME2 DEFAULT GETDATE()
);
GO

-- Table: ChordFingerings
-- Stores finger positions for each chord
-- StringNumber: 1-6 (from thickest E string to thinnest e string)
-- FretNumber: -1 = not played (X), 0 = open, 1-24 = fret number
-- FingerNumber: 0 = open/not used, 1-4 = finger number
CREATE TABLE ChordFingerings (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    ChordId INT NOT NULL,
    StringNumber INT NOT NULL CHECK (StringNumber BETWEEN 1 AND 6),
    FretNumber INT NOT NULL CHECK (FretNumber BETWEEN -1 AND 24),
    FingerNumber INT NOT NULL CHECK (FingerNumber BETWEEN 0 AND 4),
    CONSTRAINT FK_ChordFingerings_Chords FOREIGN KEY (ChordId) REFERENCES Chords(Id) ON DELETE CASCADE,
    CONSTRAINT UQ_ChordFingerings_ChordString UNIQUE (ChordId, StringNumber)
);
GO

-- Table: ChordBarres
-- Stores barre information for chords
CREATE TABLE ChordBarres (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    ChordId INT NOT NULL,
    FretNumber INT NOT NULL CHECK (FretNumber BETWEEN 1 AND 24),
    CONSTRAINT FK_ChordBarres_Chords FOREIGN KEY (ChordId) REFERENCES Chords(Id) ON DELETE CASCADE
);
GO

-- Table: ChordFamilyMapping (Many-to-Many Junction Table)
CREATE TABLE ChordFamilyMapping (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    ChordId INT NOT NULL,
    FamilyId INT NOT NULL,
    CONSTRAINT FK_ChordFamilyMapping_Chords FOREIGN KEY (ChordId) REFERENCES Chords(Id) ON DELETE CASCADE,
    CONSTRAINT FK_ChordFamilyMapping_Families FOREIGN KEY (FamilyId) REFERENCES Families(Id) ON DELETE CASCADE,
    CONSTRAINT UQ_ChordFamilyMapping UNIQUE (ChordId, FamilyId)
);
GO

-- =============================================
-- Insert Data
-- =============================================

-- Insert Families
INSERT INTO Families (Name) VALUES 
('C'), ('D'), ('E'), ('F'), ('G'), ('A'), ('B');
GO

-- =============================================
-- Insert Chords and Fingerings
-- Note: Array indices in JS [0,1,2,3,4,5] map to String Numbers [1,2,3,4,5,6]
-- =============================================

DECLARE @ChordId INT;

-- C
INSERT INTO Chords (Name, BaseFret, IsOriginal) VALUES ('C', 1, 1);
SET @ChordId = SCOPE_IDENTITY();
INSERT INTO ChordFingerings (ChordId, StringNumber, FretNumber, FingerNumber) VALUES 
(@ChordId, 1, -1, 0), (@ChordId, 2, 3, 3), (@ChordId, 3, 2, 2), 
(@ChordId, 4, 0, 0), (@ChordId, 5, 1, 1), (@ChordId, 6, 0, 0);

-- G
INSERT INTO Chords (Name, BaseFret, IsOriginal) VALUES ('G', 1, 1);
SET @ChordId = SCOPE_IDENTITY();
INSERT INTO ChordFingerings (ChordId, StringNumber, FretNumber, FingerNumber) VALUES 
(@ChordId, 1, 3, 2), (@ChordId, 2, 2, 1), (@ChordId, 3, 0, 0), 
(@ChordId, 4, 0, 0), (@ChordId, 5, 0, 0), (@ChordId, 6, 3, 3);

-- Am
INSERT INTO Chords (Name, BaseFret, IsOriginal) VALUES ('Am', 1, 1);
SET @ChordId = SCOPE_IDENTITY();
INSERT INTO ChordFingerings (ChordId, StringNumber, FretNumber, FingerNumber) VALUES 
(@ChordId, 1, -1, 0), (@ChordId, 2, 0, 0), (@ChordId, 3, 2, 2), 
(@ChordId, 4, 2, 3), (@ChordId, 5, 1, 1), (@ChordId, 6, 0, 0);

-- F
INSERT INTO Chords (Name, BaseFret, IsOriginal) VALUES ('F', 1, 1);
SET @ChordId = SCOPE_IDENTITY();
INSERT INTO ChordFingerings (ChordId, StringNumber, FretNumber, FingerNumber) VALUES 
(@ChordId, 1, 1, 1), (@ChordId, 2, 3, 3), (@ChordId, 3, 3, 4), 
(@ChordId, 4, 2, 2), (@ChordId, 5, 1, 1), (@ChordId, 6, 1, 1);
INSERT INTO ChordBarres (ChordId, FretNumber) VALUES (@ChordId, 1);

-- Dm
INSERT INTO Chords (Name, BaseFret, IsOriginal) VALUES ('Dm', 1, 1);
SET @ChordId = SCOPE_IDENTITY();
INSERT INTO ChordFingerings (ChordId, StringNumber, FretNumber, FingerNumber) VALUES 
(@ChordId, 1, -1, 0), (@ChordId, 2, -1, 0), (@ChordId, 3, 0, 0), 
(@ChordId, 4, 2, 2), (@ChordId, 5, 3, 3), (@ChordId, 6, 1, 1);

-- Em
INSERT INTO Chords (Name, BaseFret, IsOriginal) VALUES ('Em', 1, 1);
SET @ChordId = SCOPE_IDENTITY();
INSERT INTO ChordFingerings (ChordId, StringNumber, FretNumber, FingerNumber) VALUES 
(@ChordId, 1, 0, 0), (@ChordId, 2, 2, 2), (@ChordId, 3, 2, 3), 
(@ChordId, 4, 0, 0), (@ChordId, 5, 0, 0), (@ChordId, 6, 0, 0);

-- Bdim
INSERT INTO Chords (Name, BaseFret, IsOriginal) VALUES ('Bdim', 1, 1);
SET @ChordId = SCOPE_IDENTITY();
INSERT INTO ChordFingerings (ChordId, StringNumber, FretNumber, FingerNumber) VALUES 
(@ChordId, 1, -1, 0), (@ChordId, 2, 2, 1), (@ChordId, 3, 3, 2), 
(@ChordId, 4, 4, 4), (@ChordId, 5, 3, 3), (@ChordId, 6, -1, 0);

-- D
INSERT INTO Chords (Name, BaseFret, IsOriginal) VALUES ('D', 1, 1);
SET @ChordId = SCOPE_IDENTITY();
INSERT INTO ChordFingerings (ChordId, StringNumber, FretNumber, FingerNumber) VALUES 
(@ChordId, 1, -1, 0), (@ChordId, 2, -1, 0), (@ChordId, 3, 0, 0), 
(@ChordId, 4, 2, 1), (@ChordId, 5, 3, 3), (@ChordId, 6, 2, 2);

-- A
INSERT INTO Chords (Name, BaseFret, IsOriginal) VALUES ('A', 1, 1);
SET @ChordId = SCOPE_IDENTITY();
INSERT INTO ChordFingerings (ChordId, StringNumber, FretNumber, FingerNumber) VALUES 
(@ChordId, 1, -1, 0), (@ChordId, 2, 0, 0), (@ChordId, 3, 2, 2), 
(@ChordId, 4, 2, 3), (@ChordId, 5, 2, 4), (@ChordId, 6, 0, 0);

-- Bm
INSERT INTO Chords (Name, BaseFret, IsOriginal) VALUES ('Bm', 1, 1);
SET @ChordId = SCOPE_IDENTITY();
INSERT INTO ChordFingerings (ChordId, StringNumber, FretNumber, FingerNumber) VALUES 
(@ChordId, 1, -1, 0), (@ChordId, 2, 2, 1), (@ChordId, 3, 4, 3), 
(@ChordId, 4, 4, 4), (@ChordId, 5, 3, 2), (@ChordId, 6, 2, 1);
INSERT INTO ChordBarres (ChordId, FretNumber) VALUES (@ChordId, 2);

-- F#m
INSERT INTO Chords (Name, BaseFret, IsOriginal) VALUES ('F#m', 1, 1);
SET @ChordId = SCOPE_IDENTITY();
INSERT INTO ChordFingerings (ChordId, StringNumber, FretNumber, FingerNumber) VALUES 
(@ChordId, 1, 2, 1), (@ChordId, 2, 4, 3), (@ChordId, 3, 4, 4), 
(@ChordId, 4, 2, 1), (@ChordId, 5, 2, 1), (@ChordId, 6, 2, 1);
INSERT INTO ChordBarres (ChordId, FretNumber) VALUES (@ChordId, 2);

-- C#dim
INSERT INTO Chords (Name, BaseFret, IsOriginal) VALUES ('C#dim', 4, 1);
SET @ChordId = SCOPE_IDENTITY();
INSERT INTO ChordFingerings (ChordId, StringNumber, FretNumber, FingerNumber) VALUES 
(@ChordId, 1, -1, 0), (@ChordId, 2, 4, 1), (@ChordId, 3, 5, 2), 
(@ChordId, 4, 6, 4), (@ChordId, 5, 5, 3), (@ChordId, 6, -1, 0);

-- E
INSERT INTO Chords (Name, BaseFret, IsOriginal) VALUES ('E', 1, 1);
SET @ChordId = SCOPE_IDENTITY();
INSERT INTO ChordFingerings (ChordId, StringNumber, FretNumber, FingerNumber) VALUES 
(@ChordId, 1, 0, 0), (@ChordId, 2, 2, 2), (@ChordId, 3, 2, 3), 
(@ChordId, 4, 1, 1), (@ChordId, 5, 0, 0), (@ChordId, 6, 0, 0);

-- B
INSERT INTO Chords (Name, BaseFret, IsOriginal) VALUES ('B', 1, 1);
SET @ChordId = SCOPE_IDENTITY();
INSERT INTO ChordFingerings (ChordId, StringNumber, FretNumber, FingerNumber) VALUES 
(@ChordId, 1, -1, 0), (@ChordId, 2, 2, 1), (@ChordId, 3, 4, 2), 
(@ChordId, 4, 4, 3), (@ChordId, 5, 4, 4), (@ChordId, 6, 2, 1);
INSERT INTO ChordBarres (ChordId, FretNumber) VALUES (@ChordId, 2);

-- C#m
INSERT INTO Chords (Name, BaseFret, IsOriginal) VALUES ('C#m', 4, 1);
SET @ChordId = SCOPE_IDENTITY();
INSERT INTO ChordFingerings (ChordId, StringNumber, FretNumber, FingerNumber) VALUES 
(@ChordId, 1, -1, 0), (@ChordId, 2, 4, 1), (@ChordId, 3, 6, 3), 
(@ChordId, 4, 6, 4), (@ChordId, 5, 5, 2), (@ChordId, 6, 4, 1);
INSERT INTO ChordBarres (ChordId, FretNumber) VALUES (@ChordId, 4);

-- G#m
INSERT INTO Chords (Name, BaseFret, IsOriginal) VALUES ('G#m', 4, 1);
SET @ChordId = SCOPE_IDENTITY();
INSERT INTO ChordFingerings (ChordId, StringNumber, FretNumber, FingerNumber) VALUES 
(@ChordId, 1, 4, 1), (@ChordId, 2, 6, 3), (@ChordId, 3, 6, 4), 
(@ChordId, 4, 4, 1), (@ChordId, 5, 4, 1), (@ChordId, 6, 4, 1);
INSERT INTO ChordBarres (ChordId, FretNumber) VALUES (@ChordId, 4);

-- D#dim
INSERT INTO Chords (Name, BaseFret, IsOriginal) VALUES ('D#dim', 6, 1);
SET @ChordId = SCOPE_IDENTITY();
INSERT INTO ChordFingerings (ChordId, StringNumber, FretNumber, FingerNumber) VALUES 
(@ChordId, 1, -1, 0), (@ChordId, 2, 6, 1), (@ChordId, 3, 7, 2), 
(@ChordId, 4, 8, 4), (@ChordId, 5, 7, 3), (@ChordId, 6, -1, 0);

-- Bb
INSERT INTO Chords (Name, BaseFret, IsOriginal) VALUES ('Bb', 1, 1);
SET @ChordId = SCOPE_IDENTITY();
INSERT INTO ChordFingerings (ChordId, StringNumber, FretNumber, FingerNumber) VALUES 
(@ChordId, 1, -1, 0), (@ChordId, 2, 1, 1), (@ChordId, 3, 3, 2), 
(@ChordId, 4, 3, 3), (@ChordId, 5, 3, 4), (@ChordId, 6, 1, 1);
INSERT INTO ChordBarres (ChordId, FretNumber) VALUES (@ChordId, 1);

-- Gm
INSERT INTO Chords (Name, BaseFret, IsOriginal) VALUES ('Gm', 3, 1);
SET @ChordId = SCOPE_IDENTITY();
INSERT INTO ChordFingerings (ChordId, StringNumber, FretNumber, FingerNumber) VALUES 
(@ChordId, 1, 3, 1), (@ChordId, 2, 5, 3), (@ChordId, 3, 5, 4), 
(@ChordId, 4, 3, 1), (@ChordId, 5, 3, 1), (@ChordId, 6, 3, 1);
INSERT INTO ChordBarres (ChordId, FretNumber) VALUES (@ChordId, 3);

-- Edim
INSERT INTO Chords (Name, BaseFret, IsOriginal) VALUES ('Edim', 1, 1);
SET @ChordId = SCOPE_IDENTITY();
INSERT INTO ChordFingerings (ChordId, StringNumber, FretNumber, FingerNumber) VALUES 
(@ChordId, 1, 0, 0), (@ChordId, 2, 1, 1), (@ChordId, 3, 2, 2), 
(@ChordId, 4, 0, 0), (@ChordId, 5, -1, 0), (@ChordId, 6, -1, 0);

-- F#dim
INSERT INTO Chords (Name, BaseFret, IsOriginal) VALUES ('F#dim', 1, 1);
SET @ChordId = SCOPE_IDENTITY();
INSERT INTO ChordFingerings (ChordId, StringNumber, FretNumber, FingerNumber) VALUES 
(@ChordId, 1, 2, 1), (@ChordId, 2, 3, 2), (@ChordId, 3, 4, 3), 
(@ChordId, 4, 2, 1), (@ChordId, 5, -1, 0), (@ChordId, 6, -1, 0);
INSERT INTO ChordBarres (ChordId, FretNumber) VALUES (@ChordId, 2);

-- G#dim
INSERT INTO Chords (Name, BaseFret, IsOriginal) VALUES ('G#dim', 4, 1);
SET @ChordId = SCOPE_IDENTITY();
INSERT INTO ChordFingerings (ChordId, StringNumber, FretNumber, FingerNumber) VALUES 
(@ChordId, 1, 4, 1), (@ChordId, 2, 5, 2), (@ChordId, 3, 6, 3), 
(@ChordId, 4, 4, 1), (@ChordId, 5, -1, 0), (@ChordId, 6, -1, 0);
INSERT INTO ChordBarres (ChordId, FretNumber) VALUES (@ChordId, 4);

-- F#
INSERT INTO Chords (Name, BaseFret, IsOriginal) VALUES ('F#', 1, 1);
SET @ChordId = SCOPE_IDENTITY();
INSERT INTO ChordFingerings (ChordId, StringNumber, FretNumber, FingerNumber) VALUES 
(@ChordId, 1, 2, 1), (@ChordId, 2, 4, 3), (@ChordId, 3, 4, 4), 
(@ChordId, 4, 3, 2), (@ChordId, 5, 2, 1), (@ChordId, 6, 2, 1);
INSERT INTO ChordBarres (ChordId, FretNumber) VALUES (@ChordId, 2);

-- D#m
INSERT INTO Chords (Name, BaseFret, IsOriginal) VALUES ('D#m', 1, 1);
SET @ChordId = SCOPE_IDENTITY();
INSERT INTO ChordFingerings (ChordId, StringNumber, FretNumber, FingerNumber) VALUES 
(@ChordId, 1, -1, 0), (@ChordId, 2, -1, 0), (@ChordId, 3, 1, 1), 
(@ChordId, 4, 3, 3), (@ChordId, 5, 4, 4), (@ChordId, 6, 2, 2);

-- A#dim
INSERT INTO Chords (Name, BaseFret, IsOriginal) VALUES ('A#dim', 1, 1);
SET @ChordId = SCOPE_IDENTITY();
INSERT INTO ChordFingerings (ChordId, StringNumber, FretNumber, FingerNumber) VALUES 
(@ChordId, 1, -1, 0), (@ChordId, 2, 1, 1), (@ChordId, 3, 2, 2), 
(@ChordId, 4, 3, 4), (@ChordId, 5, 2, 3), (@ChordId, 6, -1, 0);

GO

-- =============================================
-- Insert Chord-Family Mappings (Many-to-Many)
-- =============================================

-- Family C chords
INSERT INTO ChordFamilyMapping (ChordId, FamilyId)
SELECT c.Id, f.Id
FROM Chords c, Families f
WHERE f.Name = 'C'
AND c.Name IN ('C', 'G', 'Am', 'F', 'Dm', 'Em', 'Bdim');

-- Family D chords
INSERT INTO ChordFamilyMapping (ChordId, FamilyId)
SELECT c.Id, f.Id
FROM Chords c, Families f
WHERE f.Name = 'D'
AND c.Name IN ('D', 'A', 'Bm', 'G', 'Em', 'F#m', 'C#dim');

-- Family E chords
INSERT INTO ChordFamilyMapping (ChordId, FamilyId)
SELECT c.Id, f.Id
FROM Chords c, Families f
WHERE f.Name = 'E'
AND c.Name IN ('E', 'B', 'C#m', 'A', 'F#m', 'G#m', 'D#dim');

-- Family F chords
INSERT INTO ChordFamilyMapping (ChordId, FamilyId)
SELECT c.Id, f.Id
FROM Chords c, Families f
WHERE f.Name = 'F'
AND c.Name IN ('F', 'C', 'Dm', 'Bb', 'Gm', 'Am', 'Edim');

-- Family G chords
INSERT INTO ChordFamilyMapping (ChordId, FamilyId)
SELECT c.Id, f.Id
FROM Chords c, Families f
WHERE f.Name = 'G'
AND c.Name IN ('G', 'D', 'Em', 'C', 'Am', 'Bm', 'F#dim');

-- Family A chords
INSERT INTO ChordFamilyMapping (ChordId, FamilyId)
SELECT c.Id, f.Id
FROM Chords c, Families f
WHERE f.Name = 'A'
AND c.Name IN ('A', 'E', 'F#m', 'D', 'Bm', 'C#m', 'G#dim');

-- Family B chords
INSERT INTO ChordFamilyMapping (ChordId, FamilyId)
SELECT c.Id, f.Id
FROM Chords c, Families f
WHERE f.Name = 'B'
AND c.Name IN ('B', 'F#', 'G#m', 'E', 'C#m', 'D#m', 'A#dim');

GO

-- =============================================
-- Create Views for Easy Querying
-- =============================================

-- View: All chords with their complete information
CREATE VIEW vw_AllChords AS
SELECT 
    c.Id,
    c.Name,
    c.BaseFret,
    c.IsOriginal,
    c.CreatedDate,
    STUFF((
        SELECT ', ' + f.Name
        FROM ChordFamilyMapping cfm
        INNER JOIN Families f ON cfm.FamilyId = f.Id
        WHERE cfm.ChordId = c.Id
        FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 2, '') AS Families
FROM Chords c;
GO

-- View: Chord fingerings in array format
CREATE VIEW vw_ChordFingeringsArray AS
SELECT 
    ChordId,
    MAX(CASE WHEN StringNumber = 1 THEN FretNumber END) AS String1_Fret,
    MAX(CASE WHEN StringNumber = 1 THEN FingerNumber END) AS String1_Finger,
    MAX(CASE WHEN StringNumber = 2 THEN FretNumber END) AS String2_Fret,
    MAX(CASE WHEN StringNumber = 2 THEN FingerNumber END) AS String2_Finger,
    MAX(CASE WHEN StringNumber = 3 THEN FretNumber END) AS String3_Fret,
    MAX(CASE WHEN StringNumber = 3 THEN FingerNumber END) AS String3_Finger,
    MAX(CASE WHEN StringNumber = 4 THEN FretNumber END) AS String4_Fret,
    MAX(CASE WHEN StringNumber = 4 THEN FingerNumber END) AS String4_Finger,
    MAX(CASE WHEN StringNumber = 5 THEN FretNumber END) AS String5_Fret,
    MAX(CASE WHEN StringNumber = 5 THEN FingerNumber END) AS String5_Finger,
    MAX(CASE WHEN StringNumber = 6 THEN FretNumber END) AS String6_Fret,
    MAX(CASE WHEN StringNumber = 6 THEN FingerNumber END) AS String6_Finger
FROM ChordFingerings
GROUP BY ChordId;
GO

-- =============================================
-- Summary
-- =============================================

PRINT '================================================';
PRINT 'ChordFamilies database setup completed successfully!';
PRINT '================================================';
PRINT 'Total Families: ' + CAST((SELECT COUNT(*) FROM Families) AS VARCHAR);
PRINT 'Total Chords: ' + CAST((SELECT COUNT(*) FROM Chords) AS VARCHAR);
PRINT 'Total Fingerings: ' + CAST((SELECT COUNT(*) FROM ChordFingerings) AS VARCHAR);
PRINT 'Total Barres: ' + CAST((SELECT COUNT(*) FROM ChordBarres) AS VARCHAR);
PRINT 'Total Chord-Family mappings: ' + CAST((SELECT COUNT(*) FROM ChordFamilyMapping) AS VARCHAR);
PRINT '================================================';
GO
