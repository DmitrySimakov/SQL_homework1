--����� ��: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task13 (lesson3)
--������������ �����: ������� ������ ���� ��������� � ������������� � ��������� ���� �������� (pc, printer, laptop). �������: model, maker, type
Select distinct model, maker, type
from product

--task14 (lesson3)
--������������ �����: ��� ������ ���� �������� �� ������� printer ������������� ������� ��� ���, � ���� ���� ����� ������� PC - "1", � ��������� - "0"
Select distinct model, maker, type
from product
--task14
--������������ �����: ��� ������ ���� �������� �� ������� printer ������������� ������� ��� ���, � ���� ���� ����� ������� PC - "1", � ��������� - "0"
select * ,
case
	when price > 
	(select avg(price) from PC)
	then 1
	else 0
end flag
from printer

--task15 (lesson3)
--�������: ������� ������ ��������, � ������� class ����������� (IS NULL)
select name
from ships
where class is null

--task16 (lesson3)
--�������: ������� ��������, ������� ��������� � ����, �� ����������� �� � ����� �� ����� ������ �������� �� ����.
select name
from battles
where date not in
(select launched
from ships
where launched is not null)


--task17 (lesson3)
--�������: ������� ��������, � ������� ����������� ������� ������ Kongo �� ������� Ships.
select battle
from ships sh join 
(select ship, battle from battles join outcomes on
battles.name = outcomes.battle) outcomes
on sh.name = outcomes.ship
where class = 'Kongo'


--task1  (lesson4)
-- ������������ �����: ������� view (�������� all_products_flag_300) ��� ���� ������� (pc, printer, laptop) � ������, ���� ��������� ������ > 300. �� view ��� �������: model, price, flag
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
-- ������������ �����: ������� view (�������� all_products_flag_avg_price) ��� ���� ������� (pc, printer, laptop) � ������, ���� ��������� ������ c������ . �� view ��� �������: model, price, flag

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
-- ������������ �����: ������� ��� �������� ������������� = 'A' �� ���������� ���� ������� �� ��������� ������������� = 'D' � 'C'. ������� model

select printer.model
from printer left join product on
printer.model = product.model
where (maker = 'A') and
price > (select avg(price) 
	from printer left join product on
	printer.model = product.model
	where maker in ('D', 'C'))


--task4 (lesson4)
-- ������������ �����: ������� ��� ������ ������������� = 'A' �� ���������� ���� ������� �� ��������� ������������� = 'D' � 'C'. ������� model
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
-- ������������ �����: ����� ������� ���� ����� ���������� ��������� ������������� = 'A' (printer & laptop & pc)

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
-- ������������ �����: ������� view � ����������� ������� (�������� count_products_by_makers) �� ������� �������������. �� view: maker, count
create view count_products_by_makers2 as 
(select maker, count(model) count_ from product
group by maker)


--task7 (lesson4)
-- �� ����������� view (count_products_by_makers) ������� ������ � colab (X: maker, y: count)

--task8 (lesson4)
-- ������������ �����: ������� ����� ������� printer (�������� printer_updated) � ������� �� ��� ��� �������� ������������� 'D'
create table printer_updated as (select *
from printer)
delete from printer_updated
where model in (select product.model
from product join printer_updated
on product.model = printer_updated.model 
where product.maker = 'D')



--task9 (lesson4)
-- ������������ �����: ������� �� ���� ������� (printer_updated) view � �������������� �������� ������������� (�������� printer_updated_with_makers)
create view printer_updated_with_makers as  (select printer_updated.*, product.maker
from printer_updated left join 
product on printer_updated.model = product.model)



--task10 (lesson4)
-- �������: ������� view c ����������� ����������� �������� � ������� ������� (�������� sunk_ships_by_classes). �� view: count, class (���� �������� ������ ���/IS NULL, �� �������� �� 0)
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
-- �������: �� ����������� view (sunk_ships_by_classes) ������� ������ � colab (X: class, Y: count)

--task12 (lesson4)
-- �������: ������� ����� ������� classes (�������� classes_with_flag) � �������� � ��� flag: ���� ���������� ������ ������ ��� ����� 9 - �� 1, ����� 0
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
-- �������: ������� ������ � colab �� ������� classes � ����������� ������� �� ������� (X: country, Y: count)

--task14 (lesson4)
-- �������: ������� ���������� ��������, � ������� �������� ���������� � ����� "O" ��� "M".


select count(name)
from ships
where name like 'O%' or name like 'M%'


--task15 (lesson4)
-- �������: ������� ���������� ��������, � ������� �������� ������� �� ���� ����.

select count(name)
from ships
where name like '% %'

--task16 (lesson4)
-- �������: ��������� ������ � ����������� ���������� �� ���� �������� � ����� ������� (X: year, Y: count)
