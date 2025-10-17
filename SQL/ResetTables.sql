-- Week 8: ETL Refresh Script
-- Drops existing tables (if any) and recreates the Standard, Fact, Audit, and Error Logging Tables

USE DW_Demo_Labs;
GO

-- ============================================
-- 1. Drop existing tables (in dependency order)
-- ============================================

IF OBJECT_ID('FactSalesStandard', 'U') IS NOT NULL DROP TABLE FactSalesStandard;
IF OBJECT_ID('DimProductStandard', 'U') IS NOT NULL DROP TABLE DimProductStandard;
IF OBJECT_ID('DimCustomerStandard', 'U') IS NOT NULL DROP TABLE DimCustomerStandard;
IF OBJECT_ID('ETLAuditLog', 'U') IS NOT NULL DROP TABLE ETLAuditLog;
IF OBJECT_ID('ETLErrorLog', 'U') IS NOT NULL DROP TABLE ETLErrorLog;
GO

-- ============================================
-- 2. Create Standard Dimension Tables
-- ============================================

CREATE TABLE DimProductStandard (
    ProductKey INT IDENTITY(1,1) PRIMARY KEY,
    ProductCode VARCHAR(20) NOT NULL UNIQUE, -- Natural Key for Lookup
    ProductName VARCHAR(100)
);

CREATE TABLE DimCustomerStandard (
    CustomerKey INT IDENTITY(1,1) PRIMARY KEY,
    CustomerCode VARCHAR(20) NOT NULL UNIQUE, -- Natural Key for Lookup
    CustomerName VARCHAR(100)
);
GO

-- ============================================
-- 3. Create Fact Table
-- ============================================

CREATE TABLE FactSalesStandard (
    FactKey INT IDENTITY(1,1) PRIMARY KEY,
    ProductKey INT NOT NULL REFERENCES DimProductStandard(ProductKey),
    CustomerKey INT NOT NULL REFERENCES DimCustomerStandard(CustomerKey),
    SaleDate DATE NOT NULL,
    Quantity INT
);
GO

-- ============================================
-- 4. Create Audit Log Table (Control Flow Auditing)
-- ============================================

CREATE TABLE ETLAuditLog (
    AuditKey INT IDENTITY(1,1) PRIMARY KEY,
    PackageName VARCHAR(100) NOT NULL,
    Status VARCHAR(20) NOT NULL, -- e.g., 'Running', 'Success', 'Failure'
    StartTime DATETIME NOT NULL,
    EndTime DATETIME
);
GO

-- ============================================
-- 5. Create Error Log Table (Data Flow Rejection Path)
-- ============================================

CREATE TABLE ETLErrorLog (
    ErrorKey INT IDENTITY(1,1) PRIMARY KEY,
    PackageName VARCHAR(100),
    ErrorReason VARCHAR(255) NOT NULL, -- Custom message: Missing Key, Invalid Quantity
    SourceData_ProductID VARCHAR(20),
    SourceData_CustomerID VARCHAR(20),
    SourceData_Quantity VARCHAR(20) -- Store as VARCHAR to handle NULLs/bad types
);
GO
