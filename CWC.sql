-- CONSISTENCY WITH CONSTRAINTS
-- Adding contraints to database assides the one provided by the data types of each columns

-- UNIQUE CONTRAINTS - Syntax
ALTER TABLE "users" ADD UNIQUE ("username");
ALTER TABLE "users" ADD CONSTRAINT "unique_usernames" UNIQUE ("username");
CREATE TABLE "users" (
    "id" SERIAL,
    "username" VARCHAR UNIQUE
);
CREATE TABLE "users" (
    "id" SERIAL,
    "username" VARCHAR,
    UNIQUE ("username"),
    UNIQUE ("id")
);
CREATE TABLE "users" (
    "id" SERIAL,
    "username" VARCHAR,
    CONSTRAINT "unique_username" UNIQUE ("username")
);

-- PRIMARY KEY CONTRAINT
-- A primary key constraint is a special type of unique constraint: just like a unique constraint, it enforces unique values across a 
-- column or set of columns. In addition to that, it also enforces a NOT NULL, which is another database constraint that can be used by 
-- itself to ensure that a column's values cannot be null.
-- Another difference between a unique and primary key constraint is that there can only be one primary key constraint per table: this
-- primary key constraint is going to identify the column or set of columns that will be the "official" database identifier for rows in that
-- table.
-- The combination UNIQUE NOT NULL has the same effect in terms of constraints as PRIMARY KEY, but primary key constraint is a special unique 
-- key that identifies rows in the table.

-- Often, a good choice is to have a so-called "surrogate key", that is, a key that is artificially generated, and that appears nowhere in 
-- the business requirements or verbiage. This will allow us to relate different entities together without relying on a piece of business 
-- data whose rules might change in the future. In opposition to a surrogate key, a key using a value that is part of the actual data is 
-- called a "natural key".

-- EXERCISE - Unique & Primary Key Constraints
-- Creating the table for this exercise
CREATE TABLE "authors" (
    "id" SERIAL,
    "name" VARCHAR,
    "email_address" VARCHAR
);
CREATE TABLE "book_authors" (
    "book_id" INTEGER,
    "author_id" INTEGER,
    "contribution_rank" SMALLINT
);
CREATE TABLE "books" (
    "id" SERIAL,
    "title" VARCHAR,
    "isbn" VARCHAR  
);
COMMENT ON COLUMN "book_authors"."contribution_rank" IS 'Each author should have a different rank for a given book';

-- Setting ids to primary keys
ALTER TABLE "books" ADD CONSTRAINT "books_primary_key" PRIMARY KEY ("id");
ALTER TABLE "authors" ADD CONSTRAINT "authors_primary_key" PRIMARY KEY ("id");
ALTER TABLE "books" ADD UNIQUE ("isbn");
ALTER TABLE "authors" ADD UNIQUE ("email_address");
ALTER TABLE "book_authors" ADD CONSTRAINT "composite_primary_key" PRIMARY KEY("author_id", "book_id");
ALTER TABLE "book_authors" ADD CONSTRAINT "unique_contribution_rank_per_book" UNIQUE ("book_id", "contribution_rank");



-- FOREIGN KEY CONSTRAINT
-- Foreign key constraints will restrict the values in a column to only values that appear in another column.
-- They preserve REFERENTIAL INTEGRITY and can reference any column, not only the PRIMARY KEY.
-- Basic syntax: 
ALTER TABLE "table_name" ADD FOREIGN KEY ("referencing_column") REFERENCES "referenced_table" ("referenced_column");
ALTER TABLE "table_name" ADD FOREIGN KEY ("referencing_column") REFERENCES "referenced_table"; -- This would target the primary key since a column is not specified.
CREATE TABLE "table_name" (
    "column1" INTEGER REFERENCES "referenced_table" ("referenced_column"),
    "column2" INTEGER,
    FOREIGN KEY ("column2") REFERENCES "referenced_table"
);
-- FOREIGN KEY MODIFIER
-- Once we set up a foreign key constraint, the database will enforce it from all angles. For example, if we have a comments table with a
-- user_id column, and insert a new comment with a valid user ID, we shouldn't be able to delete the referenced use.
-- We can however add a modifier to our foreign keys to tell them what to do when a delete request is issued... some include;
ALTER TABLE "table_name" ADD FOREIGN KEY ("ref_col") REFERENCES "ref_table" ("col") ON DELETE CASCADE; -- Deletes every row with same value as that to be deleted
ALTER TABLE "t_name" ADD FOREIGN KEY ("ref_col") REFERENCES "ref_table" ON DELETE SET NULL; -- Sets the value of the foreign key to NULL once it's deleted on the referencing column
ALTER TABLE "t_name" ADD FOREIGN KEY ("ref_col") REFERENCES "ref_table" ON DELETE RESTRICT; -- Default modifier that prevents deletion of the primary_key due to presence in the foreign table.

