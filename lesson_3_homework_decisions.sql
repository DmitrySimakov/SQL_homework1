--task1
--Корабли: Для каждого класса определите число кораблей этого класса, потопленных в сражениях. Вывести: класс и число потопленных кораблей.
select  
case
	when class is null
	then 'класс не определен'
	else class
end ship_class, 
count(result) as qnt_sunk	
from ships sh right join outcomes out on
sh.name = out.ship
where result = 'sunk'
group by class

--task2
--Корабли: Для каждого класса определите год, когда был спущен на воду первый корабль этого класса. Если год спуска на воду головного корабля неизвестен, определите минимальный год спуска на воду кораблей этого класса. Вывести: класс, год.
select cl.class, min(sh.launched)
from classes cl left join ships sh
on cl.class = sh.class
group by cl.class


--task3
--Корабли: Для классов, имеющих потери в виде потопленных кораблей и не менее 3 кораблей в базе данных, вывести имя класса и число потопленных кораблей.
select class, count(class) sunked_ship
from (select cl.class, out.ship from classes cl join outcomes out on 
cl.class = out.ship 
where out.result = 'sunk' 
union 
select sh.class, out.ship 
from outcomes out join ships sh on 
sh.name = out.ship 
where out.result = 'sunk') a

where class in (select distinct b.class 
from  (select cl.class, out.ship from classes as cl join outcomes as out on 
cl.class = out.ship 
union 
select cl.class, sh.name from classes cl join ships sh on cl.class = sh.class) b 
group by b.class 
having count(b.class) >= 3)  group by class

--task4
--Корабли: Найдите названия кораблей, имеющих наибольшее число орудий среди всех кораблей такого же водоизмещения (учесть корабли из таблицы Outcomes).

select displacement, max(numGuns) as max_numGuns
from (select a.ship, a.class, numGuns, displacement
from classes right join
(select ship, class
from outcomes left join ships
on outcomes.ship = ships.name
union
select name as ships, class
from ships) as a
on classes.class = a.class) as b
group by displacement

--задать вопрос


--task5
--Компьютерная фирма: Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM и с самым быстрым процессором среди всех ПК, имеющих наименьший объем RAM. Вывести: Maker
select distinct maker
from product
where maker in(select p.maker from product p join pc
on p.model = pc.model
where ram = (select min(ram)
from pc) and pc.speed = (select max(speed)
from pc where speed in (select speed 
from pc where ram =(select min(ram)from pc))))
and type = 'printer'

