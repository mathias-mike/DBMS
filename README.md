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

#### First Normal Form
* **Goal #1**: Same data type in a column
* **Goal #2**: Single value in a cell
* **Goal #3**: No repeating Columns
* **Goal #4**: Uniquely identify a row