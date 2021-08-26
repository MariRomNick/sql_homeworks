--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task5  (lesson6)
-- Компьютерная фирма: Создать таблицу all_products_with_index_task5 как объединение всех данных по ключу  model (union all) и сделать флаг (flag) по цене > максимальной по принтеру. 
--Также добавить нумерацию (через оконные функции) по каждой категории продукта в порядке возрастания цены (price_index). По этому price_index сделать индекс

create table all_products_with_index_task5 as 
with a as (select maker,l.model,p.type,price from product p  join laptop l on p.model = l.model 
union all 
select maker,p.model,p.type,price from product p join pc l on p.model = l.model 
union all 
select maker,l.model,p.type,price from product p join printer l on p.model = l.model)
select * ,
case when price > (select max(price) from a where  type = 'Printer') then 1
else 0
end flag,
row_number ()over (partition by type order by price) as price_index
from a

CREATE INDEX price_index ON all_products_with_index_task5  (price_index);
--task1  (lesson6, дополнительно)
-- SQL: Создайте таблицу с синтетическими данными (10000 строк, 3 колонки, все типы int) и заполните ее случайными данными от 0 до 1 000 000. Проведите EXPLAIN операции и сравните базовые операции.

--task2 (lesson6, дополнительно)
-- GCP (Google Cloud Platform): Через GCP загрузите данные csv в базу PSQL по личным реквизитам (используя только bash и интерфейс bash) 
