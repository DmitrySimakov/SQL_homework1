--task1 (lesson5)
-- Компьютерная фирма: Сделать view (pages_all_products), в которой будет постраничная разбивка всех продуктов (не более двух продуктов на одной странице). Вывод: все данные из laptop, номер страницы, список всех страниц
create view pages_all_products_v2 as
select code, maker, price, total,
	case
	when rn % 2 = 0 
	then rn/2 
	else rn/2 + 1 
	end as num_of_pages
from (
select *, count(*) over() total, row_number() over() rn
from (
	select * 
	from (
		select code, maker, price
		from PC join product
		on pc.model = product.model
		union 
		select code, maker, price
		from printer join product
		on printer.model = product.model
		union 
		select code, maker, price
		from laptop join product
		on laptop.model = product.model
		) a2
) a1
) a3

--task2 (lesson5)
-- Компьютерная фирма: Сделать view (distribution_by_type), в рамках которого будет процентное соотношение всех товаров по типу устройства. Вывод: производитель, тип продукта (printer,pc or laptop) , процентное соотношение количества товаров данного типа к количеству всех товаров производителя
create view distribution_by_type as
select distinct maker, type, ratio
from (
select *, (count(*) over(partition by type)) * 100 / count(*) over(partition by maker) as ratio
from product
where maker = 'A'
union
select *, (count(*) over(partition by type)) * 100 / count(*) over(partition by maker) as ratio
from product
where maker = 'B'
union
select *, (count(*) over(partition by type)) * 100 / count(*) over(partition by maker) as ratio
from product
where maker = 'C'
union
select *, (count(*) over(partition by type)) * 100 / count(*) over(partition by maker) as ratio
from product
where maker = 'D'
union
select *, (count(*) over(partition by type)) * 100 / count(*) over(partition by maker) as ratio
from product
where maker = 'E'
) a
order by maker

--task3 (lesson5)
-- Компьютерная фирма: Сделать на базе предыдущенр view график - круговую диаграмму

-в отдельном файле

--task4 (lesson5)
-- Корабли: Сделать копию таблицы ships (ships_two_words), но у название корабля должно состоять из двух слов
create table ships_two_words as
select *
from ships
where name like '% %'

--task5 (lesson5)
-- Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL) и название начинается с буквы "S"
select *
from ships
where name like 'S%' and class is null 

--task6 (lesson5)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и три самых дорогих (через оконные функции). Вывести model

select model
	from (
	select printer.model, row_number() over (order by price desc) max_price
	from printer join product
	on printer.model = product.model
	) a
	where max_price < 4
union 
	select printer.model
	from printer join product
	on printer.model = product.model
	where maker = 'A'
	and price > (
		select distinct avg(price) over (partition by maker) avg_price
		from printer join product
		on printer.model = product.model
		where maker = 'D'
		)
