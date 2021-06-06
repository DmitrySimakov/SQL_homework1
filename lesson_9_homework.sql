--task1  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem

SELECT 
CASE 
    WHEN g.grade < 8 
    THEN NULL 
    ELSE s.name 
    END as name, g.grade, s.marks 
FROM students s JOIN grades g ON 
s.marks BETWEEN g.min_mark AND g.max_mark
ORDER BY g.grade DESC, s.name;

--task2  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/occupations/problem

SELECT min(Doctor), min(Professor), min(Singer), min(Actor)
FROM
( Select
ROW_NUMBER() OVER (PARTITION BY Occupation order by Name) rn, 
CASE 
WHEN Occupation = 'Doctor' then Name
end as Doctor,
CASE 
WHEN Occupation = 'Professor' then Name
end as Professor,
CASE 
WHEN Occupation = 'Singer' then Name
end as Singer,
CASE 
WHEN Occupation = 'Actor' then Name
end as Actor
from OCCUPATIONS
order by Name) a
group by rn
order by rn;

--task3  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-9/problem

select distinct city
from station
where LEFT(city,1)  NOT in ('E', 'U', 'I', 'O', 'A');

--task4  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-10/problem

select distinct city
from station
where RIGHT(city,1)  NOT in ('E', 'U', 'I', 'O', 'A');

--task5  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-11/problem

SELECT DISTINCT CITY 
FROM STATION 
WHERE LOWER(SUBSTR(CITY,1,1)) NOT IN ('a','e','i','o','u') 
OR LOWER(SUBSTR(CITY, LENGTH(CITY),1)) NOT IN ('a','e','i','o','u');

--task6  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-12/problem

SELECT DISTINCT CITY 
FROM STATION 
WHERE LOWER(SUBSTR(CITY,1,1)) NOT IN ('a','e','i','o','u') 
and LOWER(SUBSTR(CITY, LENGTH(CITY),1)) NOT IN ('a','e','i','o','u');

--task7  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/salary-of-employees/problem

select name
from Employee
where salary > 2000 and months < 10

--task8  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem

--повтор
