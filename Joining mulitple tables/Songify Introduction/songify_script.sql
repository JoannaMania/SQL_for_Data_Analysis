-- Let’s see which plans are used by which premium members. 

SELECT premium_users.user_id, plans.description
FROM plans
JOIN premium_users 
  ON plans.id = premium_users.membership_plan_id;

-- Let’s see the titles of songs that were played by each user. 

SELECT plays.user_id, plays.play_date, songs.title
FROM songs 
JOIN plays
  ON songs.id = plays.song_id;

-- Which users aren’t premium users?

 SELECT users.id
 FROM users
 LEFT JOIN premium_users 
  ON users.id = premium_users.user_id
WHERE 
premium_users.user_id IS NULL;


-- Which users played songs in January?

WITH january AS (
  SELECT *
  FROM plays
  WHERE strftime("%m", play_date) = '01'
),
february AS (
  SELECT *
  FROM plays
  WHERE strftime("%m", play_date) = '02'

)
SELECT january.user_id
FROM january
LEFT JOIN february
  ON january.user_id = february.user_id
WHERE february.user_id IS NULL;

-- For each month in months, we want to know if each user in premium_users was active or canceled.

 SELECT premium_users.user_id, premium_users.purchase_date, premium_users.cancel_date, months
 FROM months
 CROSS JOIN premium_users;


 SELECT premium_users.user_id,
  months.months,
  CASE
    WHEN (
      premium_users.purchase_date <= months.months
      )
      AND
      (
        premium_users.cancel_date >= months.months
        OR
        premium_users.cancel_date IS NULL
      )
    THEN 'active'
    ELSE 'not_active'
  END AS 'status'
FROM premium_users
CROSS JOIN months;

-- Songify has added some new songs to their catalog.

SELECT *
FROM songs
UNION 
SELECT *
FROM bonus_songs
LIMIT 10;


WITH play_count AS (
  SELECT song_id,
    COUNT(*) AS times_played
  FROM plays
  GROUP BY song_id)
SELECT songs.title, songs.artist, play_count.times_played
FROM play_count
JOIN songs 
  ON play_count.song_id = songs.id;
