# Welcome to Database Management System

### Recap
The SQL syntax bassically has 3 parts
* Data Query language (DQL)
* Data Definition language (DDL)
* Data Manipulation language (DML)

*DQL involved querying a database for certain information and this was when we do things like **SELECT**, __JOIN__, **LIMIT** etc.*

## Database Normalization
This is basically a way to store data in a relational database so it can be worked with quickly and efficiently. So your database can be ***normalised*** or ***denomalized*** (Case when is messy and not very sustainable)

### Pitfalls of denomalized database
* **Insertion anomaly**: Usually occurs when inserting data into the database and is majorly the case when rows are duplicated.
* **Update anomaly**: Occurs when data is updated and not reflected at every point of that data. This is usually the case when data is repeated.
* **Deletion anomaly**: Occurs when data is deleted from the data base. Say an item in an item stored database is exhusted, do we delete the whole row for that item? Doing so will make the item to completely disappear...

### Normal Forms
_Relational theory gives a process for denormalized data to become normalized (?)_ 

#### First Normal Form - 1NF
* **Goal #1**: Same data type in a column
* **Goal #2**: Single value in a cell
* **Goal #3**: No repeating Columns
* **Goal #4**: Uniquely identify a row

  ***Candidate keys:*** *This is a set of columns that can be pointed to and can uniquely identify a row in a dataset. Can be one or more column and each set can form our __primary key__*

  ***Composite primary key:*** *This is the case when the __primary key__ contains more than one column*

#### Second Normal Form - 2NF
* **Goal #1**: Bring to *First Normal Form*
* **Goal #2**: NO Partial Dependency

  ***Dependencies:*** *This are basically relationships between two or more attributes (or columns) in a table. E.g, if we have a table of **item_no**, **varient_code**, **item_name**, **varient_name** and **quantity** and we take the candidate key (**item_no**, **varient_code**) as our **primary key**, then we can have the following dependencies in terms of our selected primary key;*
  * **item_name**: depends on...
    * **item_no** (Has no dependency with varient_code coz the same item can have multiple varients (Blue, Black, White vareints) hence the varient_code tells nothing about the item)
  * **varient_name**: depends on...
    * **varient_code** (Does not depend on item_no for same reason, same varient of different item)
  * **quantity**: depends on...
    * **item no**, and
    * **varient_code** (Depends on both because the quantity gives the count of the varient of each item)

  ***Partial dependency:*** *a column that isn't part of the **primary key**, and that depends only on part of the primary key. For example, if the primary key (PK) is (**item_no**, **varient_code**), then the column **item_name** would be a partial dependency on the PK because it only depends on the **item_no**. Hence  **item_name** and **varient_name** have a **partial dependency** on our primary key (They depend on just a part of it and not the full key set) unlike **quantity** that depends on the full primary key.*

  ##### Surrogate Keys
  Sometimes, the data already existing in a table might not be enough to provide a sensible PK. In these cases, it would make sense to create an extra column that would be completely unrelated to the data, and use that to uniquely identify rows. Such a PK would be called a "surrogate" key. Just like a surrogate mother, it doesn't have any natural relationship with the rest of the columns in the table. Its only purpose is to allow targeting a specific row.

#### Third Normal Form - 3NF
* **Goal #1**: Bring to _Second Normal Form_
* **Goal #2**: NO Transitive dependencies

  ***Transitive dependency:*** *when a column that isn't part of the primary key depends on the primary key, but through another non-key column. For example, a table of movie reviews would have a surrogate id column as its PK, and a __movie_id__ column to refer to the movie which is being reviewed. If the table also contains a __movie_name__ column, then that __movie_name__ is transitively dependent on the PK, because it depends on it through __movie_id__.*

  *To eliminate transitive dependencies, we'll use a strategy similar to that of eliminating partial dependencies: remove the concerned columns, and, if a table linking those columns to the one they depend on doesn't exist, create it. Keeping with the movie reviews example above, this would mean creating a table for movies, with an __id__ and a __movie_name__, and only keeping the __movie_id__ column in the reviews table.*

Sometimes, following all the goal laid out rules for 1NF, 2NF and 3NF to get a denomalized dataset to a normalized one can get a little confusing and so a **pragmatic approach** might be necessitated.

#### The pragmatic approach to resolving a lack of normal forms:
* Identify entities in the denormalized or partially normalized table
* Create new tables for each entity
* Go back to the original table and use it to relate the ids to each other

#### Edge cases when normalizing databases
Sometimes, over-normalization can lead to absurd situations. One hint of this is if you find yourself having to do a ridiculous amount of ***JOINs*** in order to reconstruct a data-set, especially when the data you're joining rarely changes.

A great example of this is address data, where it's most often going to be OK to keep transitive dependencies for the benefit of having a customer's address all together in the same table: if one part of the address changes, it's likely that all of the address will change.

At the end of the day, each situation is different and you'll have to use your best judgment when determining where to normalize, in order to avoid repetitions and anomalies.

### Some relationship types:
* **One-One Relationship:** When one entity "has one" of another entity, and that second entity "belongs to" only the first. For example, entity "user" and "home address" have a one-one relationship
* **One-Many Relationship:** When one entity "has many" of another entity, and that second entity "belongs to" only the first. For example, entity "user" and "email address" have a one-many relationship, because a user can have many email addresses, but each email address belongs to only one user
* **Many-Many Relationship:** When two entities are related in such a way where many links can exist on both sides. For example, entities "books" and "categories" have a many-many relationship, because a book can have multiple categories, and a category can belong to multiple books

---

## NoSQL
"NoSQL" is a term that was coined to describe those databases that don't use the relational model.

One of the key points we discussed about relational databases is their ability to provide guarantees about the data they store. Traditionally, in order to be able to do that, a relational database server had to run in the confines of a single machine. This meant that as the needs of the business grew, so did that single server.

It turns out that scaling the resources on a server isn't linear: doubling RAM, CPU, or disk space will end up costing more than double. As usage of the Internet went up, so did the amounts of data that had to be stored, as well as the volume of queries required on that data.

NoSQL — or non-relational — databases were born out of this growing need for data and query throughput.