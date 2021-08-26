--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task11 (lesson5)
-- Компьютерная фирма: Построить график с со средней и максимальной ценами на базе products_with_lowest_price (X: maker, Y1: max_price, Y2: avg)price
--c графиками пока не разобралась

--task12 (lesson5)
-- Компьютерная фирма: Сделать view, в которой будет постраничная разбивка всех laptop (не более двух продуктов на одной странице). 
--Вывод: все данные из laptop, номер страницы, список всех страниц

create view page_num_and_num_of_pages as
SELECT *,
      CASE WHEN num % 2 = 0 THEN num/2 ELSE num/2 + 1 END AS page_num,
      CASE WHEN total % 2 = 0 THEN total/2 ELSE total/2 + 1 END AS num_of_pages
FROM (
      SELECT *, ROW_NUMBER() over() AS num,
             COUNT(*) OVER() AS total
      FROM Laptop
) X;
--номер записи на странице и номер страницы
create view page_num_and_row_num as
SELECT *,ROW_NUMBER() over( partition by page_num) AS row_num
from
(SELECT *,  
CASE WHEN num % 2 = 0 THEN num/2 
ELSE (num/2 + 1) 
END  page_num
FROM (SELECT *, ROW_NUMBER() over() AS num   FROM Laptop) a) as b

--task1 (lesson5)
-- Компьютерная фирма: Сделать view (pages_all_products), в которой будет постраничная разбивка всех продуктов (не более двух продуктов на одной странице).
-- Вывод: все данные из laptop, номер страницы, список всех страниц
create view pages_all_products as
SELECT *, case when num % 2 = 0 THEN num/2 
ELSE (num/2 + 1) 
END  page_num,
CASE WHEN total % 2 = 0 THEN total/2 
ELSE total/2 + 1 
END num_of_pages
from
(SELECT *, ROW_NUMBER() over() AS num,  COUNT(*) OVER() AS total   FROM Laptop) as a

--task2 (lesson5)
-- Компьютерная фирма: Сделать view (distribution_by_type), в рамках которого будет процентное соотношение 
--всех товаров по типу устройства. Вывод: производитель,
create or replace view distribution_by_type as
select  type, cast ((max (num)*100.0/avg (total))AS NUMERIC(3,0))   as per_cent
 from
(SELECT *, ROW_NUMBER() over( partition by type ) AS num,  COUNT(*) OVER() AS total   FROM product order by  type) as a
group by  type 

--task3 (lesson5)
-- Компьютерная фирма: Сделать на базе предыдущенр view график - круговую диаграмму
--c графиками пока не разобралась

--task4 (lesson5)
-- Корабли: Сделать копию таблицы ships (ships_two_words), но у название корабля должно состоять из двух слов
create table ships_two_words as 
SELECT * from ships
where name like '% %'

--task5 (lesson5)
-- Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL) и название начинается с буквы "S"
SELECT * from ships s full join outcomes o on s.name=o.ship 
where class is null and 
ship like 'S%'

--task6 (lesson5)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'C' 
--и три самых дорогих (через оконные функции). Вывести model

select aaa.model from 
(select p.model,maker,price, row_number () over (partition by maker order by price) as row_n
from printer p join product p2 on p.model =p2.model) as aaa
where maker='A' 
and row_n<=3
and price> (select avg (price) from 
printer p join product p2 on p.model =p2.model
where maker='C')