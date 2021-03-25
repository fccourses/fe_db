/* Извлечь все телефоны конкретного заказа */
SELECT *
FROM phones AS p
  INNER JOIN phones_to_orders AS pto ON p.id = pto."phoneId"
WHERE pto."orderId" = 1;
/* Кол-во заказов каждого пользователя и его емейл */
SELECT u.id,
  u.email,
  count(o.id)
FROM users AS u
  JOIN orders AS o ON u.id = o."userId"
GROUP BY u.id
ORDER By u.id;
/* Кол-во позиций товара в определённом заказе */
/* Извлечь самый популярный телефон */
SELECT sum(pto.quantity) as "amount",
  p.id,
  p.model,
  p.brand
FROM phones p
  JOIN phones_to_orders pto ON p.id = pto."phoneId"
GROUP BY p.id,
  p.brand
ORDER BY amount DESC
LIMIT 1;
/* Извлечь пользователей и кол-во моделей, которые они покупали */
Select "uid_with_pid"."userId",
  count("uid_with_pid"."phoneId")
FROM (
    SELECT u.id as "userId",
      p.id as "phoneId"
    FROM users u
      JOIN orders o ON u.id = o."userId"
      JOIN phones_to_orders pto ON o.id = pto."orderId"
      JOIN phones p ON p.id = pto."phoneId"
    GROUP BY u.id,
      p.id
    ORDER BY u.id
  ) AS "uid_with_pid"
GROUP BY "uid_with_pid"."userId"
  /* Извлечь все заказы стоимостью выше среднего чека заказов */
  /* 1. Считаем стоимость каждого заказа */
SELECT pto."orderId",
  sum(pto.quantity * p.price)
FROM phones_to_orders pto
  JOIN phones p ON p.id = pto."phoneId"
GROUP BY pto."orderId"
  /* 2. Посчитать средний чек */
SELECT avg(orders_with_cost.cost)
FROM (
    SELECT pto."orderId",
      sum(pto.quantity * p.price) as "cost"
    FROM phones_to_orders pto
      JOIN phones p ON p.id = pto."phoneId"
    GROUP BY pto."orderId"
  ) AS "orders_with_cost"
  /* 3. */
SELECT orders_with_cost.*
FROM (
    SELECT pto."orderId",
      sum(pto.quantity * p.price) as "cost"
    FROM phones_to_orders AS pto
      JOIN phones p ON p.id = pto."phoneId"
    GROUP BY pto."orderId"
  ) AS "orders_with_cost"
WHERE orders_with_cost.cost > (
    SELECT avg(orders_with_cost.cost)
    FROM (
        SELECT pto."orderId",
          sum(pto.quantity * p.price) as "cost"
        FROM phones_to_orders pto
          JOIN phones p ON p.id = pto."phoneId"
        GROUP BY pto."orderId"
      ) AS "orders_with_cost"
  )
  /* REFACTOR << */
WITH orders_with_cost AS (
  SELECT pto."orderId",
    sum(pto.quantity * p.price) as cost
  FROM phones_to_orders pto
    JOIN phones p ON p.id = pto."phoneId"
  GROUP BY pto."orderId"
) SELECT *
FROM orders_with_cost AS owc
WHERE owc.cost > (
    SELECT avg(owc.cost)
    FROM orders_with_cost owc
  );
/* Извлечь всех пользователей 
у которых вол-во заказов больше среднего 

  1. Колво заказов каждого пользователя
   и вся инфа о пользователе
  2. Среднее кол-во заказов
  3. Объединить всё вместе и выполнить задание 
  (WHERE orderAmount > avgOrderAmount)
  ----------------------------------------------------------------
  TASKS table(attr, domain, constraints, associations)
 */