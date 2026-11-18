-- Business Databases: worked SELECT examples in reading order.
-- Use the supplied Cedar Books SQLite database.
-- The illustrative draft is intentionally wrong; its correction follows.

-- Book catalog by price
SELECT Title, ListPrice
FROM Books
ORDER BY ListPrice DESC, Title;

-- Business books above $20
SELECT BookID, Title, ListPrice
FROM Books
WHERE Category = 'Business' AND ListPrice > 20
ORDER BY Title;

-- A price condition applied to two categories
SELECT Title, Category, ListPrice
FROM Books
WHERE ListPrice >= 20
  AND (Category = 'Business' OR Category = 'Fiction')
ORDER BY Title;

-- Orders placed in April
SELECT OrderID, OrderDate, Status
FROM Orders
WHERE OrderDate >= '2025-04-01'
  AND OrderDate < '2025-05-01'
ORDER BY OrderDate, OrderID;

-- Calculate the two line values on order 501
SELECT OrderID, BookID, Quantity, UnitPrice,
       ROUND(Quantity * UnitPrice, 2) AS LineValue
FROM OrderLines
WHERE OrderID = 501
ORDER BY BookID;

-- Create a price-band label
SELECT Title, ListPrice,
       CASE WHEN ListPrice >= 25 THEN 'Premium'
            ELSE 'Everyday' END AS PriceBand
FROM Books
ORDER BY ListPrice DESC, Title;

-- Summarize the catalog
SELECT COUNT(*) AS NumberOfBooks,
       ROUND(AVG(ListPrice), 2) AS AverageListPrice,
       MIN(ListPrice) AS LowestPrice,
       MAX(ListPrice) AS HighestPrice
FROM Books;

-- Lines, copies and order value are different measures
SELECT COUNT(*) AS Lines,
       SUM(Quantity) AS Copies,
       ROUND(SUM(Quantity * UnitPrice), 2) AS OrderValue
FROM OrderLines
WHERE OrderID = 501;

-- One summary per category
SELECT Category, COUNT(*) AS NumberOfBooks,
       ROUND(AVG(ListPrice), 2) AS AverageListPrice
FROM Books
GROUP BY Category
ORDER BY Category;

-- Attach the customer name to an order
SELECT o.OrderID, o.OrderDate, c.CustomerName
FROM Orders AS o
JOIN Customers AS c ON c.CustomerID = o.CustomerID
WHERE o.OrderID = 501;

-- Reconstruct the details of order 501
SELECT o.OrderID, c.CustomerName, b.Title,
       ol.Quantity, ol.UnitPrice,
       ROUND(ol.Quantity * ol.UnitPrice, 2) AS LineValue
FROM Orders AS o
JOIN Customers AS c ON c.CustomerID = o.CustomerID
JOIN OrderLines AS ol ON ol.OrderID = o.OrderID
JOIN Books AS b ON b.BookID = ol.BookID
WHERE o.OrderID = 501
ORDER BY b.BookID;

-- Orders on file for customers with matching orders
SELECT c.CustomerID, c.CustomerName, COUNT(*) AS OrdersOnFile
FROM Customers AS c
JOIN Orders AS o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY c.CustomerID;

-- Practice: books below $20
SELECT Title, Category, ListPrice
FROM Books
WHERE ListPrice < 20
ORDER BY ListPrice, Title;

-- Illustrative draft with errors
SELECT COUNT(*) AS OrderCount,
       ROUND(SUM(ol.Quantity * b.ListPrice), 2) AS OrderValue
FROM Orders AS o
JOIN OrderLines AS ol ON ol.OrderID = o.OrderID
JOIN Books AS b ON b.BookID = ol.BookID
WHERE o.OrderDate >= '2025-04-01'
  AND o.OrderDate < '2025-05-01';

-- Independent count of completed April orders
SELECT COUNT(*) AS CompletedOrders
FROM Orders
WHERE Status = 'Completed'
  AND OrderDate >= '2025-04-01'
  AND OrderDate < '2025-05-01';

-- The six qualifying order lines
SELECT o.OrderID, ol.BookID, ol.Quantity, ol.UnitPrice
FROM Orders AS o
JOIN OrderLines AS ol ON ol.OrderID = o.OrderID
WHERE o.Status = 'Completed'
  AND o.OrderDate >= '2025-04-01'
  AND o.OrderDate < '2025-05-01'
ORDER BY o.OrderID, ol.BookID;

-- Reconcile to order subtotals
SELECT o.OrderID,
       ROUND(SUM(ol.Quantity * ol.UnitPrice), 2) AS OrderValue
FROM Orders AS o
JOIN OrderLines AS ol ON ol.OrderID = o.OrderID
WHERE o.Status = 'Completed'
  AND o.OrderDate >= '2025-04-01'
  AND o.OrderDate < '2025-05-01'
GROUP BY o.OrderID
ORDER BY o.OrderID;

-- Trace the price on order 502
SELECT ol.BookID, b.Title, ol.Quantity,
       ol.UnitPrice, b.ListPrice,
       ROUND(ol.Quantity * ol.UnitPrice, 2) AS LineValue
FROM OrderLines AS ol
JOIN Books AS b ON b.BookID = ol.BookID
WHERE ol.OrderID = 502
ORDER BY ol.BookID;

-- Final answer: count completed orders
SELECT COUNT(*) AS CompletedOrders
FROM Orders
WHERE Status = 'Completed'
  AND OrderDate >= '2025-04-01'
  AND OrderDate < '2025-05-01';

-- Final answer: total their merchandise value
SELECT ROUND(SUM(ol.Quantity * ol.UnitPrice), 2) AS OrderValue
FROM Orders AS o
JOIN OrderLines AS ol ON ol.OrderID = o.OrderID
WHERE o.Status = 'Completed'
  AND o.OrderDate >= '2025-04-01'
  AND o.OrderDate < '2025-05-01';

