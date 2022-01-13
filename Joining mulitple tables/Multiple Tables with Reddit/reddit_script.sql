
-- Let’s start by examining the three tables. What are the column names of each table?

SELECT * 
FROM users
LIMIT 10;
 
SELECT * 
FROM posts
LIMIT 10;
 
SELECT * 
FROM subreddits
LIMIT 10;

-- What is the primary key for each table? Can you identify any foreign keys?

/* The primary key of users table is id.
The primary key of posts table is id.
The primary key of subreddits table is id.
The posts table has foreign keys user_id and subreddit_id.*/

-- What user has the highest score?
SELECT username, MAX(score) AS 'highest_score'
FROM users;

-- What post has the highest score?
SELECT title, MAX(score) AS 'highest_score'
FROM posts;

-- What are the top 5 subreddits with the highest subscriber_count?
 
SELECT name
FROM subreddits
ORDER BY subscriber_count
LIMIT 5;

— how many posts each user has made
SELECT users.username, COUNT(title) AS 'posts_made'
FROM users
LEFT JOIN posts
  ON users.id = posts.user_id
GROUP BY users.id
ORDER BY posts_made DESC;


-- We only want to see existing posts where the users are still active. 

SELECT *
FROM posts
JOIN users
  ON users.id = posts.user_id
WHERE users.score IS NOT NULL;

-- Add new posts have been added to Reddit. 

SELECT *
FROM posts
UNION
SELECT *
FROM posts2;


-- Which subreddits have the most popular posts?

WITH popular_posts AS (
  SELECT *
  FROM posts
  WHERE score >= 5000
)
SELECT subreddits.name, popular_posts.title, popular_posts.score
FROM subreddits 
INNER JOIN popular_posts
  ON subreddits.id = popular_posts.subreddit_id
ORDER BY popular_posts.score DESC;

-- Find out the highest scoring post for each subreddit.

SELECT subreddits.name, posts.title, posts.score
FROM posts 
INNER JOIN subreddits
  ON subreddits.id = posts.subreddit_id
GROUP BY subreddits.name
ORDER BY posts.score DESC;

-- The highest scoring post for each subreddit.

SELECT 
  posts.title, 
  subreddits.name AS 'subreddit_name', 
  MAX(posts.score) AS 'highest_score'
FROM posts
INNER JOIN subreddits
  ON posts.subreddit_id = subreddits.id
GROUP BY subreddits.id;

-- Average score of all the posts for each subreddit. 

SELECT 
  ROUND(AVG(posts.score),2) AS 'average_score', 
  subreddits.name
FROM subreddits
INNER JOIN posts
  ON posts.subreddit_id = subreddits.id
GROUP BY 2 
ORDER BY 1 DESC;
