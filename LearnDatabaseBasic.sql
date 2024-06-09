--Important types of queries asked in interview
--select count of rows with condition from columns 
--select joins
--select columns with order by
--select nth row, top n rows

--high-level database information (Retrieves information about all databases on the SQL Server instance.)
SELECT * FROM sys.databases;

--low-level file information (Retrieves information about the physical files associated with databases.)
SELECT * FROM sys.sysaltfiles;

--create database
CREATE DATABASE LearnDatabaseBasic;

--rename database 
ALTER DATABASE LearnDatabaseBasic
SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

ALTER DATABASE LearnDatabaseBasic
MODIFY NAME = MyLearnDatabaseBasic;

ALTER DATABASE LearnDatabaseBasic
SET MULTI_USER;

--drop database
USE master;
DROP DATABASE LearnDatabaseBasic;

--use database
USE LearnDatabaseBasic;

--create tables with constraints
 CREATE TABLE Department 
(
 DeptID INT PRIMARY KEY, --primary key
 Name VARCHAR(50) NOT NULL,
 Address VARCHAR(200) NOT NULL
 ) 

CREATE TABLE Student 
(
 ID INT PRIMARY KEY, --primary key
 RollNo VARCHAR(10) NOT NULL,
 Name VARCHAR(50) NOT NULL,
 EnrollNo VARCHAR(50) UNIQUE, --unique key
 Address VARCHAR(200) NOT NULL,
 DeptID INT CONSTRAINT Student_DeptID_fk REFERENCES Department(DeptID) --foreign key
)

--drop table
DROP TABLE Student;

DROP TABLE Department;

--alter table
ALTER TABLE Department
ADD PhoneNumber VARCHAR(15);

ALTER TABLE Department
DROP COLUMN PhoneNumber;

EXEC sp_rename 'Department.Address', 'Location', 'COLUMN';

ALTER TABLE Department
ADD CONSTRAINT PK_Department PRIMARY KEY (DeptID);

ALTER TABLE Department
DROP CONSTRAINT PK_Department;

ALTER TABLE Department
ADD CONSTRAINT UQ_Department_Name UNIQUE (Name);

ALTER TABLE Department
DROP CONSTRAINT UQ_Department_Name;

ALTER TABLE Department
ADD CONSTRAINT CK_Department_Name CHECK (LEN(Name) > 0);

ALTER TABLE Department
DROP CONSTRAINT CK_Department_Name;

ALTER TABLE Department
ADD CONSTRAINT DF_Department_Address DEFAULT 'Unknown' FOR Address;

ALTER TABLE Department
DROP CONSTRAINT DF_Department_Address;

ALTER TABLE Department
ALTER COLUMN Address NVARCHAR(250);

ALTER TABLE Department
ALTER COLUMN PhoneNumber VARCHAR(15) NOT NULL;

ALTER TABLE Department
ALTER COLUMN PhoneNumber VARCHAR(15) NULL;

--truncate table
TRUNCATE TABLE Student; 

TRUNCATE TABLE Department;                   

--instert rows into table
INSERT INTO Department (DeptID, Name, Address)
VALUES (1, 'HR', '123 Main St, Anytown, USA');

INSERT INTO Department (DeptID, Name, Address)
VALUES 
(2, 'IT', '456 Tech Park, Silicon Valley, USA'),
(3, 'Finance', '789 Wall St, New York, USA');

--update rows from table
UPDATE Department
SET Name = 'Human Resources', Address = '1234 Main St, Anytown, USA'
WHERE DeptID = 1;

--delete rows from table
DELETE FROM Department
WHERE DeptID = 1;

--all select queries
DROP TABLE Employees;
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY, -- Primary key
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) UNIQUE, -- Unique constraint
    BirthDate DATE,
    HireDate DATE DEFAULT GETDATE(), -- Default constraint
    Salary DECIMAL(18, 2) CHECK (Salary > 0), -- Check constraint
    DepartmentID INT, -- Foreign key example
    IsActive BIT DEFAULT 1 -- Boolean example
);

