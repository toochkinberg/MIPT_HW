-- 1. Создать таблицы со следующими структурами и загрузить данные из csv-файлов. Детали приведены ниже.

create table customer(
	 customer_id int primary key
	,first_name varchar(50)
	,last_name varchar(50)
	,gender varchar(30)
	,dob date
	,job_title varchar(50)
	,job_industry_category varchar(50)
	,wealth_segment varchar(50)
	,deceased_indicator varchar(50)
	,owns_car varchar(30)
	,address varchar(50)
	,postcode varchar(30)
	,state varchar(30)
	,country varchar(30)
	,property_valuation int
)

create table transaction(
	 transaction_id int primary key
	,product_id int
	,customer_id int
	,transaction_date date
	,online_order varchar(30)
	,order_status varchar(30)
	,brand varchar(30)
	,product_line varchar(30)
	,product_class varchar(30)
	,product_size varchar(30)
	,list_price float
	,standard_cost float
)

-- 2. Выполнить следующие запросы:
-- (1 балл) Вывести все уникальные бренды, у которых стандартная стоимость выше 1500 долларов.

select distinct brand
from transaction t
where t.standard_cost > 1500


-- (1 балл) Вывести все подтвержденные транзакции за период '2017-04-01' по '2017-04-09' включительно.

select *
from transaction t
where 
	  t.order_status = 'Approved'and 
	  t.transaction_date between '2017-04-01' and '2017-04-09'


-- (1 балл) Вывести все профессии у клиентов из сферы IT или Financial Services, которые начинаются с фразы 'Senior'.
	  
select distinct(job_title)
from customer c
where
	c.job_industry_category in ('IT', 'Financial Services')
	and c.job_title like 'Senior%'
	

-- (1 балл) Вывести все бренды, которые закупают клиенты, работающие в сфере Financial Services
	
select distinct(brand)
from customer c
left join transaction t
	on c.customer_id = t.customer_id
where
	job_industry_category = 'Financial Services'
	and brand is not null
	and brand != ''

	
-- (1 балл) Вывести 10 клиентов, которые оформили онлайн-заказ продукции из брендов 'Giant Bicycles', 'Norco Bicycles', 'Trek Bicycles'.
	
select distinct(c.customer_id), first_name, last_name
from customer c
left join transaction t
	on c.customer_id = t.customer_id
where
	online_order = 'True'
	and brand in ('Giant Bicycles', 'Norco Bicycles', 'Trek Bicycles')
limit 10


-- (1 балл) Вывести всех клиентов, у которых нет транзакций.

select c.customer_id, first_name, last_name
from customer c
left join transaction t
	on c.customer_id = t.customer_id
where
	transaction_id is null
	

-- (2 балла) Вывести всех клиентов из IT, у которых транзакции с максимальной стандартной стоимостью.
	
select c.customer_id, first_name, last_name, t.standard_cost
from customer c
left join transaction t
	on c.customer_id = t.customer_id
where
	c.job_industry_category = 'IT'
	and t.standard_cost = (select max(coalesce(standard_cost, 0)) from transaction)
	

-- (2 балла) Вывести всех клиентов из сферы IT и Health, у которых есть подтвержденные транзакции за период '2017-07-07' по '2017-07-17'.
	
select c.customer_id, c.first_name, c.last_name
from customer c
left join "transaction" t
	on c.customer_id = t.customer_id
where
	c.job_industry_category in ('IT', 'Health')
	and t.order_status = 'Approved'
	and t.transaction_date between '2017-07-07' and '2017-07-17'