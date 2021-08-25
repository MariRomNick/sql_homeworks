--����� ��: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task10 (lesson4)
-- ������������ �����: �� ���� products_price_categories_with_makers �� ������� �� ������� ������������� ������ (X: category_price, Y: count)
--# ��� ������� ���� ��������� � colab ���� �� ����, ����������� ������ �������
--request = """
select category_price,count from products_price_categories_with_makers where maker ='A'
select category_price,count from products_price_categories_with_makers where maker ='B'
select category_price,count from products_price_categories_with_makers where maker ='C'
select category_price,count from products_price_categories_with_makers where maker ='D'
select category_price,count from products_price_categories_with_makers where maker ='E'


--task11 (lesson4)
-- ������������ �����: �� ���� products_price_categories_with_makers �� ������� �� A & D ������ (X: category_price, Y: count)
select category_price,sum(count)  from products_price_categories_with_makers where maker in ('A','D') 
group by category_price

--task12 (lesson4)
-- �������: ������� ����� ������� ships, �� � �������� ������� �� ������ ���������� � ����� N (ships_without_n)
create table ships_without_n as
select * from ships where name  not like 'N%'

--task13 (lesson3)
--������������ �����: ������� ������ ���� ��������� � ������������� � ��������� ���� �������� (pc, printer, laptop). �������: model, maker, type

select price, product.model, maker, product.type from product join laptop on product.model = laptop.model 
union all
select price, product.model, maker, product.type from product join pc on product.model = pc.model 
union all 
select price, product.model, maker, product.type from product join printer on product.model = printer.model 

--task14 (lesson3)
--������������ �����: ��� ������ ���� �������� �� ������� printer ������������� ������� ��� ���, � ���� ���� ����� ������� PC - "1", � ��������� - "0"

select *, 
case 
  when price> (select avg (price) from printer)
  then 1
  else 0
end flag
from printer

--task15 (lesson3)
--�������: ������� ������ ��������, � ������� class ����������� (IS NULL)
select name, ship
from ships full join outcomes on ships.name =outcomes.ship
where class IS null
-- ���������� ��� ����������?
select name
from ships 
where class IS null

 --task16 (lesson3)
--�������: ������� ��������, ������� ��������� � ����, �� ����������� �� � ����� �� ����� ������ �������� �� ����.
select *
from battles
where CAST(date AS varchar(4)) not in (select cast(launched AS varchar(4)) from ships)


--task17 (lesson3)
--�������: ������� ��������, � ������� ����������� ������� ������ Kongo �� ������� Ships.
select battle
from (ships join outcomes on ships.name =outcomes.ship) 
where class like 'Kongo'

--task1  (lesson4)
-- ������������ �����: ������� view (�������� all_products_flag_300) ��� ���� ������� (pc, printer, laptop) � ������, ���� ��������� ������ > 300.
-- �� view ��� �������: model, price, flag
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
-- ������������ �����: ������� view (�������� all_products_flag_avg_price) ��� ���� ������� (pc, printer, laptop) � ������, ���� ��������� ������ c������ . �� view ��� �������: model, price, flag

create or replace view all_products_flag_avg_price as 
select model, price, 
case when price > (select avg (price) from all_products_flag_300) then 1
else 0
end flag1
from all_products_flag_300
order by  price, flag1

--task3  (lesson4)
-- ������������ �����: ������� ��� �������� ������������� = 'A' �� ���������� ���� ������� �� ��������� ������������� = 'D' � 'C'. ������� model
with a as (select price, product.model, maker, product.type from product join laptop on product.model = laptop.model 
union all
select price, product.model, maker, product.type from product join pc on product.model = pc.model 
union all 
select price, product.model, maker, product.type from product join printer on product.model = printer.model )
select  distinct model 
from a
where  maker ='A' and price > (select  avg (price) from a where maker in ('D','C') )

--task4 (lesson4)
-- ������������ �����: ������� ��� ������ ������������� = 'A' �� ���������� ���� ������� �� ��������� ������������� = 'D' � 'C'. ������� model

--task5 (lesson4)
-- ������������ �����: ����� ������� ���� ����� ���������� ��������� ������������� = 'A' (printer & laptop & pc)

--task6 (lesson4)
-- ������������ �����: ������� view � ����������� ������� (�������� count_products_by_makers) �� ������� �������������. �� view: maker, count

--task7 (lesson4)
-- �� ����������� view (count_products_by_makers) ������� ������ � colab (X: maker, y: count)

--task8 (lesson4)
-- ������������ �����: ������� ����� ������� printer (�������� printer_updated) � ������� �� ��� ��� �������� ������������� 'D'

--task9 (lesson4)
-- ������������ �����: ������� �� ���� ������� (printer_updated) view � �������������� �������� ������������� (�������� printer_updated_with_makers)

--task10 (lesson4)
-- �������: ������� view c ����������� ����������� �������� � ������� ������� (�������� sunk_ships_by_classes). �� view: count, class (���� �������� ������ ���/IS NULL, �� �������� �� 0)

--task11 (lesson4)
-- �������: �� ����������� view (sunk_ships_by_classes) ������� ������ � colab (X: class, Y: count)

--task12 (lesson4)
-- �������: ������� ����� ������� classes (�������� classes_with_flag) � �������� � ��� flag: ���� ���������� ������ ������ ��� ����� 9 - �� 1, ����� 0

--task13 (lesson4)
-- �������: ������� ������ � colab �� ������� classes � ����������� ������� �� ������� (X: country, Y: count)

--task14 (lesson4)
-- �������: ������� ���������� ��������, � ������� �������� ���������� � ����� "O" ��� "M".

--task15 (lesson4)
-- �������: ������� ���������� ��������, � ������� �������� ������� �� ���� ����.

--task16 (lesson4)
-- �������: ��������� ������ � ����������� ���������� �� ���� �������� � ����� ������� (X: year, Y: count)
