-- We have previously created the required table structure and imported data from csv.

-- Let us now get an overview of the tables
SELECT * FROM app_store
LIMIT 10;

SELECT * FROM app_description
LIMIT 10;

-- Stakeholder is aspiring app developer in need of data driven insights to decide what app to build.
-- What app categories are most popular? What price should I set? and how to maximize user ratings?

-- EDA
-- Let's first check the number of unique apps in both the tables, so that we can verify that we have the same set of apps.
SELECT COUNT(DISTINCT id_) AS unique_apps FROM app_store;
SELECT COUNT(DISTINCT id_) AS unique_app_desc FROM app_description;

-- Now that we have confirmed that there are 7197 unique apps in both the tables, let us check for null values.
SELECT COUNT(*) AS Null_
FROM app_store 
WHERE track_name IS NULL OR user_rating IS NULL OR prime_genre IS NULL;

SELECT COUNT(*) AS Null_desc
FROM app_description
WHERE app_desc IS NULL;

-- We can observe that there are no null values in important columns of the tables. 
-- Now let us find the distribution of app for diferent genre
SELECT prime_genre, COUNT(*) AS Num
FROM app_store
GROUP BY prime_genre
ORDER BY Num DESC;

-- We can observe that Games genre is predominant with over 3800 apps, which is followed by Entertainment with just over 500 apps.
-- Now let's get an overview of the rating of the apps.

SELECT MIN(user_rating) AS MinRating, AVG(user_rating) AS AvgRating, MAX(user_rating) AS MaxRating
FROM app_store;

-- Now let's dive into our analysis.
-- First let us determine whether paid apps have higher rating than the free apps.
SELECT CASE
WHEN price > 0 THEN 'Paid' ELSE 'Free' END
AS App_type, AVG(user_rating) AS Avg_rating
FROM app_store
GROUP BY App_type;

-- We can observe that the paid apps have slightly better rating than the free ones.
-- Now let's check the correlation between number of supported languages and user rating. 
SELECT CASE
	WHEN lang_num < 10 THEN 'Less than 10'
	WHEN lang_num >= 10  AND lang_num < 20 THEN 'Between 10-20'
	WHEN lang_num >= 20  AND lang_num < 30 THEN 'Between 20-30'
	ELSE 'More than 30' 
	END AS Supported_languages, 
AVG(user_rating) AS Avg_rating
FROM app_store
GROUP BY Supported_languages;

-- We can observe that the apps with 10-20 supported languages has the highest average rating.
-- This tells us that it is not feasible to add more than 20 languages in the app.

-- Now let's check the genre which has low user, rating. 
-- This will show us the categories where the users are not satisfied and there is potential of penetration.
SELECT prime_genre, AVG(user_rating) AS Avg_rating
FROM app_store
GROUP BY prime_genre
ORDER BY Avg_rating
LIMIT 10;

-- Let us also check if there is a correlation between app discription lenght and user rating.
SELECT CASE
	WHEN LENGTH(d.app_desc) < 100 THEN 'Very Short'
	WHEN LENGTH(d.app_desc) >= 100  AND LENGTH(d.app_desc) < 500 THEN 'Short'
	WHEN LENGTH(d.app_desc) >= 500  AND LENGTH(d.app_desc) < 1000 THEN 'Medium'
	ELSE 'Long' 
	END AS Desc_length, 
AVG(aps.user_rating) AS Avg_rating
FROM app_store as aps JOIN app_description as d
ON aps.id_ = d.id_
GROUP BY Desc_length;

/* We can observe that the longer the app description the better understanding 
of it's functionality to the users and the higher user ratings the app gets. */

-- Finally let's check out the highest rated apps in each of the genre
SELECT prime_genre, track_name, user_rating
FROM (
	SELECT prime_genre, track_name, user_rating,
	RANK() OVER(PARTITION BY prime_genre 
				ORDER BY user_rating DESC,
				rating_count_tot DESC) AS rank_ 
	FROM app_store
) as top_
WHERE top_.rank_ = 1;
-- We got the top apps from all the 23 genre, which we can consider as a benchmark and competitor while developing our own app.
