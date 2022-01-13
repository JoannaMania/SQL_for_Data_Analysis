-- What columns does the table have?
SELECT *
FROM survey
LIMIT 10;

-- What is the number of responses for each question?
SELECT question, COUNT(DISTINCT user_id) AS no_of_anwsers 
FROM survey
GROUP BY question;

-- Which question(s) of the quiz have a lower completion rates?

\* 
100% - What are you looking for? 
95% - What's your fit? 
80% - Which shapes do you like?
95% - Which colors do you like?
74.8% - What do you think is the reason? */

-- What do you think is the reason?
-- People might not recall very well when was their last check up.
-- Maybe customers might not know what shapes are available


-- A/B testing. Let’s find out whether or not users who get more pairs to try on at home will be more likely to make a purchase.50% of the users will get 3 pairs to try on and 50% of the users will get 5 pairs to try on. 

-- Check the column names

-- quiz
-- user_id, style, fit, shape, color
SELECT *
FROM quiz
LIMIT 5;

-- home_try_on
-- user_id, number_of_pairs, address
SELECT *
FROM home_try_on
LIMIT 5;

-- purchase
-- user_id, product_id, style, model_name, color, price 
SELECT *
FROM purchase
LIMIT 5;

-- join tables 
SELECT DISTINCT q.user_id,
   h.user_id IS NOT NULL AS 'is_home_try_on',
   h.number_of_pairs,
   p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
   ON q.user_id = h.user_id
LEFT JOIN purchase p
   ON p.user_id = q.user_id
LIMIT 10;


-- Creates a temporary table 
WITH funnel AS (
SELECT DISTINCT q.user_id,
   h.user_id IS NOT NULL AS 'is_home_try_on',
   h.number_of_pairs,
   p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
   ON q.user_id = h.user_id
LEFT JOIN purchase p
   ON p.user_id = q.user_id)

 
SELECT COUNT(user_id) AS quiz, -- Aggregates across the rows
  SUM(is_home_try_on) AS 'num_checked_out', 
  SUM(is_purchase) AS 'num_purchased', 
  1.0* SUM(is_home_try_on)/ COUNT(user_id) AS 'quiz_to_check_out', -- Calculates the conversion rates between the steps. 
  1.0* SUM(is_purchase)/ SUM(is_home_try_on) AS 'check_out_to_purchase'
FROM funnel
WHERE number_of_pairs IS NOT NULL -- CalculateS the difference in purchase rates between customers who had 3 number_of_pairs with ones who had 5.
GROUP BY number_of_pairs; 
