--task1 (lesson5)
-- ������������ �����: ������� view (pages_all_products), � ������� ����� ������������ �������� ���� ��������� (�� ����� ���� ��������� �� ����� ��������). �����: ��� ������ �� laptop, ����� ��������, ������ ���� �������
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
-- ������������ �����: ������� view (distribution_by_type), � ������ �������� ����� ���������� ����������� ���� ������� �� ���� ����������. �����: �������������, ��� �������� (printer,pc or laptop) , ���������� ����������� ���������� ������� ������� ���� � ���������� ���� ������� �������������
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
-- ������������ �����: ������� �� ���� ����������� view ������ - �������� ���������

-� ��������� �����

--task4 (lesson5)
-- �������: ������� ����� ������� ships (ships_two_words), �� � �������� ������� ������ �������� �� ���� ����
create table ships_two_words as
select *
from ships
where name like '% %'

--task5 (lesson5)
-- �������: ������� ������ ��������, � ������� class ����������� (IS NULL) � �������� ���������� � ����� "S"
select *
from ships
where name like 'S%' and class is null 

--task6 (lesson5)
-- ������������ �����: ������� ��� �������� ������������� = 'A' �� ���������� ���� ������� �� ��������� ������������� = 'D' � ��� ����� ������� (����� ������� �������). ������� model

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
