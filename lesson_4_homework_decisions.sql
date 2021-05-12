--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task13 (lesson3)
--Компьютерная фирма: Вывести список всех продуктов и производителя с указанием типа продукта (pc, printer, laptop). Вывести: model, maker, type
Select distinct model, maker, type
from product

--task14 (lesson3)
--Компьютерная фирма: При выводе всех значений из таблицы printer дополнительно вывести для тех, у кого цена вышей средней PC - "1", у остальных - "0"
Select distinct model, maker, type
from product
--task14
--Компьютерная фирма: При выводе всех значений из таблицы printer дополнительно вывести для тех, у кого цена вышей средней PC - "1", у остальных - "0"
select * ,
case
	when price > 
	(select avg(price) from PC)
	then 1
	else 0
end flag
from printer

--task15 (lesson3)
--Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL)
select name
from ships
where class is null

--task16 (lesson3)
--Корабли: Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду.
select name
from battles
where date not in
(select launched
from ships
where launched is not null)


--task17 (lesson3)
--Корабли: Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.
select battle
from ships sh join 
(select ship, battle from battles join outcomes on
battles.name = outcomes.battle) outcomes
on sh.name = outcomes.ship
where class = 'Kongo'


--task1  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_300) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше > 300. Во view три колонки: model, price, flag
create view all_products_flag_300 as 
	(
	select model, price, 
	case
		when price > 300
		then 1
		else 0
	end flag
	from
	(
			select product.model, price
			from pc
			join product
			on pc.model = product.model
		union
			select product.model, price
			from printer
			join product
			on printer.model = product.model
		union
			select product.model, price
			from laptop
			join product
			on laptop.model = product.model
	) a
	)
		
--task2  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_avg_price) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше cредней . Во view три колонки: model, price, flag

create view all_products_flag_avg_price as 
	(WITH
A_table AS (select product.model, price
	from pc
	join product
	on pc.model = product.model
union
	select product.model, price
	from printer
	join product
	on printer.model = product.model
union
	select product.model, price
	from laptop
	join product
	on laptop.model = product.model
	)
	select model, price, 
	case
		when price > (select avg(price) from A_table)
		then 1
		else 0
	end flaggg
	from A_table
	)
	

--task3  (lesson4)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model

select printer.model
from printer left join product on
printer.model = product.model
where (maker = 'A') and
price > (select avg(price) 
	from printer left join product on
	printer.model = product.model
	where maker in ('D', 'C'))


--task4 (lesson4)
-- Компьютерная фирма: Вывести все товары производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model
with B_table
as (select product.model, product.maker, product.type, price
	from pc
	join product
	on pc.model = product.model
union
	select product.model, product.maker, product.type, price
	from printer
	join product
	on printer.model = product.model
union
	select  product.model, product.maker, product.type, price
	from laptop
	join product
	on laptop.model = product.model
	)
select model
from B_table
where (maker = 'A')
and (price > (select avg(price) from B_table where (type = 'Printer') and (maker in ('D', 'C'))))

	
--task5 (lesson4)
-- Компьютерная фирма: Какая средняя цена среди уникальных продуктов производителя = 'A' (printer & laptop & pc)

select avg(price)
from (select product.model, product.maker, price
	from pc
	join product
	on pc.model = product.model
union
	select product.model, product.maker, price
	from printer
	join product
	on printer.model = product.model
union
	select  product.model, product.maker, price
	from laptop
	join product
	on laptop.model = product.model
	) a
where maker = 'A'

--task6 (lesson4)
-- Компьютерная фирма: Сделать view с количеством товаров (название count_products_by_makers) по каждому производителю. Во view: maker, count
create view count_products_by_makers2 as 
(select maker, count(model) count_ from product
group by maker)


--task7 (lesson4)
-- По предыдущему view (count_products_by_makers) сделать график в colab (X: maker, y: count)

--task8 (lesson4)
-- Компьютерная фирма: Сделать копию таблицы printer (название printer_updated) и удалить из нее все принтеры производителя 'D'
create table printer_updated as (select *
from printer)
delete from printer_updated
where model in (select product.model
from product join printer_updated
on product.model = printer_updated.model 
where product.maker = 'D')



--task9 (lesson4)
-- Компьютерная фирма: Сделать на базе таблицы (printer_updated) view с дополнительной колонкой производителя (название printer_updated_with_makers)
create view printer_updated_with_makers as  (select printer_updated.*, product.maker
from printer_updated left join 
product on printer_updated.model = product.model)



--task10 (lesson4)
-- Корабли: Сделать view c количеством потопленных кораблей и классом корабля (название sunk_ships_by_classes). Во view: count, class (если значения класса нет/IS NULL, то заменить на 0)
create view sunk_ships_by_classes as
(
select count(outcomes.ship) count_,
	case
		when ships.class IS NULL
		then '0'
		else ships.class
	end class_
from outcomes left join ships on outcomes.ship = ships.name
where result = 'sunk'
group by class
)

--task11 (lesson4)
-- Корабли: По предыдущему view (sunk_ships_by_classes) сделать график в colab (X: class, Y: count)

--task12 (lesson4)
-- Корабли: Сделать копию таблицы classes (название classes_with_flag) и добавить в нее flag: если количество орудий больше или равно 9 - то 1, иначе 0
create table classes_with_flag as
(
select *, case
when numguns >= 9
then 1
else 0
end flag
from classes
)

--task13 (lesson4)
-- Корабли: Сделать график в colab по таблице classes с количеством классов по странам (X: country, Y: count)

--task14 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название начинается с буквы "O" или "M".


select count(name)
from ships
where name like 'O%' or name like 'M%'


--task15 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название состоит из двух слов.

select count(name)
from ships
where name like '% %'

--task16 (lesson4)
-- Корабли: Построить график с количеством запущенных на воду кораблей и годом запуска (X: year, Y: count)
