CREATE DATABASE Academy1_3;
USE Academy1_3;

-- 1. Actions
CREATE TABLE Actions (
    Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    Name NVARCHAR(100) NOT NULL UNIQUE CHECK (LEN(Name) > 0)
);

-- 2. Teachers
CREATE TABLE Teachers (
    Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    EmploymentDate DATE NOT NULL CHECK (EmploymentDate >= '1990-01-01'),
    Name NVARCHAR(MAX) NOT NULL CHECK (LEN(Name) > 0),
    Salary MONEY NOT NULL CHECK (Salary > 0),
    Surname NVARCHAR(MAX) NOT NULL CHECK (LEN(Surname) > 0)
);

-- 3. TeacherManipulations
CREATE TABLE TeacherManipulations (
    Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    Date DATE NOT NULL CHECK (Date <= GETDATE()),
    ActionId INT NOT NULL,
    TeacherId INT NOT NULL,
    FOREIGN KEY (ActionId) REFERENCES Actions(Id),
    FOREIGN KEY (TeacherId) REFERENCES Teachers(Id)
);

-- 4. TeacherAddedInfos
CREATE TABLE TeacherAddedInfos (
    Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    EmploymentDate DATE NOT NULL CHECK (EmploymentDate >= '1990-01-01'),
    Name NVARCHAR(MAX) NOT NULL CHECK (LEN(Name) > 0),
    Salary MONEY NOT NULL CHECK (Salary > 0),
    Surname NVARCHAR(MAX) NOT NULL CHECK (LEN(Surname) > 0),
    ManipulationId INT NOT NULL,
    FOREIGN KEY (ManipulationId) REFERENCES TeacherManipulations(Id)
);

-- 5. TeacherDeletedInfos
CREATE TABLE TeacherDeletedInfos (
    Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    EmploymentDate DATE NOT NULL CHECK (EmploymentDate >= '1990-01-01'),
    Name NVARCHAR(MAX) NOT NULL CHECK (LEN(Name) > 0),
    Salary MONEY NOT NULL CHECK (Salary > 0),
    Surname NVARCHAR(MAX) NOT NULL CHECK (LEN(Surname) > 0),
    ManipulationId INT NOT NULL,
    FOREIGN KEY (ManipulationId) REFERENCES TeacherManipulations(Id)
);

-- 1. ??????? ????????
INSERT INTO Actions (Name)
VALUES 
    (N'Added'),
    (N'Deleted'),
    (N'Updated');

-- 2. ??????? ??????????????
INSERT INTO Teachers (EmploymentDate, Name, Salary, Surname)
VALUES 
    ('2010-09-01', N'John', 5000.00, N'Doe'),
    ('2015-03-15', N'Anna', 6200.00, N'Smith'),
    ('2020-01-10', N'Robert', 7100.00, N'Johnson');

-- 3. ??????? ??????????? (???????????? Id ???????? 1, 2, 3 ? Id ?????????????? 1, 2, 3)
INSERT INTO TeacherManipulations (Date, ActionId, TeacherId)
VALUES 
    ('2022-01-01', 1, 1),
    ('2023-06-12', 2, 2),
    ('2024-02-20', 3, 3);

-- 4. ??????? ??????????? ?????????? ? ?????????????? (???????????? Id ??????????? 1, 2, 3)
INSERT INTO TeacherAddedInfos (EmploymentDate, Name, Salary, Surname, ManipulationId)
VALUES 
    ('2010-09-01', N'John', 5000.00, N'Doe', 1),
    ('2015-03-15', N'Anna', 6200.00, N'Smith', 2),
    ('2020-01-10', N'Robert', 7100.00, N'Johnson', 3);

-- 5. ??????? ????????? ?????????? ? ?????????????? (?????????? ?? ?? ??????, ??? ???????)
INSERT INTO TeacherDeletedInfos (EmploymentDate, Name, Salary, Surname, ManipulationId)
VALUES 
    ('2008-05-21', N'Linda', 4800.00, N'White', 1),
    ('2012-11-30', N'Peter', 5300.00, N'Brown', 2),
    ('2017-08-18', N'Diana', 6000.00, N'Clark', 3);

CREATE TRIGGER all_actions
ON TeacherManipulations
AFTER INSERT
AS
BEGIN 
DECLARE @TeacherId INT;
SET @TeacherId = (SELECT INSERTED.TeacherId FROM INSERTED); 
DECLARE @ManipulationId INT;
SET @ManipulationId = (SELECT INSERTED.Id FROM INSERTED); 
DECLARE @EmplDate DATE;
SET @EmplDate = (SELECT EmploymentDate FROM Teachers WHERE Id =  @TeacherId);
DECLARE @Name NVARCHAR(MAX);
SET @Name = (SELECT Name FROM Teachers WHERE Id =  @TeacherId);
DECLARE @Salary MONEY;
SET @Salary = (SELECT Salary FROM Teachers WHERE Id =  @TeacherId);
DECLARE @Surname NVARCHAR(MAX);
SET @Surname = (SELECT Surname FROM Teachers WHERE Id =  @TeacherId);
    INSERT INTO TeacherAddedInfos (EmploymentDate, Name, Salary, Surname, ManipulationId) 
    VALUES(@EmplDate, @Name, @Salary, @Surname, @ManipulationId);
	INSERT INTO TeacherDeletedInfos (EmploymentDate, Name, Salary, Surname, ManipulationId) 
    VALUES(@EmplDate, @Name, @Salary, @Surname, @ManipulationId);
END;

INSERT INTO TeacherManipulations(Date, ActionId, TeacherId)
VALUES  ('2008-02-08', 1, 1),
    ('2023-07-23', 2, 2),
    ('2024-06-21', 3, 3);

INSERT INTO TeacherAddedInfos (EmploymentDate, Name, Salary, Surname, ManipulationId)
VALUES 
    ('2010-09-01', N'Misha', 5100.00, N'Doe', 1),
    ('2015-03-15', N'Alex', 6300.00, N'Fra', 2),
    ('2020-01-10', N'Lexa', 7200.00, N'Johnson', 3);

INSERT INTO TeacherDeletedInfos (EmploymentDate, Name, Salary, Surname, ManipulationId)
VALUES 
    ('2008-05-21', N'Lora', 4800.00, N'White', 1),
    ('2012-11-30', N'Andrew', 5300.00, N'Brown', 2),
    ('2017-08-18', N'Ilia', 6000.00, N'Clark', 3);