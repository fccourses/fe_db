/* Посчитать кол-во телефонов, которые были проданы */
SELECT sum(quantity)
FROM phones_to_orders;
/* Кол-во телефонов, которые есть "на складе" */
SELECT sum(quantity)
FROM phones;
/* Средняя цена всех телефонов */
SELECT avg(price)
FROM phones;
/* Средняя цена каждого бренда */
SELECT avg(price),
  brand
FROM phones
GROUP BY brand;
/* Кол-во моделей каждого бренда */
SELECT count(*),
  brand
FROM phones
GROUP BY brand;
/* Кол-во заказов каждого пользователя, которые совершали заказы */
SELECT count(*),
  "userId"
FROM orders
GROUP BY "userId";
/* Средняя цена на IPhone */
SELECT avg(price)
FROM phones
WHERE brand = 'IPhone';
/* Стоимость всех телефонов в диапазоне их цен от 10К до 20К */
SELECT sum(price * quantity)
FROM phones
WHERE price BETWEEN 10000 AND 20000;
/* ** Узнать каких брендов телефонов осталось меньше всего ** */
SELECT *
FROM phones
ORDER BY quantity ASC
LIMIT 10;
/*
 --SORT -> ORDER BY field {ASC|DESC}
 --GROUP FILTER - HAVING condition
 */
SELECT *
FROM users
ORDER BY height ASC,
  birthday ASC,
  "firstName" DESC;
/* 
 сортировка по возрасту(не день рождения) и по имени
 */
SELECT count(*) AS "Кол-во людей этого возраста",
  "Age"
FROM (
    SELECT extract(
        'year'
        from age(birthday)
      ) AS "Age",
      *
    FROM users
  ) AS "u_w_age"
GROUP BY "Age"
HAVING count(*) >= 8
ORDER BY "Age";
/* Извлечь все бренды, у которых кол-во телефонов > 10K */
SELECT sum(quantity) AS "count",
  brand
FROM phones
GROUP BY brand
HAVING sum(quantity) > 8000;
/* 
 --text pattern -> Поиск по тексту
 
 LIKE - С учетом регистра
 ILIKE - Без учета регистра
 
 * - Всё что угодно, в любых кол-вах    =>  %
 ? - Всё что угодно, один раз           =>  _
 
 
 SIMILAR TO
 
 REG_EXP:
 ~ - С учетом регистра
 ~* - Без учета регистра
 !~
 !~*
 */
SELECT *
FROM users
WHERE "firstName" ~ '.*i{2}.*';
/* === Сочетание запросов === */
CREATE TABLE A(v char(3), t int);
CREATE TABLE B(v char(3));
INSERT INTO A
VALUES ('XXX', 1),
  ('ZXX', 2),
  ('XXY', 1),
  ('ZXY', 2),
  ('XXZ', 1),
  ('ZXZ', 2),
  ('XYX', 3),
  ('XYY', 3),
  ('XYZ', 3),
  ('YXZ', 4),
  ('YXX', 4),
  ('YXY', 4),
  ('YYY', 5)
RETURNING *;
INSERT INTO B
VALUES ('ABC'),
  ('ZXZ'),
  ('YXZ'),
  ('YXY'),
  ('XXX');
/* Объединение. Все уникальные значения из 2 таблиц */
SELECT v as "sra" FROM A
UNION
SELECT v as "test" FROM B;
/* Пересечение. Совпадающие значения */
SELECT v as "sra" FROM A
INTERSECT
SELECT v as "test" FROM B;
/* Вычитание. Значения из таблицы А, которых нет в таблице B */
SELECT v as "sra" FROM A
EXCEPT
SELECT v as "test" FROM B;
/* Узнать id всех пользователей, которые делали заказы */
SELECT id FROM users
EXCEPT
SELECT "userId" from orders;
/* Все заказы одного пользователя */
SELECT 
  o.id AS "Order ID",
  u.*
FROM users AS u
  JOIN orders AS o ON o."userId" = u.id
WHERE u.id = 2;
