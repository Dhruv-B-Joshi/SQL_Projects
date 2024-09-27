-- Creating the structure of the table
create table movies (
	film_name varchar(50),
	genre varchar(15),
	studio varchar(25),
	audience_score int,
	profit float,
	rotten_tomatoes integer,
	gross float,
	release_year smallint);
	
-- Imported data from local csv file to our table and overviewing it (we can also use copy from)
select * from movies

/* We can observe some fields containing Null values, we will delete these rows.*/ 
delete from movies where not (movies is not null);


/* 
Q1 : Genre which is most loved by the audience? 
Grouped data based on genres and then finding the average of audience_score and rotten_tomatoes
and sorting them in descending order of audience score 
*/

select 
	genre,
	avg(audience_score) :: numeric(10,2) as audience_avg, 
	avg(rotten_tomatoes) :: numeric(10,2) as rotten_tomatoes_avg
from movies
group by genre
order by audience_avg desc;

/* 
Q2 : Top 10 grossing movies ? 
Ordering data in descending based on gross profit of the movies and limiting by 10
*/

select film_name, studio, gross, profit
from movies
order by gross desc
limit 10;

/*
Q3 : Find the most profitable studios across the years?
Calculating and ordering the sum of profit and grouping the data by studios while
removing inappropriate data (Independent studio films)
*/
select studio, sum(profit) :: numeric(10,2) as sum_of_profit
from movies
where (studio!='Independent')
group by studio
order by sum_of_profit desc;

/* Similarly viewing most profitable independent movies */ 
select film_name, profit from movies
where studio ='Independent'
order by profit desc;

/* Profit of studios by year */

select studio, release_year, profit :: numeric(10,2) ,
sum(profit) over(partition by studio) as sum_of_profit
from movies
where studio!= 'Independent'
order by sum_of_profit desc;

/* Year wise profit of all the studios (except independent) ?
   Here we will use crosstab to get the desired result*/

create extension tablefunc;
select * from crosstab 
	('select studio, release_year, sum(profit) :: numeric(10,2) as sp 
	 from movies
	 where studio != ''Independent''
	 group by studio, release_year
	 order by 1') 
as Yearwiseprofit(Studio varchar(25), Year_2007 numeric(10,2),Year_2008 numeric(10,2),Year_2009 numeric(10,2),Year_2010 numeric(10,2),Year_2011 numeric(10,2));










