-- Keep a log of any SQL queries you execute as you solve the mystery.

select * from crime_scene_reports where street = 'Humphrey Street';

/*
I run this query to read the crime report and look for hints.

Crime scene report description:

Theft of the CS50 duck took place at 10:15am at the Humphrey Street bakery. Interviews were conducted today with three witnesses who were present at the time – each of their interview transcripts mentions the bakery.
*/

select * from interviews where year = 2021 and month = 7 and day = 28;

/*
I look up using this query the transcripts of the interviews that were inserted on the day of the crime.

Here is what I have found:

Ruth: Sometime within ten minutes of the theft, I saw the thief get into a car in the bakery parking lot and drive away. If you have security footage from the bakery parking lot, you might want to look for cars that left the parking lot in that time frame.

Eugene: I don't know the thief's name, but it was someone I recognized. Earlier this morning, before I arrived at Emma's bakery, I was walking by the ATM on Leggett Street and saw the thief there withdrawing some money.

Raymond: As the thief was leaving the bakery, they called someone who talked to them for less than a minute. In the call, I heard the thief say that they were planning to take the earliest flight out of Fiftyville tomorrow. The thief then asked the person on the other end of the phone to purchase the flight ticket.
*/

select * from people where passport_number in 
    (select passport_number from passengers where flight_id = (select id from flights where day = 29 and hour < 10 and origin_airport_id = 8 order by hour asc limit 1) and passport_number in 
        (select passport_number from people where phone_number in
            (select caller from phone_calls where day = 28 and duration < 60 and caller in 
                (select phone_number from people where id in 
                    (select person_id from bank_accounts where bank_accounts.person_id in 
                        (select id from people where license_plate in 
                            (select license_plate from bakery_security_logs where day = 28 and hour = 10 and activity = 'exit'))))))); 

/*
I've tried to filter down the 'Suspect List' using the hints mentioned in the interview but I end up with two people that share the same data: Bruce and Taylor, so filtering is not the solution to this problem. 
*/

-- From searching online I think you can solve this problem by observing and analyzing data, by running multiple queries on the hints from the interviews 

select name from people where id in 
    (select person_id from bank_accounts where account_number in 
        (select account_number from atm_transactions where day = 28 and atm_location = 'Leggett Street' and transaction_type = 'withdraw'));   

/*
I look up all the people who withdraw money from ATM in Leggett Street on the 28 of july:

Kenny
Iman
Benista
Taylor
Brooke
Luca
Diana
Bruce
*/
select name from people where license_plate in (select license_plate from bakery_security_logs where day = 28 and hour = 10 and minute > 10 and activity = 'exit'); 

/*
This query returns the names of all the people who left the bakery parking lot around the time of theft: 

Vanessa
Barry
Iman
Sofia
Taylor
Luca
Diana
Kelsey
Bruce
*/

-- Let me now compare this list with the previous one (people who withdraw money from ATM on the day of the theft)


select name from people where license_plate in 
    (select license_plate from bakery_security_logs where day = 28 and hour = 10 and minute > 10 and activity = 'exit') and id in 
        (select person_id from bank_accounts where account_number in 
            (select account_number from atm_transactions where day = 28 and atm_location = 'Leggett Street' and transaction_type = 'withdraw'));

/*
Here is the list of people who appeared in both lists, they withdraw money from ATM and left the parking lot of the bakery on the same time on the day of the theft: 

Iman
Taylor
Luca
Diana
Bruce
*/
select name from people where passport_number in 
    (select passport_number from passengers where flight_id = (select id from flights where origin_airport_id = 8 and day = 29 and hour < 10 order by hour asc limit 1)); 

/* 
This query returns all the people who took the earliest flight from the Fiftyville Regional Airport on the 29 of july: 

Kenny
Sofia
Taylor
Luca
Kelsey
Edward
Bruce
Doris
*/ 

-- Now let me compare this list with the previous list of people who appeared twice in ATM and Bakery parking lot logs


select name from people where passport_number in 
    (select passport_number from passengers where flight_id = (select id from flights where origin_airport_id = 8 and day = 29 and hour < 10 order by hour asc limit 1)) and license_plate in 
        (select license_plate from bakery_security_logs where day = 28 and hour = 10 and minute > 10 and activity = 'exit') and id in 
            (select person_id from bank_accounts where account_number in 
                (select account_number from atm_transactions where day = 28 and atm_location = 'Leggett Street' and transaction_type = 'withdraw'));

/*
After filtering the list we still have 3 people: 

Taylor
Luca
Bruce
*/
select name from people where phone_number in (select caller from phone_calls where day = 28 and duration <= 60);  

/*
Here is all the people who made a phone call in 28/07/2021 and duration is 60 seconds or less: 

Kenny
Sofia
Benista
Taylor
Diana
Kelsey
Kathryn
Bruce
Carina

*/

-- Without writing a query to find people who appeared from previous lists in this phone calls list I noice that Bruce and Taylor are the two persons who appeared in all of those lists

select * from people where passport_number in 
    (select passport_number from passengers where flight_id = (select id from flights where day = 29 and hour < 10 and origin_airport_id = 8 order by hour asc limit 1) and passport_number in 
        (select passport_number from people where phone_number in
            (select caller from phone_calls where day = 28 and duration < 60 and caller in 
                (select phone_number from people where id in 
                    (select person_id from bank_accounts where bank_accounts.person_id in 
                        (select id from people where license_plate in 
                            (select license_plate from bakery_security_logs where day = 28 and hour = 10 and minute < 25 and minute > 15 and activity = 'exit'))))))); 

-- Oh I found the theif, this the query I wrote earlier but what I missed is I didn't specifiy the minute the person left the parking lot which is within 10 minutes of the theift that occured in 10:15 so that was between 10:15 and 10:25, and after filtering all this lists I end up with one person: Bruce. 

-- Now let us figure out who is the thief’s accomplice: 
select * from people where phone_number = (select receiver from phone_calls where day = 28 and duration <= 60 and caller = (select phone_number from people where id = 686048)); 

-- I look up the receiver of the call that Bruce made in 28/07/2021 with a duration less than 60 secs, it's Robin. 

-- The city the thief ESCAPED TO
select city from airports where id = (select destination_airport_id from flights where id = (select flight_id from passengers where passport_number = (select passport_number from people where id = 686048))); 










