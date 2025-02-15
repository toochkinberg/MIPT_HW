create database hw_1_customers_and_transactions;

create table product(
	 product_id int primary key not null
	,brand varchar(20)
	,product_line varchar(20)
	,product_class varchar(20)
	,product_size varchar(20)
	,list_price decimal(10, 2)
	,standard_cost decimal(10, 2)
);

create table customer(
	 customer_id int primary key not null
	,first_name varchar(20)
	,last_name varchar(20)
	,gender varchar(20)
	,DOB date
	,job_title varchar(50)
	,job_industry_category varchar(50)
	,wealth_segment varchar(20)
	,deceased_indicator bool
	,owns_car bool
	,address varchar(50)
	,postcode int
	,state varchar(20)
	,country varchar(20)
	,property_valuation int
);

create table transaction(
	 transaction_id int primary key not null
	,product_id int not null
	,customer_id int not null
	,transaction_date date
	,online_order bool
	,order_status varchar(20)
	,foreign key (product_id) references product(product_id)
	,foreign key (customer_id) references customer(customer_id)
);



-- Чтобы не пилить костыли, в customer данные импортируем через скрипт, чтобы столбцы с типом данных bool заполнились сами
-- Столбец deceased_indicator всё равно загрузится некорректно, потому что значения там не Yes/No или True/False
-- Для этого столбца можно было бы загрузить через временную таблицу или загрузить текстом в нужную таблицу, а потом с помощью case when проставить bool

copy customer(customer_id,first_name,last_name,gender,DOB,job_title,job_industry_category,wealth_segment,deceased_indicator,owns_car,address,postcode,state,country,property_valuation)
from 'C:\Main\Stud\MIPT\SQL\sets\cust_1-10.csv'
with (format csv, header true, delimiter ';')

