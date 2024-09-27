CREATE TABLE movies (
Film	varchar(50),	--name of the film
Genre	varchar(20),	--film genre
Studio	varchar(30),	--Lead studio to produce the film
Audience_score	int,	--in percentage
Profitability	real,	--in millions
Rotten_tomatoes	int,	--in percentage
Gross	real,			--worldwide gross profit in millions
Release_year	varchar(10) --since it is stored as a string in the datafile.
);

COPY movies FROM 'C:/Users/91903/OneDrive/Desktop/Dhruv/Tableau/Data/HollywoodsMostProfitableStories.csv' WITH DELIMITER ',' CSV HEADER;

SELECT * FROM movies;