INSERT INTO Employees (EmployeeID, FirstName, LastName, Email, BirthDate, HireDate, Salary, DepartmentID, IsActive)
VALUES
(1, 'John', 'Doe', 'john.doe@example.com', '1985-06-15', '2020-01-10', 60000.00, 1, 1),
(2, 'Jane', 'Smith', 'jane.smith@example.com', '1990-09-23', '2019-03-22', 75000.00, 2, 1),
(3, 'Sam', 'Brown', 'sam.brown@example.com', '1978-02-14', '2018-05-30', 80000.00, 1, 0),
(4, 'Sara', 'Johnson', 'sara.johnson@example.com', '1983-11-29', '2021-07-15', 65000.00, 3, 1),
(5, 'Mike', 'Wilson', 'mike.wilson@example.com', '1992-04-05', '2017-09-20', 72000.00, 2, 1);

--columns
SELECT * FROM Employees;

SELECT FirstName, LastName, Email FROM Employees;

--distinct columns
SELECT DISTINCT FirstName, LastName
FROM Employees;

--nth rows
--first row
SELECT TOP 1 * 
FROM Employees 
ORDER BY EmployeeID ASC;

--last row
SELECT TOP 1 * 
FROM Employees 
ORDER BY EmployeeID DESC;

--top 5
SELECT TOP 5 * 
FROM Employees 
ORDER BY EmployeeID ASC;

--select 4th from top
SELECT * 
FROM Employees  
ORDER BY EmployeeID ASC
OFFSET 3 ROWS 
FETCH NEXT 1 ROW ONLY;

--select 4th from bottom
SELECT * 
FROM Employees 
ORDER BY EmployeeID DESC 
OFFSET 3 ROWS 
FETCH NEXT 1 ROW ONLY;

--where 
--operators
SELECT * FROM Employees
WHERE DepartmentID = 1;

SELECT *
FROM Employees
WHERE FirstName = 'John';

SELECT *
FROM Employees
WHERE Salary != 60000.00;

SELECT *
FROM Employees
WHERE Salary > 70000.00;

SELECT *
FROM Employees
WHERE HireDate >= '2020-01-01';

--between
SELECT *
FROM Employees
WHERE BirthDate BETWEEN '1980-01-01' AND '1990-12-31';

--in
SELECT *
FROM Employees
WHERE DepartmentID IN (1, 2);

SELECT *
FROM Employees
WHERE DepartmentID NOT IN (1, 2);

--like
SELECT *
FROM Employees
WHERE Email LIKE '%@example.com'; --end with

SELECT *
FROM Employees
WHERE FirstName NOT LIKE 'J%';  --starts with

SELECT *
FROM Employees
WHERE FirstName NOT LIKE '%J%';  --middle

--is null
SELECT *
FROM Employees
WHERE BirthDate = NULL; --shows no rows even if birthdate has null value

SELECT *
FROM Employees
WHERE BirthDate IN(NULL); --shows no rows even if birthdate has null value

SELECT *
FROM Employees
WHERE BirthDate IS NULL; --shows rows even if birthdate has null value

SELECT *
FROM Employees
WHERE Email IS NOT NULL;

--and
SELECT *
FROM Employees
WHERE IsActive = 1 AND Salary > 70000.00;

--or
SELECT *
FROM Employees
WHERE DepartmentID = 1 OR DepartmentID = 3;

--and or
SELECT *
FROM Employees
WHERE (DepartmentID = 1 OR DepartmentID = 3) AND IsActive = 1;

--not
SELECT *
FROM Employees
WHERE NOT (IsActive = 1);

--order by
SELECT * FROM Employees
ORDER BY LastName ASC;

--group by
SELECT DepartmentID, COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY DepartmentID;

--group by having
SELECT DepartmentID, AVG(Salary) AS AverageSalary
FROM Employees
GROUP BY DepartmentID
HAVING AVG(Salary) > 70000;

