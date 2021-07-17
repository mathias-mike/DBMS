--   DATA MANIPULATION LANGUAGE

-- The common command in DML is;
--     * INSERT 
--     * UPDATE
--     * DELETE

-- This commands are usually IRREVERSABLE. Backups are important!

-- Something to note about the SERIAL data type is that it calls the "nextval('students_id_seq'::regclass)" which returns the nextval
-- of that sequence. 


-- INSERSTION - FORM ONE
---------------------------------------------------------------------------------------------------------------------------------
-- The first form of the INSERT command we're looking at is: INSERT INTO table (column list) VALUES (first row of values), ....
-- E.g:
CREATE TABLE "students" (
    "id" SERIAL,
    "name" VARCHAR,
    "email" VARCHAR
);
-- We can choose to ignore a column and postgress would insert the DEFAULT value for us in there. The DEFAULT is NULL I guess.
INSERT INTO "students" ("name", "email") VALUES ('mike', 'mike@gmial.com'), ('sam', 'sam@gmail.com'), ('Paul', 'palingo@gmil.com');
INSERT INTO "students" ("id", "name", "email") VALUES (DEFAULT, 'Godswill', 'will@gmail.com'), (DEFAULT, 'Luke', DEFAULT); 
INSERT INTO "students" VALUES (DEFAULT, 'Kindness', 'kind@gmail.com'), (DEFAULT, 'Peace', DEFAULT); -- We can choose to skip the column names


