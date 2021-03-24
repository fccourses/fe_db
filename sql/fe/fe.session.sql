/* select 1 user с самым длинным full именем 
 
 concat, 
 char_length
 */
SELECT char_length(concat("firstName", ' ', "lastName")) AS "name length",
  *
FROM users
ORDER BY "name length" DESC
LIMIT 1;
/* 
 Посчитать кол-во юзеров с одним кол-вом символов в full имени
 и отсеять группы юзеров с кол-вом символов меньше 18
 */
SELECT char_length(concat("firstName", ' ', "lastName")) AS "name length",
  count(users.id)
FROM users
GROUP BY "name length"
HAVING char_length(concat("firstName", ' ', "lastName")) >= 18
ORDER BY "name length";
/* 
 Найти кол-во символов в мейлах, начинающихся с буквы m,
 сгрупировать их по кол-ву
 остеять группы у которых кол-во меньше 20 символов
 
 2) Отсеять группы которые не популярны
 */
SELECT char_length(email) AS "length",
  count(users.id)
FROM users
WHERE email ILIKE 'm%'
GROUP BY length
HAVING count(users.id) > 5;
/* моветон */
SELECT A.v,
  A.t,
  B.v
FROM A,
  B
WHERE A.v = B.v;
/* JOIN */
SELECT *
FROM A
  JOIN B ON A.v = B.v
  JOIN phones ON A.t = phones.id;
/* PK -> FK */
/* Все id заказы с samsung */
SELECT o.id,
  count(p.model)
FROM orders AS o
  JOIN phones_to_orders AS pto ON o.id = pto."orderId"
  JOIN phones p ON p.id = pto."phoneId"
WHERE p.brand ILIKE 'iphone'
GROUP BY o.id;
/* id Всех телефонов, которых покупают, кол-во проданных телефонов */
SELECT "phoneId",
  p.model,
  sum(pto.quantity)
FROM phones_to_orders AS pto
  JOIN phones AS p ON p.id = pto."phoneId"
GROUP BY "phoneId",
  p."model"
ORDER BY "phoneId";
/* мейлы пользователей, которые делали заказы
 опеределённого бренда
 */
SELECT u.email
FROM users u
  JOIN orders o ON u.id = o."userId"
  JOIN phones_to_orders pto ON pto."orderId" = o.id
  JOIN phones p ON p.id = pto."phoneId"
WHERE p.brand ILIKE 'honor'
GROUP BY u.email
  /* Пользователи и их кол-во заказов */
SELECT count(o.id) "Кол-во заказов", u.*
FROM users u
  FULL OUTER JOIN orders AS o ON o."userId" = u.id
GROUP BY o."userId", u.id
ORDER BY o."userId";

/* СТОИМОСТЬ КАЖДОГО ЗАКАЗА */

/* Извлечь все телефоны конкретного заказа */
/* Кол-во заказов каждого пользователя и его мейл */
/* Кол-во позиций товара в определённом заказе */

/* Извлечь самый популярный телефон*/