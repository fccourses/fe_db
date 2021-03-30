-- •Добавлять столбцы
ALTER TABLE tasks
ADD COLUMN deadline timestamp NOT NULL CHECK(deadline >= current_timestamp) DEFAULT current_timestamp;
ALTER TABLE tasks
ADD COLUMN test int;
-- •Удалять столбцы
ALTER TABLE tasks DROP COLUMN test;
-- •Добавлять ограничения
ALTER TABLE tasks
ADD CONSTRAINT constraint_name CHECK(task != '');
/*  */
ALTER TABLE tasks
ALTER COLUMN deadline
SET NOT NULL;
-- •Удалять ограничения
ALTER TABLE tasks DROP CONSTRAINT constraint_name;
/*  */
ALTER TABLE tasks
ALTER COLUMN deadline DROP NOT NULL;
-- •Изменять значения по умолчанию
ALTER TABLE tasks
ALTER COLUMN isdone DROP DEFAULT;
/*  */
ALTER TABLE tasks
ALTER COLUMN isdone
SET DEFAULT false;
-- •Изменять типы столбцов
ALTER TABLE tasks
ALTER COLUMN task TYPE text;
-- •Переименовывать столбцы
ALTER TABLE tasks
  RENAME COLUMN task TO body;
-- •Переименовывать таблицы
ALTER TABlE tasks
  RENAME TO user_tasks;
/* 
 1) new db. connect to db
 
 2) 
 users: login, email, password
 employees: salary, department, position, hire_date
 
 3) 
 change users table: DROP password, ADD password_hash
 
 4)
 users <=> employees
 
 */
CREATE SCHEMA task1;
/*  */
CREATE TABLE task1.users(
  id serial PRIMARY KEY,
  login varchar(16) NOT NULL CHECK(login != ''),
  email varchar(256) NOT NULL UNIQUE CHECK(email != ''),
  password text
);
/*  */
CREATE TABLE task1.employee(
  salary numeric(10, 2) NOT NULL CHECK (salary >= 0),
  department varchar(64) NOT NULL,
  position varchar(64) NOT NULL,
  hire_date timestamp NOT NULL DEFAULT current_timestamp
);
/*  */
ALTER TABLE task1.users DROP COLUMN "password";
/*  */
ALTER TABLE task1.users
ADD COLUMN password_hash text NOT NULL CHECK (password_hash != '');
/*  */
ALTER TABLE task1.employee
ADD COLUMN user_id int PRIMARY KEY REFERENCES task1.users;
/*  */
INSERT INTO task1.users (login, email, password_hash)
VALUES (
    'test1',
    'test1@gmail.com',
    'OUGFHIf247fgb2euif29-8fH-==1==12dikvlEDmkvL'
  ),
  (
    'test2',
    'test2@gmail.com',
    'OUGFHIf247fgb2euif29-8fH-==1==12dikvlEDmkvL'
  ),
  (
    'test3',
    'test3@gmail.com',
    'OUGFHIf247fgb2euif29-8fH-==1==12dikvlEDmkvL'
  ),
  (
    'test4',
    'test4@gmail.com',
    'OUGFHIf247fgb2euif29-8fH-==1==12dikvlEDmkvL'
  ),
  (
    'test5',
    'test5@gmail.com',
    'OUGFHIf247fgb2euif29-8fH-==1==12dikvlEDmkvL'
  ),
  (
    'test6',
    'test6@gmail.com',
    'OUGFHIf247fgb2euif29-8fH-==1==12dikvlEDmkvL'
  );
/*  */
INSERT INTO task1.employee (
    salary,
    department,
    position,
    hire_date,
    user_id
  )
VALUES (
    10000,
    'development',
    'senior developer',
    '1990-1-1',
    1
  ),
  (
    6000,
    'development',
    'senior developer',
    '2010-1-1',
    2
  ),
  (
    1000,
    'HR',
    'hr',
    '2020-1-1',
    3
  ),
  (
    1000,
    'Sales',
    'manager',
    '2019-1-1',
    4
  );
/*
 1. ВСЕХ users с их зарплатой 
 2. users, которые не сотрудники
 */
SELECT u.*,
  COALESCE(e.salary, 0)
FROM task1.users u
  LEFT JOIN task1.employee e ON e.user_id = u.id;
