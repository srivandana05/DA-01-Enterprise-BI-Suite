SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_SCHEMA, TABLE_NAME;

SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
  AND (
      TABLE_NAME LIKE '%SalesOrder%'
      OR TABLE_NAME LIKE '%Product%'
      OR TABLE_NAME LIKE '%Customer%'
      OR TABLE_NAME LIKE '%Territory%'
      OR TABLE_NAME LIKE '%Address%'
      OR TABLE_NAME LIKE '%Date%'
  )
ORDER BY TABLE_SCHEMA, TABLE_NAME;

select top(10) * from dbo.FactInternetSales;


SELECT
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'
  AND TABLE_NAME = 'FactInternetSales'
ORDER BY ORDINAL_POSITION;

USE AdventureWorksDW2022;
GO

SELECT
    COUNT(*) AS total_sales_lines,
    SUM(OrderQuantity) AS total_units_sold,
    SUM(SalesAmount) AS total_sales,
    SUM(TotalProductCost) AS total_product_cost
FROM dbo.FactInternetSales;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT SalesOrderNumber) AS distinct_orders,
    COUNT(DISTINCT CONCAT(
        SalesOrderNumber, '-',
        SalesOrderLineNumber
    )) AS distinct_order_lines,
    SUM(CASE
        WHEN OrderQuantity <= 0 THEN 1
        ELSE 0
    END) AS nonpositive_quantities,
    SUM(CASE
        WHEN SalesAmount < 0 THEN 1
        ELSE 0
    END) AS negative_sales_rows,
    SUM(CASE
        WHEN OrderDate IS NULL THEN 1
        ELSE 0
    END) AS missing_order_dates
FROM dbo.FactInternetSales;


-- the distribution of sales quantities
SELECT
    OrderQuantity,
    COUNT(*) AS number_of_sales_lines
FROM dbo.FactInternetSales
GROUP BY OrderQuantity
ORDER BY OrderQuantity;

-- which currencies appear in sales
SELECT
    CurrencyKey,
    COUNT(*) AS number_of_sales_lines,
    SUM(SalesAmount) AS total_sales
FROM dbo.FactInternetSales
GROUP BY CurrencyKey
ORDER BY CurrencyKey;


SELECT
    CurrencyKey,
    CurrencyAlternateKey,
    CurrencyName
FROM dbo.DimCurrency
WHERE CurrencyKey IN (6, 19, 29, 39, 98, 100)
ORDER BY CurrencyKey;

select MaritalStatus,TotalChildren
from dbo.DimCustomer
where TotalChildren = 2
order by MaritalStatus;


SELECT
    TABLE_NAME,
    ORDINAL_POSITION,
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'
  AND TABLE_NAME IN (
      'FactResellerSales',
      'FactFinance',
      'FactSalesQuota',
      'FactCurrencyRate',
      'FactProductInventory'
  )
ORDER BY
    TABLE_NAME,
    ORDINAL_POSITION;


--  dimensions needed for financial analysis
SELECT
    TABLE_NAME,
    ORDINAL_POSITION,
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'
  AND TABLE_NAME IN (
      'DimDate',
      'DimProduct',
      'DimSalesTerritory',
      'DimGeography',
      'DimAccount',
      'DimScenario',
      'DimOrganization',
      'DimDepartmentGroup',
      'DimCurrency'
  )
ORDER BY
    TABLE_NAME,
    ORDINAL_POSITION;


SELECT
    fk.name AS ForeignKeyName,
    OBJECT_NAME(fkc.parent_object_id) AS TableName,
    COL_NAME(
        fkc.parent_object_id,
        fkc.parent_column_id
    ) AS ColumnName,
    OBJECT_NAME(fkc.referenced_object_id) AS ReferencedTable,
    COL_NAME(
        fkc.referenced_object_id,
        fkc.referenced_column_id
    ) AS ReferencedColumn
FROM sys.foreign_key_columns AS fkc
JOIN sys.foreign_keys AS fk
    ON fkc.constraint_object_id = fk.object_id
WHERE SCHEMA_NAME(
    OBJECTPROPERTY(fkc.parent_object_id, 'SchemaId')
) = 'dbo'
ORDER BY TableName, ForeignKeyName;


SELECT 'FactInternetSales' AS TableName, COUNT_BIG(*) AS TotalRows
FROM dbo.FactInternetSales

UNION ALL

SELECT 'FactResellerSales', COUNT_BIG(*)
FROM dbo.FactResellerSales

UNION ALL

SELECT 'FactFinance', COUNT_BIG(*)
FROM dbo.FactFinance

UNION ALL