-- EXERCISE - Foreign Key Constraints
-- Creating tables for this exercise
CREATE TABLE "employees" (
    "id" SERIAL PRIMARY KEY,
    "name" VARCHAR,
    "manager_id" INTEGER    
);
CREATE TABLE "projects" (
    "id" SERIAL PRIMARY KEY,
    "name" VARCHAR
);
CREATE TABLE "employee_project" (
    "employee_id" INTEGER,
    "project_id" INTEGER,
    PRIMARY KEY ("employee_id", "project_id")
);
-- When an employee who's a manager gets deleted from the system, we want to keep all the employees that were under him/her. They simply won't have a manager assigned to them.
ALTER TABLE "employees" ADD CONSTRAINT "valid_manager" FOREIGN KEY ("manager_id") REFERENCES "employees" ON DELETE SET NULL;
-- We can't delete an employee as long as they have projects assigned to them
ALTER TABLE "employee_project" ADD FOREIGN KEY ("employee_id") REFERENCES "employees" ("id") ON DELETE RESTRICT; --  Default
-- When a project gets deleted from the system, we won't need to keep track of the people who were working on it
ALTER TABLE "employee_project" ADD CONSTRAINT "valid_project" FOREIGN KEY ("project_id") REFERENCES "projects" ON DELETE CASCADE;



-- CHECK CONSTRAINTS 
-- CHECK constraints allow us to implement custom business rules at the level of the database.
-- Syntax:
ALTER TABLE "table_name" ADD CONSTRAINT "non_negative_numbers" CHECK ("qty" > 0);
ALTER TABLE "t_name" ADD CONSTRAINT "less_then_5_percent_cost" CHECK ("discount" < (5 * "cost"/100));
-- Given a table users with a date_of_birth column of type DATE, write the SQL to add a requirement for users to be at least 18 years old.
ALTER TABLE "users" CHECK (AGE(CURRENT_DATE, "date_of_birth") >= INTERVAL '18 years');

-- EXERCISE - Final Review Exercise
-- Creating the tables for this exercise
CREATE TABLE "users" (
    "id" SERIAL PRIMARY KEY,
    "name" VARCHAR NOT NULL, 
    "username" VARCHAR NOT NULL
);
ALTER TABLE "users" ADD COLUMN "email" VARCHAR;
CREATE TABLE "books" (
    "id" SERIAL PRIMARY KEY,
    "name" VARCHAR NOT NULL,
    "isbn" VARCHAR NOT NULL
);
CREATE TABLE "user_book_preferences" (
    "user_id" INTEGER,
    "book_id" INTEGER,
    "preference" INTEGER
);
-- Identify the primary key for each table
ALTER TABLE "user_book_preferences" ADD PRIMARY KEY ("user_id", "book_id");
-- Identify the unique constraints necessary for each table
ALTER TABLE "users" ADD CONSTRAINT "unique_username" UNIQUE ("username");
ALTER TABLE "users" ADD CONSTRAINT "unique_emails" UNIQUE ("email");
ALTER TABLE "books" ADD CONSTRAINT "unique_isbn" UNIQUE ("isbn");
-- Identify the foreign key constraints necessary for each table
ALTER TABLE "user_book_preferences" 
    ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON DELETE CASCADE,
    ADD FOREIGN KEY ("book_id") REFERENCES "books" ("id") ON DELETE CASCADE;
-- Usernames need to have a minimum of 5 characters
ALTER TABLE "users" ADD CONSTRAINT "valid_username" CHECK(LENGTH(TRIM("username")) >= 5);
-- A book's name cannot be empty
ALTER TABLE "books" ADD CONSTRAINT "valid_book_name" CHECK(LENGTH(TRIM("name")) > 0);
-- A book's name must start with a capital letter
ALTER TABLE "books" ADD CONSTRAINT "capital_letter_name_validation" CHECK(LEFT("name", 1) ~ '[A-Z]');
-- A user's book preferences have to be distinct
ALTER TABLE "user_book_preferences" ADD CONSTRAINT "unique_user_preference_on_books" UNIQUE ("user_id", "preference");