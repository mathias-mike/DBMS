--   DATA DEFINITION LANGUAGE

-- The common command in DDL is;
--     * CREATE TABLE
--     * ALTER TABLE

-- Some PostgreSQL data types
--  * TEXT
--  * INTEGER
--  * SERIAL

-- EXERCISE - Creating Tables:
-- 01. Create a normalized set of tables.
CREATE TABLE "employees" (
    "id" SERIAL,
    "name" TEXT,
    "manager_id" INTEGER
);

CREATE TABLE "employees_phones" (
    "emp_id" INTEGER,
    "phone" TEXT
);

-- EXERCISE - DML and Data Types
-- 02. Create a schema that can accommodate a hotel reservation system. Your schema should have:
-- The ability to store customer data: first and last name, an optional phone number, and multiple email addresses.
-- The ability to store the hotel's rooms: the hotel has twenty floors with twenty rooms on each floor. In addition to the floor and room number, we need to store the room's livable area in square feet.
-- The ability to store room reservations: we need to know which guest reserved which room, and during what period.
-- After you create the schema, you should be able to reload the workspace schema to view the results
CREATE TABLE "customers" (
    "id" SERIAL, -- <-- SERIAL is a simple INTEGER  managed by postgres. (It auto increments)
    "first_name" VARCHAR, -- <-- VARCHAR is a variable character and it's just like TEXT when no limit is specified
    "last_name" VARCHAR,
    "phone_number" VARCHAR(15)
);

CREATE TABLE "customer_emails" (
    "customer_id" INTEGER, 
    "email_address" TEXT
);

CREATE TABLE "rooms" (
    "id" SERIAL,
    "floor" SMALLINT, 
    "number" SMALLINT,
    "livable_space" REAL -- <-- REAL is used to store floating point and is inexat. If exact values are needed DECIMAL or NUMERAL 
                            --  should be used
);

CREATE TABLE "reservations" (
    "id" SERIAL,
    "customer_id" INTEGER,
    "room_id" INTEGER,
    "check_in" TIMESTAMP, -- <-- TIMESTAMP WITHOUT TIME ZONE... If we needed timezone then we use TIMESTAMP WITH TIME ZONE
    "check_out" TIMESTAMP
);


-- CREATING DATA FOR THE QUESTION BELOW
CREATE TABLE "students" (
    "id" SERIAL,
    "first_name" VARCHAR,
    "last_name" VARCHAR,
    "email_address" VARCHAR(50)
);

CREATE TABLE "courses" (
    "id" SMALLSERIAL, -- <-- Like SERIAL but with SMALLINT this time
    "code" VARCHAR(10),
    "rating" SMALLINT
);

CREATE TABLE "registrations" (
    "student_id" SMALLINT,
    "course_id" SMALLINT
);


-- EXERCISE: Modifying Table Structure
-- 03. Explore the structure of the three tables in the provided SQL workspace. We'd like to make the following changes:
-- 1. It was found out that email addresses can be longer than 50 characters. We decided to remove the limit on email address lengths to keep things simple.
-- 2. We'd like the course ratings to be more granular than just integers 0 to 10, also allowing values such as 6.45 or 9.5
-- 3. We discovered a potential issue with the registrations table that will manifest itself as the number of new students and new courses keeps increasing. Identify the issue and fix it.
ALTER TABLE "students" ALTER COLUMN "email_address" SET DATA TYPE VARCHAR;

ALTER TABLE "courses" ALTER COLUMN "rating" SET DATA TYPE DECIMAL;

-- As the number of new students keeps increasing and exceeds the limit of SMALLINT which is about 32k
-- we won't be able to add new students and course to the datebase.
ALTER TABLE "courses" ALTER COLUMN "id" SET DATA TYPE INTEGER; -- NB: So long I have made a column SERIAL, I can change it's base data type as did here and it still maintains it's serialness.

ALTER TABLE "registrations" ALTER COLUMN "student_id" SET DATA TYPE INTEGER;
ALTER TABLE "registrations" ALTER COLUMN "course_id" SET DATA TYPE INTEGER;

-- Other commands
-- DROP TABLE will completely remove a table's structure and all associated data from the database, and is a destructive operation. 
-- Unless you have a backup, there's no way to recover the lost data!
DROP TABLE "table_name";

-- TRUNCATE TABLE keeps the table structure intact, but removes all the data in the table. If you add the optional RESTART IDENTITY to the command, 
-- a SERIAL column's sequence will have its next value reset to 1.
TRUNCATE TABLE "table_name"; -- With id restart
TRUNCATE TABLE "table_name" RESTART IDENTITY; -- With id restart

-- Finally, the COMMENT command allows you to add a text comment on a table's column. If describing a table using \d table_name, you won't see the comments. 
-- You'd have to use \d+ in order to see the comments that were defined on a table.
COMMENT ON COLUMN "students"."email_address" IS 'Column student email addresses'; -- To view comment on postgres use "\d+ students"...