--count
SELECT COUNT(*) AS TotalEmployees
FROM Employees;

SELECT COUNT(*) AS TotalEmployees, AVG(Salary) AS AverageSalary
FROM Employees;

SELECT COUNT(DISTINCT DepartmentID) AS DistinctDepartments
FROM Employees;

SELECT COUNT(*) AS ActiveEmployees
FROM Employees
WHERE IsActive = 1;

SELECT COUNT(*) AS HighSalaryEmployees
FROM Employees
WHERE Salary > 70000.00;

--joins
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName NVARCHAR(50) NOT NULL
);

INSERT INTO Departments (DepartmentID, DepartmentName)
VALUES
(1, 'HR'),
(2, 'IT'),
(3, 'Finance');

SELECT * FROM Employees;
SELECT * FROM Departments;

--self join
SELECT e1.EmployeeID AS Employee1, e1.FirstName AS FirstName1, e1.LastName AS LastName1,
       e2.EmployeeID AS Employee2, e2.FirstName AS FirstName2, e2.LastName AS LastName2,
       d.DepartmentName
FROM Employees e1
JOIN Employees e2 ON e1.DepartmentID = e2.DepartmentID AND e1.EmployeeID <> e2.EmployeeID
JOIN Departments d ON e1.DepartmentID = d.DepartmentID;

--inner join (By default)
SELECT e.EmployeeID, e.FirstName, e.LastName, e.Email, e.BirthDate, e.HireDate, e.Salary, e.IsActive,
       d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID;

--or

SELECT e.EmployeeID, e.FirstName, e.LastName, e.Email, e.BirthDate, e.HireDate, e.Salary, e.IsActive,
       d.DepartmentName
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID;

--Full Outer Join
SELECT e.EmployeeID, e.FirstName, e.LastName, e.Email, e.BirthDate, e.HireDate, e.Salary, e.IsActive,
       d.DepartmentID, d.DepartmentName
FROM Employees e
FULL OUTER JOIN Departments d ON e.DepartmentID = d.DepartmentID;

--Left Outer Join
SELECT e.EmployeeID, e.FirstName, e.LastName, e.Email, e.BirthDate, e.HireDate, e.Salary, e.IsActive,
       d.DepartmentName
FROM Employees e
LEFT JOIN Departments d ON e.DepartmentID = d.DepartmentID;

--Right Outer Join
SELECT e.EmployeeID, e.FirstName, e.LastName, e.Email, e.BirthDate, e.HireDate, e.Salary, e.IsActive,
       d.DepartmentName
FROM Employees e
RIGHT JOIN Departments d ON e.DepartmentID = d.DepartmentID;

--cross join
SELECT e.EmployeeID, e.FirstName, e.LastName, e.Email, e.BirthDate, e.HireDate, e.Salary, e.IsActive,
       d.DepartmentID, d.DepartmentName
FROM Employees e
CROSS JOIN Departments d;

--case statements
SELECT EmployeeID, FirstName, LastName,
    CASE
        WHEN IsActive = 1 THEN 'Active'
        ELSE 'Inactive'
    END AS Status
FROM Employees;

SELECT 
    EmployeeID, 
    FirstName, 
    LastName, 
    Salary,
    CASE 
        WHEN Salary < 60000 THEN 'Low'
        WHEN Salary BETWEEN 60000 AND 80000 THEN 'Medium'
        ELSE 'High'
    END AS SalaryLevel
FROM Employees;

SELECT 
    EmployeeID, 
    FirstName, 
    LastName,
    CASE 
        WHEN IsActive = 1 THEN 'Active'
        ELSE 'Inactive'
    END AS Status
FROM Employees;

SELECT 
    EmployeeID, 
    FirstName, 
    LastName, 
    DepartmentID,
    Salary
FROM Employees
ORDER BY 
    CASE 
        WHEN DepartmentID = 1 THEN 'HR'
        WHEN DepartmentID = 2 THEN 'IT'
        WHEN DepartmentID = 3 THEN 'Finance'
        ELSE 'Other'
    END;

