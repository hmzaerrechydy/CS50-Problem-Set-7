Link: https://cs50.harvard.edu/x/2023/psets/7/


# Movies


Provided to you is a file called movies.db, a SQLite database that stores data from IMDb about movies, the people who directed and starred in them, and their ratings. In a terminal window, run sqlite3 movies.db so that you can begin executing queries on the database.


Notice that the movies table has an id column that uniquely identifies each movie, as well as columns for the title of a movie and the year in which the movie was released. The people table also has an id column, and also has columns for each person’s name and birth year.

Movie ratings, meanwhile, are stored in the ratings table. The first column in the table is movie_id: a foreign key that references the id of the movies table. The rest of the row contains data about the rating for each movie and the number of votes the movie has received on IMDb.

Finally, the stars and directors tables match people to the movies in which they acted or directed. (Only principal stars and directors are included.) Each table has just two columns: movie_id and person_id, which reference a specific movie and person, respectively.

The challenge ahead of you is to write SQL queries to answer a variety of different questions by selecting data from one or more of these tables.


For each of the following problems, you should write a single SQL query that outputs the results specified by each problem. Your response must take the form of a single SQL query, though you may nest other queries inside of your query. You should not assume anything about the ids of any particular movies or people: your queries should be accurate even if the id of any particular movie or person were different. Finally, each query should return only the data necessary to answer the question: if the problem only asks you to output the names of movies, for example, then your query should not also output each movie’s release year.




1.sql

```sql
select title from movies where year = 2008;
```


2.sql

```sql
select birth from people where name = 'Emma Stone';
```


3.sql

```sql
select title from movies where year >= 2018 order by title asc;
```


4.sql 

```sql
select count(*) from ratings where rating = 10.0;
```


5.sql

```sql
select title, year from movies where title like "Harry Potter %" limit 8;
```


6.sql 

```sql
select avg(rating) from ratings inner join movies where movies.id = ratings.movie_id and movies.year = 2012;
```


7.sql

```sql
select title, rating from movies inner join ratings where ratings.movie_id = movies.id and movies.year = 2010 order by rating desc, title;
```


8.sql

```sql
select name from people where id in (select person_id from stars inner join movies where movies.id = stars.movie_id and movies.title = 'Toy Story');
```


9.sql

```sql
select distinct name from people where id in (select person_id from stars inner join movies where movies.id = stars.movie_id and movies.year = 2004) order by birth;
```


10.sql 

```
select distinct name from people where id in (select person_id from directors inner join movies on movies.id = directors.movie_id inner join ratings on ratings.movie_id = movies.id and rating >= 9.0);
```




11.sql 

```sql
select title, name, rating from stars inner join movies on movies.id = stars.movie_id inner join people on people.id = stars.person_id and people.name = 'Chadwick Boseman' inner join ratings on movies.id = ratings.movie_id order by rating desc limit 5;
```


12.sql

```sql
select title from movies where id in (select movie_id from stars where person_id = (select id from people where name = 'Jennifer Lawrence') and movie_id in (select movie_id from stars where person_id = (select id from people where name = 'Bradley Cooper')));
```


13.sql

```sql 
select name from people where id in (select person_id from stars where movie_id in (select movie_id from stars inner join people on people.id = stars.person_id and people.name = 'Kevin Bacon' and people.birth = 1958)) except select name from people where name = 'Kevin Bacon';
```



# Fiftyville

The CS50 Duck has been stolen! The town of Fiftyville has called upon you to solve the mystery of the stolen duck. Authorities believe that the thief stole the duck and then, shortly afterwards, took a flight out of town with the help of an accomplice. Your goal is to identify:

- Who the thief is,
- What city the thief escaped to, and
- Who the thief’s accomplice is who helped them escape
All you know is that the theft took place on July 28, 2021and that it took place on Humphrey Street.

How will you go about solving this mystery? The Fiftyville authorities have taken some of the town’s records from around the time of the theft and prepared a SQLite database for you, fiftyville.db, which contains tables of data from around the town. You can query that table using SQL SELECTqueries to access the data of interest to you. Using just the information in the database, your task is to solve the mystery.


For this problem, equally as important as solving the mystery itself is the process that you use to solve the mystery. In log.sql, keep a log of all SQL queries that you run on the database. Above each query, label each with a comment (in SQL, comments are any lines that begin with --) describing why you’re running the query and/or what information you’re hoping to get out of that particular query. You can use comments in the log file to add additional notes about your thought process as you solve the mystery: ultimately, this file should serve as evidence of the process you used to identify the thief!



### Schema


```sql
CREATE TABLE crime_scene_reports (
    id INTEGER,
    year INTEGER,
    month INTEGER,
    day INTEGER,
    street TEXT,
    description TEXT,
    PRIMARY KEY(id)
);
CREATE TABLE interviews (
    id INTEGER,
    name TEXT,
    year INTEGER,
    month INTEGER,
    day INTEGER,
    transcript TEXT,
    PRIMARY KEY(id)
);
CREATE TABLE atm_transactions (
    id INTEGER,
    account_number INTEGER,
    year INTEGER,
    month INTEGER,
    day INTEGER,
    atm_location TEXT,
    transaction_type TEXT,
    amount INTEGER,
    PRIMARY KEY(id)
);
CREATE TABLE bank_accounts (
    account_number INTEGER,
    person_id INTEGER,
    creation_year INTEGER,
    FOREIGN KEY(person_id) REFERENCES people(id)
);
CREATE TABLE airports (
    id INTEGER,
    abbreviation TEXT,
    full_name TEXT,
    city TEXT,
    PRIMARY KEY(id)
);
CREATE TABLE flights (
    id INTEGER,
    origin_airport_id INTEGER,
    destination_airport_id INTEGER,
    year INTEGER,
    month INTEGER,
    day INTEGER,
    hour INTEGER,
    minute INTEGER,
    PRIMARY KEY(id),
    FOREIGN KEY(origin_airport_id) REFERENCES airports(id),
    FOREIGN KEY(destination_airport_id) REFERENCES airports(id)
);
CREATE TABLE passengers (
    flight_id INTEGER,
    passport_number INTEGER,
    seat TEXT,
    FOREIGN KEY(flight_id) REFERENCES flights(id)
);
CREATE TABLE phone_calls (
    id INTEGER,
    caller TEXT,
    receiver TEXT,
    year INTEGER,
    month INTEGER,
    day INTEGER,
    duration INTEGER,
    PRIMARY KEY(id)
);
CREATE TABLE people (
    id INTEGER,
    name TEXT,
    phone_number TEXT,
    passport_number INTEGER,
    license_plate TEXT,
    PRIMARY KEY(id)
);
CREATE TABLE bakery_security_logs (
    id INTEGER,
    year INTEGER,
    month INTEGER,
    day INTEGER,
    hour INTEGER,
    minute INTEGER,
    activity TEXT,
    license_plate TEXT,
    PRIMARY KEY(id)
);
```
