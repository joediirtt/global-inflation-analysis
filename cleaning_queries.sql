-- Ensuring Data Consistency in global_inflation_countries.
SELECT country_name, COUNT(*)
FROM `inflation-project-000.global_inflation.global_inflation_countries`
GROUP BY country_name
ORDER BY COUNT(*) DESC;

SELECT country_code, COUNT(*)
FROM `inflation-project-000.global_inflation.global_inflation_countries`
GROUP BY country_code
ORDER BY COUNT(*) DESC;

SELECT region, COUNT(*)
FROM `inflation-project-000.global_inflation.global_inflation_countries`
GROUP BY region
ORDER BY COUNT(*) DESC;

SELECT sub_region, COUNT(*)
FROM `inflation-project-000.global_inflation.global_inflation_countries`
GROUP BY sub_region
ORDER BY COUNT(*) DESC;

SELECT intermediate_region, COUNT(*)
FROM `inflation-project-000.global_inflation.global_inflation_countries`
GROUP BY intermediate_region
ORDER BY COUNT(*) DESC;

-- Checking for Outliers
SELECT
    AVG(inflation_rate) AS avg_inflation,
    APPROX_QUANTILES(inflation_rate, 100)[OFFSET(50)] AS median_inflation,
    STDDEV(inflation_rate) AS stddev_inflation,
    APPROX_QUANTILES(inflation_rate, 100)[OFFSET(25)] AS percentile_25,
    APPROX_QUANTILES(inflation_rate, 100)[OFFSET(75)] AS percentile_75
FROM `inflation-project-000.global_inflation.global_inflation_countries`;


SELECT country_name, year, inflation_rate
FROM `inflation-project-000.global_inflation.global_inflation_countries`
WHERE inflation_rate < -10.035 OR inflation_rate > 16.725 
ORDER BY inflation_rate DESC;  

-- Checking for Duplicates
SELECT country_code, year, COUNT(*)  -- Check for duplicates based on country and year
FROM `inflation-project-000.global_inflation.global_inflation_countries`
GROUP BY country_code, year
HAVING COUNT(*) > 1;
-- No duplicates :)

-- Combining Cleaning steps (temporary Table)
CREATE OR REPLACE TEMP TABLE cleaned_inflation_data AS
SELECT
    country_code,
    country_name,
    region,
    sub_region,
    intermediate_region,
    indicator_code,
    indicator_name,
    year,
    inflation_rate
FROM `inflation-project-000.global_inflation.global_inflation_countries`;
