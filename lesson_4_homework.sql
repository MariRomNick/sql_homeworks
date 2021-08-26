--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing
--task10 (lesson4)
-- Компьютерная фирма: На базе products_price_categories_with_makers по строить по каждому производителю график (X: category_price, Y: count)
--# как сделать свою страничку в colab пока не знаю, подготовила только запросы
---request = """
select category_price,count from products_price_categories_with_makers where maker ='A'
select category_price,count from products_price_categories_with_makers where maker ='B'
select category_price,count from products_price_categories_with_makers where maker ='C'
select category_price,count from products_price_categories_with_makers where maker ='D'
select category_price,count from products_price_categories_with_makers where maker ='E'

--"""
--df = pd.read_sql_query(request, conn)
--fig = px.bar(x=df.maker.to_list(), y=df.avg.to_list(), labels={'x':'maker', 'y':'avg price'})
--fig.show()

--task11 (lesson4)
-- Компьютерная фирма: На базе products_price_categories_with_makers по строить по A & D график (X: category_price, Y: count)
select category_price,sum(count)  from products_price_categories_with_makers where maker in ('A','D') 
group by category_price
--task12 (lesson4)
-- Корабли: Сделать копию таблицы ships, но у название корабля не должно начинаться с буквы N (ships_without_n)
create table ships_without_n as
select * from ships where name  not like 'N%'

--task13 (lesson3)
--Компьютерная фирма: Вывести список всех продуктов и производителя с указанием типа продукта (pc, printer, laptop). Вывести: model, maker, type

select  product.model, maker, product.type from product join laptop on product.model = laptop.model 
union all
select  product.model, maker, product.type from product join pc on product.model = pc.model 
union all 
select  product.model, maker, product.type from product join printer on product.model = printer.model 

--task14 (lesson3)
--Компьютерная фирма: При выводе всех значений из таблицы printer дополнительно вывести для тех, у кого цена вышей средней PC - "1", у остальных - "0"

select *, 
case 
  when price> (select avg (price) from PC)
  then 1
  else 0
end flag
from printer

--task15 (lesson3)
--Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL)
select name, ship
from ships full join outcomes on ships.name =outcomes.ship
where class IS null
-- подскажите как правильнее?
select name
from ships 
where class IS null

 --task16 (lesson3)
--Корабли: Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду.
select *
from battles
where CAST(date AS varchar(4)) not in (select cast(launched AS varchar(4)) from ships)


--task17 (lesson3)
--Корабли: Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.
select battle
from (ships join outcomes on ships.name =outcomes.ship) 
where class like 'Kongo'

--task1  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_300) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше > 300.
-- Во view три колонки: model, price, flag
create or replace view all_products_flag_300 as 
select model, price, 
case when price > 300 then 1
else 0
end flag
from 
(select price, product.model, maker, product.type from product join laptop on product.model = laptop.model 
union all
select price, product.model, maker, product.type from product join pc on product.model = pc.model 
union all 
select price, product.model, maker, product.type from product join printer on product.model = printer.model )as a

--task2  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_avg_price) для всех товаров (pc, printer, laptop) с флагом, если
-- стоимость больше cредней . Во view три колонки: model, price, flag

create or replace view all_products_flag_avg_price as 
select model, price, 
case when price > (select avg (price) from all_products_flag_300) then 1
else 0
end flag1
from all_products_flag_300
order by  price, flag1

--task3  (lesson4)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model
with a as (select price, product.model, maker, product.type from product join printer on product.model = printer.model )
select  *  model 
from a
where  maker ='A' and price > (select  avg (price) from a where (maker in ('D','C') ))

--task4 (lesson4)
-- Компьютерная фирма: Вывести все товары производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model
with a as (select price, product.model, maker, product.type from product join laptop on product.model = laptop.model 
union all
select price, product.model, maker, product.type from product join pc on product.model = pc.model 
union all 
select price, product.model, maker, product.type from product join printer on product.model = printer.model )
select   model 
from a
where  maker ='A' and price > 
(select avg (price) from a where maker in ('D','C') and  type='Printer' )

