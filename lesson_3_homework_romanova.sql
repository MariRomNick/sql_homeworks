--ñõåìà ÁÄ: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--task17
--Êîðàáëè: Íàéäèòå ñðàæåíèÿ, â êîòîðûõ ó÷àñòâîâàëè êîðàáëè êëàññà Kongo èç òàáëèöû Ships.
select battle from outcomes o join ships s  on o.ship =s.name 
where class='Kongo'
--task1
--Êîðàáëè: Äëÿ êàæäîãî êëàññà îïðåäåëèòå ÷èñëî êîðàáëåé ýòîãî êëàññà, ïîòîïëåííûõ â ñðàæåíèÿõ. Âûâåñòè: êëàññ è ÷èñëî ïîòîïëåííûõ êîðàáëåé.
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
--Êîðàáëè: Äëÿ êàæäîãî êëàññà îïðåäåëèòå ãîä, êîãäà áûë ñïóùåí íà âîäó ïåðâûé êîðàáëü ýòîãî êëàññà. Åñëè ãîä ñïóñêà íà âîäó ãîëîâíîãî êîðàáëÿ íåèçâåñòåí, 
--îïðåäåëèòå ìèíèìàëüíûé ãîä ñïóñêà íà âîäó êîðàáëåé ýòîãî êëàññà. Âûâåñòè: êëàññ, ãîä.
select ships.class, min(launched)
from ships 
group by ships.class

--task3
--Êîðàáëè: Äëÿ êëàññîâ, èìåþùèõ ïîòåðè â âèäå ïîòîïëåííûõ êîðàáëåé è íå ìåíåå 3 êîðàáëåé â áàçå äàííûõ, âûâåñòè èìÿ êëàññà è ÷èñëî ïîòîïëåííûõ êîðàáëåé.
 

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
--Êîðàáëè: Íàéäèòå íàçâàíèÿ êîðàáëåé, èìåþùèõ íàèáîëüøåå ÷èñëî îðóäèé ñðåäè âñåõ êîðàáëåé òàêîãî æå âîäîèçìåùåíèÿ (ó÷åñòü êîðàáëè èç òàáëèöû Outcomes).
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
--Êîìïüþòåðíàÿ ôèðìà: Íàéäèòå ïðîèçâîäèòåëåé ïðèíòåðîâ, êîòîðûå ïðîèçâîäÿò ÏÊ ñ íàèìåíüøèì îáúåìîì RAM è ñ ñàìûì áûñòðûì ïðîöåññîðîì ñðåäè âñåõ ÏÊ,
-- èìåþùèõ íàèìåíüøèé îáúåì RAM. Âûâåñòè: Maker
select  maker
from printer p join product p2   on p.model =p2.model
where maker in 
(with Q1 as (select  maker,max(speed),
case when RAM<=all (select RAM from pc) 
      then 1
      else null
      end minram
from pc p3  join product p2   on p3.model =p2.model
group by maker,minram) 
select 
case when minram=1
      then maker
      else null
      end makerPC
 from Q1 )
group by maker      
