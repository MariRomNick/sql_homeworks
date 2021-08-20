--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--task17
--Корабли: Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.
select battle from outcomes o join ships s  on o.ship =s.name 
where class='Kongo'
--task1
--Корабли: Для каждого класса определите число кораблей этого класса, потопленных в сражениях. Вывести: класс и число потопленных кораблей.
select class,count (*)
from outcomes o join ships s  on o.ship =s.name 
where result='sunk'
group by class
--OR
select class,count (*)
from outcomes o full join ships s  on o.ship =s.name 
where result='sunk'
group by class

--task2
--Корабли: Для каждого класса определите год, когда был спущен на воду первый корабль этого класса. Если год спуска на воду головного корабля неизвестен, 
--определите минимальный год спуска на воду кораблей этого класса. Вывести: класс, год.
select ships.class, min(launched)
from ships 
group by ships.class

--task3
--Корабли: Для классов, имеющих потери в виде потопленных кораблей и не менее 3 кораблей в базе данных, вывести имя класса и число потопленных кораблей.
 

select class, result,  count (*) as countsunk
from outcomes o full join ships s  on o.ship =s.name 
group by class, result
having result='sunk' and class in 
(with Q1 as (select class, count (*) as count1
from outcomes o full join ships s  on o.ship =s.name 
group by class)
select 
case when count1 >=3 
      then class
      else null
      end countship
from Q1)

--task4
--Корабли: Найдите названия кораблей, имеющих наибольшее число орудий среди всех кораблей такого же водоизмещения (учесть корабли из таблицы Outcomes).
--with Q1 as (select   displacement,max(numguns) as max
--from classes 
--group by  displacement
--order by displacement)
select name, (numguns+displacement) as K
from classes c  join ships s  on c.class =s.class
where  (numguns+displacement) in ( 
with Q1 as (select   max(numguns) as max, displacement 
from classes 
group by  displacement) 
select 
case when displacement>0
      then (displacement+max)
      else null
      end K
from Q1)
order by K

--task5
--Компьютерная фирма: Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM и с самым быстрым процессором среди всех ПК,
-- имеющих наименьший объем RAM. Вывести: Maker
select maker as makerPR 
from printer p join product p2   on p.model =p2.model
where maker in (with Q1 as ( select  maker, max (speed) as maxspeed ,min (RAM) as minRAM
from pc p3  join product p2   on p3.model =p2.model
group by maker
order by minRAM asc, maxspeed desc
limit 1)
select 
case when maxspeed>0
      then maker
      else null
      end makerPC
from Q1)
group by makerPR 