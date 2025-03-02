-- Создать таблицы со следующими структурами и загрузить данные из csv-файлов (описание приведено ниже);

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
);

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
);


-- Выполнить следующие запросы:
-- Вывести распределение (количество) клиентов по сферам деятельности, отсортировав результат по убыванию количества. — (1 балл)

select job_industry_category, count(*) as client_count
from customer
group by job_industry_category
order by client_count desc;


-- Найти сумму транзакций за каждый месяц по сферам деятельности, отсортировав по месяцам и по сфере деятельности. — (1 балл)
-- Я понял, что сумма транзакций это сколько было заплачено за транзакции в период (list_price)

select
	date_trunc('month', transaction_date) as month
	,c.job_industry_category
	,sum(list_price) as sum
from 
	transaction t
join 
	customer c on c.customer_id = t.customer_id
group by 
	c.job_industry_category
	,date_trunc('month', transaction_date)
order by 
	month
	,c.job_industry_category;

-- Также задачу можно интерпретировать как сумму (количество) транзакций:

select
	date_trunc('month', transaction_date) as month
	,c.job_industry_category
	,count(list_price) as sum
from 
	transaction t
join 
	customer c on c.customer_id = t.customer_id
group by 
	c.job_industry_category
	,date_trunc('month', transaction_date)
order by 
	month
	,c.job_industry_category;


-- Вывести количество онлайн-заказов для всех брендов в рамках подтвержденных заказов клиентов из сферы IT. — (1 балл)

select
	t.brand
	,count(*) as quantity
from 
	transaction t
join 
	customer c on c.customer_id = t.customer_id
where
	t.online_order = 'True'
	and t.order_status = 'Approved'
	and c.job_industry_category = 'IT'
group by
	t.brand

	
-- Найти по всем клиентам сумму всех транзакций (list_price), максимум, минимум и количество транзакций, отсортировав результат 
-- по убыванию суммы транзакций и количества клиентов. Выполните двумя способами: используя только group by и используя только 
-- оконные функции. Сравните результат. — (2 балла)

select
	c.customer_id
	,c.first_name
	,c.last_name
	,sum(t.list_price) as sum_price
	,min(t.list_price) as min_price
	,max(t.list_price) as max_price
	,count(*) as quantity
from
	transaction t
join 
	customer c on c.customer_id = t.customer_id
group by
	c.customer_id
order by
	sum_price desc
	,quantity desc;

-- Только оконные функции

select distinct
	c.customer_id
	,c.first_name
	,c.last_name
	,sum(t.list_price) over (partition by c.customer_id) as sum_price
	,min(t.list_price) over (partition by c.customer_id) as min_price
	,max(t.list_price) over (partition by c.customer_id) as max_price
	,count(*) over (partition by c.customer_id) as quantity
from
	transaction t
join 
	customer c on c.customer_id = t.customer_id
order by
	sum_price desc
	,quantity desc;


-- Найти имена и фамилии клиентов с минимальной/максимальной суммой транзакций за весь период (сумма транзакций не может быть null). 
-- Напишите отдельные запросы для минимальной и максимальной суммы. — (2 балла)

-- min

with customer_transaction_sum as (
	select
		c.customer_id,
		c.first_name,
		c.last_name,
		sum(t.list_price) as total_sum
	from
		transaction t
	join 
		customer c on c.customer_id = t.customer_id
	group by
		c.customer_id
)
select
	first_name,
	last_name,
	total_sum
from
	customer_transaction_sum
where
	total_sum = (select min(total_sum) from customer_transaction_sum)

-- max	
	
with customer_transaction_sum as (
	select
		c.customer_id,
		c.first_name,
		c.last_name,
		sum(t.list_price) as total_sum
	from
		transaction t
	join 
		customer c on c.customer_id = t.customer_id
	group by
		c.customer_id
)
select
	first_name,
	last_name,
	total_sum
from
	customer_transaction_sum
where
	total_sum = (select max(total_sum) from customer_transaction_sum)
	
	
-- Вывести только самые первые транзакции клиентов. Решить с помощью оконных функций. — (1 балл)

with first_transaction as (
	select
		c.customer_id,
        c.first_name,
        c.last_name,
        t.transaction_id,
        t.transaction_date,
        row_number() over(partition by c.customer_id order by t.transaction_date) as rn
    from
    	transaction t
    join 
        customer c on c.customer_id = t.customer_id
)
select 
	customer_id,
	first_name,
	last_name,
	transaction_id as first_transaction_id,
	transaction_date as first_transaction_date
from
	first_transaction
where
	rn = 1
