--����� ��: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1  (lesson6, �������������)
-- SQL: �������� ������� � �������������� ������� (10000 �����, 3 �������, ��� ���� int) � ��������� �� ���������� ������� �� 0 �� 1 000 000. ��������� EXPLAIN �������� � �������� ������� ��������.

create table random as 
select generate_series(1, 10000) as id
, cast (random() * 1000000 as int) as r1
, cast (random() * 1000000 as int) as r2
, cast (random() * 1000000 as int) as r3

explain 
select *
from random 
where r1 > 9999

explain analyze 
select *
from random 
where r1 > 9999

--task2 (lesson6, �������������)
-- GCP (Google Cloud Platform): ����� GCP ��������� ������ csv � ���� PSQL �� ������ ���������� (��������� ������ bash � ��������� bash) 
