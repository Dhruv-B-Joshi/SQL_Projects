-- Creating the structure of the table
CREATE TABLE movies (
	film_name varchar(50),
	genre varchar(15),
	studio varchar(25),
	audience_score int,
	profit float,
	rotten_tomatoes integer,
	gross float,
	release_year smallint);
	
-- Imported data from local csv file to our table and overviewing it (we can also use COPY table_name FROM)
SELECT * FROM movies

/* We can observe some fields containing Null values, we will delete these rows.*/ 
DELETE FROM movies WHERE (movies IS NULL);


/* 
Q1 : Genre which is most loved by the audience? 
Grouped data based on genres and then finding the average of audience_score and rotten_tomatoes
and sorting them in descending order of audience score 
*/
SELECT 
	genre,
	avg(audience_score) :: numeric(10,2) AS audience_avg, 
	avg(rotten_tomatoes) :: numeric(10,2) AS rotten_tomatoes_avg
FROM movies
GROUP BY genre
ORDER BY audience_avg DESC;

/* 
Q2 : Top 10 grossing movies ? 
Ordering data in descending based on gross profit of the movies and limiting by 10
*/
SELECT film_name, studio, gross, profit
FROM movies
ORDER BY gross DESC
LIMIT 10;

/*
Q3 : Find the most profitable studios across the years?
Calculating and ordering the sum of profit and grouping the data by studios while
removing inappropriate data (Independent studio films)
*/
SELECT studio, sum(profit) :: numeric(10,2) as sum_of_profit
FROM movies
WHERE (studio!='Independent')
GROUP BY studio
ORDER BY sum_of_profit DESC;

/* Similarly viewing most profitable independent movies */ 
SELECT film_name, profit FROM movies
WHERE studio ='Independent'
ORDER BY profit DESC;

/* Profit of studios by year */
SELECT studio, release_year, profit :: numeric(10,2) ,
sum(profit) over(partition BY studio) AS sum_of_profit
FROM movies
WHERE studio!= 'Independent'
ORDER BY sum_of_profit DESC;

/* Year wise profit of all the studios (except independent) ?
   Here we will use crosstab to get the desired result*/
CREATE extension tablefunc;
SELECT * FROM crosstab 
	('select studio, release_year, sum(profit) :: numeric(10,2) as sp 
	 from movies
	 where studio != ''Independent''
	 group by studio, release_year
	 order by 1') 
AS Yearwiseprofit(Studio varchar(25), Year_2007 numeric(10,2),Year_2008 numeric(10,2),Year_2009 numeric(10,2),Year_2010 numeric(10,2),Year_2011 numeric(10,2));