SELECT 'FactSalesQuota', COUNT_BIG(*)
FROM dbo.FactSalesQuota

UNION ALL

SELECT 'FactProductInventory', COUNT_BIG(*)
FROM dbo.FactProductInventory;

-- 1. Reseller sales: order lines and orders
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT SalesOrderNumber) AS distinct_orders,
    COUNT(DISTINCT CONCAT(
        SalesOrderNumber, '-',
        SalesOrderLineNumber
    )) AS distinct_order_lines
FROM dbo.FactResellerSales;

-- 2. Finance: records by scenario and date
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT DateKey) AS distinct_dates,
    COUNT(DISTINCT ScenarioKey) AS distinct_scenarios,
    COUNT(DISTINCT AccountKey) AS distinct_accounts
FROM dbo.FactFinance;

-- 3. Sales quota: employee and date combinations
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT EmployeeKey) AS distinct_employees,
    COUNT(DISTINCT DateKey) AS distinct_dates,
    COUNT(DISTINCT CONCAT(
        EmployeeKey, '-',
        DateKey
    )) AS distinct_employee_dates
FROM dbo.FactSalesQuota;

-- 4. Inventory: product and date combinations
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT ProductKey) AS distinct_products,
    COUNT(DISTINCT DateKey) AS distinct_dates,
    COUNT(DISTINCT CONCAT(
        ProductKey, '-',
        DateKey
    )) AS distinct_product_dates
FROM dbo.FactProductInventory;


SELECT
    MIN(MovementDate) AS first_movement_date,
    MAX(MovementDate) AS last_movement_date,
    COUNT(DISTINCT ProductKey) AS distinct_products,
    COUNT(DISTINCT MovementDate) AS distinct_movement_dates,
    SUM(UnitsIn) AS total_units_in,
    SUM(UnitsOut) AS total_units_out
FROM dbo.FactProductInventory;

SELECT TOP (15)
    ProductKey,
    MovementDate,
    UnitsIn,
    UnitsOut,
    UnitsBalance,
    UnitCost
FROM dbo.FactProductInventory
ORDER BY ProductKey, MovementDate;

WITH InventoryHistory AS (
    SELECT
        ProductKey,
        MovementDate,
        UnitsIn,
        UnitsOut,
        UnitsBalance,
        LAG(UnitsBalance) OVER (
            PARTITION BY ProductKey
            ORDER BY MovementDate
        ) AS PreviousBalance
    FROM dbo.FactProductInventory
)
SELECT TOP (20)
    ProductKey,
    MovementDate,
    PreviousBalance,
    UnitsIn,
    UnitsOut,
    UnitsBalance
FROM InventoryHistory
WHERE PreviousBalance IS NOT NULL
  AND UnitsIn = 0
  AND UnitsOut = 0
  AND UnitsBalance <> PreviousBalance
ORDER BY ProductKey, MovementDate;


select sum (SalesAmount) as totalsales
from FactInternetSales

select count (distinct SalesOrderNumber) as distinctorders
from FactInternetSales

select ScenarioKey
from FactFinance;

select sum(Amount) as totalamount
from FactFinance
where ScenarioKey = 1 ;

select sum(Amount) as totalamount
from FactFinance
where ScenarioKey = 2 ;

select distinct DepartmentName
from DimEmployee;

select distinct DepartmentGroupName
from DimDepartmentGroup;

select count (distinct EmployeeKey) as totalemployees
from DimEmployee;

/* version check */
SELECT
    @@VERSION AS SQLServerVersion,
    SERVERPROPERTY('Edition') AS Edition,
    SERVERPROPERTY('ProductVersion') AS ProductVersion;

