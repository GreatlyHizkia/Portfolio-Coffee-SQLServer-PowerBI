SELECT * FROM dbo.COFFEE

-- Convert time to seconds
ALTER TABLE dbo.COFFEE ALTER COLUMN transaction_time TIME(0) NOT NULL;

-- Convert price & total to 2 decimals
ALTER TABLE dbo.COFFEE ALTER COLUMN unit_price DECIMAL(6,2)  NOT NULL;
ALTER TABLE dbo.COFFEE ALTER COLUMN Total_Bill DECIMAL(10,2) NOT NULL;

-- (Optional but recommended) rename date columns
EXEC sp_rename 'dbo.COFFEE.transaction_date_format', 'transaction_date', 'COLUMN';

-- OPTIONAL
CREATE INDEX IX_CSS_Date       ON dbo.COFFEE (transaction_date);
CREATE INDEX IX_CSS_StoreDate  ON dbo.COFFEE (store_id, transaction_date);
CREATE INDEX IX_CSS_Product    ON dbo.COFFEE (product_id);

-- Check the difference
SELECT TOP 20 *
FROM dbo.COFFEE
WHERE ABS(Total_Bill - (unit_price * transaction_qty)) > 0.01;

-- To align total_bill from calculations:
UPDATE dbo.COFFEE
SET Total_Bill = unit_price * transaction_qty;

-- Row count, date range
SELECT COUNT(*) AS rows,
       MIN(transaction_date) AS min_date,
       MAX(transaction_date) AS max_date
FROM dbo.COFFEE;

-- Check for NULLs (should be 0 for core columns)
SELECT 
  SUM(CASE WHEN transaction_time  IS NULL THEN 1 ELSE 0 END) AS null_time,
  SUM(CASE WHEN store_id          IS NULL THEN 1 ELSE 0 END) AS null_store_id,
  SUM(CASE WHEN product_id        IS NULL THEN 1 ELSE 0 END) AS null_product_id,
  SUM(CASE WHEN transaction_qty   IS NULL THEN 1 ELSE 0 END) AS null_qty,
  SUM(CASE WHEN unit_price        IS NULL THEN 1 ELSE 0 END) AS null_price,
  SUM(CASE WHEN Total_Bill        IS NULL THEN 1 ELSE 0 END) AS null_total
FROM dbo.COFFEE;


-- Check range for hour/month/day
SELECT 
  MIN([Hour])  AS min_hour,  MAX([Hour])  AS max_hour,
  MIN([Month]) AS min_month, MAX([Month]) AS max_month,
  MIN(Day_Of_Week) AS min_dow, MAX(Day_Of_Week) AS max_dow
FROM dbo.COFFEE;

-- Duplicate transaction_id (should be 0)
SELECT transaction_id, COUNT(*) AS cnt
FROM dbo.COFFEE
GROUP BY transaction_id
HAVING COUNT(*) > 1;

-- Make columns computed (automatically calculated & stored)
ALTER TABLE dbo.COFFEE
DROP COLUMN [Hour], [Month], Day_Of_Week;

ALTER TABLE dbo.COFFEE
ADD [Hour] AS DATEPART(HOUR, transaction_time) PERSISTED,
    [Month] AS DATEPART(MONTH, transaction_date) PERSISTED,
    Day_Of_Week AS DATEPART(WEEKDAY, transaction_date) PERSISTED;


BEGIN TRAN;
-- 1) Hour & Month: PERSISTED
ALTER TABLE dbo.COFFEE
ADD [Hour]  AS DATEPART(HOUR,  transaction_time) PERSISTED,
    [Month] AS DATEPART(MONTH, transaction_date) PERSISTED;

-- day_of_week

ALTER TABLE dbo.COFFEE
ADD Day_Of_Week AS ((DATEDIFF(day, 0, transaction_date) % 7) + 1) PERSISTED;
COMMIT TRAN;

SELECT * FROM dbo.COFFEE


-- Check row count & date range
SELECT COUNT(*) AS total_rows,
       MIN(transaction_date) AS start_date,
       MAX(transaction_date) AS end_date
FROM dbo.COFFEE;

