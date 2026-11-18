/*
Supply Chain Analytics & Inventory Optimization
Synthetic portfolio dataset — SQL Server
Run in SSMS after creating a database named SupplyChainAnalytics.
*/
IF DB_ID('SupplyChainAnalytics') IS NULL
    CREATE DATABASE SupplyChainAnalytics;
GO
USE SupplyChainAnalytics;
GO

DROP TABLE IF EXISTS dbo.PurchaseOrders;
DROP TABLE IF EXISTS dbo.Inventory;
DROP TABLE IF EXISTS dbo.Products;
DROP TABLE IF EXISTS dbo.Suppliers;
GO

CREATE TABLE dbo.Products (
    ProductID varchar(10) PRIMARY KEY,
    ProductName varchar(100) NOT NULL,
    Category varchar(50) NOT NULL,
    UnitCost decimal(10,2) NOT NULL,
    ReorderPoint int NOT NULL,
    TargetStock int NOT NULL
);

CREATE TABLE dbo.Suppliers (
    SupplierID varchar(10) PRIMARY KEY,
    SupplierName varchar(100) NOT NULL,
    Country varchar(50),
    SupplierTier varchar(30)
);

CREATE TABLE dbo.Inventory (
    ProductID varchar(10) PRIMARY KEY,
    OnHandQty int NOT NULL,
    SnapshotDate date NOT NULL,
    CONSTRAINT FK_Inventory_Products FOREIGN KEY (ProductID) REFERENCES dbo.Products(ProductID)
);

CREATE TABLE dbo.PurchaseOrders (
    PurchaseOrderID varchar(10) PRIMARY KEY,
    ProductID varchar(10) NOT NULL,
    SupplierID varchar(10) NOT NULL,
    OrderDate date NOT NULL,
    PromisedDate date NOT NULL,
    ReceivedDate date NOT NULL,
    OrderQty int NOT NULL,
    UnitCost decimal(10,2) NOT NULL,
    CONSTRAINT FK_PO_Products FOREIGN KEY (ProductID) REFERENCES dbo.Products(ProductID),
    CONSTRAINT FK_PO_Suppliers FOREIGN KEY (SupplierID) REFERENCES dbo.Suppliers(SupplierID)
);
GO

-- Import each CSV using SSMS: database > Tasks > Import Flat File.
-- Ensure date columns are typed as DATE and quantity/cost columns as numeric.
-- If importing to tables with existing names, clear the tables first.

-- 1. Inventory status
SELECT p.ProductID, p.ProductName, p.Category, i.OnHandQty,
       p.ReorderPoint, p.TargetStock,
       CASE WHEN i.OnHandQty < p.ReorderPoint THEN 'Reorder Now'
            WHEN i.OnHandQty < p.TargetStock THEN 'Watch'
            ELSE 'Healthy' END AS InventoryStatus,
       CAST(i.OnHandQty * p.UnitCost AS decimal(12,2)) AS EstimatedInventoryValue
FROM dbo.Products p
JOIN dbo.Inventory i ON p.ProductID = i.ProductID
ORDER BY CASE WHEN i.OnHandQty < p.ReorderPoint THEN 1
              WHEN i.OnHandQty < p.TargetStock THEN 2 ELSE 3 END,
         p.ProductName;

-- 2. Supplier on-time delivery performance
WITH Delivery AS (
    SELECT s.SupplierID, s.SupplierName, po.PurchaseOrderID,
           CASE WHEN po.ReceivedDate <= po.PromisedDate THEN 1 ELSE 0 END AS OnTime,
           CASE WHEN po.ReceivedDate > po.PromisedDate
                THEN DATEDIFF(day, po.PromisedDate, po.ReceivedDate) ELSE 0 END AS DelayDays
    FROM dbo.PurchaseOrders po
    JOIN dbo.Suppliers s ON po.SupplierID = s.SupplierID
)
SELECT SupplierID, SupplierName, COUNT(*) AS TotalOrders,
       SUM(OnTime) AS OnTimeOrders,
       CAST(100.0 * SUM(OnTime) / NULLIF(COUNT(*),0) AS decimal(5,2)) AS OnTimeDeliveryPct,
       AVG(CAST(DelayDays AS decimal(10,2))) AS AvgDelayDays
FROM Delivery
GROUP BY SupplierID, SupplierName
ORDER BY OnTimeDeliveryPct;

-- 3. Spend by category and supplier
SELECT p.Category, s.SupplierName,
       SUM(po.OrderQty * po.UnitCost) AS TotalSpend,
       COUNT(DISTINCT po.PurchaseOrderID) AS PurchaseOrders
FROM dbo.PurchaseOrders po
JOIN dbo.Products p ON po.ProductID = p.ProductID
JOIN dbo.Suppliers s ON po.SupplierID = s.SupplierID
GROUP BY p.Category, s.SupplierName
ORDER BY TotalSpend DESC;

-- 4. Monthly procurement spend
SELECT YEAR(OrderDate) AS OrderYear, MONTH(OrderDate) AS OrderMonth,
       SUM(OrderQty * UnitCost) AS MonthlySpend
FROM dbo.PurchaseOrders
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY OrderYear, OrderMonth;

-- 5. Data quality checks
SELECT ProductID, COUNT(*) AS RowCount
FROM dbo.Products GROUP BY ProductID HAVING COUNT(*) > 1;

SELECT * FROM dbo.PurchaseOrders
WHERE OrderQty <= 0 OR UnitCost < 0 OR ReceivedDate < OrderDate;