-- TRUNCATE TABLE task1.employee;
SELECT *
FROM task1.users u
WHERE u.id NOT IN (
    SELECT e.user_id
    FROM task1.employee e
  );
/* 
 WINDOW FUNCTIONS 
 */
CREATE SCHEMA wf;
/*  */
DROP TAble wf.employees;
DROP TAble wf.departments;
/*  */
CREATE TABLE wf.employees(
  id serial PRIMARY KEY,
  "name" varchar(256) NOT NULL CHECK("name" != ''),
  salary numeric(10, 2) NOT NULL CHECK (salary >= 0),
  hire_date timestamp NOT NULL DEFAULT current_timestamp,
  department_id int REFERENCES wf.departments ON DELETE CASCADE ON UPDATE NO ACTION
);
/*  */
CREATE TABLE wf.departments(
  id serial PRIMARY KEY,
  "name" varchar(64) NOT NULL
);
/*  */
INSERT INTO wf.departments("name")
VALUES ('SALES'),
  ('HR'),
  ('DEVELOPMENT'),
  ('QA'),
  ('TOP MANAGEMENT');
INSERT INTO wf.employees ("name", salary, hire_date, department_id)
VALUES ('TEST TESTov', 10000, '1990-1-1', 1),
  ('John Doe', 6000, '2010-1-1', 2),
  ('Matew Doe', 3456, '2020-1-1', 2),
  ('Matew Doe1', 53462, '2020-1-1', 3),
  ('Matew Doe2', 124543, '2012-1-1', 4),
  ('Matew Doe3', 12365, '2004-1-1', 5),
  ('Matew Doe4', 1200, '2000-8-1', 5),
  ('Matew Doe5', 2535, '2010-1-1', 2),
  ('Matew Doe6', 1000, '2014-1-1', 3),
  ('Matew Doe6', 63456, '2017-6-1', 1),
  ('Matew Doe7', 1000, '2020-1-1', 3),
  ('Matew Doe8', 346434, '2015-4-1', 2),
  ('Matew Doe9', 3421, '2018-1-1', 3),
  ('Matew Doe0', 34563, '2013-2-1', 5),
  ('Matew Doe10', 2466, '2011-1-1', 1),
  ('Matew Doe11', 9999, '1999-1-1', 5),
  ('TESTing 1', 1000, '2019-1-1', 2);
/*  */
SELECT d.name,
  count(e.id)
FROM wf.departments d
  JOIN wf.employees e ON e.department_id = d.id
GROUP BY d.id;
/*  */
SELECT e.*,
  d.name
FROM wf.departments d
  JOIN wf.employees e ON e.department_id = d.id
  /*  */
SELECT avg(e.salary),
  d.id
FROM wf.departments d
  JOIN wf.employees e ON e.department_id = d.id
GROUP BY d.id;
/* JOIN
 user|dep|avg dep salary
 
 */
SELECT e.*,
  d.name,
  "d_a_s"."avg_salary"
FROM wf.departments d
  JOIN wf.employees e ON e.department_id = d.id
  JOIN (
    SELECT avg(e.salary) AS "avg_salary",
      d.id
    FROM wf.departments d
      JOIN wf.employees e ON e.department_id = d.id
    GROUP BY d.id
  ) AS "d_a_s" ON d.id = d_a_s.id;
/* WINDOW FUNC 
 user|dep|avg dep salary
 */
SELECT e.*,
  d.name,
  round(
    avg(e.salary) OVER (
      PARTITION BY d.id
      ORDER BY e.salary ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    )
  ) as "avg_dep_salary",
  avg(e.salary) OVER ()
FROM wf.departments d
  JOIN wf.employees e ON e.department_id = d.id;
/* Сумма зарплаты на весь отдел. Сколько денег уходит на з/п всем рабочим */
SELECT e.*,
  d.name,
  round(
    sum(e.salary) OVER (
      PARTITION BY d.id
      ORDER BY e.salary ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    )
  ) as "avg_dep_salary",
  sum(e.salary) OVER ()
FROM wf.departments d
  JOIN wf.employees e ON e.department_id = d.id;
/* phones */
delete from users
where users.id = 5; -- restrict deletion
/*  */

delete from wf.employees
where wf.employees.id = 3;

delete from wf.departments
where id = 3;