/* 
 Типы ассоциации
 
 1 => : <= 1 
 1  : <= m   
 m : <= m_to_n => : n
 
 <= - REFERENCES
 */
CREATE TABLE "phones"(
  id serial PRIMARY KEY,
  brand varchar(64) NOT NULL,
  model varchar(64) NOT NULL,
  price decimal(10, 2) NOT NULL CHECK (price > 0),
  quantity int NOT NULL CHECK (quantity > 0),
  UNIQUE(brand, model)
);
/*  */
CREATE TABLE "orders"(
  id serial PRIMARY KEY,
  "createdAt" timestamp NOT NULL DEFAULT current_timestamp,
  "userId" REFERENCES "users"(id)
);
/*  */
CREATE TABLE "users_to_orders"(
  "orderId" int REFERENCES "orders"(id),
  "userId" int REFERENCES "users"(id),
  quantity int NOT NULL,
  PRIMARY KEY ("orderId", "userId")
)
/*  Посчитать кол-во телефонов, которые были проданы  */
SELECT sum(price * quantity)
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
/* Стоимость всех телефонов в диапазоне цены от 10К до 20К */
SELECT sum(price * quantity)
FROM phones;
/* Кол-во моделей каждого бренда */
SELECT count(model),
  brand
FROM phones
GROUP BY brand;
/* Кол-во заказов каждого пользователя, которые совершали заказы */
SELECT count(id) AS "Кол-во заказов этого пользователя",
  "userId" AS "ID пользователя"
FROM orders
GROUP BY "userId";
/* 
 -- SORTING -> ORDER BY field ASC | DESC
 -- GROUP FILTERING -> HAVING
 */
SELECT *
FROM users
ORDER BY height ASC,
  birthday DESC,
  "isMale" ASC;
/* ** Узнать каких брендов телефонов осталось меньше всего ** */
/* 
 посчитать сколько брендов телефонов всего
 отсортировать список
 */
SELECT sum(quantity) AS "amount of brand phones",
  brand
FROM phones
GROUP BY brand
ORDER BY "amount of brand phones" ASC
LIMIT 2;
/* model */
SELECT *
FROM phones
ORDER BY quantity ASC;
/* 
 сортировка по возрасту(не день рождения) и по имени
 */
SELECT count(*) as "amount",
  age
FROM (
    SELECT *,
      extract(
        'year'
        from age("birthday")
      ) AS "age"
    FROM users
  ) AS "u_age"
GROUP BY "age"
HAVING count(*) > 5
ORDER BY "age" ASC;
/*  ИЗВЛЕЧЬ ВСЕ БРЕНДЫ,
 У КОТОРЫХ КОЛ-ВО ТЕЛЕФОНОВ > 10к 
 */
SELECT sum(quantity),
  brand
FROM phones
GROUP BY brand
HAVING sum(quantity) > 77000;
/*  */
/* 
 text patterns
 
 LIKE
 ILIKE
 % - *
 _ - ?
 
 SIMILAR TO
 % - *
 _ - ?
 reg exp
 
 ~
 reg exp
 
 
 */
SELECT *
FROM users
WHERE "firstName" ~ '[ABCD]{1}\w'
  AND "isMale" = false;
/*  */
CREATE TABLE A(v char(3), t int);
INSERT INTO A
VALUES ('XXX', 1),
  ('XXZ', 1),
  ('XXY', 1),
  ('XYZ', 2),
  ('XYZ', 3),
  ('ZYZ', 3),
  ('ZZZ', 3),
  ('XZZ', 3),
  ('YXZ', 4),
  ('YYZ', 4),
  ('YZX', 4);
/*  */
CREATE TABLE B(b char(3));
INSERT INTO B
VALUES ('XXX'),
  ('XXZ'),
  ('YYZ'),
  ('YZX');
/*  */
SELECT *
FROM A;
SELECT *
FROM B;
/*  */
SELECT *
FROM A,
  B;
/* Все уникальные значения из двух таблиц */
SELECT V
FROM A
UNION
SELECT B
FROM B;
/* Совпадающие значения */
SELECT V
FROM A
INTERSECT
SELECT B
FROM B;
/* Значения из таблицы А, которых нет в таблице B */
SELECT V
FROM A
EXCEPT
SELECT B
FROM B;
/*  */
/* INSERT INTO users (
 "firstName",
 "lastName",
 email,
 "isMale",
 birthday,
 height
 )
 VALUES (
 'Test',
 'Testov',
 'testuniq@gmail.com',
 true,
 '1990/12/12',
 1.9
 ); */
/*  */
SELECT id
FROM users
UNION
SELECT "userId"
FROM orders;
/* ВСЕ ЗАКАЗЫ ОДНОГО ПОЛЬЗОВАТЕЛЯ */
SELECT u.*, o.id AS "orderId"
FROM "users" AS u
  JOIN "orders" AS o ON "o"."userId" = "u"."id"
WHERE "u"."id" = 1;