SELECT 
    DepartmentID,
    SUM(Salary) AS TotalSalary,
    CASE 
        WHEN SUM(Salary) > 150000 THEN 'High Salary Department'
        ELSE 'Low Salary Department'
    END AS SalaryCategory
FROM Employees
GROUP BY DepartmentID;

SELECT 
    EmployeeID, 
    FirstName, 
    LastName,
    CASE 
        WHEN IsActive = 1 THEN 
            CASE 
                WHEN Salary > 70000 THEN 'Active - High Salary'
                ELSE 'Active - Low Salary'
            END
        ELSE 
            CASE 
                WHEN Salary > 70000 THEN 'Inactive - High Salary'
                ELSE 'Inactive - Low Salary'
            END
    END AS EmployeeCategory
FROM Employees;

UPDATE Employees
SET SalaryLevel = 
    CASE 
        WHEN Salary < 60000 THEN 'Low'
        WHEN Salary BETWEEN 60000 AND 80000 THEN 'Medium'
        ELSE 'High'
    END;

SELECT 
    e.EmployeeID, 
    e.FirstName, 
    e.LastName, 
    d.DepartmentName,
    CASE 
        WHEN d.DepartmentName = 'HR' THEN 'Human Resources'
        WHEN d.DepartmentName = 'IT' THEN 'Information Technology'
        WHEN d.DepartmentName = 'Finance' THEN 'Finance Department'
        ELSE 'Other Department'
    END AS DepartmentCategory
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID;

SELECT 
    EmployeeID, 
    FirstName, 
    LastName,
    CASE 
        WHEN Salary > 70000 THEN Salary * 0.10
        ELSE Salary * 0.05
    END AS Bonus
FROM Employees;

SELECT 
    DepartmentID,
    COUNT(*) AS EmployeeCount,
    CASE 
        WHEN AVG(Salary) > 70000 THEN 'High Average Salary'
        ELSE 'Low Average Salary'
    END AS SalaryCategory
FROM Employees
GROUP BY DepartmentID
HAVING COUNT(*) > 2;

SELECT 
    EmployeeID, 
    FirstName, 
    LastName,
    (SELECT 
        CASE 
            WHEN DepartmentName = 'HR' THEN 'Human Resources'
            WHEN DepartmentName = 'IT' THEN 'Information Technology'
            ELSE 'Other'
        END
    FROM Departments d
    WHERE d.DepartmentID = e.DepartmentID) AS DepartmentName
FROM Employees e;

--built in functions

-- Create Departments Table
DROP TABLE Departments;
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName NVARCHAR(50) NOT NULL
);

-- Insert Sample Data into Departments Table
INSERT INTO Departments (DepartmentID, DepartmentName)
VALUES
(1, 'HR'),
(2, 'IT'),
(3, 'Finance');

-- Create Employees Table
DROP TABLE Employees;

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) UNIQUE,
    BirthDate DATE,
    HireDate DATE DEFAULT GETDATE(),
    Salary DECIMAL(18, 2) CHECK (Salary > 0),
    DepartmentID INT,
    IsActive BIT DEFAULT 1
);

-- Insert Sample Data into Employees Table
INSERT INTO Employees (EmployeeID, FirstName, LastName, Email, BirthDate, HireDate, Salary, DepartmentID, IsActive)
VALUES
(1, 'John', 'Doe', 'john.doe@example.com', '1985-06-15', '2020-01-10', 60000.00, 1, 1),
(2, 'Jane', 'Smith', 'jane.smith@example.com', '1990-09-23', '2019-03-22', 75000.00, 2, 1),
(3, 'Sam', 'Brown', 'sam.brown@example.com', '1978-02-14', '2018-05-30', 80000.00, 1, 0),
(4, 'Sara', 'Johnson', 'sara.johnson@example.com', '1983-11-29', '2021-07-15', 65000.00, 3, 1),
(5, 'Mike', 'Wilson', 'mike.wilson@example.com', '1992-04-05', '2017-09-20', 72000.00, 2, 1);

