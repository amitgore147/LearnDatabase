--create database
CREATE DATABASE LearnDatabaseAdvance;

--drop database
USE master;
DROP DATABASE LearnDatabaseAdvance;

--use database
USE LearnDatabaseAdvance;

--index
--clustored index
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Department NVARCHAR(50),
    Salary DECIMAL(18, 2)
);

INSERT INTO Employees (EmployeeID, FirstName, LastName, Department, Salary)
VALUES
    (1, 'John', 'Doe', 'Sales', 50000.00),
    (2, 'Jane', 'Smith', 'Marketing', 60000.00),
    (3, 'Alice', 'Johnson', 'Sales', 55000.00),
    (4, 'Bob', 'Brown', 'Finance', 70000.00),
    (5, 'Charlie', 'Davis', 'Marketing', 62000.00);

-- This clustered index is automatically created because of the primary key constraint.
-- No need to explicitly create it unless you want to define it on a different column.

SELECT * FROM Employees WHERE EmployeeID = 4;

DROP TABLE Employees;

-- Example of creating a clustered index explicitly on a different column
CREATE TABLE Employees (
    EmployeeID INT,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Department NVARCHAR(50),
    Salary DECIMAL(18, 2)
);

CREATE CLUSTERED INDEX IX_Employees_Department
ON Employees (Department);

SELECT * FROM Employees WHERE Department = 'Sales';

--non-clustored index
CREATE NONCLUSTERED INDEX IX_Employees_LastName
ON Employees (LastName);

SELECT * FROM Employees WHERE LastName = 'Johnson';

DROP TABLE Employees;

--temporary tables
--local
CREATE TABLE #Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Department NVARCHAR(50),
    Salary DECIMAL(18, 2)
);

INSERT INTO #Employees (EmployeeID, FirstName, LastName, Department, Salary)
VALUES
    (1, 'John', 'Doe', 'Sales', 50000.00),
    (2, 'Jane', 'Smith', 'Marketing', 60000.00),
    (3, 'Alice', 'Johnson', 'Sales', 55000.00),
    (4, 'Bob', 'Brown', 'Finance', 70000.00),
    (5, 'Charlie', 'Davis', 'Marketing', 62000.00);

DROP TABLE #Employees;

--global
CREATE TABLE ##Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Department NVARCHAR(50),
    Salary DECIMAL(18, 2)
);

INSERT INTO ##Employees (EmployeeID, FirstName, LastName, Department, Salary)
VALUES
    (1, 'John', 'Doe', 'Sales', 50000.00),
    (2, 'Jane', 'Smith', 'Marketing', 60000.00),
    (3, 'Alice', 'Johnson', 'Sales', 55000.00),
    (4, 'Bob', 'Brown', 'Finance', 70000.00),
    (5, 'Charlie', 'Davis', 'Marketing', 62000.00);

DROP TABLE ##Employees;

--views/virtual tables
CREATE VIEW EmployeeView AS
SELECT *
FROM Employees;

SELECT * FROM EmployeeView;

DROP VIEW EmployeeView;

--temporary tables vs views/virtual tables
--temporary tables are physical tables that exist temporarily and are useful for storing intermediate results within a session. Views are virtual tables that provide a simplified and consistent view of the data and can be used to enforce security and improve query performance.

--batch
BEGIN
    SELECT 'Hello, ' AS Greeting;
    SELECT 'World!' AS Target;
END;

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY NOT NULL,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Department NVARCHAR(50),
    Salary DECIMAL(18, 2)
);

INSERT INTO Employees (EmployeeID, FirstName, LastName, Department, Salary)
VALUES
    (1, 'John', 'Doe', 'Sales', 50000.00),
    (2, 'Jane', 'Smith', 'Marketing', 60000.00),
    (3, 'Alice', 'Johnson', 'Sales', 55000.00),
    (4, 'Bob', 'Brown', 'Finance', 70000.00),
    (5, 'Charlie', 'Davis', 'Marketing', 62000.00);

SELECT * FROM Employees;

BEGIN

    DECLARE @EmployeeID INT = 1, 
            @TotalAmount DECIMAL(18, 2)

    SELECT @TotalAmount = Salary * 2 -- Assuming QuantityPurchased is always 2
    FROM Employees
    WHERE EmployeeID = @EmployeeID

    IF @TotalAmount > 0 AND @TotalAmount < 50000
        SET @TotalAmount = 0.95 * @TotalAmount
    ELSE IF @TotalAmount >= 50000 AND @TotalAmount < 150000
        SET @TotalAmount = 0.9 * @TotalAmount

    PRINT @TotalAmount
