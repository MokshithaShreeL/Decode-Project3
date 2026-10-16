-- DecodeLabs Data Analytics Project 3: SQL Data Analysis
-- Dataset: Dataset for Data Analytics(2).xlsx
-- SQL dialect: MySQL 8+
-- Import the Excel data as a table named ecommerce_orders.
-- Expected columns: OrderID, Date, CustomerID, Product, Quantity, UnitPrice,
-- ShippingAddress, PaymentMethod, OrderStatus, TrackingNumber, ItemsInCart,
-- CouponCode, ReferralSource, TotalPrice.

CREATE DATABASE IF NOT EXISTS data_analytics_project3;
USE data_analytics_project3;

-- If importing via MySQL Workbench Table Data Import Wizard, import the
-- spreadsheet as ecommerce_orders first, then run the analysis queries below.

-- 1. Display all records
SELECT * FROM ecommerce_orders;

-- 2. Select useful order details
SELECT OrderID, Date, CustomerID, Product, Quantity, UnitPrice, TotalPrice
FROM ecommerce_orders;

-- 3. Filter orders above 1000
SELECT OrderID, Date, Product, TotalPrice, OrderStatus
FROM ecommerce_orders
WHERE TotalPrice > 1000
ORDER BY TotalPrice DESC;

-- 4. Orders within a date range
SELECT OrderID, Date, Product, TotalPrice
FROM ecommerce_orders
WHERE Date BETWEEN '2024-01-01' AND '2024-12-31'
ORDER BY Date;

-- 5. Sort orders from highest to lowest value
SELECT OrderID, Product, TotalPrice
FROM ecommerce_orders
ORDER BY TotalPrice DESC;

-- 6. Count total orders
SELECT COUNT(*) AS total_orders
FROM ecommerce_orders;

-- 7. Total units and total sales
SELECT SUM(Quantity) AS total_units,
       ROUND(SUM(TotalPrice), 2) AS total_sales
FROM ecommerce_orders;

-- 8. Average, minimum and maximum order value
SELECT ROUND(AVG(TotalPrice), 2) AS average_order_value,
       ROUND(MIN(TotalPrice), 2) AS minimum_order_value,
       ROUND(MAX(TotalPrice), 2) AS maximum_order_value
FROM ecommerce_orders;

-- 9. Product-wise sales (GROUP BY + SUM + COUNT + AVG)
SELECT Product,
       COUNT(*) AS number_of_orders,
       SUM(Quantity) AS units_sold,
       ROUND(SUM(TotalPrice), 2) AS total_sales,
       ROUND(AVG(TotalPrice), 2) AS average_order_value
FROM ecommerce_orders
GROUP BY Product
ORDER BY total_sales DESC;

-- 10. Order status summary
SELECT OrderStatus,
       COUNT(*) AS order_count,
       ROUND(SUM(TotalPrice), 2) AS total_sales,
       ROUND(AVG(TotalPrice), 2) AS average_order_value
FROM ecommerce_orders
GROUP BY OrderStatus
ORDER BY order_count DESC;

-- 11. Payment method analysis
SELECT PaymentMethod,
       COUNT(*) AS order_count,
       ROUND(SUM(TotalPrice), 2) AS total_sales
FROM ecommerce_orders
GROUP BY PaymentMethod
ORDER BY total_sales DESC;

-- 12. Referral source analysis
SELECT ReferralSource,
       COUNT(*) AS order_count,
       ROUND(SUM(TotalPrice), 2) AS total_sales,
       ROUND(AVG(TotalPrice), 2) AS average_order_value
FROM ecommerce_orders
GROUP BY ReferralSource
ORDER BY total_sales DESC;

-- 13. Monthly sales trend
SELECT DATE_FORMAT(Date, '%Y-%m') AS sales_month,
       COUNT(*) AS order_count,
       ROUND(SUM(TotalPrice), 2) AS monthly_sales
FROM ecommerce_orders
GROUP BY DATE_FORMAT(Date, '%Y-%m')
ORDER BY sales_month;

-- 14. Coupon usage, including orders without a coupon
SELECT COALESCE(CouponCode, 'No coupon') AS coupon,
       COUNT(*) AS order_count,
       ROUND(SUM(TotalPrice), 2) AS total_sales
FROM ecommerce_orders
GROUP BY COALESCE(CouponCode, 'No coupon')
ORDER BY order_count DESC;

-- 15. Categories with at least 100 orders (HAVING)
SELECT Product, COUNT(*) AS order_count,
       ROUND(SUM(TotalPrice), 2) AS total_sales
FROM ecommerce_orders
GROUP BY Product
HAVING COUNT(*) >= 100
ORDER BY order_count DESC;

-- 16. Find customers with more than one order
SELECT CustomerID, COUNT(*) AS order_count,
       ROUND(SUM(TotalPrice), 2) AS customer_spend
FROM ecommerce_orders
GROUP BY CustomerID
HAVING COUNT(*) > 1
ORDER BY customer_spend DESC;

-- 17. Check duplicate order IDs
SELECT OrderID, COUNT(*) AS occurrences
FROM ecommerce_orders
GROUP BY OrderID
HAVING COUNT(*) > 1;

-- 18. Check missing coupon values
SELECT COUNT(*) AS missing_coupon_count
FROM ecommerce_orders
WHERE CouponCode IS NULL OR TRIM(CouponCode) = '';

-- 19. Revenue by year
SELECT YEAR(Date) AS sales_year,
       COUNT(*) AS order_count,
       ROUND(SUM(TotalPrice), 2) AS yearly_sales
FROM ecommerce_orders
GROUP BY YEAR(Date)
ORDER BY sales_year;

-- 20. Important note: WHERE filters rows before grouping; HAVING filters groups.
-- Do not use SELECT aliases in WHERE when the alias is created in SELECT.