/* 1. JOB LOG TABLE SETUP */
IF OBJECT_ID('dbo.DA01_JobLog', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.DA01_JobLog
    (
        JobLogID INT IDENTITY(1,1) PRIMARY KEY,
        JobName VARCHAR(100) NOT NULL,
        ExecutionTime DATETIME2 NOT NULL
            DEFAULT SYSDATETIME(),
        Status VARCHAR(20) NOT NULL,
        Details VARCHAR(500) NULL
    );
END;
GO

INSERT INTO dbo.DA01_JobLog
    (JobName, Status, Details)
VALUES
    ('DA01_DataProcessing', 'Success',
     'Scheduled job execution test');
GO

SELECT *
FROM dbo.DA01_JobLog
ORDER BY JobLogID DESC;

SELECT TOP 10 *
FROM dbo.DA01_JobLog
ORDER BY JobLogID DESC;

/* 2. DATA QUALITY VALIDATION */

SELECT
    COUNT_BIG(*) AS TotalSalesRows,
    SUM(
        CASE
            WHEN ProductKey IS NULL
              OR OrderDateKey IS NULL
              OR CustomerKey IS NULL
              OR SalesAmount IS NULL
              OR SalesAmount < 0
            THEN 1
            ELSE 0
        END
    ) AS InvalidSalesRows
FROM dbo.FactInternetSales;


/* DATA DICTIONARY: TABLE COLUMNS */

SELECT
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME IN (
    'FactInternetSales',
    'DimDate',
    'DimProduct',
    'DimProductSubcategory',
    'DimProductCategory',
    'DimCustomer',
    'DimSalesTerritory'
)
ORDER BY
    TABLE_NAME,
    ORDINAL_POSITION;

    /* ==========================================
   3. DA-01 DATA DICTIONARY
   Purpose: Document core sales model tables
   ========================================== */

SELECT
    TABLE_NAME AS TableName,
    CASE TABLE_NAME
        WHEN 'FactInternetSales'
            THEN 'Fact table: sales transactions and measures'
        WHEN 'DimDate'
            THEN 'Dimension: calendar and fiscal dates'
        WHEN 'DimProduct'
            THEN 'Dimension: product attributes'
        WHEN 'DimProductSubcategory'
            THEN 'Dimension: product subcategories'
        WHEN 'DimProductCategory'
            THEN 'Dimension: product categories'
        WHEN 'DimCustomer'
            THEN 'Dimension: customer attributes'
        WHEN 'DimSalesTerritory'
            THEN 'Dimension: sales regions and countries'
    END AS BusinessPurpose,
    COUNT(*) AS ColumnCount
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME IN (
    'FactInternetSales',
    'DimDate',
    'DimProduct',
    'DimProductSubcategory',
    'DimProductCategory',
    'DimCustomer',
    'DimSalesTerritory'
)
GROUP BY TABLE_NAME
ORDER BY
    CASE TABLE_NAME
        WHEN 'FactInternetSales' THEN 1
        WHEN 'DimDate' THEN 2
        WHEN 'DimProduct' THEN 3
        WHEN 'DimProductSubcategory' THEN 4
        WHEN 'DimProductCategory' THEN 5
        WHEN 'DimCustomer' THEN 6
        WHEN 'DimSalesTerritory' THEN 7
    END;


    /* ==========================================
   4. DA-01 PRIMARY KEY / FOREIGN KEY INVENTORY
   ========================================== */

SELECT
    fk.name AS ForeignKeyName,
    OBJECT_NAME(fk.parent_object_id) AS FromTable,
    COL_NAME(
        fkc.parent_object_id,
        fkc.parent_column_id
    ) AS FromColumn,
    OBJECT_NAME(fk.referenced_object_id) AS ToTable,
    COL_NAME(
        fkc.referenced_object_id,
        fkc.referenced_column_id
    ) AS ToColumn
FROM sys.foreign_keys AS fk
INNER JOIN sys.foreign_key_columns AS fkc
    ON fk.object_id = fkc.constraint_object_id
WHERE OBJECT_NAME(fk.parent_object_id) IN (
    'FactInternetSales',
    'DimDate',
    'DimProduct',
    'DimProductSubcategory',
    'DimProductCategory',
    'DimCustomer',
    'DimSalesTerritory'
)
ORDER BY FromTable, ForeignKeyName;

/* ==========================================
   5. DA-01 PRIMARY KEY INVENTORY
   ========================================== */

SELECT
    t.name AS TableName,
    c.name AS PrimaryKeyColumn
FROM sys.tables AS t
INNER JOIN sys.indexes AS i
    ON t.object_id = i.object_id
   AND i.is_primary_key = 1
INNER JOIN sys.index_columns AS ic
    ON i.object_id = ic.object_id
   AND i.index_id = ic.index_id
INNER JOIN sys.columns AS c
    ON ic.object_id = c.object_id
   AND ic.column_id = c.column_id
WHERE t.name IN (
    'FactInternetSales',
    'DimDate',
    'DimProduct',
    'DimProductSubcategory',
    'DimProductCategory',
    'DimCustomer',
    'DimSalesTerritory'
)
ORDER BY t.name, ic.key_ordinal;

/* ==========================================
   6. VERIFY FACT TABLE KEY UNIQUENESS
   ========================================== */

SELECT
    COUNT_BIG(*) AS TotalRows,
    COUNT_BIG(
        DISTINCT CONCAT(
            SalesOrderNumber,
            '-',
            SalesOrderLineNumber
        )
    ) AS DistinctSalesOrderLines
FROM dbo.FactInternetSales;