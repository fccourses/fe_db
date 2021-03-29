/* 1NF */
create table test(
  v1 varchar(12),
  v2 int,
  primary key(v1, v2)
);
/*  */
insert into test
values ('test', 1),
  ('zxc', 2),
  ('test', 1);
/* 2NF */
create table positions(
  "name" varchar(64) primary key,
  car_availability
);
create table employees(
  id serial primary key,
  "name",
  department,
  position varchar(64) REFERENCES positions,
);
insert into employees(position, car_availability)
values ('HR', false),
  ('sales', false),
  ('developer', false),
  ('driver', true);
/* 3NF */
create table departments("name" primary key, phone_number);
create table employees(
  id primary key,
  "name",
  department varchar(64) references departments,
);
insert into employees("name", department, department_number)
values ('t1 f1', 'HR', '555-35-35'),
  ('t2 f2', 'Sales', '777-11-11'),
  ('t3 f3', 'Sales', '777-12-21');
/* BCNF */
/* 
 teachers
 students
 subjects
 
 teacher n:1 subjects
 students m:n subjects
 students m:n teachers
 */
create table students(id serial primary key);
create table subjects("name" varchar(64) primary key);
create table teachers(
  id primary key,
  "subject" varchar(64) references subjects
);
/*  */
create students_to_teachers(
  teacher_id int references teachers,
  student_id int references students,
  primary key(teacher_id, student_id)
);
insert into students_to_teachers
values (1, 1),
  (1, 2),
  (2, 1),
  (2, 2);
/* 4NF */
/* 
 
 restaurants
 pizza
 delivery_services
 */
create table pizzas("name" varchar(64) primary key);
create table restaurants (id serial primary key, "address" jsonb);
create table delivery_services (id serial primary key);
create table pizza_to_restaurant(
  pizza_name varchar(64) references pizzas,
  restaurant_id int references restaurants,
  primary key(pizza_name, restaurant_id)
);
create table restaurants_to_deliveries(
  restaurant_id int references restaurants,
  delivery_id int references delivery_services,
  primary key(restaurant_id, delivery_id)
);
insert into restaurants_to_deliveries
values (1, 1),
  (1, 2),
  (2, 1),
  (2, 3);
insert into restaurants(address)
values(
    '{"country":"Ukraine","city":"Zaporozhye","district":"Voznesenovskiy"}'
);














/*
  Необходимо спроектировать базу данных ПОСТАВКА ТОВАРОВ
  В БД должна храниться информация:
  - о ТОВАРАХ : код товара, наименование товара, цена товара
  - ЗАКАЗАХ на поставку товаров: код заказа, наименование заказчика, адрес заказчика, телефон,
  номер договора, дата заключения договора, наименование товара, плановая поставка (шт.);
  - фактических ОТГРУЗКАХ товаров: код отгрузки, код заказа, дата отгрузки,
  отгружено товара (шт.)
  При проектировании БД необходимо учитывать следующее:
  • товар имеет несколько заказов на поставку. Заказ соответствует одному товару;
  • товару могут соответствовать несколько отгрузок. В отгрузке могут участвовать несколько товаров.

  Кроме того следует учесть:
  • товар не обязательно имеет заказ. Каждому заказу обязательно соответствует товар;
  • товар не обязательно отгружается заказчику. Каждая отгрузка обязательно соответствует некоторому товару.
*/


















