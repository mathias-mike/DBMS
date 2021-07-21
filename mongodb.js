// MongoDB, a document-oriented, schemaless NoSQL database that can scale horizontally. Here are a few commands that can be ran on the 
// mongoshell. MongoDB, unlike sequal, does not have it's own query language, so you can basically interface with it using any language
// (Python, PHP, Javascript, Java...) In this case, we will be using Javascript.
// The Document storage of mongodb happens in BSON


// MongoDB SHELL COMMANDS
// db -- shows the current database
// show dbs -- Shows a list of databases in the server
// show collections -- shows a list of collection in the current database
// use <db_name> -- Swictches to db if it exist else create new one with the name provided

// Javascript to manipulate data in mongodb database
db.presidents.insertMany([ // presidents is a collection
    {
        firstname:'Gorge',
        lastname:'Washington',
        election:[1788, 1792]

    },
    {
        firstname:'John',
        lastname:'Adams',
        election:[1796]
    },
    {
        firstname:'Barak',
        lastname:'Obama',
        election:[2008, 2012]
    }
])

// Queries
// SELECT * FROM presidents;
db.presidents.find({}) // .pretty() will return readable result

// SELECT * FROM presidents WHERE firstname = 'Gorge';
db.presidents.find({
    firstname: 'Gorge'
})

// SELECT * FROM presidents WHERE firstname = 'Gorge' AND lastname = 'Washington';
db.presidents.find({
    firstname: 'Gorge',
    lastname:'Washington'
})

// SELECT * FROM presidents WHERE firstname != 'Gorge';
db.presidents.find({
    firstname: {
        $not: {$eq: 'Gorge'}
    }
})

// SELECT * FROM presidents WHERE lastname = 'Trump' OR lastname = 'Washington';
db.presidents.find({
    $or:[
        {lastname:'Trump'},
        {lastname:'Washington'}
    ]
})

// SELECT * FROM presidents WHERE lastname LIKE '%ash%';
db.presidents.find({
    lastname:/ash/ // Regular Expression goes within the /../
})

// SELECT * FROM presidents WHERE LOWER(lastname) LIKE 'wash%';
db.presidents.find({
    lastname:/^wash/i // Regular Expression goes within the /../. ^ mean starts with, and the "i" means case-insensitive
})

// Find the president that were elected after 1792
db.presidents.find({
    election:{$gt: 1792} // $gt means greater than
})

// And so much more view: https://docs.mongodb.com/manual/tutorial/query-documents/
// https://docs.mongodb.com/manual/crud/

// EXERCISE -- Querying MongoDB
// Find the total number of events in the collection
db.events.countDocuments({}) // Result -- 225000

// The total number of events for the device with ID 8f5844d2-7ab3-478e-8ea7-4ea05ab9052e
db.events.countDocuments({
    deviceId:'8f5844d2-7ab3-478e-8ea7-4ea05ab9052e'
}) // Result -- 240

// The total number of events that came from a Firefox browser and happened on or after April 20th, 2019
db.events.countDocuments({
    'browser.vendor':'firefox',
    'timestamp': {
        $gte: ISODate('2019-04-20') // $gte means greater than or equal
    }
}) // Result -- 57225

// The list of the top 100 events that happened in Chrome on Windows, sorted in reverse chronological order
db.events.find({
    'browser.vendor': 'chrome',
    'browser.os': 'windows'
}).sort({
    'timestamp': -1 // 1 for accending
}).limit(100).pretty()
// Alternative
db.events.find({
    browser: { vendor: 'chrome', os: 'windows' } // EXACT MATCH! browser cannot contain anything other than vendor and os
  }).sort({
    timestamp: -1
  }).limit(100)


// Some basic MongoDB design patterns 
// Key points:
// * Forget relational model and data normalization but think in terms of documents
// * Duplication of data is okay
// * Store data as you will need to access it
// * 16 MB document limit

// 1. Polymorphism
//    Documents in the same collection have differnt properties of even missing properties and this is possible because of the schemaless
//    nature of mongoDB. E.g
/*
{
    _id: 1,
    name: "16GB DDR3 RAM",
    desc: "Lorem ipsum",
    category: "memory",
    price: 100.75,
    timing: "16-18-18-38", // diff
    pins: 288 // diff
}
{
    _id: 2,
    name: "1TB SSD",
    desc: "The best",
    category: "storage",
    price: 83.00,
    factor: "2.5\"", // diff
    read_speed: "2800mbps" // diff  
}
*/

// 2. Extended Reference
//    Have to seperate collection but maintain small information of one collection in the other and vise versa... E.g;
/*
    BOOK COLLECTION
{
    _id: 5,
    title: "Think and Grow Rich",
    publication: 1997,
    num_pages: 221,
    isbn: "0-7475-3211-9",
    author: {
        author_id: 55
        name: "Napoleon Hill"
    }                                                           // Brief from the authors collection
}

    AUTHOR COLLECTION
{
    _id: 55,
    name: "Napoleon Hill",
    dob: ISODate("1886-10-26"),
    residence: "Newyork",
    nationality: "American",
    books: [
        {
            book_id: 5, 
            title: "..."
        },
        {
            book_id: 12, 
            title: "..."
        }
    ]                                                         // Briefs from the books collection
}

This goes in line with storing data the way you will want to access it. Say you have a book inventory website, you will want to display each
book with the authors name as a link that can be clicked to switch to that authors page. And the authors page will have a list of all books
by that author.
*/

// 3. Subset Pattern
//    Turns out mongoDB allows for an infinit scroll kinda thing with the subset pattern where you scroll and as the list gets exaushted you
//    are presented with the option to load more or more data is just loaded automatically. 
//
//    To do this, mongoDB maintians 2 collection, one for the main page (Articles Collection) and another for the loading portion (Comments collection)
//    The Articles collection in our case will have few comments, say 10, in it's docuements (using Extended Ref) and as you scoll and the 
//    10 comments gets exausted, more comments are loaded from the comments collection and the seen comments can be trimmed off the articles 
//    document.

// 4. Outlier Pattern


// https://developer.mongodb.com/tag/schema-design for more