--create database
CREATE DATABASE LearnDatabaseAdvance;

--drop database
USE master;
DROP DATABASE LearnDatabaseAdvance;

--use database
USE LearnDatabaseAdvance;

--transaction
DROP TABLE Employees;

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Department NVARCHAR(50),
    Salary DECIMAL(18, 2)
);

INSERT INTO Employees (EmployeeID, FirstName, LastName, Department, Salary)
VALUES
(1, 'John', 'Doe', 'HR', 60000.00),
(2, 'Jane', 'Smith', 'Finance', 75000.00),
(3, 'Sam', 'Brown', 'IT', 80000.00);

BEGIN TRANSACTION;

-- Update salary
UPDATE Employees
SET Salary = 85000.00
WHERE EmployeeID = 3;

-- Check the update
IF (SELECT Salary FROM Employees WHERE EmployeeID = 3) = 85000.00
BEGIN
    -- Commit the transaction
    COMMIT;
    PRINT 'Transaction committed successfully.';
END
ELSE
BEGIN
    -- Rollback the transaction
    ROLLBACK;
    PRINT 'Transaction rolled back due to a condition.';
END;

--or

BEGIN TRANSACTION;

BEGIN TRY
    -- Update operation
    UPDATE Employees
    SET Salary = 85000.00
    WHERE EmployeeID = 3;

    -- Commit the transaction
    COMMIT;
    PRINT 'Transaction committed successfully.';
END TRY
BEGIN CATCH
    -- Roll back the transaction in case of an error
    ROLLBACK;
    PRINT 'Transaction rolled back due to an error.';
    PRINT ERROR_MESSAGE();
END CATCH;

--trancount
-- Check initial transaction count
PRINT 'Initial @@TRANCOUNT: ' + CAST(@@TRANCOUNT AS NVARCHAR);

-- Begin outer transaction
BEGIN TRANSACTION;
PRINT 'After BEGIN TRANSACTION (Outer) @@TRANCOUNT: ' + CAST(@@TRANCOUNT AS NVARCHAR);

-- Perform some operation
INSERT INTO Employees (EmployeeID, FirstName, LastName, Department, Salary)
VALUES (4, 'Alice', 'Johnson', 'Marketing', 70000.00);

-- Begin nested transaction
BEGIN TRANSACTION;
PRINT 'After BEGIN TRANSACTION (Nested) @@TRANCOUNT: ' + CAST(@@TRANCOUNT AS NVARCHAR);

-- Perform another operation
UPDATE Employees
SET Salary = 71000.00
WHERE EmployeeID = 4;

-- Commit nested transaction
COMMIT;
PRINT 'After COMMIT (Nested) @@TRANCOUNT: ' + CAST(@@TRANCOUNT AS NVARCHAR);

-- Commit outer transaction
COMMIT;
PRINT 'After COMMIT (Outer) @@TRANCOUNT: ' + CAST(@@TRANCOUNT AS NVARCHAR);

--or
-- Check initial transaction count
PRINT 'Initial @@TRANCOUNT: ' + CAST(@@TRANCOUNT AS NVARCHAR);

BEGIN TRY
    -- Begin outer transaction
    BEGIN TRANSACTION;
    PRINT 'After BEGIN TRANSACTION (Outer) @@TRANCOUNT: ' + CAST(@@TRANCOUNT AS NVARCHAR);

    -- Perform some operation
    INSERT INTO Employees (EmployeeID, FirstName, LastName, Department, Salary)
    VALUES (5, 'Bob', 'Miller', 'Sales', 68000.00);

    -- Begin nested transaction
    BEGIN TRANSACTION;
    PRINT 'After BEGIN TRANSACTION (Nested) @@TRANCOUNT: ' + CAST(@@TRANCOUNT AS NVARCHAR);

    -- Perform another operation that causes an error
    UPDATE Employees
    SET Salary = NULL -- Assuming Salary cannot be NULL
    WHERE EmployeeID = 5;

    -- Commit nested transaction
    COMMIT;
    PRINT 'After COMMIT (Nested) @@TRANCOUNT: ' + CAST(@@TRANCOUNT AS NVARCHAR);

    -- Commit outer transaction
    COMMIT;
    PRINT 'After COMMIT (Outer) @@TRANCOUNT: ' + CAST(@@TRANCOUNT AS NVARCHAR);