END

DROP TABLE Employees;

--exception handling
BEGIN
    DECLARE @EmployeeID INT = 8, 
            @TotalAmount DECIMAL(18, 2)

    BEGIN TRY
        SELECT @TotalAmount = Salary * 2 -- Assuming QuantityPurchased is always 2
        FROM Employees
        WHERE EmployeeID = @EmployeeID

        IF @TotalAmount IS NULL
        BEGIN
            THROW 50001, 'Employee not found', 1;
        END

        IF @TotalAmount > 0 AND @TotalAmount < 1000
            SET @TotalAmount = 0.95 * @TotalAmount
        ELSE IF @TotalAmount >= 1000 AND @TotalAmount < 2000
            SET @TotalAmount = 0.9 * @TotalAmount

        PRINT @TotalAmount
    END TRY
    BEGIN CATCH
        PRINT 'An error occurred: ' + ERROR_MESSAGE();
    END CATCH
END

DROP TABLE Employees;

--trigger
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Department NVARCHAR(50)
);

CREATE TABLE AuditLog (
    LogID INT IDENTITY(1,1) NOT NULL,
    EmployeeID INT,
    LogDate DATETIME,
    Action NVARCHAR(50)
);

INSERT INTO Employees (EmployeeID, FirstName, LastName, Department)
VALUES (1, 'John', 'Doe', 'IT'),
       (2, 'Jane', 'Smith', 'HR');

CREATE TRIGGER trgAfterInsertUpdateDelete
ON Employees
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS(SELECT 1 FROM inserted)
    BEGIN
        INSERT INTO AuditLog (EmployeeID, LogDate, Action)
        SELECT EmployeeID, GETDATE(), 'INSERT'
        FROM inserted;
    END;

    IF EXISTS(SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO AuditLog (EmployeeID, LogDate, Action)
        SELECT EmployeeID, GETDATE(), 'DELETE'
        FROM deleted;
    END;
END;

DROP TRIGGER trgAfterInsertUpdateDelete;

-- Insert a new employee
INSERT INTO Employees (EmployeeID, FirstName, LastName, Department)
VALUES (3, 'Alice', 'Johnson', 'Finance');
INSERT INTO Employees (EmployeeID, FirstName, LastName, Department)
VALUES (4, 'Alice', 'Johnson', 'Finance');
INSERT INTO Employees (EmployeeID, FirstName, LastName, Department)
VALUES (5, 'Alice', 'Johnson', 'Finance');

-- Delete an existing employee
DELETE FROM Employees WHERE EmployeeID = 4;

-- Check the AuditLog table for the logged actions
SELECT * FROM Employees;
SELECT * FROM AuditLog;

DROP TABLE Employees;
DROP TABLE AuditLog;

--merge
DROP TABLE Employees;
DROP TABLE EmployeeUpdates;

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    DepartmentID INT,
    Salary DECIMAL(10, 2)
);

INSERT INTO Employees (EmployeeID, FirstName, LastName, DepartmentID, Salary)
VALUES 
(1, 'John', 'Doe', 101, 60000.00),
(2, 'Jane', 'Smith', 102, 65000.00),
(3, 'Jim', 'Brown', 103, 55000.00),
(4, 'Jake', 'White', 104, 50000.00),
(5, 'Jill', 'Black', 105, 70000.00);


CREATE TABLE EmployeeUpdates (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    DepartmentID INT,
    Salary DECIMAL(10, 2)
);

INSERT INTO EmployeeUpdates (EmployeeID, FirstName, LastName, DepartmentID, Salary)
VALUES 
(1, 'John', 'Doe', 101, 62000.00), -- Updated Salary
(2, 'Jane', 'Smith', 102, 65000.00), -- Same record, no changes
(3, 'Jimmy', 'Brown', 103, 56000.00), -- Updated FirstName and Salary
(6, 'James', 'Green', 106, 52000.00); -- New record

MERGE Employees AS target
USING EmployeeUpdates AS source
ON target.EmployeeID = source.EmployeeID
WHEN MATCHED THEN
    UPDATE SET 
        target.FirstName = source.FirstName,
        target.LastName = source.LastName,
        target.DepartmentID = source.DepartmentID,
        target.Salary = source.Salary
WHEN NOT MATCHED BY TARGET THEN
    INSERT (EmployeeID, FirstName, LastName, DepartmentID, Salary)
    VALUES (source.EmployeeID, source.FirstName, source.LastName, source.DepartmentID, source.Salary)
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;

