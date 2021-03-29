/*
 Условные конструкция. CASE
 Выражения подзапросов.
 Представления.
 */
/* 
 CASE
 WHEN condition1 = true THEN r1
 WHEN condition2 != true THEN r2
 ELSE r3
 END
 */
SELECT (
    CASE
      WHEN true = false THEN '+'
      WHEN true THEN '-'
      ELSE '???'
    END
  ) AS "test field";
/*  */
SELECT *,
  (
    CASE
      WHEN "isMale" = true THEN 'male'
      WHEN "isMale" = false THEN 'female'
      ELSE 'other'
    END
  ) AS "gender"
FROM users;
/*  */
SELECT *,
  (
    CASE
      extract(
        month
        from "birthday"
      )
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
      WHEN 12 THEN 'winter'
    END
  ) AS "season"
FROM users;
/*  */
SELECT *,
  (
    CASE
      WHEN extract(
        year
        from age("birthday")
      ) < 30 THEN 'not adult'
      WHEN extract(
        year
        from age("birthday")
      ) >= 30 THEN 'adult'
    END
  ) AS "age status"
FROM users;
/* 
 Если бренд это айфон - то вернуть строчку APPLE
 в колонку производитель. А если нет - "other"
 */
SELECT *,
  (
    CASE
      WHEN "brand" ILIKE 'iphone' THEN 'Apple'
      ELSE 'other'
    END
  ) AS "manufacturer"
FROM phones;
/* TASK
 price < 10K - доступный
 price > 20K  - флагман
 price > 10 and price < 20 - средний
 */
SELECT *,
  (
    CASE
      WHEN price < 10000 THEN '1'
      WHEN price > 20000 THEN '2'
      ELSE '3'
    END
  ) as "status"
FROM phones;
/* ВСЕ ТЕЛЕФОНЫ дороже среднего */
SELECT *,
  (
    CASE
      WHEN price > (
        SELECT avg(price)
        from phones
      ) THEN 'high price'
      ELSE 'low'
    END
  ) AS "status"
FROM phones;
/* TASK:
 > 4 - постоянный клиент
 > 2 - активный клиент
 > 0 - клиент
 */
SELECT "userId",
  (
    CASE
      WHEN count(id) > 4 THEN 'constant'
      WHEN count(id) > 2 THEN 'active'
      ELSE 'buyer'
    END
  ) AS "status"
FROM orders
GROUP BY "userId";
/* с email */
SELECT u.id,
  u.email,
  (
    CASE
      WHEN count(o.id) > 4 THEN 'constant'
      WHEN count(o.id) > 2 THEN 'active'
      ELSE 'buyer'
    END
  ) AS "status"
FROM orders o
  RIGHT JOIN users u ON u.id = o."userId"
GROUP BY u.id,
  u.email;
/*  */
SELECT sum(
    CASE
      WHEN price > 5000 THEN 1
      ELSE 0
    END
  )
FROM phones;
/*  */
/*
 COALESCE: 
 */
SELECT model,
  price,
  COALESCE("description", 'Not available')
FROM phones;
/* 
 NULLIF
 */
SELECT NULLIF(12, 12);
-- NULL
SELECT NULLIF(NULL, NULL);
-- NULL
SELECT NULLIF(NULL, 50);
-- NULL
SELECT NULLIF(120, 50);
-- 120
SELECT NULLIF('hello', '50');
-- hello
/*  */
SELECT GREATEST(1, 2, 3, 4, 5, 4532453, 1234, 12, 1, 1, 1, 1);
SELECT LEAST(1, 2, 3, 4, 5, 4532453, 1234, 12, 1, 1, 1, 1);
/*  */
/* 
 Выражения подзапросов 
 
 [NOT] IN
 EXISTS
 SOME/ANY
 */
/* ВСЕ ПОЛЬЗОВАТЕЛИ, КОТОРЫЕ НЕ ДЕЛАЛИ ЗАКАЗЫ */
SELECT *
FROM users u
WHERE u.id NOT IN (
    SELECT "userId"
    FROM orders
  );
/* ТЕЛЕФОНЫ КОТОРЫХ НЕ ЗАКАЗЫВАЛИ */
SELECT *
FROM phones p
WHERE p.id NOT IN (
    SELECT "phoneId"
    FROM phones_to_orders
  );
/*  */
SELECT EXISTS(
    SELECT *
    FROM USERS u
    WHERE u.id = 302
  );
/*  */
SELECT *
FROM users u
WHERE EXISTS (
    SELECT *
    FROM orders o
    WHERE u.id = o."userId"
  );
/* ТЕЛЕФОНЫ КОТОРЫХ НЕ ЗАКАЗЫВАЛИ */
SELECT *
FROM phones p
WHERE p.id != ALL (
    SELECT "phoneId"
    FROM phones_to_orders
  );
/* ТЕЛЕФОНЫ ДОРОЖЕ ВСЕХ АЙФОНОВ */
SELECT *
FROM phones
WHERE phones.price > (
    SELECT max(price)
    FROM phones
    WHERE brand ILIKE 'iphone'
  )
  /* Представления | VIEWS | Виртуальные таблицы */
  CREATE OR REPLACE VIEW "users_with_orders_amount" AS (
    SELECT u.*,
      count(o.id) AS "order_amount"
    FROM users u
      LEFT OUTER JOIN orders o ON u.id = o."userId"
    GROUP BY u.id,
      u.email
  );
SELECT *
FROM "users_with_orders_amount"
WHERE "order_amount" > 3
  /* ЗАКАЗ и его стоимость */
  CREATE VIEW "orders_with_price" AS (
    SELECT o."userId",
      o.id,
      sum(p.price * pto.quantity)
    FROM orders o
      JOIN phones_to_orders pto ON o."id" = pto."orderId"
      JOIN phones p ON p.id = pto."phoneId"
    GROUP BY o.id
  );
/*  */
CREATE VIEW "spam_list" AS (
  SELECT owc.*,
    u.email,
    u.birthday
  FROM "orders_with_price" owc
    JOIN users u ON u.id = owc."userId"
);
/*  */
SELECT *
FROM "spam_list";
/*  View: full name, age, gender  */
CREATE VIEW "transformed_users" AS (
  SELECT concat("firstName", ' ', "lastName") AS "fullName",
    extract(
      year
      from age("birthday")
    ) AS "age",
    (
      CASE
        WHEN "isMale" = true THEN 'male'
        WHEN "isMale" = false THEN 'female'
        ELSE 'other'
      END
    ) AS "gender"
  FROM users
);
/* View with top buyers: 
 top 10 most expensive buyers, 
 largest number of orders */

/* 

  CASE
    WHEN cond1 THEN r1

  CASE expression
    WHEN v1 THEN r1

  ELSE r2
  END

COALESCE
NULLIF
[NOT] IN, SOME/ANY, EXISTS

VIEW
 */