END TRY
BEGIN CATCH
    -- Roll back all active transactions
    IF @@TRANCOUNT > 0
    BEGIN
        ROLLBACK; --The ROLLBACK statement rolls back all active transactions, and @@TRANCOUNT returns to 0.
    END
    PRINT 'Error occurred, transactions rolled back. @@TRANCOUNT: ' + CAST(@@TRANCOUNT AS NVARCHAR);
    PRINT ERROR_MESSAGE();
END CATCH;

DROP TABLE Employees;

--stored procedure
DROP TABLE Employees;
DROP TABLE Departments;

-- Create Departments table
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY IDENTITY(1,1),
    DepartmentName NVARCHAR(100) NOT NULL
);

-- Create Employees table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Insert data into Departments table
INSERT INTO Departments (DepartmentName) VALUES ('HR');
INSERT INTO Departments (DepartmentName) VALUES ('IT');
INSERT INTO Departments (DepartmentName) VALUES ('Finance');

-- Insert data into Employees table
INSERT INTO Employees (FirstName, LastName, DepartmentID) VALUES ('John', 'Doe', 1);
INSERT INTO Employees (FirstName, LastName, DepartmentID) VALUES ('Jane', 'Smith', 2);
INSERT INTO Employees (FirstName, LastName, DepartmentID) VALUES ('Michael', 'Johnson', 3);

-- Create a stored procedure to get employees by department
CREATE PROCEDURE GetEmployeesByDepartment
    @DepartmentName NVARCHAR(100)
AS
BEGIN
    SELECT e.EmployeeID, e.FirstName, e.LastName, d.DepartmentName
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE d.DepartmentName = @DepartmentName;
END;

EXEC GetEmployeesByDepartment @DepartmentName = 'IT';

DROP PROCEDURE dbo.GetEmployeesByDepartment;

--with recompile
CREATE PROCEDURE GetEmployeeDetails
    @EmployeeID INT
WITH RECOMPILE --Ensures the stored procedure is recompiled every time it is executed, which can be beneficial for procedures with varying query plans depending on input parameters.
AS
BEGIN
    SELECT EmployeeID, FirstName, LastName, DepartmentID
    FROM Employees
    WHERE EmployeeID = @EmployeeID;
END;

EXEC GetEmployeesByDepartment @DepartmentName = 'IT';

DROP PROCEDURE dbo.GetEmployeesByDepartment;

--with encryption
CREATE PROCEDURE GetDepartmentDetails
    @DepartmentID INT
WITH ENCRYPTION --Encrypts the stored procedure definition to protect the code from being viewed or modified by unauthorized users.
AS
BEGIN
    SELECT DepartmentID, DepartmentName
    FROM Departments
    WHERE DepartmentID = @DepartmentID;
END;

EXEC GetEmployeesByDepartment @DepartmentName = 'IT';

DROP PROCEDURE dbo.GetEmployeesByDepartment;

DROP TABLE Employees;
DROP TABLE Departments;

--stored procedure vs user defined function
--Use stored procedures when you need to perform operations that modify the database, manage transactions, or return multiple result sets.
--Use UDFs when you need to encapsulate reusable logic that can be used within SQL queries, especially if you need to return a single value or a table without modifying the database state.

