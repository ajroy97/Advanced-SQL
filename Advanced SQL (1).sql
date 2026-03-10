CREATE DATABASE physicswallah;
use physicswallah;
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    Quantity INT
);

INSERT INTO Products (ProductID, ProductName, Category, Price, Quantity) VALUES
(1, 'Laptop', 'Electronics', 50000, 2),
(2, 'Mobile', 'Electronics', 20000, 5),
(3, 'Headphones', 'Electronics', 1500, 10),
(4, 'Chair', 'Furniture', 3000, 4),
(5, 'Table', 'Furniture', 7000, 2),
(6, 'Notebook', 'Stationery', 50, 100),
(7, 'Pen', 'Stationery', 20, 200);

## Q1. What is a CTE?
WITH cte_name AS (
    SELECT ProductName, Price 
    FROM Products
)
SELECT * FROM cte_name;

## Q2. Why are some views updatable?
### Updatable View Example:
CREATE VIEW vw_SimpleProducts AS
SELECT ProductID, ProductName, Price
FROM Products;

UPDATE vw_simple
SET Price = 500
WHERE ProductID = 1;

### Read-only View Example:
CREATE VIEW vw_Summary AS
SELECT Category, COUNT(*) 
FROM Products
GROUP BY Category;

## Q3. Advantages of Stored Procedures
DELIMITER //

CREATE PROCEDURE GetAllProducts()
BEGIN
    SELECT * FROM Products;
END //

DELIMITER ;
# Reusable code

# Faster execution (precompiled)

# Better security (restrict direct table access)

# Reduces network traffic

## Q4. Purpose of Triggers
# Triggers automatically execute when an event occurs (INSERT, UPDATE, DELETE).

## Q5. Need for Data Modelling & Normalization
# Avoid data redundancy

# Improve data integrity

# Reduce anomalies (Insert, Update, Delete anomalies)

# Better database structure

## Q6. CTE to Calculate Total Revenue
WITH RevenueCTE AS (
    SELECT 
        ProductID,
        ProductName,
        Price * Quantity AS Revenue
    FROM Products
)
SELECT *
FROM RevenueCTE
WHERE Revenue > 3000;

## Q7. Create View: vw_CategorySummary
CREATE VIEW vw_CategorySummary AS
SELECT 
    Category,
    COUNT(*) AS TotalProducts,
    AVG(Price) AS AveragePrice
FROM Products
GROUP BY Category;

## Q8. Create Updatable View & Update Price
# Step 1: Create View
CREATE VIEW vw_ProductDetails AS
SELECT ProductID, ProductName, Price
FROM Products;

# Step 2: Update Using View
UPDATE vw_ProductDetails
SET Price = 5000
WHERE ProductID = 1;

## Q9. Stored Procedure for Category
DELIMITER //

CREATE PROCEDURE GetProductsByCategory(IN cat_name VARCHAR(100))
BEGIN
    SELECT *
    FROM Products
    WHERE Category = cat_name;
END //

DELIMITER ;

# Call Procedure:
CALL GetProductsByCategory('Electronics');

## Q10. AFTER DELETE Trigger
# Step 1: Create Archive Table
CREATE TABLE ProductArchive (
    ProductID INT,
    ProductName VARCHAR(100),
    Category VARCHAR(100),
    Price DECIMAL(10,2),
    DeletedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

# Step 2: Create Trigger
DELIMITER //

CREATE TRIGGER after_product_delete
AFTER DELETE ON Products
FOR EACH ROW
BEGIN
    INSERT INTO ProductArchive(ProductID, ProductName, Category, Price, DeletedAt)
    VALUES(OLD.ProductID, OLD.ProductName, OLD.Category, OLD.Price, NOW());
END //

DELIMITER ;