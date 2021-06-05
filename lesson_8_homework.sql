--task1  (lesson8)
-- oracle: https://leetcode.com/problems/department-top-three-salaries/

select department, employee, salary
from
(
select *, dense_rank() over(partition by department order by salary desc) rnk
FROM
(
select d.name as department , e.name as employee , salary
from employee e left join department d on
e.departmentId = d.id
) a
) b
where rnk < 4

--task2  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/17

select member_name, status, costs
from 
(
select family_member, sum(amount*unit_price) as costs
from Payments
where date BETWEEN STR_TO_DATE('2005-01-01 00:00:00', '%Y-%m-%d %H:%i:%s')
AND STR_TO_DATE('2005-12-31 23:59:59', '%Y-%m-%d %H:%i:%s')
GROUP BY family_member
) a
join FamilyMembers fm on
fm.member_id = a.family_member

--task3  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/13

select name
FROM (
select name, count(name) as count
from Passenger
GROUP BY name
HAVING count > 1 
) a

--task4  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38

select COUNT(first_name) as count
from Student
where first_name = 'Anna'

--task5  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/35

select COUNT(classroom) as count
from Schedule
where date = STR_TO_DATE('2019-09-02', '%Y-%m-%d %H:%i:%s')
GROUP BY date

--task6  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38
-- Повтор

--task7  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/32

SELECT avg(age_m) age
from (
SELECT  
  (
    (YEAR(CURRENT_DATE) - YEAR(birthday)) -                             
    (DATE_FORMAT(CURRENT_DATE, '%m%d') < DATE_FORMAT(birthday, '%m%d'))
  ) AS age_m
FROM FamilyMembers
) a

--task8  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/27

select good_type_name, costs
from GoodTypes gt join 
(
select type, sum(costs_g) as costs
from 
(
select good, sum(amount*unit_price) as costs_g
from Payments
where date BETWEEN STR_TO_DATE('2005-01-01 00:00:00', '%Y-%m-%d %H:%i:%s')
AND STR_TO_DATE('2005-12-31 23:59:59', '%Y-%m-%d %H:%i:%s')
GROUP BY good
) a 
join Goods g on 
a.good = g.good_id
GROUP BY type
)b
on gt.good_type_id = b.type

--task9  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/37

select min(age_m) as year
from 
(
SELECT
  (
    (YEAR(CURRENT_DATE) - YEAR(birthday)) -                             
    (DATE_FORMAT(CURRENT_DATE, '%m%d') < DATE_FORMAT(birthday, '%m%d'))
  ) AS age_m
 from Student
 ) a

--task10  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/44

SELECT max(age_m) as max_year
from class cl join 
(
select st.class, age_m
from Student_in_class st join
(
  SELECT id,
  (
    (YEAR(CURRENT_DATE) - YEAR(birthday)) -                             
    (DATE_FORMAT(CURRENT_DATE, '%m%d') < DATE_FORMAT(birthday, '%m%d'))
  ) AS age_m
 from Student) a
 on a.id = st.student
 ) b
 on 
 cl.id = b.class
 where name like '10%'

--task11 (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/20

select status, member_name, costs
from FamilyMembers fm JOIN 
( 
SELECT family_member, sum(amount*unit_price) as costs
from Payments p right JOIN 
(
select good_id
from GoodTypes gt RIGHT JOIN Goods g on 
gt.good_type_id = g.type
where good_type_name = 'entertainment'
) a
ON p.good = a.good_id
GROUP BY family_member
) b 
on fm.member_id = b.family_member

--task12  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/55

delete from Company
where id in 
(
SELECT company
FROM (
SELECT company, DENSE_RANK() OVER(ORDER BY qnt) as dense_rnk
from 
(
SELECT company, count(company) as qnt
from Trip
GROUP BY company
) a 
) b
where dense_rnk = 1
)

--task13  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/45

select distinct classroom
from (
SELECT classroom, count, DENSE_RANK() OVER(ORDER BY count DESC) dense_rnk
from (
select classroom, count(*) over(partition by classroom) count
FROM Schedule
) a
) b 
where dense_rnk = 1

--task14  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/43

SELECT last_name
FROM Teacher t join Schedule sh ON 
t.id = sh.teacher
where subject LIKE  
(
SELECT DISTINCT subject
FROM subject su join Schedule sch on 
su.id = sch.subject
where su.name = 'Physical Culture'
)
ORDER BY last_name

--task15  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/63

SELECT concat(last_name, '.', SUBSTRING(first_name, 1, 1), '.',SUBSTRING(middle_name, 1, 1),'.') as name
from Student
order BY name
