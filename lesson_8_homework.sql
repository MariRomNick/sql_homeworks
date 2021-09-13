--task1  (lesson8)
-- oracle: https://leetcode.com/problems/department-top-three-salaries/
select Department,Employee,Salary
from 
(
	select  Employee.Name as Employee ,Department.Name as Department , Salary,
	dense_rank () over (partition by DepartmentId order by Salary desc) as drn 
	from Employee join Department on Employee.DepartmentId =Department.Id
) a 
where drn <=3

--task2  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/17

        SELECT  member_name, 
                status, 
                sum(amount*unit_price) AS costs 
        FROM  FamilyMembers join Payments on FamilyMembers.member_id = Payments.family_member WHERE  YEAR(date)=2005 
        group by member_name, status

--task3  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/13

select a.name from (select name, COUNT(*) from Passenger group by name having  COUNT(*) >1) as a

--task4  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38

select a.count from (select COUNT(*) as count,first_name from Student group by first_name having  first_name ='Anna') as a

--task5  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/35
Сколько различных кабинетов школы использовались 2.09.2019 в образовательных целях ?

select count from
 (select DISTINCT  classroom, COUNT(*) OVER() AS count, date  from Schedule where 
 DATE_FORMAT(date, '%e.%m.%Y') = '2.09.2019' )
  as a
limit 1

--или
select count from
 (select   classroom,date, COUNT(*) OVER() AS count   from Schedule
 group by  classroom,date 
 having DATE_FORMAT(date, '%e.%m.%Y') = '2.09.2019' )
  as a
limit 1

--task6  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38
select a.count from (select COUNT(*) as count,first_name from Student group by first_name having  first_name ='Anna') as a

--task7  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/32
--для My SQL
select FLOOR (avg( DATEDIFF(CURDATE(), birthday)/365)) as age from  FamilyMembers 

--task8  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/27

SELECT a.good_type_name as good_type_name,sum (a.cost) as costs from
(select good_type_name,date,(amount * unit_price) as cost
from Goods join Payments on  Payments.good=Goods.good_id
join GoodTypes on Goods.type=GoodTypes.good_type_id 
where year (date)='2005') as a
group by a.good_type_name

--task9  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/37

select FLOOR (min( DATEDIFF(CURDATE(), birthday)/365)) as year from Student

--task10  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/44

select FLOOR (max( DATEDIFF(CURDATE(), birthday)/365)) as max_year 
from Student join Student_in_class on Student.id=Student_in_class.student
join Class on Student_in_class.class=Class.id
where LEFT  (name,2)='10'

--task11 (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/20

SELECT status, member_name, sum(cost) as costs
from (
SELECT *,
amount * unit_price as cost
from FamilyMembers
join Payments on FamilyMembers.member_id = Payments.family_member) as a
where a.good in 
(SELECT good_id from Goods JOIN GoodTypes on Goods.type = GoodTypes.good_type_id where good_type_name = 'entertainment')

--task12  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/55

DELETE FROM Company
WHERE name in 
(select name from
(WITH a AS (select  name, COUNT(*) AS count1 from Trip join Company on Trip.company=Company.id group by  name)
select * , case 
when count1 = (select min(count1) from a)  then 1
else 0
end flag 
from a) b
where flag=1)

--task13  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/45
Какой(ие) кабинет(ы) пользуются самым большим спросом?

select classroom from
(WITH a AS (select  classroom, COUNT(*) AS count1 from Schedule group by  classroom)
select * , case 
when count1 = (select max(count1) from a)  then 1
else 0
end flag 
from a) b
where flag=1

--task14  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/43

SELECT last_name
from Teacher join Schedule on Teacher.id=Schedule.teacher join Subject on Subject.id=Schedule.subject
where name='Physical Culture'
order by last_name

--task15  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/63
SELECT CONCAT_WS('.', last_name, LEFT(first_name, 1), LEFT(middle_name, 1), '') as name from Student order by name


