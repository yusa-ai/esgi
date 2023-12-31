-- Exercice 1
WITH total_sales AS (
  SELECT name, sum(eu_sales + na_sales + jp_sales + other_sales) AS sales 
  FROM video_game_sales
  GROUP BY name 
)
SELECT name, sales
FROM total_sales
ORDER BY sales DESC
LIMIT 5;

-- Exercice 2
WITH avg_sales_per_genre AS (
  SELECT genre, avg(eu_sales + na_sales + jp_sales + other_sales) AS sales
  FROM video_game_sales
  GROUP BY genre
)
SELECT genre, sales::MONEY
FROM avg_sales_per_genre 
ORDER BY sales DESC;

-- Exercice 3
WITH publisher_nb_games AS (
  SELECT publisher, count(*) AS nb_games
  FROM video_game_sales
  GROUP BY publisher
)
SELECT *
FROM publisher_nb_games
WHERE nb_games >= 100
ORDER BY nb_games DESC;

-- Exercice 4
WITH game_sales AS (
  SELECT name, genre, eu_sales + na_sales + jp_sales + other_sales AS sales
  FROM video_game_sales
  GROUP BY name, genre, sales
)
SELECT *
FROM game_sales
ORDER BY genre, sales DESC;
WITH game_sales AS (
  SELECT name, genre, eu_sales + na_sales + jp_sales + other_sales AS sales
  FROM video_game_sales
  GROUP BY name, genre, sales
)
SELECT *
FROM game_sales
ORDER BY genre, sales DESC;

-- Exercice 5
WITH mario_sales AS (
  SELECT name, platform, year, eu_sales + na_sales + jp_sales + other_sales AS sales
  FROM video_game_sales
  WHERE name ilike 'Mario%'
  GROUP BY name, platform, year, sales
)
SELECT name, platform, year, sales, sum(sales) OVER (PARTITION BY year)
FROM mario_sales
WHERE year IS NOT NULL
ORDER BY year DESC;

-- Exercice 6
WITH ranked_sales AS (
  SELECT 
    name, 
    year, 
    eu_sales + na_sales + jp_sales + other_sales AS sales,
    rank() OVER (PARTITION BY year ORDER BY eu_sales + na_sales + jp_sales + other_sales) AS rank
  FROM video_game_sales
)
SELECT
  name,
  year,
  sales
FROM ranked_sales 
WHERE rank = 1
AND year IS NOT NULL
ORDER BY year DESC;

-- Exercice 7
-- Je crois pas que ce soit ça mais j'y passe trop de temps et je saurai jamais de toute façon (:
WITH cumulative_sales AS (
  SELECT 
  name,
  genre,
  year, 
  eu_sales + na_sales + jp_sales + other_sales AS sales,
  sum(eu_sales + na_sales + jp_sales + other_sales) OVER (ORDER BY year) AS cml_sales 
  FROM video_game_sales
  WHERE genre = 'Strategy'
)
SELECT name, year, sales, cml_sales
FROM cumulative_sales;

-- Exercice 8
WITH top_platforms AS (
  SELECT
    genre,
    platform,
    sum(eu_sales + na_sales + jp_sales + other_sales) AS sales,
    rank() OVER (PARTITION BY genre ORDER BY sum(eu_sales + na_sales + jp_sales + other_sales)) AS rank
  FROM video_game_sales
)
SELECT DISTINCT genre, platform, sales 
FROM top_platforms
WHERE rank = 1;
