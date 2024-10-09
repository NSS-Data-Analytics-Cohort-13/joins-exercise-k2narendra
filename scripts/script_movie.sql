--1. Give the name, release year, and worldwide gross of the lowest grossing movie.

SELECT s.film_title
	, s.release_year 
	, r.worldwide_gross
FROM specs as s
INNER JOIN revenue as r
	ON s.movie_id = r.movie_id
WHERE worldwide_gross = (SELECT MIN(worldwide_gross) FROM revenue)

	
--2. What year has the highest average imdb rating?
	
SELECT s.release_year, AVG (r.imdb_rating) as Avg_rating
FROM specs as s
INNER JOIN rating as r
on s.movie_id = r.movie_id
GROUP BY s.release_year
ORDER BY avg_rating DESC
LIMIT 1

--3. What is the highest grossing G-rated movie? Which company distributed it?
	
select company_name from distributors where distributor_id in
(select domestic_distributor_id from specs where movie_Id in (select movie_id from revenue 
	where worldwide_gross in (select max(worldwide_gross) from revenue
	where movie_id in (select movie_id from specs where mpaa_rating like 'G') )))

	--Alternatively
	
select  s.film_title, company_name
from specs as s
inner join revenue as r
on s.movie_id = r.movie_id
inner join distributors as d
on d.distributor_id = s.domestic_distributor_id
where s.mpaa_rating ilike 'G'
order by r.worldwide_gross desc
limit 1;

 --4. Write a query that returns, for each distributor in the distributors table, the distributor name and the number of movies associated with that distributor in the movies table. Your result set should include all of the distributors, whether or not they have any movies in the movies table.

select  d.company_name, count(s.film_title) as Number_of_movies
from distributors as d
left join specs as s
on d.distributor_id = s.domestic_distributor_id
group by d.company_name;

--5. Write a query that returns the five distributors with the highest average movie budget.

SELECT d.company_name, 
	ROUND(AVG(r.film_budget))::MONEY AS Avg_budget
FROM specs as s
LEFT JOIN revenue as r
ON s.movie_id=r.movie_id
INNER JOIN distributors as d
ON d.distributor_id=s.domestic_distributor_id
GROUP BY d.company_name
ORDER BY avg_budget DESC
LIMIT 5

--6. How many movies in the dataset are distributed by a company which is not headquartered in California? Which of these movies has the highest imdb rating?

SELECT count(s.film_title) AS Number_of_Movie, max(r.imdb_rating) AS Rating
FROM distributors as d
inner JOIN specs as s
ON d.distributor_id = s.domestic_distributor_id
	INNER JOIN rating as r
	USING(movie_id)
WHERE d.headquarters NOT IN('%CA%')

--7. Which have a higher average rating, movies which are over two hours long or movies which are under two hours?

select 
    case when s.length_in_min <= 120 then 'under_2hr' else 'over_2hr' end as movie_length --then r.imdb_rating else 0 end as , then 
    , avg(r.imdb_rating) as avg_rating
	--case when s.length_in_min > 120 then r.imdb_rating else 0 end as over_2hr
from
    rating as r
inner join specs as s 
on s.movie_id = r.movie_id
	group by movie_length
order by avg_rating desc 
