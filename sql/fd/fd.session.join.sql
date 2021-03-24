-- Select 1 юзера с самым длинным full именем.
SELECT id,
  char_length(concat("firstName", ' ', "lastName")) AS l
FROM users
ORDER BY l DESC
limit 1;
/*
 Посчитать кол-во юзеров с одним кол-вом симоволов в имени 
 и отсеять группы юзеров с кол-вом этих символом меньше 18
 */
SELECT char_length(concat("firstName", ' ', "lastName")) AS "name length",
  count(*) AS "Amount"
FROM users
GROUP BY "name length"
HAVING char_length(concat("firstName", ' ', "lastName")) < 18
ORDER BY "name length";
/* 
 Найти кол-во симоволов в мейлах, начинающихся с буквы m
 Сгрупировать их кол-ву символов.
 Отсеять группы у которых кол-во меньше 25.
 
 2)  Остеить группы, которые не популярны. 
 */
SELECT char_length("email") AS "length",
  count(*)
FROM users --WHERE email LIKE 'm%'
GROUP BY "length"
HAVING count(*) >= 10
ORDER BY "length";
/* моветон */
SELECT *
FROM A,
  B
WHERE A.v = B.b;
/*  */
SELECT *
FROM A
  JOIN B ON A.v = B.b;
/* id ЗАКАЗОВ С АЙФОНАМИ */
SELECT o.id "order id",
  p.id "phone id",
  p.model
FROM orders AS o
  JOIN phones_to_orders AS pto ON o.id = pto."orderId"
  JOIN phones AS p ON pto."phoneId" = p.id
WHERE p.brand ILIKE 'iphone';
/* ВСЕ ТЕЛЕФОНЫ, КОТОРЫЕ ПОКУПАЮТ И ИХ кол-во продаж */
SELECT p.id,
  p.model,
  sum(pto.quantity)
FROM phones_to_orders AS pto
  JOIN phones AS p ON p.id = pto."phoneId"
GROUP BY p.id
ORDER BY p.id;
/* Пoльзователи которые делали заказы */
SELECT count(o.id) AS "AMOUNT",
  u.*
FROM users AS u
  INNER JOIN orders AS o ON o."userId" = u.id
GROUP BY u.id
ORDER BY u.id DESC;
/* ПОЛУЧИТЬ ВСЕХ ПОЛЬЗОВАТЕЛЕЙ И ИХ КОЛ_ВО ЗАКАЗОВ */
SELECT count(o.id) AS "AMOUNT",
  u.*
FROM users AS u -- LEFT TABLE
  LEFT OUTER JOIN orders AS o ON o."userId" = u.id -- RIGHT TABLE
GROUP BY u.id
ORDER BY u.id DESC;
/* СТОИМОСТЬ КАЖДОГО ЗАКАЗА */
SELECT pto."orderId", sum(p.price * pto.quantity)
FROM phones_to_orders AS pto
  JOIN phones AS p ON p.id = pto."phoneId"
GROUP BY pto."orderId";

/* Извлечь все телефоны конкретного заказа */
/* Кол-во заказов каждого пользователя и его емейл */
/* Кол-во позиций товара в определённом заказе */

/* Извлечь самый популярный телефон */
/* Извлечь пользователей и кол-во моделей, которые они покупали */

/* Извлечь все заказы стоимостью выше среднего чека заказов */
/* Извлечь всех пользователей у которых кол-во заказов больше среднего */