SELECT * FROM Employees;
SELECT * FROM EmployeeUpdates;

DROP TABLE Employees;
DROP TABLE EmployeeUpdates;

--SQL Server specific clauses and settings
DROP TABLE Users;
DROP TABLE PurchaseDetails;

CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    UserName NVARCHAR(50),
    UserEmail NVARCHAR(50)
);

INSERT INTO Users (UserID, UserName, UserEmail)
VALUES 
(1, 'John Doe', 'john.doe@example.com'),
(2, 'Jane Smith', 'jane.smith@example.com'),
(3, 'Alice Johnson', 'alice.johnson@example.com'),
(4, 'Bob Brown', 'bob.brown@example.com');

CREATE TABLE PurchaseDetails (
    PurchaseID INT PRIMARY KEY,
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    ProductID INT,
    QuantityPurchased INT,
    PurchaseDate DATE
);

INSERT INTO PurchaseDetails (PurchaseID, UserID, ProductID, QuantityPurchased, PurchaseDate)
VALUES 
(1, 1, 101, 2, '2023-01-15'),
(2, 1, 102, 1, '2023-02-20'),
(3, 2, 101, 3, '2023-03-10'),
(4, 3, 103, 5, '2023-04-05'),
(5, 4, 104, 2, '2023-05-18');

--into
SELECT * INTO BackUpUsers FROM Users;
SELECT * FROM BackUpUsers;

--top
SELECT TOP 10 ProductID, SUM(QuantityPurchased) AS PurchaseCount 
FROM PurchaseDetails 
GROUP BY ProductID 
ORDER BY SUM(QuantityPurchased) DESC;

SELECT TOP 10 WITH TIES ProductID, SUM(QuantityPurchased) AS PurchaseCount 
FROM PurchaseDetails 
GROUP BY ProductID 
ORDER BY SUM(QuantityPurchased) DESC;

DROP TABLE Users;
DROP TABLE PurchaseDetails;

--a) CONCAT_NULL_YIELDS_NULL Flag Example
-- Setting the flag ON
SET CONCAT_NULL_YIELDS_NULL ON;

-- Concatenating a string with NULL
SELECT 'Infosys' + NULL AS Result;  -- Result will be NULL

-- Setting the flag OFF
SET CONCAT_NULL_YIELDS_NULL OFF;

-- Concatenating a string with NULL
SELECT 'Infosys' + NULL AS Result;  -- Result will be 'Infosys'

--b) ANSI_NULLS Flag Example
DROP TABLE Users;
CREATE TABLE Users (
    EmailId NVARCHAR(50),
    UserPassword NVARCHAR(50),
    RoleId INT,
    Gender CHAR(1),
    CreatedDate DATE,
    UserName NVARCHAR(50)
);

INSERT INTO Users VALUES 
('Abc@gmail.com', 'ABC@1234', NULL, 'M', '2016-06-02', 'XYZ');

-- Setting the flag ON
SET ANSI_NULLS ON;

-- Using NULL in a comparison (incorrect)
SELECT EmailId, UserPassword FROM Users WHERE RoleId = NULL;  -- This will not work

-- Using IS NULL in a comparison (correct)
SELECT EmailId, UserPassword FROM Users WHERE RoleId IS NULL;  -- This will work

-- Setting the flag OFF
SET ANSI_NULLS OFF;

-- Using NULL in a comparison
SELECT EmailId, UserPassword FROM Users WHERE RoleId = NULL;  -- This will work

-- Using IS NULL in a comparison
SELECT EmailId, UserPassword FROM Users WHERE RoleId IS NULL;  -- This will also work

DROP TABLE Users;

--Common Table Expression (CTE)
DROP TABLE PurchaseDetails;

CREATE TABLE PurchaseDetails (
    PurchaseID INT PRIMARY KEY,
    ProductID INT,
    QuantityPurchased INT
);

INSERT INTO PurchaseDetails (PurchaseID, ProductID, QuantityPurchased)
VALUES 
(1, 101, 5),
(2, 102, 3),
(3, 101, 2),
(4, 103, 4),
(5, 102, 1);

WITH TotalQuantityCTE AS (
    SELECT ProductID, SUM(QuantityPurchased) AS TotalQuantity
    FROM PurchaseDetails
    GROUP BY ProductID
)

SELECT * FROM TotalQuantityCTE; --usecase

DROP TABLE PurchaseDetails;

