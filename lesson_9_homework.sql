--task1  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem

select case when Grades.Grade>7 then Students.Name else 'NULL' end Name, Grades.Grade, Students.Marks from Students,Grades where Students.Marks between Grades.Min_mark and Grades.Max_Mark order by Grades.Grade desc,Name asc, Students.Marks asc;
--task2  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/occupations/problem

select min(Doctor), min(Professor), min(Singer), min(Actor) from (select case when Occupation='Doctor' then Name end as Doctor,     case when Occupation='Professor' then Name end as Professor,     case when Occupation='Singer' then Name end as Singer,     case when Occupation='Actor' then Name end as Actor,  ROW_NUMBER() OVER (PARTITION BY OCCUPATION ORDER BY NAME) as rnk   from OCCUPATIONS   order by Name ) temp group by rnk;
--task3  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-9/problem

select distinct city from station where lower(left(city, 1)) not in ('a', 'e', 'i', 'o', 'u');

--task4  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-10/problem

select distinct city from station where lower(right (city, 1)) not in ('a', 'e', 'i', 'o', 'u');

--task5  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-11/problem
select distinct city from station where lower(left(city, 1)) not in ('a', 'e', 'i', 'o', 'u') or lower(right(city, 1)) not in ('a', 'e', 'i', 'o', 'u');

--task6  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-12/problem

select distinct city from station where lower(left(city, 1)) not in ('a', 'e', 'i', 'o', 'u') and lower(right(city, 1)) not in ('a', 'e', 'i', 'o', 'u');

--task7  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/salary-of-employees/problem
select name from Employee where salary >2000 and months<10 order by  employee_id;

--task8  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem
select case when Grades.Grade>7 then Students.Name else 'NULL' end Name, Grades.Grade, Students.Marks from Students,Grades where Students.Marks between Grades.Min_mark and Grades.Max_Mark order by Grades.Grade desc,Name asc, Students.Marks asc;
