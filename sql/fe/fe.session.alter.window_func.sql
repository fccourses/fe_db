create table user_tasks (
  id serial not null constraint tasks_pkey primary key,
  userid integer constraint tasks_userid_fkey references users,
  body text not null,
  isdone boolean default false,
  deadline timestamp default CURRENT_TIMESTAMP not null constraint tasks_deadline_check check (deadline >= CURRENT_TIMESTAMP)
);
INSERT INTO user_tasks (userid, body, isdone, deadline)
VALUES (1, 'test', false, '2022-1-1');
-- •Добавлять столбцы
ALTER TABLE user_tasks
ADD COLUMN createdAt timestamp NOT NULL DEFAULT current_timestamp;
ALTER TABLE user_tasks
ADD COLUMN test int;
-- •Удалять столбцы
ALTER TABLE user_tasks DROP COLUMN test;
-- •Добавлять ограничения
ALTER TABLE user_tasks
ADD CONSTRAINT tasks_createdAt_check CHECK(createdAt <= current_timestamp);
ALTER TABLE user_tasks
ALTER COLUMN createdAt
SET NOT NULL;
-- •Удалять ограничения
ALTER TABLE user_tasks DROP CONSTRAINT tasks_createdAt_check;
ALTER TABLE user_tasks
ALTER COLUMN createdAt DROP NOT NULL;
-- •Изменять значения по умолчанию
ALTER TABLE user_tasks
ALTER COLUMN isdone DROP DEFAULT;
ALTER TABLE user_tasks
ALTER COLUMN isdone
SET DEFAULT false;
-- •Изменять типы столбцов
ALTER TABLE user_tasks
ALTER COLUMN body TYPE varchar(512);
-- •Переименовывать столбцы
ALTER TABLE user_tasks
  RENAME COLUMN isdone TO status;
-- •Переименовывать таблицы
ALTER TABLE user_tasks
  RENAME TO tasks;
/*  */
CREATE TYPE task_status AS ENUM ('done', 'processing', 'unstarted');
/*  */
create or replace function to_status(v boolean) returns task_status language plpgsql as $$
declare result task_status;
begin
select (
    CASE
      WHEN v THEN 'done'
      WHEN NOT v THEN 'unstarted'
      ELSE 'processing'
    END
  ) into result;
return result;
end;
$$
/*  */
CREATE CAST (boolean AS task_status) WITH FUNCTION to_status(boolean) as IMPLICIT;
/*  */
ALTER TABLE tasks
ALTER COLUMN status TYPE task_status USING (status::task_status);
/* 
 users: login, email, password
 employees: salary, department, position, 
 hire_date, name
 */
create schema pjt;
create table pjt.users(
  id serial primary key,
  login varchar(16) NOT NULL CHECK (login != ''),
  email varchar(256) NOT NULL CHECK (email != ''),
  password varchar(32)
);
/*  */
create table pjt.employees(
  salary numeric(10, 2) NOT NULL CHECK (salary >= 0),
  department varchar(64) NOT NULL CHECK(department != ''),
  position varchar(64) NOT NULL CHECK (position != ''),
  hire_date date NOT NULL CHECK (hire_date <= current_timestamp),
  name varchar(128) NOT NULL CHECK(name != '')
);
/*  */
ALTER TABLE pjt.users
ADD UNIQUE("login");
/*  */
ALTER TABLE pjt.users
ADD UNIQUE("email");
/* 
 change user table: delete password column, create column password_hash
 */
ALTER TABLE pjt.users DROP COLUMN "password";
/*  */
ALTER TABLE pjt.users
ADD COLUMN "password_hash" text NOT NULL;
/* users  1  <=>  0..1  employees. alter */
ALTER TABLE pjt.employees
ADD COLUMN user_id int PRIMARY KEY REFERENCES pjt.users;
/*  */
ALTER TABLE pjt.employees DROP COLUMN "name";
/*  */
INSERT INTO pjt.users (login, email, password_hash)
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
INSERT INTO pjt.employees (
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
/* ВСЕХ users с инфой об  их зарплате. */
SELECT u.*,
  COALESCE(e.salary, 0) AS "salary"
FROM pjt.users u
  LEFT JOIN pjt.employees e ON e.user_id = u.id;
/* Пользователи, которые не сотрудники. */
SELECT *
FROM pjt.users u
WHERE u.id NOT IN(
    SELECT user_id
    FROM pjt.employees
  );
/* ================ */
CREATE SCHEMA wf;
create table wf.departments(
  id serial primary key,
  name varchar(64) NOT NULL
);
/*  */
drop table wf.employees;
create table wf.employees(
  id serial primary key,
  department_id int REFERENCES wf.departments ON DELETE CASCADE,
  name varchar(128) NOT NULL,
  hire_date date NOT NULL CHECK(hire_date <= current_timestamp),
  salary numeric(10, 2) NOT NULL CHECK(salary >= 0)
);
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
/* Кол-во Сотрудников в отделах */
SELECT count(e.id),
  d.name
FROM wf.departments d
  JOIN wf.employees e ON e.department_id = d.id
GROUP BY d.id;
/* СОТРУДНИК И НАЗВАНИЕ ОТДЕЛА */
SELECT e.*,
  d.name
FROM wf.departments d
  JOIN wf.employees e ON e.department_id = d.id
  /* Средняя з\п по отделам */
SELECT avg(e.salary) AS "avg_salary",
  d.name,
  d.id
FROM wf.departments d
  JOIN wf.employees e ON e.department_id = d.id
GROUP BY d.id;
/* user info | dep info | avg salary by dep  */
SELECT e.*,
  d.*,
  das.avg_salary
FROM wf.departments d
  JOIN wf.employees e ON e.department_id = d.id
  JOIN (
    SELECT avg(e.salary) AS "avg_salary",
      d.name,
      d.id
    FROM wf.departments d
      JOIN wf.employees e ON e.department_id = d.id
    GROUP BY d.id
  ) AS "das" ON das.id = d.id;
/* WINDOW FUNCTIONS */
SELECT e.*,
  d.*,
  avg(e.salary) OVER (PARTITION BY d.id) AS "avg_salary",
  avg(e.salary) OVER ()
FROM wf.departments d
  JOIN wf.employees e ON e.department_id = d.id;
/* 
 Инфа о работнике с:
 1) ВСЯ зарплата на отдел. 
 2) СКОЛЬКО ВСЕГО денег уходит на ЗП 
 */
SELECT e.*,
  d.*,
  sum(e.salary) OVER (
    PARTITION BY d.id
    ORDER BY e.salary ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  ) AS "sum_salary",
  sum(e.salary) OVER ()
FROM wf.departments d
  JOIN wf.employees e ON e.department_id = d.id;
/* КАСКАДНОЕ УДАЛЕНИЕ ДАННЫХ. целостность */
delete from wf.departments
where id = 2;