--pivot
DROP TABLE Sales;

-- Create the Sales table
CREATE TABLE Sales (
    Year INT,
    Quarter CHAR(2),
    Revenue DECIMAL(10, 2)
);

-- Insert sample data into the Sales table
INSERT INTO Sales (Year, Quarter, Revenue) VALUES
(2022, 'Q1', 10000),
(2022, 'Q2', 15000),
(2022, 'Q3', 12000),
(2022, 'Q4', 18000),
(2023, 'Q1', 11000),
(2023, 'Q2', 16000),
(2023, 'Q3', 13000),
(2023, 'Q4', 19000);


SELECT Year, Quarter, Revenue FROM Sales

SELECT *
FROM (
    SELECT Year, Quarter, Revenue
    FROM Sales
) AS SourceTable
PIVOT (
    SUM(Revenue)
    FOR Quarter IN ([Q1], [Q2], [Q3], [Q4])
) AS PivotTable;


--unpivot
SELECT Year, Quarter, Revenue
FROM (
    SELECT Year, Q1, Q2, Q3, Q4
    FROM (
        SELECT Year, Quarter, Revenue
        FROM Sales
    ) AS SourceTable
    PIVOT (
        SUM(Revenue)
        FOR Quarter IN ([Q1], [Q2], [Q3], [Q4])
    ) AS PivotTable
) AS UnpivotTable
UNPIVOT (
    Revenue FOR Quarter IN ([Q1], [Q2], [Q3], [Q4])
) AS UnpivotResult;

--pagination
DROP TABLE Employees;

-- Create a table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name NVARCHAR(50),
    Department NVARCHAR(50),
    Salary DECIMAL(10, 2)
);

-- Insert some data
INSERT INTO Employees (EmployeeID, Name, Department, Salary)
VALUES
    (1, 'John Doe', 'IT', 55000.00),
    (2, 'Jane Smith', 'Finance', 60000.00),
    (3, 'Bob Johnson', 'HR', 50000.00),
    (4, 'Alice Brown', 'IT', 62000.00),
    (5, 'Charlie Davis', 'Finance', 58000.00),
    (6, 'Eve Wilson', 'HR', 51000.00),
    (7, 'Grace Lee', 'IT', 59000.00),
    (8, 'Henry Clark', 'Finance', 64000.00),
    (9, 'Ivy Rodriguez', 'HR', 53000.00),
    (10, 'Jack Young', 'IT', 60000.00);

--basic
SELECT *
FROM Employees
ORDER BY EmployeeID
OFFSET 0 ROWS
FETCH NEXT 5 ROWS ONLY;

--Pagination with Page Number and Page Size
DECLARE @PageNumber INT = 2;
DECLARE @PageSize INT = 3;

SELECT *
FROM Employees
ORDER BY EmployeeID
OFFSET (@PageNumber - 1) * @PageSize ROWS
FETCH NEXT @PageSize ROWS ONLY;

--Pagination with Sorting
DECLARE @PageNumber INT = 1;
DECLARE @PageSize INT = 4;
DECLARE @SortColumn NVARCHAR(50) = 'Salary';
DECLARE @SortOrder NVARCHAR(4) = 'DESC';

SELECT *
FROM Employees
ORDER BY
    CASE WHEN @SortOrder = 'ASC' THEN
        CASE
            WHEN @SortColumn = 'EmployeeID' THEN EmployeeID
            WHEN @SortColumn = 'Name' THEN Name
            WHEN @SortColumn = 'Department' THEN Department
            WHEN @SortColumn = 'Salary' THEN Salary
        END
    END ASC,
    CASE WHEN @SortOrder = 'DESC' THEN
        CASE
            WHEN @SortColumn = 'EmployeeID' THEN EmployeeID
            WHEN @SortColumn = 'Name' THEN Name
            WHEN @SortColumn = 'Department' THEN Department
            WHEN @SortColumn = 'Salary' THEN Salary
        END
    END DESC
OFFSET (@PageNumber - 1) * @PageSize ROWS
FETCH NEXT @PageSize ROWS ONLY;

--Pagination with Total Count
DECLARE @PageNumber INT = 1;
DECLARE @PageSize INT = 3;
DECLARE @TotalCount INT;

SELECT @TotalCount = COUNT(*)
FROM Employees;

SELECT *, @TotalCount AS TotalCount
FROM Employees
ORDER BY EmployeeID
OFFSET (@PageNumber - 1) * @PageSize ROWS
FETCH NEXT @PageSize ROWS ONLY;


