-- Check NULLs in important columns
SELECT 
  SUM(CASE WHEN transaction_id IS NULL THEN 1 ELSE 0 END) AS null_trx_id,
  SUM(CASE WHEN transaction_date IS NULL THEN 1 ELSE 0 END) AS null_date,
  SUM(CASE WHEN store_id IS NULL THEN 1 ELSE 0 END) AS null_store,
  SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS null_product,
  SUM(CASE WHEN unit_price IS NULL THEN 1 ELSE 0 END) AS null_price,
  SUM(CASE WHEN transaction_qty IS NULL THEN 1 ELSE 0 END) AS null_qty
FROM dbo.COFFEE;


-- Sales per hour (all stores)
SELECT [Hour],
       SUM(transaction_qty) AS total_qty,
       SUM(Total_Bill) AS Revenue
FROM dbo.COFFEE
GROUP BY [Hour]
ORDER BY [Hour];

-- Sales per month
SELECT [Month],
       DATENAME(MONTH, DATEFROMPARTS(2023, [Month], 1)) AS month_name,
       SUM(transaction_qty) AS total_qty,
       SUM(Total_Bill) AS total_sales
FROM dbo. COFFEE
GROUP BY [Month]
ORDER BY [Month];

-- Contribution per store location
SELECT store_location,
       SUM(transaction_qty) AS total_qty,
       SUM(Total_Bill) AS Revenue,
       ROUND(100.0 * SUM(Total_Bill) / SUM(SUM(Total_Bill)) OVER (), 2) AS revenue_share_percent
FROM dbo.COFFEE
GROUP BY store_location
ORDER BY Revenue DESC;

-- Analyze product category
SELECT product_category,
       SUM(transaction_qty) AS total_qty,
       SUM(Total_Bill) AS total_sales,
       ROUND(100.0 * SUM(Total_Bill) / SUM(SUM(Total_Bill)) OVER (), 2) AS revenue_share_percent
FROM dbo.COFFEE
GROUP BY product_category
ORDER BY total_sales DESC;

-- Peak hours per location
SELECT store_location,
       [Hour],
       SUM(transaction_qty) AS total_qty,
       SUM(Total_Bill) AS total_sales
FROM dbo.COFFEE
GROUP BY store_location, [Hour]
ORDER BY store_location, total_sales DESC;

-- Busiest day of the week
SELECT DATEPART(WEEKDAY, transaction_date) AS day_number,
       DATENAME(WEEKDAY, transaction_date) AS day_name,
       SUM(transaction_qty) AS total_qty,
       SUM(Total_Bill) AS total_sales
FROM dbo.COFFEE
GROUP BY DATEPART(WEEKDAY, transaction_date), DATENAME(WEEKDAY, transaction_date)
ORDER BY total_sales DESC;

-- Heatmap hour X day
SELECT 
    Day_Of_Week,
    DATENAME(WEEKDAY, transaction_date) AS day_name,
    [Hour],
    SUM(transaction_qty) AS total_qty,
    SUM(Total_Bill) AS Revenue
FROM dbo.COFFEE
GROUP BY Day_Of_Week, DATENAME(WEEKDAY, transaction_date), [Hour]
ORDER BY Day_Of_Week, [Hour];

-- AOV per location 
WITH trx AS (
  SELECT transaction_id, store_location, SUM(Total_Bill) AS trx_value
  FROM dbo.COFFEE
  GROUP BY transaction_id, store_location
)
SELECT store_location,
       AVG(trx_value) AS avg_order_value
FROM trx
GROUP BY store_location
ORDER BY avg_order_value DESC;


-- ADD NEW COLUMN "Spender segment"
ALTER TABLE dbo.COFFEE
ADD spender_segment AS 
    CASE 
        WHEN Total_Bill < 5 THEN 'Low Spender'
        WHEN Total_Bill >= 5 AND Total_Bill < 15 THEN 'Medium Spender'
        WHEN Total_Bill >= 15 THEN 'High Spender'
        ELSE 'Other'
    END;

-- Analyze spender segment
SELECT
    spender_segment,
    SUM(Total_Bill) AS total_sales,
    (CAST(SUM(Total_Bill) AS FLOAT) * 100) / (SELECT SUM(Total_Bill) FROM coffee) AS percentage_of_total_sales
FROM
    coffee
GROUP BY
    spender_segment
ORDER BY
    percentage_of_total_sales DESC;

