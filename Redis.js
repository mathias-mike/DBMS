// # Redis
/*
* An in momory Database
* Extremely fast
* General-purpose data stuctures
* Usages include;
    * Standalone
    * Companion to other database
     

The two most basic commands of Redis: GET and SET
GET key allows us to retrieve a key by its name, and SET key value allows us to assign a string value to a key.

Here is a link to redis commands: https://redis.io/commands#
*/

/* 
        EXERCISE

    Exploring data in a redis command line
    -> KEYS *
    -> HGETALL ids
        Gets a document of users: 3 and books: 3
    -> HGETALL users:1
        name: firs_name
    -> HGETALL books:1
        1) "title"
        2) "1984"
        3) "release_year"
        4) "1949"
        5) "author"
        6) "George Orwell"
    
    1. How is the system currently storing the primary keys used for users and books?
        Stored in HASH

    2. What is the name of the user with ID 3?
    -> HGETALL users:3
    -> HGET user:3 name
        "some user"

    3. What would be the ID of the next book?
    -> HGET ids books
        "3" which means next book
    -> HINCRBY ids books 
        "4"

    4. Notice that books have authors in common. Fix that by creating a new entity called authors. Add the authors to the system, 
       and then modify the books to refer to authors by their ID instead of their name.
    -> HINCRBY ids authors 
    -> HSET authors:1 name "George Orwell"
    -> HSET books:1 author 1
    -> HSET books:2 author 1
                            Made a mistake used -> HDEL books:1 authors   
                                                -> HDEL books:2 authors         
                                                                            to delete

    5. Devise a strategy that would allow users to search for books in a partial-match, case-insensitive way.
        Can be done with HSET
    
*/