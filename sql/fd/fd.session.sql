DROP TABLE "users";

CREATE TABLE "users" (
  id serial PRIMARY KEY,
  first_name varchar(64) NOT NULL,
  last_name varchar(64) NOT NULL,
  email varchar(256) NOT NULL CHECK (email != ''),
  is_male boolean NOT NULL,
  birthday date NOT NULL CHECK (
    birthday < current_date
    AND birthday > '1900/1/1'
  ),
  height numeric(3, 2) NOT NULL CHECK (
    height > 0.20
    AND height < 2.5
  ),
  CONSTRAINT "CK_FULL_NAME" CHECK (
    first_name != ''
    AND last_name != ''
  )
);
ALTER TABLE "users"
ADD COLUMN "weight" int CHECK (
    "weight" BETWEEN 0 AND 300
  );
/* 
 
 Агрегатные функции
 
 min - вернет минимальное
 max - максимальное
 sum - аккумулятор
 count - считает кол-во кортежей
 avg - среднее значение
 
 */
SELECT avg("height"),
  "is_male"
FROM "users"
WHERE extract(
    'month'
    from age("birthday")
  ) = 1
GROUP BY "is_male";
/* 
 средний рост пользователей
 средний рост мужчин и женщин
 минимальный рост мужчин и женщин
 минимальный, максимальный и средний рост мужчины и женщины
 Кол-во людей родившихся 1 января 1970 года
 Кол-во людей с определённым именем -> John | *
 Кол-во людей в возрасте от 20 до 30 лет
 */
SELECT min(height),
  max(height),
  avg(height),
  "is_male"
FROM "users"
GROUP BY "is_male";
/*  */
SELECT count(*)
FROM "users"
WHERE "birthday" = '1955/08/26';
/*  */
SELECT count(*)
FROM "users"
WHERE extract(
    'year'
    from age("birthday")
  ) BETWEEN 20 AND 30;
/*  */
SELECT *
FROM "users"
WHERE "id" IN (123,534,210,1000,510,348);
/*  */
/* phones: brand, model, price, quantity */
/* users can buy phones */