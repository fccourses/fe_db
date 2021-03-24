CREATE TABLE "team"(
  "id" serial PRIMARY KEY,
  "name" varchar(64) NOT NULL
);
/*  */
CREATE TABLE "coach"(
  "id" serial PRIMARY KEY,
  "name" varchar(64) NOT NULL,
  "team_id" int REFERENCES "team"("id")
);
/*  */
ALTER TABLE "team"
ADD COLUMN "coach_id" int REFERENCES "coach"("id");
/*  */