/* Get familiar with the data. 
Take a look at the first 100 rows.
How many different segments are there?
Answer: 2
*/


SELECT *
FROM subscriptions
LIMIT 100;

/* Determine the range of months of data provided. Which months will you be able to calculate churn for? 
Answer: From 01.12.2016 until 31.03.2017
*/

SELECT 
MIN(subscription_start), 
MAX(subscription_end)
FROM subscriptions
LIMIT 100; 

/* Calculate churn rate for each segment.
Three months are taken into consideration: January - March
December is excluded because cancellation is possible after first month 
*/

WITH months AS ( -- Temporary table for months 
  SELECT 
  '2017-01-01' AS first_day,
  '2017-01-31' AS last_day
UNION 
SELECT 
  '2017-02-01' AS first_day,
  '2017-02-28' AS last_day
UNION
SELECT
  '2017-03-01' AS first_day,
  '2017-03-31' AS last_day
), 

cross_join AS ( -- Temporary table to join months and subscriptions
  SELECT *
  FROM subscriptions
  CROSS JOIN months
  ), 
  
status AS ( -- Temporary table with grouped segments, active and canceled subscriptions
  SELECT id, 
  first_day AS month, 
  CASE
    WHEN (subscription_start < first_day) AND ((subscription_end IS NULL) or (subscription_end > first_day)) AND (segment = 87) THEN 1
    ELSE 0
  END AS is_active_87, 
  CASE
    WHEN (subscription_start < first_day) AND ((subscription_end IS NULL) or (subscription_end > first_day)) AND (segment = 30) THEN 1
    ELSE 0
  END AS is_active_30, 
  CASE 
    WHEN (subscription_end BETWEEN first_day AND last_day) AND (segment = 87) THEN 1
    ELSE 0
  END AS is_canceled_87, 
  CASE 
    WHEN (subscription_end BETWEEN first_day AND last_day) AND (segment = 30) THEN 1
    ELSE 0
  END AS is_canceled_30
FROM cross_join 
), 

/*
Create a temporary table that is a SUM of the active and canceled subscriptions for each segment, for each month.*/

status_aggregate AS (
  SELECT 
    SUM(is_active_87) AS sum_active_87, 
    SUM(is_active_30) AS sum_active_30,
    SUM(is_canceled_87) AS sum_canceled_87,
    SUM(is_canceled_30) AS sum_canceled_30
  FROM status
  ), 

/* Calculate the churn rates for the two segments over the three month period. Which segment has a lower churn rate?*/

churn AS (
  SELECT 
  ROUND(1.0*sum_canceled_87/sum_active_87, 2) AS churn_87, 
  ROUND(1.0*sum_canceled_30/sum_active_30, 2) AS churn_30
  FROM status_aggregate
)

SELECT *
FROM churn;

/* The churn rate is higher in the segment 87 (37%), than in the segment 30 (9%)