/* 1NF */
create table relation_constr(
  v1 varchar(20),
  v2 varchar(20),
  primary key(v1, v2) -- 1 NF
);
insert into relation_constr
Values ('test', 'testovich'),
  ('validimir', 'testovich'),
  ('test', 'testovich'),
  ('test', 'testovich');
/* 2NF */
create table positions(
  position varchar(64) primary key,
  car_availability boolean not null
);
/*  */
create table employees(
  id serial primary key,
  position varchar(64) REFERENCES positions
);
/* 3NF */
create table departments (
  "department" varchar(64) primary key,
  "phone_department" char(11) not null unique
);
create table employees(
  id serial PRIMARY KEY,
  "name" varchar(64) not null,
  "department" varchar(64) references departments
);
/*  */
insert into func_dep
Values ('test testovich', 'HR', '555-35-35'),
  ('vlad testovich', 'HR', '555-35-35'),
  ('name surnamovich', 'Financial', '555-33-33');
/* BCNF */
/* 
 students
 teachers
 subjects
 
 teacher m:1 subject
 students m:n subjects
 studetns m:n teachers
 */
create table subjects(subject_name varchar(64) primary key);
create table students(id serial PRIMARY KEY);
create table teachers(
  id serial PRIMARY KEY,
  subject_name varchar(64) REFERENCES subjects
);
create table student_to_teacher(
  student_id int REFERENCes students,
  teacher_id int references teachers,
  primary key(student_id, teacher_id)
);
INSERT INTO student_to_teacher
values (1, 1),
  (1, 2),
  (2, 1),
  (2, 2);
/* 
 
 restaurant
 pizza-type
 delivery service
 
 4NF
 */
create table pizza(pizza_name varchar(64) primary key);
create table pizza_to_restaurant(
  pizza varchar(64) references pizza(pizza_name),
  restaurant_id int references restaurant,
  primary key(pizza_id, restaurant_id)
);
create table restaurants(
  id serial PRIMARY KEY,
  "name" varchar(64),
  "address" jsonb
);
create table delivery_service(id);
create table restaurants_to_deliveries(
  restaurant_id int,
  delivery_id int,
  primary key(restaurant_id, delivery_id)
);
insert into restaurant_to_deliveries
values (1, 1),
  (1, 2),
  (2, 3);
/*  */
SELECT *
FROM restaurants
  Join pizza_to_restaurant ON
  Join pizza ON
Where restaurant.id = 1;
/*  */
/* 
 
 product: price, name, code
 customer: name, address, phone_number
 contract: number, created_at
 order: code
 shipment: date, code
 
 
 customer 1:n contracts
 contracts 1:n orders
 orders m:n products
 shipment m:n orders
 
 shipment m:n products
 */
create table products (id, price, product_name, code);
create table customers(id, customer_name, address, phone_number);
create table contracts(id, customer_id, created_at);
create table orders(id, contract_id ref contracts);
create products_to_orders(product_id, order_id);
create table shipments (id, shipment_time);
create table shipment_to_orders_products(
  shipment_id,
  product_id,
  order_id,
  quantity check,
  fk() ref pto() primary key(shipment_id, product_id, order_id)
);