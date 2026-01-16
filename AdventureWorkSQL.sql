
SHOW DATABASES;
-- 1
SELECT COUNT(*) 
FROM project.sql_data;
SELECT *
FROM  project.sql_data
LIMIT 10;
-- 1
SELECT COUNT(*) AS total_records
FROM project.sql_data;

-- 2
SELECT COUNT(*) AS total_rows
FROM project.sql_data;

-- 3
SELECT SUM(SalesAmount) AS total_sales
FROM project.sql_data;

-- 4
SELECT SUM(PROFIT) AS total_profit
FROM project.sql_data;

-- 5
SELECT AVG(UnitPrice) AS avg_unit_price
FROM project.sql_data;

-- 6
SELECT ProductKey, SUM(SalesAmount) AS total_sales
FROM project.sql_data
GROUP BY ProductKey
ORDER BY total_sales DESC;

-- 7
SELECT ProductKey, SUM(PROFIT) AS total_profit
FROM project.sql_data
GROUP BY ProductKey
ORDER BY total_profit DESC;

-- 8
SELECT CustomerKey, COUNT(*) AS total_orders
FROM project.sql_data
GROUP BY CustomerKey
ORDER BY total_orders DESC;

-- 9
SELECT SalesTerritoryKey, SUM(SalesAmount) AS total_sales
FROM project.sql_data
GROUP BY SalesTerritoryKey
ORDER BY total_sales DESC;

-- 10
SELECT SalesOrderNumber, SalesAmount
FROM project.sql_data
ORDER BY SalesAmount DESC
LIMIT 10;

-- 11
SELECT *
FROM project.sql_data
WHERE PROFIT > 100
ORDER BY PROFIT DESC;

-- 12
SELECT SUM(Freight) AS total_freight
FROM project.sql_data;

-- 13
SELECT 
    DATE_FORMAT(STR_TO_DATE(OrderDateKey, '%Y%m%d'), '%Y-%m') AS month,
    SUM(SalesAmount) AS total_sales
FROM project.sql_data
GROUP BY month
ORDER BY month;

-- 14
SELECT
    CONCAT(YEAR(order_date), '-Q', QUARTER(order_date)) AS quarter,
    SUM(SalesAmount) AS total_sales,
    SUM(PROFIT) AS total_profit
FROM (
    SELECT 
        STR_TO_DATE(OrderDateKey, '%Y%m%d') AS order_date,
        SalesAmount,
        PROFIT
    FROM project.sql_data
) t
GROUP BY quarter
ORDER BY quarter;

-- 15
SELECT
    year,
    total_sales,
    LAG(total_sales) OVER (ORDER BY year) AS prev_year_sales,
    ROUND(
        (total_sales - LAG(total_sales) OVER (ORDER BY year)) /
        LAG(total_sales) OVER (ORDER BY year) * 100, 2
    ) AS growth_percentage
FROM (
    SELECT
        YEAR(STR_TO_DATE(OrderDateKey, '%Y%m%d')) AS year,
        SUM(SalesAmount) AS total_sales
    FROM project.sql_data
    GROUP BY year
) y;

-- 16
SELECT *
FROM (
    SELECT
        YEAR(STR_TO_DATE(OrderDateKey, '%Y%m%d')) AS year,
        ProductKey,
        SUM(PROFIT) AS total_profit,
        RANK() OVER (
            PARTITION BY YEAR(STR_TO_DATE(OrderDateKey, '%Y%m%d'))
            ORDER BY SUM(PROFIT) DESC
        ) AS rnk
    FROM project.sql_data
    GROUP BY year, ProductKey
) ranked
WHERE rnk <= 5;

-- 17
SELECT
    CustomerKey,
    SUM(SalesAmount) AS lifetime_sales,
    SUM(PROFIT) AS lifetime_profit,
    COUNT(DISTINCT SalesOrderNumber) AS total_orders
FROM project.sql_data
GROUP BY CustomerKey
ORDER BY lifetime_sales DESC;

-- 18
SELECT
    SalesTerritoryKey,
    SUM(SalesAmount) AS total_sales,
    SUM(PROFIT) AS total_profit,
    ROUND(SUM(PROFIT) / SUM(SalesAmount) * 100, 2) AS profit_margin_pct
FROM project.sql_data
GROUP BY SalesTerritoryKey
ORDER BY profit_margin_pct DESC;
