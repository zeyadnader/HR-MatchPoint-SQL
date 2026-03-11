-- ======================================================================
-- PROJECT: HR MatchPoint Engine (T-SQL)
-- DESCRIPTION: A database-first approach to ranking job candidates 
--              based on skill proficiency and job requirements.
-- ======================================================================

-- 1. CREATE NORMALIZED TABLES
CREATE TABLE Candidates (CandidateID INT IDENTITY(1,1), FullName VARCHAR(100));
CREATE TABLE Skills (SkillID INT IDENTITY(1,1), SkillName VARCHAR(50));
CREATE TABLE Jobs (JobID INT IDENTITY(1,1), JobTitle VARCHAR(100));
CREATE TABLE CandidateSkills (CandidateID INT, SkillID INT, ProficiencyLevel INT); -- 1 to 5
CREATE TABLE JobRequirements (JobID INT, SkillID INT, Importance INT); -- 1 to 3

-- 2. INSERT MOCK DATA (To test the engine)
INSERT INTO Skills (SkillName) VALUES ('T-SQL'), ('Python'), ('Azure'), ('C#');
INSERT INTO Jobs (JobTitle) VALUES ('Senior DBA'), ('Backend Developer');
INSERT INTO Candidates (FullName) VALUES ('Alice (DBA Expert)'), ('Bob (Backend Dev)'), ('Charlie (Junior)');

-- Link Candidates to their Skills & Proficiency
INSERT INTO CandidateSkills VALUES
(1, 1, 5), (1, 3, 4), -- Alice: T-SQL(5), Azure(4)
(2, 2, 5), (2, 4, 4), -- Bob: Python(5), C#(4)
(3, 1, 2), (3, 2, 2); -- Charlie: T-SQL(2), Python(2)

-- Link Jobs to their Required Skills & Importance
INSERT INTO JobRequirements VALUES
(1, 1, 3), (1, 3, 2), -- DBA Job needs T-SQL(High) and Azure(Med)
(2, 2, 3), (2, 4, 3); -- Backend Job needs Python(High) and C#(High)

GO

-- 3. THE RANKING ENGINE (Stored Procedure)
CREATE PROCEDURE usp_RankCandidatesForJob
    @SearchJobID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Calculate score and rank candidates using Window Functions
    SELECT 
        c.FullName,
        SUM(cs.ProficiencyLevel * jr.Importance) AS TotalMatchScore,
        DENSE_RANK() OVER (ORDER BY SUM(cs.ProficiencyLevel * jr.Importance) DESC) AS CandidateRank
    FROM Candidates c
    JOIN CandidateSkills cs ON c.CandidateID = cs.CandidateID
    JOIN JobRequirements jr ON cs.SkillID = jr.SkillID
    WHERE jr.JobID = @SearchJobID
    GROUP BY c.CandidateID, c.FullName
    ORDER BY CandidateRank;
END;
GO

-- 4. EXECUTE THE ENGINE (Example)
-- Find the best candidates for the 'Senior DBA' role (JobID = 1)
-- EXEC usp_RankCandidatesForJob @SearchJobID = 1;