-- String Functions
SELECT CHARINDEX('Smith', 'John Smith') AS CharIndexExample;
SELECT LEN('Hello, World!') AS LenExample;
SELECT LOWER('SQL SERVER') AS LowerExample;
SELECT UPPER('sql server') AS UpperExample;
SELECT LTRIM('   Hello') AS LTrimExample;
SELECT RTRIM('Hello   ') AS RTrimExample;
SELECT REPLACE('Hello, World!', 'World', 'SQL Server') AS ReplaceExample;
SELECT SUBSTRING('SQL Server', 0, 4) AS SubstringExample;

-- Date and Time Functions
SELECT GETDATE() AS GetDateExample;
SELECT DATEADD(day, 10, '2024-06-01') AS DateAddExample;
SELECT DATEDIFF(day, '2024-06-01', '2024-06-11') AS DateDiffExample;
SELECT DATENAME(month, '2024-06-01') AS DateNameExample;
SELECT DATEPART(year, '2024-06-01') AS DatePartExample;

-- Aggregate Functions
SELECT COUNT(*) AS CountExample FROM Employees;

SELECT COUNT(*) 
FROM Employees 
WHERE DepartmentID = 2;

SELECT COUNT(Salary) 
FROM Employees;

SELECT COUNT(DISTINCT DepartmentID) 
FROM Employees;

SELECT DepartmentID, COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY DepartmentID;

SELECT DepartmentID, COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY DepartmentID
HAVING COUNT(*) > 10;

SELECT DepartmentID, COUNT(*) AS EmployeeCount, AVG(Salary) AS AverageSalary
FROM Employees
GROUP BY DepartmentID;

SELECT DepartmentID
FROM (
    SELECT DepartmentID, COUNT(*) AS EmployeeCount
    FROM Employees
    GROUP BY DepartmentID
) AS DepartmentCounts
WHERE EmployeeCount > 5;

SELECT SUM(Salary) AS SumExample FROM Employees;
SELECT AVG(Salary) AS AvgExample FROM Employees;
SELECT MIN(Salary) AS MinExample FROM Employees;
SELECT MAX(Salary) AS MaxExample FROM Employees;

-- Mathematical Functions
SELECT ABS(-123.45) AS AbsExample;
SELECT CEILING(123.45) AS CeilingExample;
SELECT FLOOR(123.45) AS FloorExample;
SELECT POWER(2, 3) AS PowerExample;
SELECT ROUND(123.4567, 2) AS RoundExample;

-- Conversion Functions
SELECT CAST('123' AS INT) AS CastExample;
SELECT CONVERT(VARCHAR, GETDATE(), 101) AS ConvertExample;

-- Logical Functions
SELECT ISNULL(NULL, 'No Value') AS IsNullExample;
SELECT COALESCE(NULL, NULL, 'First Non-NULL') AS CoalesceExample;

-- System Functions
SELECT @@VERSION AS VersionExample;
INSERT INTO Employees (FirstName, LastName, Email, BirthDate, Salary, DepartmentID)
VALUES ('Alice', 'Green', 'alice.green@example.com', '1987-08-25', 62000.00, 2);
SELECT SCOPE_IDENTITY() AS ScopeIdentityExample;

-- Row Number Functions
SELECT EmployeeID, FirstName, LastName, 
       ROW_NUMBER() OVER (ORDER BY LastName) AS RowNum
FROM Employees;

-- Ranking Functions
SELECT EmployeeID, FirstName, LastName, 
       RANK() OVER (ORDER BY Salary DESC) AS Rank
FROM Employees;

SELECT EmployeeID, FirstName, LastName, 
       DENSE_RANK() OVER (ORDER BY Salary DESC) AS DenseRank
FROM Employees;

SELECT EmployeeID, FirstName, LastName, 
       NTILE(2) OVER (ORDER BY Salary DESC) AS NTile, Salary
