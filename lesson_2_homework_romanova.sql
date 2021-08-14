--����� ��: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

������� 1: ������� name, class �� ��������, ���������� ����� 1920
select name, class from ships where launched>1920

������� 2: ������� name, class �� ��������, ���������� ����� 1920, �� �� ������� 1942
select name, class from ships where launched BETWEEN 1921 AND 1942

������� 3: ����� ���������� �������� � ������ ������. ������� ���������� � class
select class, count(*) from ships group by class

������� 4: ��� ������� ��������, ������ ������ ������� �� ����� 16, ������� ����� � ������. (������� classes)
select class, country  from classes where bore>=16

������� 5: ������� �������, ����������� � ��������� � �������� ��������� (������� Outcomes, North Atlantic). �����: ship.
select ship from Outcomes where battle='North Atlantic' and result='sunk'

������� 6: ������� �������� (ship) ���������� ������������ �������
select ship from Outcomes as t1 join battles as t2 on t1.battle =t2.name
where result='sunk' and date=
  (select max (date)from  Outcomes as t1 join battles as t2 on t1.battle =t2.name )

������� 7: ������� �������� ������� (ship) � ����� (class) ���������� ������������ �������
select name as ship, class from ships
where  name in
  (select ship from Outcomes as t1 join battles as t2 on t1.battle =t2.name 
   where result='sunk' and date=(select max (date)from  Outcomes as t1 join battles as t2 on t1.battle =t2.name ))
-- � ��������� Outcomes ����� ������� �������, ������������� � ��������� Ships, ������� ���� � ��������� �������, ������� ������ ������
������� 8: ������� ��� ����������� �������, � ������� ������ ������ �� ����� 16, � ������� ���������. �����: ship, class
select name as ship , class from ships
where
name in (select ship from Outcomes where result='sunk')
and  class in (select class  from classes where bore>=16)
������� 9: ������� ��� ������ ��������, ���������� ��� (������� classes, country = 'USA'). �����: class
select class from classes where country = 'USA'

������� 10: ������� ��� �������, ���������� ��� (������� classes & ships, country = 'USA'). �����: name, class
select name, ships.class 
from classes join ships on classes.class=ships.class
where country = 'USA'
