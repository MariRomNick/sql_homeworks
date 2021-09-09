--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1  (lesson7)
-- sqlite3: Сделать тестовый проект с БД (sqlite3, project name: task1_7). В таблицу table1 записать 1000 строк с случайными значениями (3 колонки, тип int) от 0 до 1000.
-- Далее построить гистаграмму распределения этих трех колонко

import sqlite3
conn = sqlite3.connect('task1_7')  
c = conn.cursor()

#проверка подключения PostgreSQL 
import psycopg2
import pandas as pd
#Библиотека ждя визуализации
from IPython.display import HTML
import plotly.express as px

#!введите свои реквизиты!
DB_HOST = '52.157.159.24'
DB_USER = 'student21'
DB_USER_PASSWORD = 'student21_password'
DB_NAME = 'sql_ex_for_student21'

conn_ps2 = psycopg2.connect(host=DB_HOST, user=DB_USER, password=DB_USER_PASSWORD, dbname=DB_NAME)

df = pd.read_sql_query(' select * from table1 ', conn_ps2)
df.to_sql('table1', conn, if_exists = 'append', index = False, index_label=None)

request = """ select * from table1 """ 
df = pd.read_sql_query(request, conn) 
fig = px.scatter_matrix(df)
fig.show()

--task2  (lesson7)
-- oracle: https://leetcode.com/problems/duplicate-emails/

select email from
(select email, count (*) as a from Person group by email) b
 where a >1

--task3  (lesson7)
-- oracle: https://leetcode.com/problems/employees-earning-more-than-their-managers/

select c.name as Employee from 
(select a.name from Employee as a join Employee as b  on a.ManagerId=b.Id
where a.Salary> b. Salary) c

--task4  (lesson7)
-- oracle: https://leetcode.com/problems/rank-scores/

select Score as score, dense_rank() over  (order by Score desc) as Rank 
from Scores

--task5  (lesson7)
-- oracle: https://leetcode.com/problems/combine-two-tables/

select FirstName, LastName, City, State from Person left join Address 
on Person.PersonId=Address.PersonId