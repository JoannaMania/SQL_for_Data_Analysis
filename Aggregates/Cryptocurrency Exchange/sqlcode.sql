-- What is the total money_in in the table?
SELECT SUM(money_in)
FROM transactions;


-- What is the total money_out in the table?
SELECT SUM(money_out)
FROM transactions;


-- It was reported that Bitcoin dominates Fiddy Cent’s exchange. Let’s see if it is true within these dates by answering two questions:
-- How many money_in transactions are in this table? 40

SELECT COUNT(money_in)
FROM transactions;

-- How many money_in transactions are in this table where ‘BIT’ is the currency? Answer: 21
SELECT COUNT(money_in)
FROM transactions
WHERE currency = 'BIT';


-- What was the largest transaction in this whole table? Answer: money in - 6000.0, money out- 15047.0
SELECT MAX(money_in)
FROM transactions;

SELECT MAX(money_out)
FROM transactions;


---What is the average money_in in the table for the currency Ethereum (‘ETH’)? Answer: 131.8888
SELECT AVG(money_in)
FROM transactions
WHERE currency = 'ETH'


---Let’s build a ledger for the different dates.
SELECT date, 
  ROUND(AVG(money_in), 2), 
  ROUND(AVG(money_out), 2)
FROM transactions
GROUP BY date;
