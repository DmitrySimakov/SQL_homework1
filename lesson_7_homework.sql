--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1  (lesson7)
-- sqlite3: Сделать тестовый проект с БД (sqlite3, project name: task1_7). В таблицу table1 записать 1000 строк с случайными значениями (3 колонки, тип int) от 0 до 1000.
-- Далее построить гистаграмму распределения этих трех колонко

--task2  (lesson7)
-- oracle: https://leetcode.com/problems/duplicate-emails/

select email
from (
select email, count(email) as count_email
from person
group by email
having count_email > 1
) a

--task3  (lesson7)
-- oracle: https://leetcode.com/problems/employees-earning-more-than-their-managers/

select e.name as Employee
from employee e join employee em
on e.managerid = em.id
where e.salary > em.salary

--task4  (lesson7)
-- oracle: https://leetcode.com/problems/rank-scores/


select Score, dense_rank() over (order by score desc) as 'Rank'
From Scores

--task5  (lesson7)
-- oracle: https://leetcode.com/problems/combine-two-tables/

select FirstName, LastName, City, State
from person left join address on
person.PersonId = address.PersonId