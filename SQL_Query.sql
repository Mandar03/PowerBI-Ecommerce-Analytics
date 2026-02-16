CREATE DATABASE EcommerceAnalytics;

USE EcommerceAnalytics;

CREATE TABLE olist_customers_raw (
    customer_id VARCHAR(50),
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(100),
    customer_state CHAR(2)
);

CREATE TABLE olist_orders_raw (
    order_id VARCHAR(50),
    customer_id VARCHAR(50),
    order_status VARCHAR(50),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME
);

CREATE TABLE olist_order_items_raw (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date DATETIME,
    price FLOAT,
    freight_value FLOAT
);

CREATE TABLE olist_products_raw (
    product_id VARCHAR(50),
    product_category_name VARCHAR(100),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g FLOAT,
    product_length_cm FLOAT,
    product_height_cm FLOAT,
    product_width_cm FLOAT
);

CREATE TABLE olist_order_payments_raw (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(50),
    payment_installments INT,
    payment_value FLOAT
);


SELECT COUNT(*) AS total_customers
FROM olist_customers_raw;

SELECT COUNT(*) AS total_orders
FROM olist_orders_raw;


SELECT TOP 10 *
FROM olist_customers_raw;

SELECT TOP 10 *
FROM olist_orders_raw;

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME LIKE '%olist%';

SELECT
    t.NAME AS table_name,
    p.rows
FROM sys.tables t
JOIN sys.partitions p
    ON t.object_id = p.object_id
WHERE p.index_id IN (0,1)
ORDER BY p.rows DESC;

INSERT INTO olist_customers_raw (
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
)
SELECT
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
FROM olist_customers_dataset;

SELECT COUNT(*) FROM olist_customers_raw;
SELECT TOP 10 * FROM olist_customers_raw;

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME LIKE 'olist%';

DROP TABLE IF EXISTS olist_order_payments_raw;
DROP TABLE IF EXISTS olist_order_items_raw;
DROP TABLE IF EXISTS olist_orders_raw;
DROP TABLE IF EXISTS olist_products_raw;
DROP TABLE IF EXISTS olist_customers_raw;

CREATE TABLE olist_customers_raw (
    customer_id VARCHAR(50),
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(100),
    customer_state CHAR(2)
);

CREATE TABLE olist_orders_raw (
    order_id VARCHAR(50),
    customer_id VARCHAR(50),
    order_status VARCHAR(50),
    order_purchase_timestamp DATETIME2,
    order_approved_at DATETIME2,
    order_delivered_carrier_date DATETIME2,
    order_delivered_customer_date DATETIME2,
    order_estimated_delivery_date DATETIME2
);

CREATE TABLE olist_order_items_raw (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date DATETIME2,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2)
);

CREATE TABLE olist_products_raw (
    product_id VARCHAR(50),
    product_category_name VARCHAR(100),
    product_name_length INT,
    product_description_length INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

CREATE TABLE olist_order_payments_raw (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(50),
    payment_installments INT,
    payment_value DECIMAL(10,2)
);


SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME LIKE 'olist%';

SELECT 'customers' AS table_name, COUNT(*) AS total_rows FROM olist_customers_raw
UNION ALL
SELECT 'orders', COUNT(*) FROM olist_orders_raw
UNION ALL
SELECT 'order_items', COUNT(*) FROM olist_order_items_raw
UNION ALL
SELECT 'products', COUNT(*) FROM olist_products_raw
UNION ALL
SELECT 'payments', COUNT(*) FROM olist_order_payments_raw;

SELECT 
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customer_id) AS distinct_customers
FROM olist_customers_raw;

DROP TABLE olist_customers_dataset
DROP TABLE olist_order_items_raw;
DROP TABLE olist_order_payments_raw;
DROP TABLE olist_orders_raw;
DROP TABLE olist_products_raw;
DROP TABLE product_category_name_translation;

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME LIKE 'olist%';


