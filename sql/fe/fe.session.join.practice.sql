/* Извлечь все телефоны конкретного заказа */
/* Кол-во заказов каждого пользователя и его емейл */
SELECT u.email,
  count(o.id)
FROM orders o
  JOIN users u ON u.id = o."userId"
GROUP BY u.id;
/* Кол-во позиций товара в определённом заказе */
/* Извлечь самый популярный телефон */
SELECT sum(pto.quantity) as "amount",
  pto."phoneId",
  p.brand,
  p.model
FROM phones_to_orders pto
  JOIN phones p ON p.id = pto."phoneId"
GROUP BY pto."phoneId",
  p.brand,
  p.model
ORDER BY amount DESC
LIMIT 1;
/* Извлечь пользователей и кол-во моделей, которые они покупали */
SELECT count("pid"),
  "uid"
FROM (
    SELECT u.id as "uid",
      p.id "pid"
    FROM users u
      JOIN orders o ON u.id = o."userId"
      JOIN phones_to_orders pto ON o.id = pto."orderId"
      JOIN phones p ON p.id = pto."phoneId"
    GROUP BY u.id,
      p.id
  ) AS "uid_with_pid"
GROUP BY "uid";
/* Извлечь все заказы стоимостью выше среднего чека заказов */
/* 1. Считаем стоимость каждого заказа*/
SELECT pto."orderId",
  sum(pto.quantity * p.price) as "cost"
FROM phones_to_orders pto
  JOIN phones p ON p.id = pto."phoneId"
GROUP BY pto."orderId";
/* 2. ПОЛУЧИТЬ СРЕДНЮЮ СТОИМОСТЬ */
SELECT avg(owc.cost)
FROM (
    SELECT pto."orderId",
      sum(pto.quantity * p.price) as "cost"
    FROM phones_to_orders pto
      JOIN phones p ON p.id = pto."phoneId"
    GROUP BY pto."orderId"
  ) AS "owc";
/* 3. Детали */
SELECT owc.*
FROM (
    SELECT pto."orderId",
      sum(pto.quantity * p.price) as "cost"
    FROM phones_to_orders pto
      JOIN phones p ON p.id = pto."phoneId"
    GROUP BY pto."orderId"
  ) AS "owc"
WHERE owc.cost > (
    SELECT avg(owc.cost)
    FROM (
        SELECT pto."orderId",
          sum(pto.quantity * p.price) as "cost"
        FROM phones_to_orders pto
          JOIN phones p ON p.id = pto."phoneId"
        GROUP BY pto."orderId"
      ) AS "owc"
  );
/* 4. REFACTOR */
WITH "orders_with_cost" AS (
  SELECT pto."orderId",
    sum(pto.quantity * p.price) as "cost"
  FROM phones_to_orders pto
    JOIN phones p ON p.id = pto."phoneId"
  GROUP BY pto."orderId"
)
SELECT owc.*
FROM "orders_with_cost" AS owc
WHERE owc.cost > (
    SELECT avg(owc.cost)
    FROM "orders_with_cost" AS owc
  );
/* Извлечь всех пользователей 
 у которых вол-во заказов больше среднего  */
/* ВСЕ ЗАКАЗЫ С ОПРЕДЕЛЁННЫМ ТЕЛЕФОНОМ. Показать бренд и модель телефона. */
/* Tasks (attr, domain, constraints, associations), INSERTs */
      /* Все пользователи у которых есть таски*/
      /* Пользователь и все его таски */
      /* Пользователь и все его невыполненные таски */
      /* Кол-во выполненных тасок пользователя */