--User-defined Function
--1)Scalar Function
--2)Table-Valued Functions
--Inline Table-Values Functions
--Multi-statement table-valued functions (MSTVF)
DROP TABLE Employees;
DROP TABLE Departments;

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName NVARCHAR(50) NOT NULL
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    DepartmentID INT,
    Salary DECIMAL(10, 2),
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Insert data into Departments table
INSERT INTO Departments (DepartmentID, DepartmentName)
VALUES (1, 'Human Resources'),
       (2, 'IT'),
       (3, 'Finance');

-- Insert data into Employees table
INSERT INTO Employees (EmployeeID, FirstName, LastName, DepartmentID, Salary)
VALUES (1, 'John', 'Doe', 1, 50000.00),
       (2, 'Jane', 'Smith', 2, 60000.00),
       (3, 'Michael', 'Johnson', 2, 70000.00),
       (4, 'Emily', 'Davis', 3, 55000.00);

--Scalar functions return a single value, inline table-valued functions return a table inline with a query, 
--and multi-statement table-valued functions return a table after executing multiple statements.

--1)Scalar Function

CREATE FUNCTION dbo.GetEmployeeFullName (@EmployeeID INT)
RETURNS NVARCHAR(101)
AS
BEGIN
    DECLARE @FullName NVARCHAR(101)
    
    SELECT @FullName = FirstName + ' ' + LastName
    FROM Employees
    WHERE EmployeeID = @EmployeeID

    RETURN @FullName
END;

SELECT EmployeeID, dbo.GetEmployeeFullName(EmployeeID) AS FullName, Salary
FROM Employees;

DROP FUNCTION dbo.GetEmployeeFullName;

DROP TABLE Employees;
DROP TABLE Departments;

--2)Table-Valued Functions
--Inline Table-Values Functions
DROP TABLE Employees;

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    DepartmentID INT,
    Salary DECIMAL(10, 2),
    HireDate DATE
);

INSERT INTO Employees (EmployeeID, FirstName, LastName, DepartmentID, Salary, HireDate)
VALUES
    (1, 'John', 'Doe', 1, 50000.00, '2020-01-15'),
    (2, 'Jane', 'Smith', 2, 60000.00, '2019-05-20'),
    (3, 'Michael', 'Johnson', 2, 70000.00, '2018-11-10'),
    (4, 'Emily', 'Davis', 1, 55000.00, '2021-02-28');

CREATE FUNCTION GetEmployeesByDepartmentt (@DepartmentID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT EmployeeID, FirstName, LastName, Salary, HireDate
    FROM Employees
    WHERE DepartmentID = @DepartmentID
);

SELECT *
FROM GetEmployeesByDepartmentt(1);

DROP FUNCTION dbo.GetEmployeesByDepartmentt;

DROP TABLE Employees;

--2)Table-Valued Functions
--Multi-statement table-valued functions (MSTVF)
DROP TABLE Employees;

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    DepartmentID INT,
    Salary DECIMAL(10, 2),
    HireDate DATE
);

INSERT INTO Employees (EmployeeID, FirstName, LastName, DepartmentID, Salary, HireDate)
VALUES
    (1, 'John', 'Doe', 1, 50000.00, '2020-01-15'),
    (2, 'Jane', 'Smith', 2, 60000.00, '2019-05-20'),
    (3, 'Michael', 'Johnson', 2, 70000.00, '2018-11-10'),
    (4, 'Emily', 'Davis', 1, 55000.00, '2021-02-28');

CREATE FUNCTION GetEmployeesWithHireDate (@HireDateFilter DATE)
RETURNS @Employees TABLE (
    EmployeeID INT,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Salary DECIMAL(10, 2),
    HireDate DATE
)
AS
BEGIN
    INSERT INTO @Employees (EmployeeID, FirstName, LastName, Salary, HireDate)
    SELECT EmployeeID, FirstName, LastName, Salary, HireDate
    FROM Employees
    WHERE HireDate > @HireDateFilter;

    RETURN;
END;

SELECT *
FROM GetEmployeesWithHireDate('2020-01-01');

DROP FUNCTION dbo.GetEmployeesWithHireDate;

DROP TABLE Employees;