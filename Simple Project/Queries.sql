-- Creating the structure of the table.
CREATE TABLE movies (
	film_name VARCHAR(50),
	genre VARCHAR(15),
	studio VARCHAR(25),
	audience_score INT,
	profit FLOAT,
	rotten_tomatoes INT,
	gross FLOAT,
	release_year SMALLINT);
	
-- Importing data from local csv file to our table and overviewing it. (we can also use COPY table_name FROM)
SELECT * FROM movies
LIMIT 5;

-- We can observe some fields containing Null values, we will delete these rows.
DELETE FROM movies WHERE (movies IS NULL);

/* 
Q1 : Genre which is most loved by the audience? 
Grouped data based on genres and then finding the average of audience_score and rotten_tomatoes
and sorting them in descending order of audience score 
*/
SELECT 
	genre,
	AVG(audience_score) :: NUMERIC(10,2) AS audience_avg, 
	AVG(rotten_tomatoes) :: NUMERIC(10,2) AS rotten_tomatoes_avg
FROM movies
GROUP BY genre
ORDER BY audience_avg DESC;

/*
Q2 : Finding the most profitable studios across the years?
Calculating and ordering the sum of profit and grouping the data by studios while
removing inappropriate data (Independent studio films)
*/
SELECT studio, SUM(profit) :: NUMERIC(10,2) AS sum_of_profit
FROM movies
WHERE (studio!='Independent')
GROUP BY studio
ORDER BY sum_of_profit DESC;

-- Similarly viewing most profitable independent movies
SELECT film_name, profit FROM movies
WHERE studio ='Independent'
ORDER BY profit DESC
LIMIT 5;

/* Q3 : Year wise profit of all the studios (except independent) ?
   Here we will use crosstab to get the desired result. */
CREATE extension tablefunc;
SELECT * FROM crosstab 
	('SELECT studio, release_year, SUM(profit) :: NUMERIC(10,2) as sp 
	 FROM movies
	 WHERE studio != ''Independent''
	 GROUP BY studio, release_year
	 ORDER BY 1') 
AS Yearwiseprofit(Studio VARCHAR(25), Year_2007 NUMERIC(10,2),Year_2008 NUMERIC(10,2),
				  Year_2009 NUMERIC(10,2),Year_2010 NUMERIC(10,2),Year_2011 NUMERIC(10,2));