--task5 (lesson4)
-- Компьютерная фирма: Какая средняя цена среди уникальных продуктов производителя = 'A' (printer & laptop & pc)
with a as (select price, product.model, maker, product.type from product join laptop on product.model = laptop.model 
union 
select price, product.model, maker, product.type from product join pc on product.model = pc.model 
union 
select price, product.model, maker, product.type from product join printer on product.model = printer.model  )
select avg (price) 
from a
where  maker ='A' 


--task6 (lesson4)
-- Компьютерная фирма: Сделать view с количеством товаров (название count_products_by_makers) по каждому производителю. Во view: maker, count
create or replace view ount_products_by_makers as 
select maker, count (*)
from (select price, maker from product join laptop on product.model = laptop.model 
union all
select price,  maker from product join pc on product.model = pc.model 
union all 
select price, maker from product join printer on product.model = printer.model  ) a
group by maker

--task7 (lesson4)
-- По предыдущему view (count_products_by_makers) сделать график в colab (X: maker, y: count)

--task8 (lesson4)
-- Компьютерная фирма: Сделать копию таблицы printer (название printer_updated) и удалить из нее все принтеры производителя 'D'
create table printer_updated as
select * from printer where model in (
select printer.model from  product  join printer on product.model = printer.model 
where maker <> 'D')

--or

create table printer_updated as
select * from printer 

DELETE  FROM printer_updated
WHERE model in (
select printer.model from  product  join printer on product.model = printer.model 
where maker = 'D')
--task9 (lesson4)
-- Êîìïüþòåðíàÿ ôèðìà: Ñäåëàòü íà áàçå òàáëèöû (printer_updated) view ñ äîïîëíèòåëüíîé êîëîíêîé ïðîèçâîäèòåëÿ (íàçâàíèå printer_updated_with_makers)

--task10 (lesson4)
-- Êîðàáëè: Ñäåëàòü view c êîëè÷åñòâîì ïîòîïëåííûõ êîðàáëåé è êëàññîì êîðàáëÿ (íàçâàíèå sunk_ships_by_classes). Âî view: count, class (åñëè çíà÷åíèÿ êëàññà íåò/IS NULL, òî çàìåíèòü íà 0)

--task11 (lesson4)
-- Êîðàáëè: Ïî ïðåäûäóùåìó view (sunk_ships_by_classes) ñäåëàòü ãðàôèê â colab (X: class, Y: count)

--task12 (lesson4)
-- Êîðàáëè: Ñäåëàòü êîïèþ òàáëèöû classes (íàçâàíèå classes_with_flag) è äîáàâèòü â íåå flag: åñëè êîëè÷åñòâî îðóäèé áîëüøå èëè ðàâíî 9 - òî 1, èíà÷å 0

--task13 (lesson4)
-- Êîðàáëè: Ñäåëàòü ãðàôèê â colab ïî òàáëèöå classes ñ êîëè÷åñòâîì êëàññîâ ïî ñòðàíàì (X: country, Y: count)

--task14 (lesson4)
-- Êîðàáëè: Âåðíóòü êîëè÷åñòâî êîðàáëåé, ó êîòîðûõ íàçâàíèå íà÷èíàåòñÿ ñ áóêâû "O" èëè "M".

--task15 (lesson4)
-- Êîðàáëè: Âåðíóòü êîëè÷åñòâî êîðàáëåé, ó êîòîðûõ íàçâàíèå ñîñòîèò èç äâóõ ñëîâ.

--task16 (lesson4)
-- Êîðàáëè: Ïîñòðîèòü ãðàôèê ñ êîëè÷åñòâîì çàïóùåííûõ íà âîäó êîðàáëåé è ãîäîì çàïóñêà (X: year, Y: count)