-- INSERTION - FORM TWO
------------------------------------------------------------------------------------------------------------------------------------
-- This form allows to feed the result of a regular SELECT query to the INSERT command. This form is really useful for migrating data from one 
-- table to another while transforming it.
-- INSERT INTO table_name (column list in the order it's returned by the SELECT) SELECT …
-- E.g
CREATE TABLE "students_main" (
    "id" SERIAL,
    "nick_name" VARCHAR, 
    "email" VARCHAR
);
INSERT INTO "students_main" SELECT * FROM "students" WHERE "email" IS NOT NULL;
INSERT INTO "students_main" ("nick_name", "email") SELECT "name", "name"||'@student.com' FROM "students" WHERE "email" IS NULL;


-- EXERCISE - Inserting Data
-- First trying to create the tables for this exercise
CREATE TABLE "dnorm_people" (
    "first_name" VARCHAR,
    "last_name" VARCHAR,
    "emails" VARCHAR
);
INSERT INTO "dnorm_people" ("first_name", "last_name", "emails") VALUES 
('Minerva', 'Burks', 'velit@cras.org,vel.sapien.imperdiet@vel.edu,est.mauris@segittissempernam.net'), 
('Carolyn', 'Travis', 'ornare@tristiquesenectus.ca,marius.quis.turpis@milacinia.edu,mauris@auto.ca'), 
('Ria', 'Hogan', 'Moris.mobi@samel.org,ria.hogan.imperdiet@vel.edu,hogan.sae@segittissempernam.net'),
('Rinah', 'Watts', 'rina@cras.org,watss.sapien.imperdiet@vel.edu,est.rinahwatts@segittissempernam.net'), 
('Maisie', 'Sales', 'Donec@maind.ca,seakd.quis.turpis@milacinia.edu'), 
('Jullian', 'Daugherty', 'Julss.mobi@samel.org,pelais.hogan.imperdiet@vel.edu,dog.sae@segittissempernam.net'),
('Harding', 'Bowen', 'hardened.criminal@cras.org,homo.sapien.imperdiet@vel.edu,people.sha.mauris@segittissempernam.net'),
('Honorato', 'Harman', 'a.plus.people@tristiquesenectus.ca,h.h.hsquared@milacinia.edu'), 
('September', 'Joyner', 'sept.mobi@samel.org,ria.month.imperdiet@vel.edu,joyner.sae@segittissempernam.net'),
('Alden', 'Mercado', 'alden@cras.org,mac.sapien.imperdiet@vel.edu,donald.mauris@segittissempernam.net'), 
('Michael', 'Mathias', 'leesanmoj@gmail.com,mr.michaelofficial@gmail.com,momathias@student.oau.edu.ng');

CREATE TABLE "people" (
    "id" SERIAL,
    "first_name" VARCHAR,
    "last_name" VARCHAR
);
INSERT INTO "people" ("first_name", "last_name") SELECT "first_name", "last_name" FROM "dnorm_people";

CREATE TABLE "people_emails" (
    "people_id" INTEGER,
    "email" VARCHAR
);
INSERT INTO "people_emails" 
SELECT p.id, s.email
FROM people p
JOIN (
    SELECT first_name, last_name, REGEXP_SPLIT_TO_TABLE(emails, ',+') email FROM dnorm_people
) s
ON p.first_name = s.first_name AND p.last_name = s.last_name;


-- UPDATING
-- The basic syntax for updating data in a table is: UPDATE table_name SET col1=newval1, … WHERE ….

-- EXERCISE - Updating Data
-- First getting the table to be used... Would be altering the people table for this purpose
UPDATE "people" SET "last_name" = UPPER("last_name"); -- Make all last name upper_case
ALTER TABLE "people" ADD COLUMN "born_ago" VARCHAR;
UPDATE "people" SET "born_ago" = '57 years 5 months 7 days' WHERE "id" = 1;
UPDATE "people" SET "born_ago" = '38 years 1 month 27 days' WHERE "id" = 2;
UPDATE "people" SET "born_ago" = '55 years 6 months 7 days' WHERE "id" = 3;
UPDATE "people" SET "born_ago" = '32 years 14 days' WHERE "id" = 4;
UPDATE "people" SET "born_ago" = '38 years 7 months 26 days' WHERE "id" = 5;
UPDATE "people" SET "born_ago" = '57 years 9 months 2 days' WHERE "id" = 6;
UPDATE "people" SET "born_ago" = '33 years 3 months 27 days' WHERE "id" = 7;
UPDATE "people" SET "born_ago" = '56 years 5 months 4 days' WHERE "id" = 8;
UPDATE "people" SET "born_ago" = '21 years 11 months 15 days' WHERE "id" = 9;
UPDATE "people" SET "born_ago" = '25 years 7 months 15 days' WHERE "id" = 10;
UPDATE "people" SET "born_ago" = '24 years 10 months 24 days' WHERE "id" = 11;

--  TABLE READY FOR WORK
-- 1. All values of the last_name column are currently in upper-case. We'd like to change them from e.g. "SMITH" to "Smith".
--    Using an UPDATE query and the right string function(s), make that happen.
UPDATE "people" SET "last_name" = LEFT("last_name", 1) || LOWER(RIGHT("last_name", LENGTH("last_name") - 1)) WHERE "id" < 6;
UPDATE "people" SET "last_name" = SUBSTR("last_name", 1, 1) || LOWER(SUBSTR("last_name", 2)) WHERE "id" = 6;
UPDATE "people" SET "last_name" = INITCAP("last_name") WHERE "id" > 6;

--2. Instead of dates of birth, the table has a column born_ago, a TEXT field of the form e.g. '34 years 5 months 3 days'. We'd like to 
--   convert this to an actual date of birth. In a first step, use the appropriate DDL command to add a date_of_birth column of the 
--   appropriate data type. Then, using an UPDATE query, set the date_of_birth column to the correct value based on the value of the born_ago
--   column. Finally, using another DDL command, remove the born_ago column from the table.

-- STEP 1: SPLIT THE born_ago
WITH split_date AS(
    SELECT CASE WHEN (REGEXP_SPLIT_TO_ARRAY("born_ago", ' '))[2] ~* 'year[s]?' 
            THEN (REGEXP_SPLIT_TO_ARRAY("born_ago", ' '))[1]
            WHEN (REGEXP_SPLIT_TO_ARRAY("born_ago", ' '))[4] ~* 'year[s]?' 
            THEN (REGEXP_SPLIT_TO_ARRAY("born_ago", ' '))[3]
            WHEN (REGEXP_SPLIT_TO_ARRAY("born_ago", ' '))[6] ~* 'year[s]?' 
            THEN (REGEXP_SPLIT_TO_ARRAY("born_ago", ' '))[5] ELSE '0' END :: INTEGER AS _year,
        CASE WHEN (REGEXP_SPLIT_TO_ARRAY("born_ago", ' '))[2] ~* 'month[s]?' 
            THEN (REGEXP_SPLIT_TO_ARRAY("born_ago", ' '))[1] 
            WHEN (REGEXP_SPLIT_TO_ARRAY("born_ago", ' '))[4] ~* 'month[s]?' 
            THEN (REGEXP_SPLIT_TO_ARRAY("born_ago", ' '))[3]
            WHEN (REGEXP_SPLIT_TO_ARRAY("born_ago", ' '))[6] ~* 'month[s]?' 
            THEN (REGEXP_SPLIT_TO_ARRAY("born_ago", ' '))[5] ELSE '0' END :: INTEGER AS _month,
        CASE WHEN (REGEXP_SPLIT_TO_ARRAY("born_ago", ' '))[2] ~* 'day[s]?' 
            THEN (REGEXP_SPLIT_TO_ARRAY("born_ago", ' '))[1]
            WHEN (REGEXP_SPLIT_TO_ARRAY("born_ago", ' '))[4] ~* 'day[s]?' 
            THEN (REGEXP_SPLIT_TO_ARRAY("born_ago", ' '))[3] 
            WHEN (REGEXP_SPLIT_TO_ARRAY("born_ago", ' '))[6] ~* 'day[s]?' 
            THEN (REGEXP_SPLIT_TO_ARRAY("born_ago", ' '))[5] ELSE '0' END :: INTEGER AS _day  
    FROM people
) -- THIS IS AWESOME BUT NOT WHAT WE NEED... MEHN DATES ARE CRAZY, GOTTA LEARN AND MASTER HOW TO MANIPULATE THEM.
-- INSTEAD WE NEED THIS
SELECT CURRENT_DATE - "born_ago"::INTERVAL as _date
FROM people; -- So simple

-- ADDING THE date_of_birth COLUMN
ALTER TABLE "people" ADD COLUMN "date_of_birth" DATE;
-- SETTING THE VALUES OF THE date_of_birth COLUMN
UPDATE "people" SET "date_of_birth" = CURRENT_DATE - "born_ago"::INTERVAL;
-- DROP born_ago COLUMN
ALTER TABLE "people" DROP COLUMN "born_ago";


-- DELETING ROWS
-- The basic syntax for deleting rows from a table is DELETE FROM table_name WHERE …. Just like SELECT and UPDATE, omitting the 
-- WHERE clause will delete all rows from the table. Again, this is rarely what you want to do! Contrary to TRUNCATE TABLE, doing a 
-- DELETE without a WHERE won't allow you to restart the sequence if you have one in your table. More importantly, in a future lesson 
-- we'll learn about indexing as a way to make queries perform faster in the presence of large amounts of data. Running TRUNCATE will 
-- also clear these indexes, which will further accelerate queries once new data gets inserted in that table.

-- A VERY IMPORTANT FUNCTION TO KNOW IS THE (PG_TYPEOF() which tells us the type of a value returned)
-- Look into https://www.postgresql.org/docs/9.1/functions-datetime.html to get better understanding of how to work with date and time.