/* 
 Условные конструкции: CASE
 Выражения подзапросов
 Представления
 Изменение таблиц
 */
SELECT *
FROM users;
/* 
 CASE 
 WHEN true THEN 'male'
 WHEN NOT true THEN 'female'
 ELSE 'not specified'
 END 
 */
SELECT id,
  "email",
  (
    CASE
      WHEN "isMale" THEN 'male'
      WHEN NOT "isMale" THEN 'female'
      ELSE 'not specified'
    END
  ) AS "gender",
  "isMale"
FROM users;
/* TASK: Если бренд - Iphone, то 
 в колонке производителя написать Apple. */
SELECT *,
  (
    CASE
      WHEN "brand" ILIKE 'iphone' THEN 'APPLE'
      ELSE 'Other'
    END
  ) AS "manufacturer"
FROM phones;
/* TASK: 
 цена < 10K - доступный - cheap
 цена - 10К - 20К - средний - mid
 цена > 20К - дорогой - flagman
 
 */
SELECT *,
  (
    CASE
      WHEN "price" < 10000 THEN 'cheap phone'
      WHEN "price" > 20000 THEN 'flagman'
      ELSE 'middle phone'
    END
  ) AS "Price filter"
FROM phones;
/* 
 TASK:
 
 1) Считает кол-во заказов у пользователя. 
 id, email, count
 
 count()
 GROUP BY
 
 2)  По кол-ву заказов опреледить статус пользователя.
 Если заказов больше 5 - постоянные покупатель
 Если больше 2 - активный покупатель
 В другом случае - покупатель
 */
SELECT u.id,
  u.email,
  count(o.id) AS "amount",
  (
    CASE
      WHEN count(o.id) >= 5 THEN 'constant buyer'
      WHEN count(o.id) >= 2 THEN 'active buyer'
      ELSE 'buyer'
    END
  ) AS "status"
FROM orders o
  JOIN users u ON u.id = o."userId"
GROUP BY u.id;
/*  */
SELECT *,
  (
    CASE
      extract(
        month
        from "birthday"
      )
      WHEN 12 THEN 'winter'
      WHEN 1 THEN 'winter'
      WHEN 2 THEN 'winter'
      WHEN 3 THEN 'spring'
      WHEN 4 THEN 'spring'
      WHEN 5 THEN 'spring'
      WHEN 6 THEN 'summer'
      WHEN 7 THEN 'summer'
      WHEN 8 THEN 'summer'
      WHEN 9 THEN 'fall'
      WHEN 10 THEN 'fall'
      WHEN 11 THEN 'fall'
      ELSE '???'
    END
  ) AS "age for case"
FROM users;
SELECT COALESCE(NULL, NULL, 36, 68, 100);
--36
SELECT NULLIF(5, 100);
-- 5
SELECT NULLIF(5, 5);
-- Null
SELECT NULLIF(5, -1);
-- 5
SELECT GREATEST(10, 120, 3214, 345, 2, 1);
-- 3214
SELECT LEAST(10, 120, 3214, 345, 2, 1);
-- 1
/* Выражения подзапросов 
 
 [NOT] IN
 EXISTS
 SOME/ANY
 */
-- ВСЕ ПОЛЬЗОВАТЕЛИ, КОТОРЫЕ НЕ ДЕЛАЛИ ЗАКАЗЫ
SELECT *
FROM users u
WHERE u.id IN (
    SELECT orders."userId"
    FROM orders
  );
/*  */
SELECT u.id,
  u.email,
  concat(u."firstName", ' ', u."lastName")
FROM users u
WHERE u.id IN (
    SELECT users.id
    FROM users
    WHERE users.id % 10 = 0
  );
/*  */
SELECT *
FROM users u
WHERE u.id IN (
    SELECT o."userId"
    FROM phones p
      JOIN phones_to_orders pto ON p.id = pto."phoneId"
      JOIN orders o ON o.id = pto."orderId"
    WHERE p.id = 21
    GROUP BY o."userId"
  )
  /* EXISTS */
SELECT EXISTS(
    SELECT *
    FROM users
    WHERE users.id = 324523423
  );
/* Делал ли пользователь заказ */
SELECT *
FROM users
WHERE EXISTS(
    SELECT *
    FROM orders
    WHERE orders."userId" = users.id
  )
  /*  */
SELECT *
FROM phones p
WHERE p.id != ALL(
    SELECT pto."phoneId"
    FROM phones_to_orders pto
  );
/* Представления | Views | Виртуальные таблицы */
CREATE VIEW "users_with_order_amount" AS (
  SELECT u.*,
    count(o.id) AS "Order amount"
  FROM users u
    JOIN orders o ON u.id = o."userId"
  GROUP BY u.id
);
/* НЕ ИСПУЛЬЗУЯ VIEWS */
SELECT *
FROM (
    SELECT u.*,
      count(o.id) AS "Order amount"
    FROM users u
      JOIN orders o ON u.id = o."userId"
    GROUP BY u.id
  ) AS "uwoa"
WHERE "Order amount" >= 2
  AND "birthday" BETWEEN '1980-1-1' AND '1990-1-1';
/* ИСПУЛЬЗУЯ VIEWS */
SELECT *
FROM "users_with_order_amount"
WHERE "Order amount" >= 2
  AND "birthday" BETWEEN '1980-1-1' AND '1990-1-1';
/* ЗАКАЗЫ и их стоимость */
CREATE VIEW "orders_with_cost" AS (
  SELECT o.id,
    o."userId",
    sum(p.price * pto.quantity) as "total"
  FROM orders o
    JOIN phones_to_orders pto ON o.id = pto."orderId"
    JOIN phones p ON p.id = pto."phoneId"
  GROUP BY o.id
);
/*  */
DROP VIEW "user_total_check";
CREATE VIEW "user_total_check" as (
  SELECT owc.*,
    u.email
  FROM orders_with_cost owc
    JOIN users u ON owc."userId" = u.id
);
/* CREATE VIEW “name” AS ( table expression ) */
/* 
 view: id, full name, gender{ male|female|other }, age
 */
CREATE OR REPLACE VIEW "trasnformed_users" AS (
    SELECT id,
      concat("firstName", ' ', "lastName") AS "full_name",
      (
        CASE
          WHEN "isMale" THEN 'male'
          WHEN NOT "isMale" THEN 'female'
          ELSE 'other'
        END
      ) AS "gender",
      extract(
        year
        from age("birthday")
      ) AS "age",
      "email"
    FROM users
  );

/* 

  CASE, COALESCE, NULLIF

  CASE
    WHEN condition1 THEN r1
    WHEN condition2 THEN r2

  CASE expression
    WHEN v1 THEN r1
    WHEN v2 THEN r2

  [NOT] IN, SOME/ANY, EXISTS

  VIEWS

 */
