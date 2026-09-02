-- =======================================================================
-- Northwind Order & Revenue Analysis
-- Task 3 - SQL for Data Analysis | Elevate Labs Data Analyst Internship
-- =======================================================================

-- 1. SELECT, WHERE, ORDER BY
-- List all orders shipped to Germany, most recent first

SELECT OrderID, CustomerID, OrderDate, ShipCountry
FROM Orders
WHERE ShipCountry = 'Germany'
ORDER BY OrderDate DESC;
=======================================================================
-- 2. GROUP BY with aggregate function
-- Total number of orders placed by each customer

SELECT CustomerID, COUNT(OrderID) AS TotalOrders
FROM Orders
GROUP BY CustomerID
ORDER BY TotalOrders DESC;
=======================================================================
-- 3. INNER JOIN
-- List each order with the customer's company name

SELECT o.OrderID, c.CompanyName, o.OrderDate
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
ORDER BY o.OrderDate DESC
LIMIT 20;
============================================================================
-- 4. LEFT JOIN
-- List all customers and their orders (including customers with no orders)

SELECT c.CustomerID, c.CompanyName, o.OrderID, o.OrderDate
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
ORDER BY c.CustomerID;
============================================================================
-- 5. RIGHT JOIN (SQLite doesn't support RIGHT JOIN directly,
-- so it's simulated by swapping table order with LEFT JOIN)
-- Equivalent of: all orders and their employee, even if employee missing

SELECT e.EmployeeID, e.LastName, o.OrderID
FROM Orders o
LEFT JOIN Employees e ON o.EmployeeID = e.EmployeeID
ORDER BY e.EmployeeID;
============================================================================
-- 6. Aggregate functions: SUM and AVG
-- Total and average revenue per order (using Order Details)

SELECT OrderID,
       SUM(UnitPrice * Quantity * (1 - Discount)) AS OrderRevenue,
       AVG(UnitPrice) AS AvgUnitPrice
FROM "Order Details"
GROUP BY OrderID
ORDER BY OrderRevenue DESC
LIMIT 20;
============================================================================
-- 7. Subquery
-- Customers whose total order revenue is above the overall average

SELECT CustomerID, TotalRevenue
FROM (
    SELECT o.CustomerID,
           SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalRevenue
    FROM Orders o
    JOIN "Order Details" od ON o.OrderID = od.OrderID
    GROUP BY o.CustomerID
) AS CustomerRevenue
WHERE TotalRevenue > (
    SELECT AVG(UnitPrice * Quantity * (1 - Discount))
    FROM "Order Details"
)
ORDER BY TotalRevenue DESC;
=================================================================================
-- 8. Create a VIEW for analysis
-- A reusable view showing revenue per customer

CREATE VIEW IF NOT EXISTS CustomerRevenueSummary AS
SELECT o.CustomerID,
       c.CompanyName,
       COUNT(DISTINCT o.OrderID) AS TotalOrders,
       SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalRevenue
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN "Order Details" od ON o.OrderID = od.OrderID
GROUP BY o.CustomerID, c.CompanyName;

-- Query the view

SELECT * FROM CustomerRevenueSummary
ORDER BY TotalRevenue DESC
LIMIT 10;
=====================================================================================
-- 9. Optimize with an INDEX
-- Speeds up lookups/joins on CustomerID in Orders

CREATE INDEX IF NOT EXISTS idx_orders_customerid ON Orders(CustomerID);

-- Speeds up lookups/joins on OrderID in Order Details

CREATE INDEX IF NOT EXISTS idx_orderdetails_orderid ON "Order Details" (OrderID);

-- Verify index was created

SELECT name, tbl_name FROM sqlite_master WHERE type = 'index' AND name LIKE 'idx_%';
=======================================================================================