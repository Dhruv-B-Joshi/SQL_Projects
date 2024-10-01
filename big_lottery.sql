-- We have already created the table structure and imported the required data.
-- Now let us get an overview of it.
COPY grants from ''
with csv header delimiter ',';

SELECT * FROM grants
LIMIT 5;

-- First let us find out which constituencies has recieved the highst amount of grants.
SELECT constituency, SUM(award_amount) AS tot_grant
FROM grants 
GROUP BY constituency
ORDER BY tot_grant DESC
LIMIT 5;

-- Let's check the amount of grant recieved to low population of the constituency.
SELECT constituency, population, SUM(award_amount) AS tot_grant
FROM grants
GROUP BY constituency, population
ORDER BY population, tot_grant DESC
LIMIT 5;

-- Let us also check the grant which provided the least and most funding_per_head 
(SELECT applicant, constituency, funder, programme, award_amount, funding_per_head
FROM grants
ORDER BY funding_per_head
LIMIT 5)
UNION ALL
(SELECT applicant, constituency, funder, programme, award_amount, funding_per_head
FROM grants
ORDER BY funding_per_head DESC
LIMIT 5);

/* We can observe that the funder and programme for all the low funding_per_head is the same 
also the funder for the grants with highest funding_per_head is also the same */
-- Let us now check the programme through which each funder has awarded biggest grant.

SELECT funder, SUM(award_amount) AS tot_award
FROM grants
GROUP BY funder
ORDER BY tot_award DESC;

-- As the name suggest the Big Lottery Fund is the biggest contributor and Micro Grants Joint Pot is the smallest.
-- Now let us check the least amount granted through a programme by each funder
SELECT funder, programme, award_amount
FROM (SELECT funder, programme, award_amount,
	 DENSE_RANK() OVER(PARTITION BY funder
				ORDER BY award_amount) AS rank_
	  FROM grants) AS big
WHERE big.rank_=1;


-- Let's find out the type of organization to get the highest amount of grant.
SELECT org_type, SUM(award_amount)  AS tot_grant
FROM grants
GROUP BY org_type
ORDER BY tot_grant DESC
LIMIT 5;

/* We can note that the organizations classified as Third Sector has cumitatively recieved the maximum 
amount of grant amount, 6 times that of it's next member Public Sector - Local Government */
-- Let's see which organization's have recieved more amount of grants New, Mid, Old or Very Old

SELECT CASE
		WHEN org_age < 10 THEN 'New'
		WHEN org_age >= 10 AND org_age < 25 THEN 'Mid'
		WHEN org_age >= 25 AND org_age < 50 THEN 'Old'
		ELSE 'Very Old'
		END AS Antiquity, COUNT(org_age) AS num_grants
FROM grants
GROUP BY Antiquity
ORDER BY num_grants DESC;

-- Almost twice the amount of grants have been awarded to organizations which are about 10-25 years old, compared to others
-- Finally let's add a new column duration to the table showcasing the time delay between the grant awardee decided and announced
ALTER TABLE grants ADD duration INTEGER DEFAULT 0;
UPDATE grants SET duration = announcement_date - decision_date;

-- Let's check if there is any instance where the grant is announced before deciding the amount. 
SELECT COUNT(*) FROM grants WHERE duration < 0;

-- We can see that there is a single instance where grant is announced before desicion. 
-- Now let's check the range of delay
SELECT MAX(duration), AVG(duration), MIN(duration) FROM grants;

-- Let's check which of the funder is usually late in awarding grants 
SELECT funder, AVG(duration) as avg_delay
FROM grants
GROUP BY funder
ORDER BY avg_delay DESC;

-- We can observe that the NOF or New Opportunities FUND from various places is generally 20-50 days behind schedule.