FROM Employees;

-- Window Functions
SELECT EmployeeID, FirstName, LastName, 
       Salary, LEAD(Salary, 1) OVER (ORDER BY Salary) AS NextSalary
FROM Employees;

SELECT EmployeeID, FirstName, LastName, 
       Salary, LAG(Salary, 1) OVER (ORDER BY Salary) AS PrevSalary
FROM Employees;

---------------------------------------------------------------------------------------------------------

--identity
CREATE TABLE Categories
(
    CategoryId TINYINT CONSTRAINT pk_CategoryId PRIMARY KEY IDENTITY(1,1),
    CategoryName VARCHAR(20) CONSTRAINT uq_CategoryName UNIQUE NOT NULL
)
GO

-- Insert data into Categories table
INSERT INTO Categories (CategoryName)
VALUES 
('Electronics'),
('Books'),
('Clothing'),
('Toys'),
('Furniture'),
('Groceries'),
('Stationery'),
('Sports'),
('Beauty'),
('Automotive');
GO

SELECT * FROM Categories Order By CategoryId ASC;

SET IDENTITY_INSERT person ON  
  
/*INSERT VALUE*/    
INSERT INTO person(Fullname, Occupation, Gender, PersonID)  
VALUES('Mary Smith', 'Business Analyst', 'Female', 14);  
  
SET IDENTITY_INSERT person OFF    

--sequence
-- Step 1: Create the Source Table
CREATE TABLE SourceTable
(
    SourceName VARCHAR(50) NOT NULL
);
GO

-- Step 2: Insert Data into Source Table
INSERT INTO SourceTable (SourceName)
VALUES 
('Alice'),
('Bob'),
('Charlie'),
('Diana'),
('Eve');
GO

-- Step 3: Create a Sequence
CREATE SEQUENCE MySequence
    START WITH 1
    INCREMENT BY 1;
GO

-- Step 4: Create the Target Table
CREATE TABLE TargetTable
(
    ID INT NOT NULL,
    TargetName VARCHAR(50) NOT NULL
);
GO

-- Step 5: Insert Data into Target Table Using the Sequence
INSERT INTO TargetTable (ID, TargetName)
SELECT NEXT VALUE FOR MySequence, SourceName
FROM SourceTable;
GO

-- Step 6: Verify the Data
SELECT * FROM TargetTable;
GO

--sequence another example
-- Create sequence
CREATE SEQUENCE Purchase_Sequence
START WITH 1
INCREMENT BY 1;

-- Create table for PurchaseDetailsIndia
CREATE TABLE PurchaseDetailsIndia (
    PurchaseID INT DEFAULT NEXT VALUE FOR Purchase_Sequence PRIMARY KEY,
    Email VARCHAR(255),
    ProductCode VARCHAR(50),
    Quantity INT,
    PurchaseDate DATETIME
);

-- Create table for PurchaseDetailsUK
CREATE TABLE PurchaseDetailsUK (
    PurchaseID INT DEFAULT NEXT VALUE FOR Purchase_Sequence PRIMARY KEY,
    Email VARCHAR(255),
    ProductCode VARCHAR(50),
    Quantity INT,
    PurchaseDate DATETIME
);

-- Insert data
INSERT INTO PurchaseDetailsIndia VALUES (NEXT VALUE FOR Purchase_Sequence, 'Franken@gmail.com', 'P101', 2, '2014-01-12 12:00:00');
INSERT INTO PurchaseDetailsUK VALUES (NEXT VALUE FOR Purchase_Sequence, 'Albert@gmail.com', 'P143', 1, '2014-01-13 12:01:00');
INSERT INTO PurchaseDetailsIndia VALUES (NEXT VALUE FOR Purchase_Sequence, 'Franken@gmail.com', 'P112', 3, '2014-01-14 12:02:00');

SELECT PurchaseId FROM PurchaseDetailsIndia;
SELECT PurchaseId FROM PurchaseDetailsUK;



















