-- PERFORMANCE AND INDEXING
-- \timing on -- To switch on timing in pgsl (How long it takes to execute a query).
-- Basic syntax
CREATE INDEX "index_name" ON "table_name" ("column_name");
CREATE INDEX ON "table_name" (SOME_FUNCTION("column_name")); -- e.g REGEXP_REPLACE(), LOWER()...
-- Though adding indexes makes search fast, it comes with storage cost and also slows down insertion or manipulation of data, hence redundant
-- indexes can become a problem. We can drop redundant indexes by;
DROP INDEX "index_name";

-- You can create indexes to match patterns with LIKE and = but nothing else using
CREATE INDEX ON "table_name" ("column_to_partially_match" XX_PATTERN_OPS); -- The XX can be TEXT or VARCHAR

-- Indexes can span multiple columns, and the order of those columns will determine which queries can be supported by the composite
-- (multiple-column) index.
CREATE INDEX "index_name" ON "table_name" ("column_1", "column_2");
-- Search on "column_1" and search on "column_1" AND "column_2" is supported. But search on "column_2" is not supported.

-- You can also have UNIQUE INDEX. This is actually the same as the UNIQUE CONSTRAINT that we learnt before, infact, under the hood, the unique 
-- constraint creates a unique index to allow for quick search when trying to check for uniqueness. However we might actually want to create a 
-- unique index sometimes because it allows for expressions also instead of just columns... e.g;
CREATE UNIQUE INDEX "case_sensitive_uniqueness" ON "users" (LOWER("username")); 


-- EXERCISE - Indexing
-- Creating the tables for this exercise
CREATE TABLE "books" (
    "id" SERIAL,
    "title" VARCHAR,
    "isbn" VARCHAR,
    "author_id" INTEGER
);
CREATE TABLE "authors" (
    "id" SERIAL,
    "name" VARCHAR
);
CREATE TABLE "topics" (
    "id" SERIAL,
    "name" VARCHAR
);
CREATE TABLE "book_topics" (
    "book_id" INTEGER,
    "topic_id" INTEGER
);
-- We need to be able to quickly find books and authors by their IDs. -- PRIMARY KEYS SOLVES THIS
ALTER TABLE "books" 
    ADD CONSTRAINT "books_primary_key" PRIMARY KEY ("id"),
    ADD UNIQUE ("isbn"),
    ADD FOREIGN KEY ("author_id") REFERENCES "authors" ("id") ON DELETE SET NULL;
ALTER TABLE "authors" ADD PRIMARY KEY ("id");
ALTER TABLE "topics" 
    ADD PRIMARY KEY ("id"),
    ADD UNIQUE ("name"),
    ALTER COLUMN "name" SET NOT NULL;
-- We need to be able to quickly tell which books an author has written.
CREATE INDEX "quick_book_search_by_author" ON "books" ("author_id");
-- We need to be able to quickly find a book by its ISBN # -- THE UNIQUE CONSTRAIN SOLVES THIS
-- We need to be able to quickly search for books by their titles in a case-insensitive way, even if the title is partial. 
-- For example, searching for "the" should return "The Lord of the Rings".
CREATE INDEX "comparison_fast_search" ON "books" (LOWER("title") VARCHAR_PATTERN_OPS);
-- For a given book, we need to be able to quickly find all the topics associated to it.
ALTER TABLE "book_topics" ADD CONSTRAINT "composit_primary_key_book_topics" PRIMARY KEY ("book_id", "topic_id");
-- For a given topic, we need to be able to quickly find all the books tagged with it
CREATE INDEX ON "book_topics" ("topic_id");

-- Setting all foreign keys
ALTER TABLE "book_topics" ADD CONSTRAINT "book_id_ref_books" FOREIGN KEY ("book_id") REFERENCES "books" ("id");
ALTER TABLE "book_topics" ADD CONSTRAINT "topic_id_ref_books" FOREIGN KEY ("topic_id") REFERENCES "topics" ("id");

ALTER TABLE "books" DROP CONSTRAINT "books_author_id_fkey1"; -- Deleting an extra constrain that I created.

-- QUICK NOTE: FOR ANY FOREIGN KEY ADD, THE REFERECE COLUMN MUST HAVE AN INDEX TO ALLOW FOR QUICK SEARCH AND VERIFY... 
-- ELSE POSTGRES WON'T CREATE THE FOREIGN KEY



-- EXPLAIN COMMAND
-- Syntax
EXPLAIN SELECT * FROM "user_data" WHERE "name" IS NOT NULL; -- This will not execute the query. Instead, it will show you the query plan, i.e. what Postgres would do if you were to execute that query.
ANALYZE -- CAN BE USED TO FORCE POSTGRES TO UPDATE IT'S STATISTICS
-- EXPLAIN ANALYZE
EXPLAIN ANALYZE SELECT * FROM "user_data" WHERE "name" IS NOT NULL; 



-- EXERCISE - Creating a Complete Schema
-- You're being tasked with creating a database of movies with the following specification;
-- A movie has a title and a description, and zero or more categories associated to it.
CREATE TABLE "movies" (
    "id" SERIAL PRIMARY KEY,
    "title" VARCHAR UNIQUE NOT NULL,
    "description" TEXT
);
-- A category is just a name, but that name has to be unique
CREATE TABLE "categories" (
    "id" SERIAL PRIMARY KEY,
    "category" VARCHAR UNIQUE NOT NULL
);
CREATE TABLE "movie_categories" (
    "movie_id" INTEGER REFERENCES "movies" ("id") ON DELETE CASCADE,
    "category_id" INTEGER REFERENCES "categories" ("id") ON DELETE CASCADE,
    PRIMARY KEY ("movie_id", "category_id")
);
CREATE TABLE "users" (
    "id" SERIAL PRIMARY KEY,
    "name" VARCHAR,
    "username" VARCHAR NOT NULL
);
CREATE UNIQUE INDEX "case_insensitive_uniqueness" ON "users" (LOWER("username")); -- A user's username has to be unique in a case-insensitive way,
-- Also make finding a user by their username fast
CREATE TABLE "user_ratings" (
    "user_id" INTEGER REFERENCES "users" ("id") ON DELETE SET NULL,
    "movie_id" INTEGER REFERENCES "movies" ("id") ON DELETE RESTRICT,
    "rating" SMALLINT, -- CHECK ("rating" BETWEEN 0 AND 100)
    PRIMARY KEY ("user_id", "movie_id"), -- A user can only rate a movie once
    CHECK ("rating" >= 0 AND "rating" <= 100) -- The rating is an integer between 0 and 100, inclusive
);
-- Users can "like" categories.
CREATE TABLE "likes" (
    "user_id" INTEGER REFERENCES "users" ("id") ON DELETE SET NULL,
    "category_id" INTEGER REFERENCES "categories" ("id") ON DELETE RESTRICT,
    PRIMARY KEY ("user_id", "category_id")
);

-- ADDING INDEXES TO MAKE QUERIES EXECUTE FAST...
CREATE INDEX ON "movies" (LOWER("title") VARCHAR_PATTERN_OPS);
CREATE INDEX ON "user_ratings" ("movie_id");
CREATE INDEX ON "likes" ("category_id");



