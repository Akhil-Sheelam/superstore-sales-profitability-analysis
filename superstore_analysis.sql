-- ============================================================
-- SUPERSTORE SALES & PROFITABILITY ANALYSIS
-- Database: superstore_analysis
-- Table: superstore_raw2
-- ============================================================

-- Select the project database
USE superstore_analysis;


-- ============================================================
-- 1. VERIFY DATA
-- ============================================================

-- Check total number of imported records
SELECT COUNT(*) AS total_rows
FROM superstore_raw2;


-- ============================================================
-- 2. DATA QUALITY CHECK
-- ============================================================

-- Check for invalid date conversions
SELECT
    SUM(order_date_clean IS NULL) AS invalid_order_dates,
    SUM(ship_date_clean IS NULL) AS invalid_ship_dates
FROM superstore_raw2;


-- ============================================================
-- 3. OVERALL BUSINESS PERFORMANCE
-- ============================================================

SELECT
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Profit`), 2) AS total_profit,
    COUNT(DISTINCT `Order ID`) AS total_orders,
    SUM(`Quantity`) AS total_quantity,
    ROUND(
        SUM(`Profit`) / SUM(`Sales`) * 100,
        2
    ) AS profit_margin_percent
FROM superstore_raw2;


-- ============================================================
-- 4. SALES & PROFIT BY CATEGORY
-- ============================================================

SELECT
    `Category`,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Profit`), 2) AS total_profit,
    ROUND(
        SUM(`Profit`) / SUM(`Sales`) * 100,
        2
    ) AS profit_margin_percent
FROM superstore_raw2
GROUP BY `Category`
ORDER BY total_profit DESC;


-- ============================================================
-- 5. SUB-CATEGORY PROFITABILITY
-- ============================================================

SELECT
    `Sub-Category`,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Profit`), 2) AS total_profit,
    ROUND(
        SUM(`Profit`) / SUM(`Sales`) * 100,
        2
    ) AS profit_margin_percent
FROM superstore_raw2
GROUP BY `Sub-Category`
ORDER BY total_profit DESC;


-- ============================================================
-- 6. LOSS-MAKING SUB-CATEGORIES
-- ============================================================

SELECT
    `Sub-Category`,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Profit`), 2) AS total_profit,
    ROUND(
        SUM(`Profit`) / SUM(`Sales`) * 100,
        2
    ) AS profit_margin_percent
FROM superstore_raw2
GROUP BY `Sub-Category`
HAVING SUM(`Profit`) < 0
ORDER BY total_profit ASC;


-- ============================================================
-- 7. DISCOUNT VS PROFIT
-- ============================================================

SELECT
    `Discount`,
    COUNT(*) AS records,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Profit`), 2) AS total_profit,
    ROUND(AVG(`Profit`), 2) AS average_profit
FROM superstore_raw2
GROUP BY `Discount`
ORDER BY `Discount`;


-- ============================================================
-- 8. SALES & PROFIT BY REGION
-- ============================================================

SELECT
    `Region`,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Profit`), 2) AS total_profit,
    ROUND(
        SUM(`Profit`) / SUM(`Sales`) * 100,
        2
    ) AS profit_margin_percent
FROM superstore_raw2
GROUP BY `Region`
ORDER BY total_profit DESC;


-- ============================================================
-- 9. TOP 10 CUSTOMERS BY SALES
-- ============================================================

SELECT
    `Customer ID`,
    `Customer Name`,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Profit`), 2) AS total_profit
FROM superstore_raw2
GROUP BY
    `Customer ID`,
    `Customer Name`
ORDER BY total_sales DESC
LIMIT 10;


-- ============================================================
-- 10. TOP 10 CUSTOMERS BY PROFIT
-- ============================================================

SELECT
    `Customer ID`,
    `Customer Name`,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Profit`), 2) AS total_profit
FROM superstore_raw2
GROUP BY
    `Customer ID`,
    `Customer Name`
ORDER BY total_profit DESC
LIMIT 10;


-- ============================================================
-- 11. TOP 10 LOSS-MAKING PRODUCTS
-- ============================================================

SELECT
    `Product ID`,
    `Product Name`,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Profit`), 2) AS total_profit,
    ROUND(AVG(`Discount`) * 100, 2) AS average_discount_percent
FROM superstore_raw2
GROUP BY
    `Product ID`,
    `Product Name`
HAVING SUM(`Profit`) < 0
ORDER BY total_profit ASC
LIMIT 10;


-- ============================================================
-- 12. REGIONAL + CATEGORY ANALYSIS
-- ============================================================

SELECT
    `Region`,
    `Category`,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Profit`), 2) AS total_profit,
    ROUND(
        SUM(`Profit`) / SUM(`Sales`) * 100,
        2
    ) AS profit_margin_percent
FROM superstore_raw2
GROUP BY
    `Region`,
    `Category`
ORDER BY
    `Region`,
    total_profit DESC;


-- ============================================================
-- 13. DISCOUNT BAND ANALYSIS
-- ============================================================

SELECT
    CASE
        WHEN `Discount` = 0 THEN '0%'
        WHEN `Discount` <= 0.20 THEN '1-20%'
        WHEN `Discount` <= 0.40 THEN '21-40%'
        ELSE '40%+'
    END AS discount_band,

    COUNT(*) AS records,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Profit`), 2) AS total_profit,
    ROUND(AVG(`Profit`), 2) AS average_profit

FROM superstore_raw2

GROUP BY discount_band

ORDER BY
    CASE discount_band
        WHEN '0%' THEN 1
        WHEN '1-20%' THEN 2
        WHEN '21-40%' THEN 3
        WHEN '40%+' THEN 4
    END;


-- ============================================================
-- 14. YEARLY PERFORMANCE
-- ============================================================

SELECT
    YEAR(order_date_clean) AS order_year,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Profit`), 2) AS total_profit,
    ROUND(
        SUM(`Profit`) / SUM(`Sales`) * 100,
        2
    ) AS profit_margin_percent
FROM superstore_raw2
GROUP BY YEAR(order_date_clean)
ORDER BY order_year;


-- ============================================================
-- 15. MONTHLY SALES & PROFIT TREND
-- ============================================================

SELECT
    DATE_FORMAT(order_date_clean, '%Y-%m') AS month_year,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Profit`), 2) AS total_profit
FROM superstore_raw2
GROUP BY DATE_FORMAT(order_date_clean, '%Y-%m')
ORDER BY month_year;


-- ============================================================
-- 16. SHIPPING PERFORMANCE
-- ============================================================

SELECT
    `Ship Mode`,
    COUNT(DISTINCT `Order ID`) AS total_orders,
    ROUND(AVG(delivery_days), 2) AS avg_delivery_days,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Profit`), 2) AS total_profit
FROM superstore_raw2
GROUP BY `Ship Mode`
ORDER BY avg_delivery_days;
