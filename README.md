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