SELECT 'customers' AS table_name, COUNT(*) rows FROM olist_customers_dataset
UNION ALL
SELECT 'sellers', COUNT(*) FROM olist_sellers_dataset
UNION ALL
SELECT 'products', COUNT(*) FROM olist_products_dataset
UNION ALL
SELECT 'orders', COUNT(*) FROM olist_orders_dataset
UNION ALL
SELECT 'order_items', COUNT(*) FROM olist_order_items_dataset
UNION ALL
SELECT 'payments', COUNT(*) FROM olist_order_payments_dataset
UNION ALL
SELECT 'reviews', COUNT(*) FROM olist_order_reviews_dataset
UNION ALL
SELECT 'geolocation', COUNT(*) FROM olist_geolocation_dataset;

-- Orders should be unique
SELECT order_id, COUNT(*) 
FROM olist_orders_dataset
GROUP BY order_id
HAVING COUNT(*) > 1;



----Analysis Part ----------

1. How big is the business?

SELECT 
    (SELECT COUNT(DISTINCT customer_id) FROM olist_customers_dataset) AS total_customers,
    (SELECT COUNT(DISTINCT order_id) FROM olist_orders_dataset) AS total_orders,
    (SELECT COUNT(DISTINCT product_id) FROM olist_products_dataset) AS total_products,
    (SELECT COUNT(DISTINCT seller_id) FROM olist_sellers_dataset) AS total_sellers;

2. Total revenue generated

SELECT * FROM olist_order_payments_dataset;

SELECT
	ROUND(SUM(payment_value),2) AS TotalRevenue
FROM olist_order_payments_dataset;

3. Orders by status (business health)

SELECT * FROM olist_orders_dataset;

SELECT order_status,
	COUNT(*) AS TotalOrderCount
FROM olist_orders_dataset
GROUP BY order_status
ORDER BY TotalOrderCount DESC;

CUSTOMER GEOGRAPHY ANALYSIS
4. Customers by state

SELECT * FROM olist_customers_dataset;

SELECT customer_state,
	COUNT(DISTINCT customer_id) AS total_customers
FROM olist_customers_dataset
GROUP BY customer_state
ORDER BY total_customers DESC;

5. Revenue by state

SELECT * FROM olist_customers_dataset;
SELECT * FROM olist_orders_dataset;
SELECT * FROM olist_order_payments_dataset;

SELECT customer_state,
	ROUND(SUM(payment_value),2) AS TotalRevenue
FROM olist_customers_dataset AS C
JOIN olist_orders_dataset AS O
ON C.customer_id = O.customer_id
JOIN olist_order_payments_dataset AS OP
ON OP.order_id = O.order_id
GROUP BY customer_state
ORDER BY TotalRevenue DESC;



PRODUCT & CATEGORY PERFORMANCE
6. Top product categories by revenue

SELECT * FROM olist_order_items_dataset;
SELECT * FROM olist_products_dataset;

SELECT product_category_name,
	ROUND(SUM(price),2) AS TotalRevenue
FROM olist_order_items_dataset AS OI
JOIN olist_products_dataset AS P
ON OI.product_id = P.product_id
GROUP BY product_category_name
ORDER BY TotalRevenue DESC;


DELIVERY PERFORMANCE
7. Actual delivery time (in days)

SELECT * FROM olist_orders_dataset;

SELECT order_purchase_timestamp, order_delivered_customer_date,
	DATEDIFF(Day, order_purchase_timestamp, order_delivered_customer_date) AS DeliveryDate
FROM olist_orders_dataset
WHERE order_delivered_customer_date IS NOT NULL;


PAYMENT BEHAVIOR ANALYSIS
8. Most used payment methods

SELECT * FROM olist_order_payments_dataset;

SELECT payment_type,
	COUNT(*) AS TotalTransaction
FROM olist_order_payments_dataset
GROUP BY payment_type
ORDER By TotalTransaction DESC;

CUSTOMER SATISFACTION
9. Average review score

SELECT * FROM olist_order_reviews_dataset;

SELECT AVG(review_score) AS AvgReviewScore
FROM olist_order_reviews_dataset;
