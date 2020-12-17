DROP TABLE IF EXISTS airport CASCADE;

DROP TABLE IF EXISTS boarding_passes CASCADE;

DROP TABLE IF EXISTS seats CASCADE;

DROP TABLE IF EXISTS aircraft CASCADE;

DROP TABLE IF EXISTS ticket CASCADE;

DROP TABLE IF EXISTS ticket_flights CASCADE;

DROP TABLE IF EXISTS bookings CASCADE;

DROP TABLE IF EXISTS flights CASCADE;

DROP TABLE IF EXISTS payment CASCADE;

DROP TABLE IF EXISTS customer_information CASCADE;

DROP TABLE IF EXISTS user_history CASCADE;




/*create tables*/


-- Extended
CREATE TABLE customer_information(
    customer_id SERIAL PRIMARY KEY,
	customer_name text NOT NULL,
	email char(50),
    phone char(15)
    
    -- PRIMARY KEY(customer_id)
);


CREATE TABLE aircraft(
    aircraft_code char(3),
    model char(25),
    RANGE integer,
    PRIMARY KEY(aircraft_code),
    CONSTRAINT "flights_aircraft_code_fkey" FOREIGN KEY (aircraft_code) REFERENCES aircraft(aircraft_code),
    CONSTRAINT "seats_aircraft_code_fkey" FOREIGN KEY (aircraft_code) REFERENCES aircraft(aircraft_code) ON DELETE CASCADE
);

CREATE TABLE airport (
    airport_code char(3) NOT NULL,
    airport_name char(40),
    city char(20),
    coordinates point,
    timezone text,
    PRIMARY KEY (airport_code)
);

CREATE TABLE flights (
    flight_id SERIAL,
    flight_no character(6) NOT NULL,
    scheduled_departure timestamp WITH time zone NOT NULL,
    scheduled_arrival timestamp WITH time zone NOT NULL,
    departure_airport character(3) NOT NULL,
    arrival_airport character(3) NOT NULL,
    STATUS character varying(20) NOT NULL,
    aircraft_code character(3) NOT NULL,
    seats_available integer NOT NULL,
    seats_booked integer NOT NULL,
    
    -- Extended
    arrival_gate char(2) NOT NULL,
    baggage_claim_no character varying NOT NULL,
    boading_time timestamp WITH time zone NOT NULL,
    gate char(2) NOT NULL,
    waitlist numeric NOT NULL,
    checked_bags integer NOT NULL,
    movie character varying NOT NULL,
    meal character varying NOT NULL,
    


    
    
    PRIMARY KEY (flight_id),
    CONSTRAINT flights_aircraft_code_fkey FOREIGN KEY (aircraft_code) REFERENCES aircraft(aircraft_code),
    CONSTRAINT flights_arrival_airport_fkey FOREIGN KEY (arrival_airport) REFERENCES airport(airport_code),
    CONSTRAINT flights_departure_airport_fkey FOREIGN KEY (departure_airport) REFERENCES airport(airport_code),
    CONSTRAINT flights_check CHECK ((scheduled_arrival > scheduled_departure)),

    CONSTRAINT flights_status_check CHECK (
        (
            (STATUS)::text = ANY (
                ARRAY [('On Time'::character varying)::text, ('Delayed'::character varying)::text, ('Departed'::character varying)::text, ('Arrived'::character varying)::text, ('Scheduled'::character varying)::text, ('Cancelled'::character varying)::text]
            )
        )
    )
);

CREATE TABLE user_history (
	history_id SERIAL PRIMARY KEY,
    departure_airport character(3) NOT NULL,
    arrival_airport character(3) NOT NULL,
    date varchar(10) NOT NULL,
    travelers integer NOT NULL,
    fair_conditions character varying(10) NOT NULL,
	flight_id SERIAL,
    
    CONSTRAINT user_history_flight_id_fkey FOREIGN KEY (flight_id) REFERENCES flights(flight_id),
    CONSTRAINT user_history_arrival_airport_fkey FOREIGN KEY (arrival_airport) REFERENCES airport(airport_code),
    CONSTRAINT user_history_departure_airport_fkey FOREIGN KEY (departure_airport) REFERENCES airport(airport_code)
);

CREATE TABLE bookings (
    book_ref character(6) NOT NULL,
    customer_id integer NOT NULL,
    book_date timestamp WITH time zone NOT NULL,
    total_amount numeric(10, 2) NOT NULL,
    PRIMARY KEY(book_ref),
    CONSTRAINT "customer_information_customer_id_fkey" FOREIGN KEY (customer_id) REFERENCES customer_information(customer_id)
);


-- Extended
CREATE TABLE payment(
    payment_id SERIAL,
	book_ref character(6) NOT NULL,
    card_number varchar(16) NOT NULL,
    taxes numeric NOT NULL,
    amount_in_dollars numeric NOT NULL,
    
    PRIMARY KEY(payment_id),
    CONSTRAINT "payment_book_ref_fkey" FOREIGN KEY (book_ref) REFERENCES bookings(book_ref)
);

CREATE TABLE ticket(
    ticket_no char(13) NOT NULL,
    book_ref character(6) NOT NULL,
    passenger_id SERIAL,
    passenger_name text NOT NULL,
    email char(50),
    phone char(15),
    PRIMARY KEY (ticket_no),
    CONSTRAINT "tickets_book_ref_fkey" FOREIGN KEY (book_ref) REFERENCES bookings(book_ref)
);

CREATE TABLE ticket_flights (
    ticket_no character(13) NOT NULL,
    flight_id integer NOT NULL,
    fare_conditions character varying(10) NOT NULL,
    amount numeric(10, 2) NOT NULL,
    PRIMARY KEY (ticket_no, flight_id),
    CONSTRAINT ticket_flights_flight_id_fkey FOREIGN KEY (flight_id) REFERENCES flights(flight_id),
    CONSTRAINT ticket_flights_ticket_no_fkey FOREIGN KEY (ticket_no) REFERENCES ticket(ticket_no),
    CONSTRAINT ticket_flights_amount_check CHECK ((amount >= (0)::numeric)),
    CONSTRAINT ticket_flights_fare_conditions_check CHECK (
        (
            (fare_conditions)::text = ANY (
                ARRAY [('Economy'::character varying)::text, ('Comfort'::character varying)::text, ('Business'::character varying)::text]
            )
        )
    )
);

CREATE TABLE boarding_passes (
    ticket_no character(13) NOT NULL,
    flight_id integer NOT NULL,
    boarding_no SERIAL,
    seat_no character varying(4) NOT NULL,
    PRIMARY KEY(ticket_no, flight_id),
    CONSTRAINT boarding_passes_ticket_no_fkey FOREIGN KEY (ticket_no, flight_id) REFERENCES ticket_flights(ticket_no, flight_id)
);

CREATE TABLE seats (
    aircraft_code character(3) NOT NULL,
    seat_no character varying(4) NOT NULL,
    fare_conditions character varying(10) NOT NULL,
    PRIMARY KEY (aircraft_code, seat_no),
    CONSTRAINT seats_aircraft_code_fkey FOREIGN KEY (aircraft_code) REFERENCES aircraft(aircraft_code) ON DELETE CASCADE,
    CONSTRAINT seats_fare_conditions_check CHECK (
        (
            (fare_conditions)::text = ANY (
                ARRAY [('Economy'::character varying)::text, ('Comfort'::character varying)::text, ('Business'::character varying)::text]
            )
        )
    )
);

/* INSERT VALUES */
/*airport table */
INSERT INTO airport
VALUES (
        'HOU',
        'George Bush Airport',
        'Houston',
        NULL,
        'CT'
    );

INSERT INTO airport
VALUES (
        'JFK',
        'John F Kennedy Airport',
        'New York',
        NULL,
        'ET'
    );

INSERT INTO airport
VALUES (
        'LAX',
        'Los Angeles Airport',
        'Los Angeles',
        NULL,
        'PT'
    );

INSERT INTO airport
VALUES ('ORD', 'O Hare Airport', 'Chicago', NULL, 'CT');

INSERT INTO airport
VALUES ('MIA', 'Miami Airport', 'Miami', NULL, 'ET');

/*aircraft*/
INSERT INTO aircraft
VALUES ('773', 'Boeing 777-300', 11100);

INSERT INTO aircraft
VALUES ('763', 'Boeing 767-300', 7900);

INSERT INTO aircraft
VALUES ('SU9', 'Boeing 777-300', 5700);

INSERT INTO aircraft
VALUES ('320', 'Boeing 777-300', 6400);

INSERT INTO aircraft
VALUES ('321', 'Boeing 777-300', 6100);

ALTER SEQUENCE flights_flight_id_seq RESTART WITH 1001;


    
INSERT INTO flights(flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, STATUS, 
aircraft_code, seats_available, seats_booked, arrival_gate, baggage_claim_no, boading_time, gate, waitlist, checked_bags, movie, meal)
SELECT
upper(left(md5(i::text), 6)),
--generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-30 00:00','1 days 15 hours 12min'),
'2020-12-14 08:00',
'2020-12-14 12:00',
--generate_series('2020-12-2 00:00'::timestamp WITH time zone,'2021-1-31 00:00','1 days 18 hours 12min'),
'HOU',
CASE WHEN RANDOM() < 0.25 THEN 'JFK' WHEN RANDOM() < 0.5 THEN 'LAX' WHEN RANDOM() < 0.75 THEN 'ORD' ELSE 'MIA' END,
'Scheduled',
CASE WHEN RANDOM() < 0.2 THEN '773' WHEN RANDOM() < 0.4 THEN '763' WHEN RANDOM() < 0.6 THEN 'SU9' WHEN RANDOM() < 0.8 THEN '320' ELSE '321' END,
50,
0,
CASE WHEN RANDOM() < 0.2 THEN 'A1' WHEN RANDOM() < 0.5 THEN 'A2' WHEN RANDOM() < 0.7 THEN 'A3' ELSE 'A4' END,
upper(left(md5(i::text), 7)),
-- generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-31 00:00','1 days 16 hours 12min'),
'2020-12-14 09:00',
CASE WHEN RANDOM() < 0.2 THEN 'D4' WHEN RANDOM() < 0.5 THEN 'D3' WHEN RANDOM() < 0.7 THEN 'D2' ELSE 'D1' END,
10,
100,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END
FROM generate_series(1, 4) s(i);

INSERT INTO flights(flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, STATUS, 
aircraft_code, seats_available, seats_booked, arrival_gate, baggage_claim_no, boading_time, gate, waitlist, checked_bags, movie, meal)
SELECT
upper(left(md5(i::text), 6)),
--generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-30 00:00','1 days 15 hours 12min'),
'2020-12-6 08:00',
'2020-12-6 12:00',
--generate_series('2020-12-2 00:00'::timestamp WITH time zone,'2021-1-31 00:00','1 days 18 hours 12min'),
'HOU',
CASE WHEN RANDOM() < 0.25 THEN 'JFK' WHEN RANDOM() < 0.5 THEN 'LAX' WHEN RANDOM() < 0.75 THEN 'ORD' ELSE 'MIA' END,
'Scheduled',
CASE WHEN RANDOM() < 0.2 THEN '773' WHEN RANDOM() < 0.4 THEN '763' WHEN RANDOM() < 0.6 THEN 'SU9' WHEN RANDOM() < 0.8 THEN '320' ELSE '321' END,
50,
0,
CASE WHEN RANDOM() < 0.2 THEN 'A1' WHEN RANDOM() < 0.5 THEN 'A2' WHEN RANDOM() < 0.7 THEN 'A3' ELSE 'A4' END,
upper(left(md5(i::text), 7)),
-- generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-31 00:00','1 days 16 hours 12min'),
'2020-12-6 09:00',
CASE WHEN RANDOM() < 0.2 THEN 'D4' WHEN RANDOM() < 0.5 THEN 'D3' WHEN RANDOM() < 0.7 THEN 'D2' ELSE 'D1' END,
10,
100,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END
FROM generate_series(1, 4) s(i);

INSERT INTO flights(flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, STATUS, 
aircraft_code, seats_available, seats_booked, arrival_gate, baggage_claim_no, boading_time, gate, waitlist, checked_bags, movie, meal)
SELECT
upper(left(md5(i::text), 6)),
--generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-30 00:00','1 days 15 hours 12min'),
'2020-12-12 08:00',
'2020-12-12 12:00',
--generate_series('2020-12-2 00:00'::timestamp WITH time zone,'2021-1-31 00:00','1 days 18 hours 12min'),
'HOU',
CASE WHEN RANDOM() < 0.25 THEN 'JFK' WHEN RANDOM() < 0.5 THEN 'LAX' WHEN RANDOM() < 0.75 THEN 'ORD' ELSE 'MIA' END,
'Scheduled',
CASE WHEN RANDOM() < 0.2 THEN '773' WHEN RANDOM() < 0.4 THEN '763' WHEN RANDOM() < 0.6 THEN 'SU9' WHEN RANDOM() < 0.8 THEN '320' ELSE '321' END,
50,
0,
CASE WHEN RANDOM() < 0.2 THEN 'A1' WHEN RANDOM() < 0.5 THEN 'A2' WHEN RANDOM() < 0.7 THEN 'A3' ELSE 'A4' END,
upper(left(md5(i::text), 7)),
-- generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-31 00:00','1 days 16 hours 12min'),
'2020-12-12 09:00',
CASE WHEN RANDOM() < 0.2 THEN 'D4' WHEN RANDOM() < 0.5 THEN 'D3' WHEN RANDOM() < 0.7 THEN 'D2' ELSE 'D1' END,
10,
100,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END
FROM generate_series(1, 4) s(i);


INSERT INTO flights(flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, STATUS, 
aircraft_code, seats_available, seats_booked, arrival_gate, baggage_claim_no, boading_time, gate, waitlist, checked_bags, movie, meal)
SELECT
upper(left(md5(i::text), 6)),
--generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-30 00:00','1 days 15 hours 12min'),
'2020-12-15 08:00',
'2020-12-15 12:00',
--generate_series('2020-12-2 00:00'::timestamp WITH time zone,'2021-1-31 00:00','1 days 18 hours 12min'),
'HOU',
CASE WHEN RANDOM() < 0.25 THEN 'JFK' WHEN RANDOM() < 0.5 THEN 'LAX' WHEN RANDOM() < 0.75 THEN 'ORD' ELSE 'MIA' END,
'Scheduled',
CASE WHEN RANDOM() < 0.2 THEN '773' WHEN RANDOM() < 0.4 THEN '763' WHEN RANDOM() < 0.6 THEN 'SU9' WHEN RANDOM() < 0.8 THEN '320' ELSE '321' END,
50,
0,
CASE WHEN RANDOM() < 0.2 THEN 'A1' WHEN RANDOM() < 0.5 THEN 'A2' WHEN RANDOM() < 0.7 THEN 'A3' ELSE 'A4' END,
upper(left(md5(i::text), 7)),
-- generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-31 00:00','1 days 16 hours 12min'),
'2020-12-15 09:00',
CASE WHEN RANDOM() < 0.2 THEN 'D4' WHEN RANDOM() < 0.5 THEN 'D3' WHEN RANDOM() < 0.7 THEN 'D2' ELSE 'D1' END,
10,
100,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END
FROM generate_series(1, 4) s(i);


INSERT INTO flights(flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, STATUS, 
aircraft_code, seats_available, seats_booked, arrival_gate, baggage_claim_no, boading_time, gate, waitlist, checked_bags, movie, meal)
SELECT
upper(left(md5(i::text), 6)),
--generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-30 00:00','1 days 15 hours 12min'),
'2020-12-25 08:00',
'2020-12-25 12:00',
--generate_series('2020-12-2 00:00'::timestamp WITH time zone,'2021-1-31 00:00','1 days 18 hours 12min'),
'HOU',
CASE WHEN RANDOM() < 0.25 THEN 'JFK' WHEN RANDOM() < 0.5 THEN 'LAX' WHEN RANDOM() < 0.75 THEN 'ORD' ELSE 'MIA' END,
'Scheduled',
CASE WHEN RANDOM() < 0.2 THEN '773' WHEN RANDOM() < 0.4 THEN '763' WHEN RANDOM() < 0.6 THEN 'SU9' WHEN RANDOM() < 0.8 THEN '320' ELSE '321' END,
50,
0,
CASE WHEN RANDOM() < 0.2 THEN 'A1' WHEN RANDOM() < 0.5 THEN 'A2' WHEN RANDOM() < 0.7 THEN 'A3' ELSE 'A4' END,
upper(left(md5(i::text), 7)),
-- generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-31 00:00','1 days 16 hours 12min'),
'2020-12-25 09:00',
CASE WHEN RANDOM() < 0.2 THEN 'D4' WHEN RANDOM() < 0.5 THEN 'D3' WHEN RANDOM() < 0.7 THEN 'D2' ELSE 'D1' END,
10,
100,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END
FROM generate_series(1, 4) s(i);


INSERT INTO flights(flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, STATUS, 
aircraft_code, seats_available, seats_booked, arrival_gate, baggage_claim_no, boading_time, gate, waitlist, checked_bags, movie, meal)
SELECT
upper(left(md5(i::text), 6)),
--generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-30 00:00','1 days 15 hours 12min'),
'2020-12-30 08:00',
'2020-12-30 12:00',
--generate_series('2020-12-2 00:00'::timestamp WITH time zone,'2021-1-31 00:00','1 days 18 hours 12min'),
'HOU',
CASE WHEN RANDOM() < 0.25 THEN 'JFK' WHEN RANDOM() < 0.5 THEN 'LAX' WHEN RANDOM() < 0.75 THEN 'ORD' ELSE 'MIA' END,
'Scheduled',
CASE WHEN RANDOM() < 0.2 THEN '773' WHEN RANDOM() < 0.4 THEN '763' WHEN RANDOM() < 0.6 THEN 'SU9' WHEN RANDOM() < 0.8 THEN '320' ELSE '321' END,
50,
0,
CASE WHEN RANDOM() < 0.2 THEN 'A1' WHEN RANDOM() < 0.5 THEN 'A2' WHEN RANDOM() < 0.7 THEN 'A3' ELSE 'A4' END,
upper(left(md5(i::text), 7)),
-- generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-31 00:00','1 days 16 hours 12min'),
'2020-12-30 09:00',
CASE WHEN RANDOM() < 0.2 THEN 'D4' WHEN RANDOM() < 0.5 THEN 'D3' WHEN RANDOM() < 0.7 THEN 'D2' ELSE 'D1' END,
10,
100,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END
FROM generate_series(1, 4) s(i);

INSERT INTO flights(flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, STATUS, 
aircraft_code, seats_available, seats_booked, arrival_gate, baggage_claim_no, boading_time, gate, waitlist, checked_bags, movie, meal)
SELECT
upper(left(md5(i::text), 6)),
--generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-30 00:00','1 days 15 hours 12min'),
'2021-1-6 08:00',
'2021-1-6 12:00',
--generate_series('2020-12-2 00:00'::timestamp WITH time zone,'2021-1-31 00:00','1 days 18 hours 12min'),
'HOU',
CASE WHEN RANDOM() < 0.25 THEN 'JFK' WHEN RANDOM() < 0.5 THEN 'LAX' WHEN RANDOM() < 0.75 THEN 'ORD' ELSE 'MIA' END,
'Scheduled',
CASE WHEN RANDOM() < 0.2 THEN '773' WHEN RANDOM() < 0.4 THEN '763' WHEN RANDOM() < 0.6 THEN 'SU9' WHEN RANDOM() < 0.8 THEN '320' ELSE '321' END,
50,
0,
CASE WHEN RANDOM() < 0.2 THEN 'A1' WHEN RANDOM() < 0.5 THEN 'A2' WHEN RANDOM() < 0.7 THEN 'A3' ELSE 'A4' END,
upper(left(md5(i::text), 7)),
-- generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-31 00:00','1 days 16 hours 12min'),
'2021-1-6 09:00',
CASE WHEN RANDOM() < 0.2 THEN 'D4' WHEN RANDOM() < 0.5 THEN 'D3' WHEN RANDOM() < 0.7 THEN 'D2' ELSE 'D1' END,
10,
100,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END
FROM generate_series(1, 4) s(i);

INSERT INTO flights(flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, STATUS, 
aircraft_code, seats_available, seats_booked, arrival_gate, baggage_claim_no, boading_time, gate, waitlist, checked_bags, movie, meal)
SELECT
upper(left(md5(i::text), 6)),
--generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-30 00:00','1 days 15 hours 12min'),
'2021-1-13 08:00',
'2021-1-13 12:00',
--generate_series('2020-12-2 00:00'::timestamp WITH time zone,'2021-1-31 00:00','1 days 18 hours 12min'),
'HOU',
CASE WHEN RANDOM() < 0.25 THEN 'JFK' WHEN RANDOM() < 0.5 THEN 'LAX' WHEN RANDOM() < 0.75 THEN 'ORD' ELSE 'MIA' END,
'Scheduled',
CASE WHEN RANDOM() < 0.2 THEN '773' WHEN RANDOM() < 0.4 THEN '763' WHEN RANDOM() < 0.6 THEN 'SU9' WHEN RANDOM() < 0.8 THEN '320' ELSE '321' END,
50,
0,
CASE WHEN RANDOM() < 0.2 THEN 'A1' WHEN RANDOM() < 0.5 THEN 'A2' WHEN RANDOM() < 0.7 THEN 'A3' ELSE 'A4' END,
upper(left(md5(i::text), 7)),
-- generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-31 00:00','1 days 16 hours 12min'),
'2021-1-13 09:00',
CASE WHEN RANDOM() < 0.2 THEN 'D4' WHEN RANDOM() < 0.5 THEN 'D3' WHEN RANDOM() < 0.7 THEN 'D2' ELSE 'D1' END,
10,
100,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END
FROM generate_series(1, 4) s(i);

INSERT INTO flights(flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, STATUS, 
aircraft_code, seats_available, seats_booked, arrival_gate, baggage_claim_no, boading_time, gate, waitlist, checked_bags, movie, meal)
SELECT
upper(left(md5(i::text), 6)),
--generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-30 00:00','1 days 15 hours 12min'),
'2021-1-18 08:00',
'2021-1-18 12:00',
--generate_series('2020-12-2 00:00'::timestamp WITH time zone,'2021-1-31 00:00','1 days 18 hours 12min'),
'HOU',
CASE WHEN RANDOM() < 0.25 THEN 'JFK' WHEN RANDOM() < 0.5 THEN 'LAX' WHEN RANDOM() < 0.75 THEN 'ORD' ELSE 'MIA' END,
'Scheduled',
CASE WHEN RANDOM() < 0.2 THEN '773' WHEN RANDOM() < 0.4 THEN '763' WHEN RANDOM() < 0.6 THEN 'SU9' WHEN RANDOM() < 0.8 THEN '320' ELSE '321' END,
50,
0,
CASE WHEN RANDOM() < 0.2 THEN 'A1' WHEN RANDOM() < 0.5 THEN 'A2' WHEN RANDOM() < 0.7 THEN 'A3' ELSE 'A4' END,
upper(left(md5(i::text), 7)),
-- generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-31 00:00','1 days 16 hours 12min'),
'2021-1-18 09:00',
CASE WHEN RANDOM() < 0.2 THEN 'D4' WHEN RANDOM() < 0.5 THEN 'D3' WHEN RANDOM() < 0.7 THEN 'D2' ELSE 'D1' END,
10,
100,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END
FROM generate_series(1, 4) s(i);



INSERT INTO flights(flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, STATUS, 
aircraft_code, seats_available, seats_booked, arrival_gate, baggage_claim_no, boading_time, gate, waitlist, checked_bags, movie, meal)
SELECT
upper(left(md5(i::text), 6)),
--generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-30 00:00','1 days 15 hours 12min'),
'2021-1-31 08:00',
'2021-1-31 12:00',
--generate_series('2020-12-2 00:00'::timestamp WITH time zone,'2021-1-31 00:00','1 days 18 hours 12min'),
'HOU',
CASE WHEN RANDOM() < 0.25 THEN 'JFK' WHEN RANDOM() < 0.5 THEN 'LAX' WHEN RANDOM() < 0.75 THEN 'ORD' ELSE 'MIA' END,
'Scheduled',
CASE WHEN RANDOM() < 0.2 THEN '773' WHEN RANDOM() < 0.4 THEN '763' WHEN RANDOM() < 0.6 THEN 'SU9' WHEN RANDOM() < 0.8 THEN '320' ELSE '321' END,
50,
0,
CASE WHEN RANDOM() < 0.2 THEN 'A1' WHEN RANDOM() < 0.5 THEN 'A2' WHEN RANDOM() < 0.7 THEN 'A3' ELSE 'A4' END,
upper(left(md5(i::text), 7)),
-- generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-31 00:00','1 days 16 hours 12min'),
'2021-1-31 09:00',
CASE WHEN RANDOM() < 0.2 THEN 'D4' WHEN RANDOM() < 0.5 THEN 'D3' WHEN RANDOM() < 0.7 THEN 'D2' ELSE 'D1' END,
10,
100,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END
FROM generate_series(1, 4) s(i);

INSERT INTO flights(flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, STATUS, 
aircraft_code, seats_available, seats_booked, arrival_gate, baggage_claim_no, boading_time, gate, waitlist, checked_bags, movie, meal)
SELECT
upper(left(md5(i::text), 6)),
--generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-30 00:00','1 days 15 hours 12min'),
'2020-12-2 08:00',
'2020-12-2 12:00',
--generate_series('2020-12-2 00:00'::timestamp WITH time zone,'2021-1-31 00:00','1 days 18 hours 12min'),
'JFK',
CASE WHEN RANDOM() < 0.25 THEN 'HOU' WHEN RANDOM() < 0.5 THEN 'LAX' WHEN RANDOM() < 0.75 THEN 'ORD' ELSE 'MIA' END,
'Scheduled',
CASE WHEN RANDOM() < 0.2 THEN '773' WHEN RANDOM() < 0.4 THEN '763' WHEN RANDOM() < 0.6 THEN 'SU9' WHEN RANDOM() < 0.8 THEN '320' ELSE '321' END,
50,
0,
CASE WHEN RANDOM() < 0.2 THEN 'A1' WHEN RANDOM() < 0.5 THEN 'A2' WHEN RANDOM() < 0.7 THEN 'A3' ELSE 'A4' END,
upper(left(md5(i::text), 7)),
-- generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-31 00:00','1 days 16 hours 12min'),
'2020-12-2 09:00',
CASE WHEN RANDOM() < 0.2 THEN 'D4' WHEN RANDOM() < 0.5 THEN 'D3' WHEN RANDOM() < 0.7 THEN 'D2' ELSE 'D1' END,
10,
100,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END
FROM generate_series(1, 4) s(i);

INSERT INTO flights(flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, STATUS, 
aircraft_code, seats_available, seats_booked, arrival_gate, baggage_claim_no, boading_time, gate, waitlist, checked_bags, movie, meal)
SELECT
upper(left(md5(i::text), 6)),
--generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-30 00:00','1 days 15 hours 12min'),
'2020-12-6 08:00',
'2020-12-6 12:00',
--generate_series('2020-12-2 00:00'::timestamp WITH time zone,'2021-1-31 00:00','1 days 18 hours 12min'),
'JFK',
CASE WHEN RANDOM() < 0.25 THEN 'HOU' WHEN RANDOM() < 0.5 THEN 'LAX' WHEN RANDOM() < 0.75 THEN 'ORD' ELSE 'MIA' END,
'Scheduled',
CASE WHEN RANDOM() < 0.2 THEN '773' WHEN RANDOM() < 0.4 THEN '763' WHEN RANDOM() < 0.6 THEN 'SU9' WHEN RANDOM() < 0.8 THEN '320' ELSE '321' END,
50,
0,
CASE WHEN RANDOM() < 0.2 THEN 'A1' WHEN RANDOM() < 0.5 THEN 'A2' WHEN RANDOM() < 0.7 THEN 'A3' ELSE 'A4' END,
upper(left(md5(i::text), 7)),
-- generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-31 00:00','1 days 16 hours 12min'),
'2020-12-6 09:00',
CASE WHEN RANDOM() < 0.2 THEN 'D4' WHEN RANDOM() < 0.5 THEN 'D3' WHEN RANDOM() < 0.7 THEN 'D2' ELSE 'D1' END,
10,
100,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END
FROM generate_series(1, 4) s(i);

INSERT INTO flights(flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, STATUS, 
aircraft_code, seats_available, seats_booked, arrival_gate, baggage_claim_no, boading_time, gate, waitlist, checked_bags, movie, meal)
SELECT
upper(left(md5(i::text), 6)),
--generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-30 00:00','1 days 15 hours 12min'),
'2020-12-12 08:00',
'2020-12-12 12:00',
--generate_series('2020-12-2 00:00'::timestamp WITH time zone,'2021-1-31 00:00','1 days 18 hours 12min'),
'JFK',
CASE WHEN RANDOM() < 0.25 THEN 'HOU' WHEN RANDOM() < 0.5 THEN 'LAX' WHEN RANDOM() < 0.75 THEN 'ORD' ELSE 'MIA' END,
'Scheduled',
CASE WHEN RANDOM() < 0.2 THEN '773' WHEN RANDOM() < 0.4 THEN '763' WHEN RANDOM() < 0.6 THEN 'SU9' WHEN RANDOM() < 0.8 THEN '320' ELSE '321' END,
50,
0,
CASE WHEN RANDOM() < 0.2 THEN 'A1' WHEN RANDOM() < 0.5 THEN 'A2' WHEN RANDOM() < 0.7 THEN 'A3' ELSE 'A4' END,
upper(left(md5(i::text), 7)),
-- generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-31 00:00','1 days 16 hours 12min'),
'2020-12-12 09:00',
CASE WHEN RANDOM() < 0.2 THEN 'D4' WHEN RANDOM() < 0.5 THEN 'D3' WHEN RANDOM() < 0.7 THEN 'D2' ELSE 'D1' END,
10,
100,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END
FROM generate_series(1, 4) s(i);


INSERT INTO flights(flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, STATUS, 
aircraft_code, seats_available, seats_booked, arrival_gate, baggage_claim_no, boading_time, gate, waitlist, checked_bags, movie, meal)
SELECT
upper(left(md5(i::text), 6)),
--generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-30 00:00','1 days 15 hours 12min'),
'2020-12-15 08:00',
'2020-12-15 12:00',
--generate_series('2020-12-2 00:00'::timestamp WITH time zone,'2021-1-31 00:00','1 days 18 hours 12min'),
'JFK',
CASE WHEN RANDOM() < 0.25 THEN 'HOU' WHEN RANDOM() < 0.5 THEN 'LAX' WHEN RANDOM() < 0.75 THEN 'ORD' ELSE 'MIA' END,
'Scheduled',
CASE WHEN RANDOM() < 0.2 THEN '773' WHEN RANDOM() < 0.4 THEN '763' WHEN RANDOM() < 0.6 THEN 'SU9' WHEN RANDOM() < 0.8 THEN '320' ELSE '321' END,
50,
0,
CASE WHEN RANDOM() < 0.2 THEN 'A1' WHEN RANDOM() < 0.5 THEN 'A2' WHEN RANDOM() < 0.7 THEN 'A3' ELSE 'A4' END,
upper(left(md5(i::text), 7)),
-- generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-31 00:00','1 days 16 hours 12min'),
'2020-12-15 09:00',
CASE WHEN RANDOM() < 0.2 THEN 'D4' WHEN RANDOM() < 0.5 THEN 'D3' WHEN RANDOM() < 0.7 THEN 'D2' ELSE 'D1' END,
10,
100,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END
FROM generate_series(1, 4) s(i);


INSERT INTO flights(flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, STATUS, 
aircraft_code, seats_available, seats_booked, arrival_gate, baggage_claim_no, boading_time, gate, waitlist, checked_bags, movie, meal)
SELECT
upper(left(md5(i::text), 6)),
--generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-30 00:00','1 days 15 hours 12min'),
'2020-12-25 08:00',
'2020-12-25 12:00',
--generate_series('2020-12-2 00:00'::timestamp WITH time zone,'2021-1-31 00:00','1 days 18 hours 12min'),
'JFK',
CASE WHEN RANDOM() < 0.25 THEN 'HOU' WHEN RANDOM() < 0.5 THEN 'LAX' WHEN RANDOM() < 0.75 THEN 'ORD' ELSE 'MIA' END,
'Scheduled',
CASE WHEN RANDOM() < 0.2 THEN '773' WHEN RANDOM() < 0.4 THEN '763' WHEN RANDOM() < 0.6 THEN 'SU9' WHEN RANDOM() < 0.8 THEN '320' ELSE '321' END,
50,
0,
CASE WHEN RANDOM() < 0.2 THEN 'A1' WHEN RANDOM() < 0.5 THEN 'A2' WHEN RANDOM() < 0.7 THEN 'A3' ELSE 'A4' END,
upper(left(md5(i::text), 7)),
-- generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-31 00:00','1 days 16 hours 12min'),
'2020-12-25 09:00',
CASE WHEN RANDOM() < 0.2 THEN 'D4' WHEN RANDOM() < 0.5 THEN 'D3' WHEN RANDOM() < 0.7 THEN 'D2' ELSE 'D1' END,
10,
100,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END
FROM generate_series(1, 4) s(i);


INSERT INTO flights(flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, STATUS, 
aircraft_code, seats_available, seats_booked, arrival_gate, baggage_claim_no, boading_time, gate, waitlist, checked_bags, movie, meal)
SELECT
upper(left(md5(i::text), 6)),
--generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-30 00:00','1 days 15 hours 12min'),
'2020-12-30 08:00',
'2020-12-30 12:00',
--generate_series('2020-12-2 00:00'::timestamp WITH time zone,'2021-1-31 00:00','1 days 18 hours 12min'),
'JFK',
CASE WHEN RANDOM() < 0.25 THEN 'HOU' WHEN RANDOM() < 0.5 THEN 'LAX' WHEN RANDOM() < 0.75 THEN 'ORD' ELSE 'MIA' END,
'Scheduled',
CASE WHEN RANDOM() < 0.2 THEN '773' WHEN RANDOM() < 0.4 THEN '763' WHEN RANDOM() < 0.6 THEN 'SU9' WHEN RANDOM() < 0.8 THEN '320' ELSE '321' END,
50,
0,
CASE WHEN RANDOM() < 0.2 THEN 'A1' WHEN RANDOM() < 0.5 THEN 'A2' WHEN RANDOM() < 0.7 THEN 'A3' ELSE 'A4' END,
upper(left(md5(i::text), 7)),
-- generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-31 00:00','1 days 16 hours 12min'),
'2020-12-30 09:00',
CASE WHEN RANDOM() < 0.2 THEN 'D4' WHEN RANDOM() < 0.5 THEN 'D3' WHEN RANDOM() < 0.7 THEN 'D2' ELSE 'D1' END,
10,
100,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END
FROM generate_series(1, 4) s(i);

INSERT INTO flights(flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, STATUS, 
aircraft_code, seats_available, seats_booked, arrival_gate, baggage_claim_no, boading_time, gate, waitlist, checked_bags, movie, meal)
SELECT
upper(left(md5(i::text), 6)),
--generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-30 00:00','1 days 15 hours 12min'),
'2021-1-6 08:00',
'2021-1-6 12:00',
--generate_series('2020-12-2 00:00'::timestamp WITH time zone,'2021-1-31 00:00','1 days 18 hours 12min'),
'JFK',
CASE WHEN RANDOM() < 0.25 THEN 'HOU' WHEN RANDOM() < 0.5 THEN 'LAX' WHEN RANDOM() < 0.75 THEN 'ORD' ELSE 'MIA' END,
'Scheduled',
CASE WHEN RANDOM() < 0.2 THEN '773' WHEN RANDOM() < 0.4 THEN '763' WHEN RANDOM() < 0.6 THEN 'SU9' WHEN RANDOM() < 0.8 THEN '320' ELSE '321' END,
50,
0,
CASE WHEN RANDOM() < 0.2 THEN 'A1' WHEN RANDOM() < 0.5 THEN 'A2' WHEN RANDOM() < 0.7 THEN 'A3' ELSE 'A4' END,
upper(left(md5(i::text), 7)),
-- generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-31 00:00','1 days 16 hours 12min'),
'2021-1-6 09:00',
CASE WHEN RANDOM() < 0.2 THEN 'D4' WHEN RANDOM() < 0.5 THEN 'D3' WHEN RANDOM() < 0.7 THEN 'D2' ELSE 'D1' END,
10,
100,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END
FROM generate_series(1, 4) s(i);

INSERT INTO flights(flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, STATUS, 
aircraft_code, seats_available, seats_booked, arrival_gate, baggage_claim_no, boading_time, gate, waitlist, checked_bags, movie, meal)
SELECT
upper(left(md5(i::text), 6)),
--generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-30 00:00','1 days 15 hours 12min'),
'2021-1-13 08:00',
'2021-1-13 12:00',
--generate_series('2020-12-2 00:00'::timestamp WITH time zone,'2021-1-31 00:00','1 days 18 hours 12min'),
'JFK',
CASE WHEN RANDOM() < 0.25 THEN 'HOU' WHEN RANDOM() < 0.5 THEN 'LAX' WHEN RANDOM() < 0.75 THEN 'ORD' ELSE 'MIA' END,
'Scheduled',
CASE WHEN RANDOM() < 0.2 THEN '773' WHEN RANDOM() < 0.4 THEN '763' WHEN RANDOM() < 0.6 THEN 'SU9' WHEN RANDOM() < 0.8 THEN '320' ELSE '321' END,
50,
0,
CASE WHEN RANDOM() < 0.2 THEN 'A1' WHEN RANDOM() < 0.5 THEN 'A2' WHEN RANDOM() < 0.7 THEN 'A3' ELSE 'A4' END,
upper(left(md5(i::text), 7)),
-- generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-31 00:00','1 days 16 hours 12min'),
'2021-1-13 09:00',
CASE WHEN RANDOM() < 0.2 THEN 'D4' WHEN RANDOM() < 0.5 THEN 'D3' WHEN RANDOM() < 0.7 THEN 'D2' ELSE 'D1' END,
10,
100,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END
FROM generate_series(1, 4) s(i);

INSERT INTO flights(flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, STATUS, 
aircraft_code, seats_available, seats_booked, arrival_gate, baggage_claim_no, boading_time, gate, waitlist, checked_bags, movie, meal)
SELECT
upper(left(md5(i::text), 6)),
--generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-30 00:00','1 days 15 hours 12min'),
'2021-1-18 08:00',
'2021-1-18 12:00',
--generate_series('2020-12-2 00:00'::timestamp WITH time zone,'2021-1-31 00:00','1 days 18 hours 12min'),
'JFK',
CASE WHEN RANDOM() < 0.25 THEN 'HOU' WHEN RANDOM() < 0.5 THEN 'LAX' WHEN RANDOM() < 0.75 THEN 'ORD' ELSE 'MIA' END,
'Scheduled',
CASE WHEN RANDOM() < 0.2 THEN '773' WHEN RANDOM() < 0.4 THEN '763' WHEN RANDOM() < 0.6 THEN 'SU9' WHEN RANDOM() < 0.8 THEN '320' ELSE '321' END,
50,
0,
CASE WHEN RANDOM() < 0.2 THEN 'A1' WHEN RANDOM() < 0.5 THEN 'A2' WHEN RANDOM() < 0.7 THEN 'A3' ELSE 'A4' END,
upper(left(md5(i::text), 7)),
-- generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-31 00:00','1 days 16 hours 12min'),
'2021-1-18 09:00',
CASE WHEN RANDOM() < 0.2 THEN 'D4' WHEN RANDOM() < 0.5 THEN 'D3' WHEN RANDOM() < 0.7 THEN 'D2' ELSE 'D1' END,
10,
100,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END
FROM generate_series(1, 4) s(i);



INSERT INTO flights(flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, STATUS, 
aircraft_code, seats_available, seats_booked, arrival_gate, baggage_claim_no, boading_time, gate, waitlist, checked_bags, movie, meal)
SELECT
upper(left(md5(i::text), 6)),
--generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-30 00:00','1 days 15 hours 12min'),
'2021-1-31 08:00',
'2021-1-31 12:00',
--generate_series('2020-12-2 00:00'::timestamp WITH time zone,'2021-1-31 00:00','1 days 18 hours 12min'),
'JFK',
CASE WHEN RANDOM() < 0.25 THEN 'HOU' WHEN RANDOM() < 0.5 THEN 'LAX' WHEN RANDOM() < 0.75 THEN 'ORD' ELSE 'MIA' END,
'Scheduled',
CASE WHEN RANDOM() < 0.2 THEN '773' WHEN RANDOM() < 0.4 THEN '763' WHEN RANDOM() < 0.6 THEN 'SU9' WHEN RANDOM() < 0.8 THEN '320' ELSE '321' END,
50,
0,
CASE WHEN RANDOM() < 0.2 THEN 'A1' WHEN RANDOM() < 0.5 THEN 'A2' WHEN RANDOM() < 0.7 THEN 'A3' ELSE 'A4' END,
upper(left(md5(i::text), 7)),
-- generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-31 00:00','1 days 16 hours 12min'),
'2021-1-31 09:00',
CASE WHEN RANDOM() < 0.2 THEN 'D4' WHEN RANDOM() < 0.5 THEN 'D3' WHEN RANDOM() < 0.7 THEN 'D2' ELSE 'D1' END,
10,
100,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END
FROM generate_series(1, 4) s(i);


INSERT INTO flights(flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, STATUS, 
aircraft_code, seats_available, seats_booked, arrival_gate, baggage_claim_no, boading_time, gate, waitlist, checked_bags, movie, meal)
SELECT
upper(left(md5(i::text), 6)),
--generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-30 00:00','1 days 15 hours 12min'),
'2020-12-2 08:00',
'2020-12-2 12:00',
--generate_series('2020-12-2 00:00'::timestamp WITH time zone,'2021-1-31 00:00','1 days 18 hours 12min'),
'LAX',
CASE WHEN RANDOM() < 0.25 THEN 'HOU' WHEN RANDOM() < 0.5 THEN 'JFK' WHEN RANDOM() < 0.75 THEN 'ORD' ELSE 'MIA' END,
'Scheduled',
CASE WHEN RANDOM() < 0.2 THEN '773' WHEN RANDOM() < 0.4 THEN '763' WHEN RANDOM() < 0.6 THEN 'SU9' WHEN RANDOM() < 0.8 THEN '320' ELSE '321' END,
50,
0,
CASE WHEN RANDOM() < 0.2 THEN 'A1' WHEN RANDOM() < 0.5 THEN 'A2' WHEN RANDOM() < 0.7 THEN 'A3' ELSE 'A4' END,
upper(left(md5(i::text), 7)),
-- generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-31 00:00','1 days 16 hours 12min'),
'2020-12-2 09:00',
CASE WHEN RANDOM() < 0.2 THEN 'D4' WHEN RANDOM() < 0.5 THEN 'D3' WHEN RANDOM() < 0.7 THEN 'D2' ELSE 'D1' END,
10,
100,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END
FROM generate_series(1, 4) s(i);

INSERT INTO flights(flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, STATUS, 
aircraft_code, seats_available, seats_booked, arrival_gate, baggage_claim_no, boading_time, gate, waitlist, checked_bags, movie, meal)
SELECT
upper(left(md5(i::text), 6)),
--generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-30 00:00','1 days 15 hours 12min'),
'2020-12-6 08:00',
'2020-12-6 12:00',
--generate_series('2020-12-2 00:00'::timestamp WITH time zone,'2021-1-31 00:00','1 days 18 hours 12min'),
'LAX',
CASE WHEN RANDOM() < 0.25 THEN 'HOU' WHEN RANDOM() < 0.5 THEN 'JFK' WHEN RANDOM() < 0.75 THEN 'ORD' ELSE 'MIA' END,
'Scheduled',
CASE WHEN RANDOM() < 0.2 THEN '773' WHEN RANDOM() < 0.4 THEN '763' WHEN RANDOM() < 0.6 THEN 'SU9' WHEN RANDOM() < 0.8 THEN '320' ELSE '321' END,
50,
0,
CASE WHEN RANDOM() < 0.2 THEN 'A1' WHEN RANDOM() < 0.5 THEN 'A2' WHEN RANDOM() < 0.7 THEN 'A3' ELSE 'A4' END,
upper(left(md5(i::text), 7)),
-- generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-31 00:00','1 days 16 hours 12min'),
'2020-12-6 09:00',
CASE WHEN RANDOM() < 0.2 THEN 'D4' WHEN RANDOM() < 0.5 THEN 'D3' WHEN RANDOM() < 0.7 THEN 'D2' ELSE 'D1' END,
10,
100,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END
FROM generate_series(1, 4) s(i);

INSERT INTO flights(flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, STATUS, 
aircraft_code, seats_available, seats_booked, arrival_gate, baggage_claim_no, boading_time, gate, waitlist, checked_bags, movie, meal)
SELECT
upper(left(md5(i::text), 6)),
--generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-30 00:00','1 days 15 hours 12min'),
'2020-12-12 08:00',
'2020-12-12 12:00',
--generate_series('2020-12-2 00:00'::timestamp WITH time zone,'2021-1-31 00:00','1 days 18 hours 12min'),
'LAX',
CASE WHEN RANDOM() < 0.25 THEN 'HOU' WHEN RANDOM() < 0.5 THEN 'JFK' WHEN RANDOM() < 0.75 THEN 'ORD' ELSE 'MIA' END,
'Scheduled',
CASE WHEN RANDOM() < 0.2 THEN '773' WHEN RANDOM() < 0.4 THEN '763' WHEN RANDOM() < 0.6 THEN 'SU9' WHEN RANDOM() < 0.8 THEN '320' ELSE '321' END,
50,
0,
CASE WHEN RANDOM() < 0.2 THEN 'A1' WHEN RANDOM() < 0.5 THEN 'A2' WHEN RANDOM() < 0.7 THEN 'A3' ELSE 'A4' END,
upper(left(md5(i::text), 7)),
-- generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-31 00:00','1 days 16 hours 12min'),
'2020-12-12 09:00',
CASE WHEN RANDOM() < 0.2 THEN 'D4' WHEN RANDOM() < 0.5 THEN 'D3' WHEN RANDOM() < 0.7 THEN 'D2' ELSE 'D1' END,
10,
100,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END
FROM generate_series(1, 4) s(i);


INSERT INTO flights(flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, STATUS, 
aircraft_code, seats_available, seats_booked, arrival_gate, baggage_claim_no, boading_time, gate, waitlist, checked_bags, movie, meal)
SELECT
upper(left(md5(i::text), 6)),
--generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-30 00:00','1 days 15 hours 12min'),
'2020-12-15 08:00',
'2020-12-15 12:00',
--generate_series('2020-12-2 00:00'::timestamp WITH time zone,'2021-1-31 00:00','1 days 18 hours 12min'),
'LAX',
CASE WHEN RANDOM() < 0.25 THEN 'HOU' WHEN RANDOM() < 0.5 THEN 'JFK' WHEN RANDOM() < 0.75 THEN 'ORD' ELSE 'MIA' END,
'Scheduled',
CASE WHEN RANDOM() < 0.2 THEN '773' WHEN RANDOM() < 0.4 THEN '763' WHEN RANDOM() < 0.6 THEN 'SU9' WHEN RANDOM() < 0.8 THEN '320' ELSE '321' END,
50,
0,
CASE WHEN RANDOM() < 0.2 THEN 'A1' WHEN RANDOM() < 0.5 THEN 'A2' WHEN RANDOM() < 0.7 THEN 'A3' ELSE 'A4' END,
upper(left(md5(i::text), 7)),
-- generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-31 00:00','1 days 16 hours 12min'),
'2020-12-15 09:00',
CASE WHEN RANDOM() < 0.2 THEN 'D4' WHEN RANDOM() < 0.5 THEN 'D3' WHEN RANDOM() < 0.7 THEN 'D2' ELSE 'D1' END,
10,
100,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END
FROM generate_series(1, 4) s(i);


INSERT INTO flights(flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, STATUS, 
aircraft_code, seats_available, seats_booked, arrival_gate, baggage_claim_no, boading_time, gate, waitlist, checked_bags, movie, meal)
SELECT
upper(left(md5(i::text), 6)),
--generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-30 00:00','1 days 15 hours 12min'),
'2020-12-25 08:00',
'2020-12-25 12:00',
--generate_series('2020-12-2 00:00'::timestamp WITH time zone,'2021-1-31 00:00','1 days 18 hours 12min'),
'LAX',
CASE WHEN RANDOM() < 0.25 THEN 'HOU' WHEN RANDOM() < 0.5 THEN 'JFK' WHEN RANDOM() < 0.75 THEN 'ORD' ELSE 'MIA' END,
'Scheduled',
CASE WHEN RANDOM() < 0.2 THEN '773' WHEN RANDOM() < 0.4 THEN '763' WHEN RANDOM() < 0.6 THEN 'SU9' WHEN RANDOM() < 0.8 THEN '320' ELSE '321' END,
50,
0,
CASE WHEN RANDOM() < 0.2 THEN 'A1' WHEN RANDOM() < 0.5 THEN 'A2' WHEN RANDOM() < 0.7 THEN 'A3' ELSE 'A4' END,
upper(left(md5(i::text), 7)),
-- generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-31 00:00','1 days 16 hours 12min'),
'2020-12-25 09:00',
CASE WHEN RANDOM() < 0.2 THEN 'D4' WHEN RANDOM() < 0.5 THEN 'D3' WHEN RANDOM() < 0.7 THEN 'D2' ELSE 'D1' END,
10,
100,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END
FROM generate_series(1, 4) s(i);


INSERT INTO flights(flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, STATUS, 
aircraft_code, seats_available, seats_booked, arrival_gate, baggage_claim_no, boading_time, gate, waitlist, checked_bags, movie, meal)
SELECT
upper(left(md5(i::text), 6)),
--generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-30 00:00','1 days 15 hours 12min'),
'2020-12-30 08:00',
'2020-12-30 12:00',
--generate_series('2020-12-2 00:00'::timestamp WITH time zone,'2021-1-31 00:00','1 days 18 hours 12min'),
'LAX',
CASE WHEN RANDOM() < 0.25 THEN 'HOU' WHEN RANDOM() < 0.5 THEN 'JFK' WHEN RANDOM() < 0.75 THEN 'ORD' ELSE 'MIA' END,
'Scheduled',
CASE WHEN RANDOM() < 0.2 THEN '773' WHEN RANDOM() < 0.4 THEN '763' WHEN RANDOM() < 0.6 THEN 'SU9' WHEN RANDOM() < 0.8 THEN '320' ELSE '321' END,
50,
0,
CASE WHEN RANDOM() < 0.2 THEN 'A1' WHEN RANDOM() < 0.5 THEN 'A2' WHEN RANDOM() < 0.7 THEN 'A3' ELSE 'A4' END,
upper(left(md5(i::text), 7)),
-- generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-31 00:00','1 days 16 hours 12min'),
'2020-12-30 09:00',
CASE WHEN RANDOM() < 0.2 THEN 'D4' WHEN RANDOM() < 0.5 THEN 'D3' WHEN RANDOM() < 0.7 THEN 'D2' ELSE 'D1' END,
10,
100,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END
FROM generate_series(1, 4) s(i);

INSERT INTO flights(flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, STATUS, 
aircraft_code, seats_available, seats_booked, arrival_gate, baggage_claim_no, boading_time, gate, waitlist, checked_bags, movie, meal)
SELECT
upper(left(md5(i::text), 6)),
--generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-30 00:00','1 days 15 hours 12min'),
'2021-1-6 08:00',
'2021-1-6 12:00',
--generate_series('2020-12-2 00:00'::timestamp WITH time zone,'2021-1-31 00:00','1 days 18 hours 12min'),
'LAX',
CASE WHEN RANDOM() < 0.25 THEN 'HOU' WHEN RANDOM() < 0.5 THEN 'JFK' WHEN RANDOM() < 0.75 THEN 'ORD' ELSE 'MIA' END,
'Scheduled',
CASE WHEN RANDOM() < 0.2 THEN '773' WHEN RANDOM() < 0.4 THEN '763' WHEN RANDOM() < 0.6 THEN 'SU9' WHEN RANDOM() < 0.8 THEN '320' ELSE '321' END,
50,
0,
CASE WHEN RANDOM() < 0.2 THEN 'A1' WHEN RANDOM() < 0.5 THEN 'A2' WHEN RANDOM() < 0.7 THEN 'A3' ELSE 'A4' END,
upper(left(md5(i::text), 7)),
-- generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-31 00:00','1 days 16 hours 12min'),
'2021-1-6 09:00',
CASE WHEN RANDOM() < 0.2 THEN 'D4' WHEN RANDOM() < 0.5 THEN 'D3' WHEN RANDOM() < 0.7 THEN 'D2' ELSE 'D1' END,
10,
100,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END
FROM generate_series(1, 4) s(i);

INSERT INTO flights(flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, STATUS, 
aircraft_code, seats_available, seats_booked, arrival_gate, baggage_claim_no, boading_time, gate, waitlist, checked_bags, movie, meal)
SELECT
upper(left(md5(i::text), 6)),
--generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-30 00:00','1 days 15 hours 12min'),
'2021-1-13 08:00',
'2021-1-13 12:00',
--generate_series('2020-12-2 00:00'::timestamp WITH time zone,'2021-1-31 00:00','1 days 18 hours 12min'),
'LAX',
CASE WHEN RANDOM() < 0.25 THEN 'HOU' WHEN RANDOM() < 0.5 THEN 'JFK' WHEN RANDOM() < 0.75 THEN 'ORD' ELSE 'MIA' END,
'Scheduled',
CASE WHEN RANDOM() < 0.2 THEN '773' WHEN RANDOM() < 0.4 THEN '763' WHEN RANDOM() < 0.6 THEN 'SU9' WHEN RANDOM() < 0.8 THEN '320' ELSE '321' END,
50,
0,
CASE WHEN RANDOM() < 0.2 THEN 'A1' WHEN RANDOM() < 0.5 THEN 'A2' WHEN RANDOM() < 0.7 THEN 'A3' ELSE 'A4' END,
upper(left(md5(i::text), 7)),
-- generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-31 00:00','1 days 16 hours 12min'),
'2021-1-13 09:00',
CASE WHEN RANDOM() < 0.2 THEN 'D4' WHEN RANDOM() < 0.5 THEN 'D3' WHEN RANDOM() < 0.7 THEN 'D2' ELSE 'D1' END,
10,
100,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END
FROM generate_series(1, 4) s(i);

INSERT INTO flights(flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, STATUS, 
aircraft_code, seats_available, seats_booked, arrival_gate, baggage_claim_no, boading_time, gate, waitlist, checked_bags, movie, meal)
SELECT
upper(left(md5(i::text), 6)),
--generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-30 00:00','1 days 15 hours 12min'),
'2021-1-18 08:00',
'2021-1-18 12:00',
--generate_series('2020-12-2 00:00'::timestamp WITH time zone,'2021-1-31 00:00','1 days 18 hours 12min'),
'LAX',
CASE WHEN RANDOM() < 0.25 THEN 'HOU' WHEN RANDOM() < 0.5 THEN 'JFK' WHEN RANDOM() < 0.75 THEN 'ORD' ELSE 'MIA' END,
'Scheduled',
CASE WHEN RANDOM() < 0.2 THEN '773' WHEN RANDOM() < 0.4 THEN '763' WHEN RANDOM() < 0.6 THEN 'SU9' WHEN RANDOM() < 0.8 THEN '320' ELSE '321' END,
50,
0,
CASE WHEN RANDOM() < 0.2 THEN 'A1' WHEN RANDOM() < 0.5 THEN 'A2' WHEN RANDOM() < 0.7 THEN 'A3' ELSE 'A4' END,
upper(left(md5(i::text), 7)),
-- generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-31 00:00','1 days 16 hours 12min'),
'2021-1-18 09:00',
CASE WHEN RANDOM() < 0.2 THEN 'D4' WHEN RANDOM() < 0.5 THEN 'D3' WHEN RANDOM() < 0.7 THEN 'D2' ELSE 'D1' END,
10,
100,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END
FROM generate_series(1, 4) s(i);



INSERT INTO flights(flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, STATUS, 
aircraft_code, seats_available, seats_booked, arrival_gate, baggage_claim_no, boading_time, gate, waitlist, checked_bags, movie, meal)
SELECT
upper(left(md5(i::text), 6)),
--generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-30 00:00','1 days 15 hours 12min'),
'2021-1-31 08:00',
'2021-1-31 12:00',
--generate_series('2020-12-2 00:00'::timestamp WITH time zone,'2021-1-31 00:00','1 days 18 hours 12min'),
'LAX',
CASE WHEN RANDOM() < 0.25 THEN 'HOU' WHEN RANDOM() < 0.5 THEN 'JFK' WHEN RANDOM() < 0.75 THEN 'ORD' ELSE 'MIA' END,
'Scheduled',
CASE WHEN RANDOM() < 0.2 THEN '773' WHEN RANDOM() < 0.4 THEN '763' WHEN RANDOM() < 0.6 THEN 'SU9' WHEN RANDOM() < 0.8 THEN '320' ELSE '321' END,
50,
0,
CASE WHEN RANDOM() < 0.2 THEN 'A1' WHEN RANDOM() < 0.5 THEN 'A2' WHEN RANDOM() < 0.7 THEN 'A3' ELSE 'A4' END,
upper(left(md5(i::text), 7)),
-- generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-31 00:00','1 days 16 hours 12min'),
'2021-1-31 09:00',
CASE WHEN RANDOM() < 0.2 THEN 'D4' WHEN RANDOM() < 0.5 THEN 'D3' WHEN RANDOM() < 0.7 THEN 'D2' ELSE 'D1' END,
10,
100,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END
FROM generate_series(1, 4) s(i);

INSERT INTO flights(flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, STATUS, 
aircraft_code, seats_available, seats_booked, arrival_gate, baggage_claim_no, boading_time, gate, waitlist, checked_bags, movie, meal)
SELECT
upper(left(md5(i::text), 6)),
--generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-30 00:00','1 days 15 hours 12min'),
'2020-12-2 08:00',
'2020-12-2 12:00',
--generate_series('2020-12-2 00:00'::timestamp WITH time zone,'2021-1-31 00:00','1 days 18 hours 12min'),
'ORD',
CASE WHEN RANDOM() < 0.25 THEN 'HOU' WHEN RANDOM() < 0.5 THEN 'JFK' WHEN RANDOM() < 0.75 THEN 'LAX' ELSE 'MIA' END,
'Scheduled',
CASE WHEN RANDOM() < 0.2 THEN '773' WHEN RANDOM() < 0.4 THEN '763' WHEN RANDOM() < 0.6 THEN 'SU9' WHEN RANDOM() < 0.8 THEN '320' ELSE '321' END,
50,
0,
CASE WHEN RANDOM() < 0.2 THEN 'A1' WHEN RANDOM() < 0.5 THEN 'A2' WHEN RANDOM() < 0.7 THEN 'A3' ELSE 'A4' END,
upper(left(md5(i::text), 7)),
-- generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-31 00:00','1 days 16 hours 12min'),
'2020-12-2 09:00',
CASE WHEN RANDOM() < 0.2 THEN 'D4' WHEN RANDOM() < 0.5 THEN 'D3' WHEN RANDOM() < 0.7 THEN 'D2' ELSE 'D1' END,
10,
100,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END
FROM generate_series(1, 4) s(i);

INSERT INTO flights(flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, STATUS, 
aircraft_code, seats_available, seats_booked, arrival_gate, baggage_claim_no, boading_time, gate, waitlist, checked_bags, movie, meal)
SELECT
upper(left(md5(i::text), 6)),
--generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-30 00:00','1 days 15 hours 12min'),
'2020-12-6 08:00',
'2020-12-6 12:00',
--generate_series('2020-12-2 00:00'::timestamp WITH time zone,'2021-1-31 00:00','1 days 18 hours 12min'),
'ORD',
CASE WHEN RANDOM() < 0.25 THEN 'HOU' WHEN RANDOM() < 0.5 THEN 'JFK' WHEN RANDOM() < 0.75 THEN 'LAX' ELSE 'MIA' END,
'Scheduled',
CASE WHEN RANDOM() < 0.2 THEN '773' WHEN RANDOM() < 0.4 THEN '763' WHEN RANDOM() < 0.6 THEN 'SU9' WHEN RANDOM() < 0.8 THEN '320' ELSE '321' END,
50,
0,
CASE WHEN RANDOM() < 0.2 THEN 'A1' WHEN RANDOM() < 0.5 THEN 'A2' WHEN RANDOM() < 0.7 THEN 'A3' ELSE 'A4' END,
upper(left(md5(i::text), 7)),
-- generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-31 00:00','1 days 16 hours 12min'),
'2020-12-6 09:00',
CASE WHEN RANDOM() < 0.2 THEN 'D4' WHEN RANDOM() < 0.5 THEN 'D3' WHEN RANDOM() < 0.7 THEN 'D2' ELSE 'D1' END,
10,
100,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END
FROM generate_series(1, 4) s(i);

INSERT INTO flights(flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, STATUS, 
aircraft_code, seats_available, seats_booked, arrival_gate, baggage_claim_no, boading_time, gate, waitlist, checked_bags, movie, meal)
SELECT
upper(left(md5(i::text), 6)),
--generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-30 00:00','1 days 15 hours 12min'),
'2020-12-12 08:00',
'2020-12-12 12:00',
--generate_series('2020-12-2 00:00'::timestamp WITH time zone,'2021-1-31 00:00','1 days 18 hours 12min'),
'ORD',
CASE WHEN RANDOM() < 0.25 THEN 'HOU' WHEN RANDOM() < 0.5 THEN 'JFK' WHEN RANDOM() < 0.75 THEN 'LAX' ELSE 'MIA' END,
'Scheduled',
CASE WHEN RANDOM() < 0.2 THEN '773' WHEN RANDOM() < 0.4 THEN '763' WHEN RANDOM() < 0.6 THEN 'SU9' WHEN RANDOM() < 0.8 THEN '320' ELSE '321' END,
50,
0,
CASE WHEN RANDOM() < 0.2 THEN 'A1' WHEN RANDOM() < 0.5 THEN 'A2' WHEN RANDOM() < 0.7 THEN 'A3' ELSE 'A4' END,
upper(left(md5(i::text), 7)),
-- generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-31 00:00','1 days 16 hours 12min'),
'2020-12-12 09:00',
CASE WHEN RANDOM() < 0.2 THEN 'D4' WHEN RANDOM() < 0.5 THEN 'D3' WHEN RANDOM() < 0.7 THEN 'D2' ELSE 'D1' END,
10,
100,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END
FROM generate_series(1, 4) s(i);


INSERT INTO flights(flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, STATUS, 
aircraft_code, seats_available, seats_booked, arrival_gate, baggage_claim_no, boading_time, gate, waitlist, checked_bags, movie, meal)
SELECT
upper(left(md5(i::text), 6)),
--generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-30 00:00','1 days 15 hours 12min'),
'2020-12-15 08:00',
'2020-12-15 12:00',
--generate_series('2020-12-2 00:00'::timestamp WITH time zone,'2021-1-31 00:00','1 days 18 hours 12min'),
'ORD',
CASE WHEN RANDOM() < 0.25 THEN 'HOU' WHEN RANDOM() < 0.5 THEN 'JFK' WHEN RANDOM() < 0.75 THEN 'LAX' ELSE 'MIA' END,
'Scheduled',
CASE WHEN RANDOM() < 0.2 THEN '773' WHEN RANDOM() < 0.4 THEN '763' WHEN RANDOM() < 0.6 THEN 'SU9' WHEN RANDOM() < 0.8 THEN '320' ELSE '321' END,
50,
0,
CASE WHEN RANDOM() < 0.2 THEN 'A1' WHEN RANDOM() < 0.5 THEN 'A2' WHEN RANDOM() < 0.7 THEN 'A3' ELSE 'A4' END,
upper(left(md5(i::text), 7)),
-- generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-31 00:00','1 days 16 hours 12min'),
'2020-12-15 09:00',
CASE WHEN RANDOM() < 0.2 THEN 'D4' WHEN RANDOM() < 0.5 THEN 'D3' WHEN RANDOM() < 0.7 THEN 'D2' ELSE 'D1' END,
10,
100,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END
FROM generate_series(1, 4) s(i);


INSERT INTO flights(flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, STATUS, 
aircraft_code, seats_available, seats_booked, arrival_gate, baggage_claim_no, boading_time, gate, waitlist, checked_bags, movie, meal)
SELECT
upper(left(md5(i::text), 6)),
--generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-30 00:00','1 days 15 hours 12min'),
'2020-12-25 08:00',
'2020-12-25 12:00',
--generate_series('2020-12-2 00:00'::timestamp WITH time zone,'2021-1-31 00:00','1 days 18 hours 12min'),
'ORD',
CASE WHEN RANDOM() < 0.25 THEN 'HOU' WHEN RANDOM() < 0.5 THEN 'JFK' WHEN RANDOM() < 0.75 THEN 'LAX' ELSE 'MIA' END,
'Scheduled',
CASE WHEN RANDOM() < 0.2 THEN '773' WHEN RANDOM() < 0.4 THEN '763' WHEN RANDOM() < 0.6 THEN 'SU9' WHEN RANDOM() < 0.8 THEN '320' ELSE '321' END,
50,
0,
CASE WHEN RANDOM() < 0.2 THEN 'A1' WHEN RANDOM() < 0.5 THEN 'A2' WHEN RANDOM() < 0.7 THEN 'A3' ELSE 'A4' END,
upper(left(md5(i::text), 7)),
-- generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-31 00:00','1 days 16 hours 12min'),
'2020-12-25 09:00',
CASE WHEN RANDOM() < 0.2 THEN 'D4' WHEN RANDOM() < 0.5 THEN 'D3' WHEN RANDOM() < 0.7 THEN 'D2' ELSE 'D1' END,
10,
100,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END
FROM generate_series(1, 4) s(i);


INSERT INTO flights(flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, STATUS, 
aircraft_code, seats_available, seats_booked, arrival_gate, baggage_claim_no, boading_time, gate, waitlist, checked_bags, movie, meal)
SELECT
upper(left(md5(i::text), 6)),
--generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-30 00:00','1 days 15 hours 12min'),
'2020-12-30 08:00',
'2020-12-30 12:00',
--generate_series('2020-12-2 00:00'::timestamp WITH time zone,'2021-1-31 00:00','1 days 18 hours 12min'),
'ORD',
CASE WHEN RANDOM() < 0.25 THEN 'HOU' WHEN RANDOM() < 0.5 THEN 'JFK' WHEN RANDOM() < 0.75 THEN 'LAX' ELSE 'MIA' END,
'Scheduled',
CASE WHEN RANDOM() < 0.2 THEN '773' WHEN RANDOM() < 0.4 THEN '763' WHEN RANDOM() < 0.6 THEN 'SU9' WHEN RANDOM() < 0.8 THEN '320' ELSE '321' END,
50,
0,
CASE WHEN RANDOM() < 0.2 THEN 'A1' WHEN RANDOM() < 0.5 THEN 'A2' WHEN RANDOM() < 0.7 THEN 'A3' ELSE 'A4' END,
upper(left(md5(i::text), 7)),
-- generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-31 00:00','1 days 16 hours 12min'),
'2020-12-30 09:00',
CASE WHEN RANDOM() < 0.2 THEN 'D4' WHEN RANDOM() < 0.5 THEN 'D3' WHEN RANDOM() < 0.7 THEN 'D2' ELSE 'D1' END,
10,
100,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END
FROM generate_series(1, 4) s(i);

INSERT INTO flights(flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, STATUS, 
aircraft_code, seats_available, seats_booked, arrival_gate, baggage_claim_no, boading_time, gate, waitlist, checked_bags, movie, meal)
SELECT
upper(left(md5(i::text), 6)),
--generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-30 00:00','1 days 15 hours 12min'),
'2021-1-6 08:00',
'2021-1-6 12:00',
--generate_series('2020-12-2 00:00'::timestamp WITH time zone,'2021-1-31 00:00','1 days 18 hours 12min'),
'ORD',
CASE WHEN RANDOM() < 0.25 THEN 'HOU' WHEN RANDOM() < 0.5 THEN 'JFK' WHEN RANDOM() < 0.75 THEN 'LAX' ELSE 'MIA' END,
'Scheduled',
CASE WHEN RANDOM() < 0.2 THEN '773' WHEN RANDOM() < 0.4 THEN '763' WHEN RANDOM() < 0.6 THEN 'SU9' WHEN RANDOM() < 0.8 THEN '320' ELSE '321' END,
50,
0,
CASE WHEN RANDOM() < 0.2 THEN 'A1' WHEN RANDOM() < 0.5 THEN 'A2' WHEN RANDOM() < 0.7 THEN 'A3' ELSE 'A4' END,
upper(left(md5(i::text), 7)),
-- generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-31 00:00','1 days 16 hours 12min'),
'2021-1-6 09:00',
CASE WHEN RANDOM() < 0.2 THEN 'D4' WHEN RANDOM() < 0.5 THEN 'D3' WHEN RANDOM() < 0.7 THEN 'D2' ELSE 'D1' END,
10,
100,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END
FROM generate_series(1, 4) s(i);

INSERT INTO flights(flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, STATUS, 
aircraft_code, seats_available, seats_booked, arrival_gate, baggage_claim_no, boading_time, gate, waitlist, checked_bags, movie, meal)
SELECT
upper(left(md5(i::text), 6)),
--generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-30 00:00','1 days 15 hours 12min'),
'2021-1-13 08:00',
'2021-1-13 12:00',
--generate_series('2020-12-2 00:00'::timestamp WITH time zone,'2021-1-31 00:00','1 days 18 hours 12min'),
'ORD',
CASE WHEN RANDOM() < 0.25 THEN 'HOU' WHEN RANDOM() < 0.5 THEN 'JFK' WHEN RANDOM() < 0.75 THEN 'LAX' ELSE 'MIA' END,
'Scheduled',
CASE WHEN RANDOM() < 0.2 THEN '773' WHEN RANDOM() < 0.4 THEN '763' WHEN RANDOM() < 0.6 THEN 'SU9' WHEN RANDOM() < 0.8 THEN '320' ELSE '321' END,
50,
0,
CASE WHEN RANDOM() < 0.2 THEN 'A1' WHEN RANDOM() < 0.5 THEN 'A2' WHEN RANDOM() < 0.7 THEN 'A3' ELSE 'A4' END,
upper(left(md5(i::text), 7)),
-- generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-31 00:00','1 days 16 hours 12min'),
'2021-1-13 09:00',
CASE WHEN RANDOM() < 0.2 THEN 'D4' WHEN RANDOM() < 0.5 THEN 'D3' WHEN RANDOM() < 0.7 THEN 'D2' ELSE 'D1' END,
10,
100,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END
FROM generate_series(1, 4) s(i);

INSERT INTO flights(flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, STATUS, 
aircraft_code, seats_available, seats_booked, arrival_gate, baggage_claim_no, boading_time, gate, waitlist, checked_bags, movie, meal)
SELECT
upper(left(md5(i::text), 6)),
--generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-30 00:00','1 days 15 hours 12min'),
'2021-1-18 08:00',
'2021-1-18 12:00',
--generate_series('2020-12-2 00:00'::timestamp WITH time zone,'2021-1-31 00:00','1 days 18 hours 12min'),
'ORD',
CASE WHEN RANDOM() < 0.25 THEN 'HOU' WHEN RANDOM() < 0.5 THEN 'JFK' WHEN RANDOM() < 0.75 THEN 'LAX' ELSE 'MIA' END,
'Scheduled',
CASE WHEN RANDOM() < 0.2 THEN '773' WHEN RANDOM() < 0.4 THEN '763' WHEN RANDOM() < 0.6 THEN 'SU9' WHEN RANDOM() < 0.8 THEN '320' ELSE '321' END,
50,
0,
CASE WHEN RANDOM() < 0.2 THEN 'A1' WHEN RANDOM() < 0.5 THEN 'A2' WHEN RANDOM() < 0.7 THEN 'A3' ELSE 'A4' END,
upper(left(md5(i::text), 7)),
-- generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-31 00:00','1 days 16 hours 12min'),
'2021-1-18 09:00',
CASE WHEN RANDOM() < 0.2 THEN 'D4' WHEN RANDOM() < 0.5 THEN 'D3' WHEN RANDOM() < 0.7 THEN 'D2' ELSE 'D1' END,
10,
100,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END
FROM generate_series(1, 4) s(i);



INSERT INTO flights(flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, STATUS, 
aircraft_code, seats_available, seats_booked, arrival_gate, baggage_claim_no, boading_time, gate, waitlist, checked_bags, movie, meal)
SELECT
upper(left(md5(i::text), 6)),
--generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-30 00:00','1 days 15 hours 12min'),
'2021-1-31 08:00',
'2021-1-31 12:00',
--generate_series('2020-12-2 00:00'::timestamp WITH time zone,'2021-1-31 00:00','1 days 18 hours 12min'),
'ORD',
CASE WHEN RANDOM() < 0.25 THEN 'HOU' WHEN RANDOM() < 0.5 THEN 'JFK' WHEN RANDOM() < 0.75 THEN 'LAX' ELSE 'MIA' END,
'Scheduled',
CASE WHEN RANDOM() < 0.2 THEN '773' WHEN RANDOM() < 0.4 THEN '763' WHEN RANDOM() < 0.6 THEN 'SU9' WHEN RANDOM() < 0.8 THEN '320' ELSE '321' END,
50,
0,
CASE WHEN RANDOM() < 0.2 THEN 'A1' WHEN RANDOM() < 0.5 THEN 'A2' WHEN RANDOM() < 0.7 THEN 'A3' ELSE 'A4' END,
upper(left(md5(i::text), 7)),
-- generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-31 00:00','1 days 16 hours 12min'),
'2021-1-31 09:00',
CASE WHEN RANDOM() < 0.2 THEN 'D4' WHEN RANDOM() < 0.5 THEN 'D3' WHEN RANDOM() < 0.7 THEN 'D2' ELSE 'D1' END,
10,
100,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END
FROM generate_series(1, 4) s(i);

INSERT INTO flights(flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, STATUS, 
aircraft_code, seats_available, seats_booked, arrival_gate, baggage_claim_no, boading_time, gate, waitlist, checked_bags, movie, meal)
SELECT
upper(left(md5(i::text), 6)),
--generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-30 00:00','1 days 15 hours 12min'),
'2020-12-2 08:00',
'2020-12-2 12:00',
--generate_series('2020-12-2 00:00'::timestamp WITH time zone,'2021-1-31 00:00','1 days 18 hours 12min'),
'MIA',
CASE WHEN RANDOM() < 0.25 THEN 'HOU' WHEN RANDOM() < 0.5 THEN 'JFK' WHEN RANDOM() < 0.75 THEN 'LAX' ELSE 'ORD' END,
'Scheduled',
CASE WHEN RANDOM() < 0.2 THEN '773' WHEN RANDOM() < 0.4 THEN '763' WHEN RANDOM() < 0.6 THEN 'SU9' WHEN RANDOM() < 0.8 THEN '320' ELSE '321' END,
50,
0,
CASE WHEN RANDOM() < 0.2 THEN 'A1' WHEN RANDOM() < 0.5 THEN 'A2' WHEN RANDOM() < 0.7 THEN 'A3' ELSE 'A4' END,
upper(left(md5(i::text), 7)),
-- generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-31 00:00','1 days 16 hours 12min'),
'2020-12-2 09:00',
CASE WHEN RANDOM() < 0.2 THEN 'D4' WHEN RANDOM() < 0.5 THEN 'D3' WHEN RANDOM() < 0.7 THEN 'D2' ELSE 'D1' END,
10,
100,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END
FROM generate_series(1, 4) s(i);

INSERT INTO flights(flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, STATUS, 
aircraft_code, seats_available, seats_booked, arrival_gate, baggage_claim_no, boading_time, gate, waitlist, checked_bags, movie, meal)
SELECT
upper(left(md5(i::text), 6)),
--generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-30 00:00','1 days 15 hours 12min'),
'2020-12-6 08:00',
'2020-12-6 12:00',
--generate_series('2020-12-2 00:00'::timestamp WITH time zone,'2021-1-31 00:00','1 days 18 hours 12min'),
'MIA',
CASE WHEN RANDOM() < 0.25 THEN 'HOU' WHEN RANDOM() < 0.5 THEN 'JFK' WHEN RANDOM() < 0.75 THEN 'LAX' ELSE 'ORD' END,
'Scheduled',
CASE WHEN RANDOM() < 0.2 THEN '773' WHEN RANDOM() < 0.4 THEN '763' WHEN RANDOM() < 0.6 THEN 'SU9' WHEN RANDOM() < 0.8 THEN '320' ELSE '321' END,
50,
0,
CASE WHEN RANDOM() < 0.2 THEN 'A1' WHEN RANDOM() < 0.5 THEN 'A2' WHEN RANDOM() < 0.7 THEN 'A3' ELSE 'A4' END,
upper(left(md5(i::text), 7)),
-- generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-31 00:00','1 days 16 hours 12min'),
'2020-12-6 09:00',
CASE WHEN RANDOM() < 0.2 THEN 'D4' WHEN RANDOM() < 0.5 THEN 'D3' WHEN RANDOM() < 0.7 THEN 'D2' ELSE 'D1' END,
10,
100,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END
FROM generate_series(1, 4) s(i);

INSERT INTO flights(flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, STATUS, 
aircraft_code, seats_available, seats_booked, arrival_gate, baggage_claim_no, boading_time, gate, waitlist, checked_bags, movie, meal)
SELECT
upper(left(md5(i::text), 6)),
--generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-30 00:00','1 days 15 hours 12min'),
'2020-12-12 08:00',
'2020-12-12 12:00',
--generate_series('2020-12-2 00:00'::timestamp WITH time zone,'2021-1-31 00:00','1 days 18 hours 12min'),
'MIA',
CASE WHEN RANDOM() < 0.25 THEN 'HOU' WHEN RANDOM() < 0.5 THEN 'JFK' WHEN RANDOM() < 0.75 THEN 'LAX' ELSE 'ORD' END,
'Scheduled',
CASE WHEN RANDOM() < 0.2 THEN '773' WHEN RANDOM() < 0.4 THEN '763' WHEN RANDOM() < 0.6 THEN 'SU9' WHEN RANDOM() < 0.8 THEN '320' ELSE '321' END,
50,
0,
CASE WHEN RANDOM() < 0.2 THEN 'A1' WHEN RANDOM() < 0.5 THEN 'A2' WHEN RANDOM() < 0.7 THEN 'A3' ELSE 'A4' END,
upper(left(md5(i::text), 7)),
-- generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-31 00:00','1 days 16 hours 12min'),
'2020-12-12 09:00',
CASE WHEN RANDOM() < 0.2 THEN 'D4' WHEN RANDOM() < 0.5 THEN 'D3' WHEN RANDOM() < 0.7 THEN 'D2' ELSE 'D1' END,
10,
100,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END
FROM generate_series(1, 4) s(i);


INSERT INTO flights(flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, STATUS, 
aircraft_code, seats_available, seats_booked, arrival_gate, baggage_claim_no, boading_time, gate, waitlist, checked_bags, movie, meal)
SELECT
upper(left(md5(i::text), 6)),
--generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-30 00:00','1 days 15 hours 12min'),
'2020-12-15 08:00',
'2020-12-15 12:00',
--generate_series('2020-12-2 00:00'::timestamp WITH time zone,'2021-1-31 00:00','1 days 18 hours 12min'),
'MIA',
CASE WHEN RANDOM() < 0.25 THEN 'HOU' WHEN RANDOM() < 0.5 THEN 'JFK' WHEN RANDOM() < 0.75 THEN 'LAX' ELSE 'ORD' END,
'Scheduled',
CASE WHEN RANDOM() < 0.2 THEN '773' WHEN RANDOM() < 0.4 THEN '763' WHEN RANDOM() < 0.6 THEN 'SU9' WHEN RANDOM() < 0.8 THEN '320' ELSE '321' END,
50,
0,
CASE WHEN RANDOM() < 0.2 THEN 'A1' WHEN RANDOM() < 0.5 THEN 'A2' WHEN RANDOM() < 0.7 THEN 'A3' ELSE 'A4' END,
upper(left(md5(i::text), 7)),
-- generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-31 00:00','1 days 16 hours 12min'),
'2020-12-15 09:00',
CASE WHEN RANDOM() < 0.2 THEN 'D4' WHEN RANDOM() < 0.5 THEN 'D3' WHEN RANDOM() < 0.7 THEN 'D2' ELSE 'D1' END,
10,
100,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END
FROM generate_series(1, 4) s(i);


INSERT INTO flights(flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, STATUS, 
aircraft_code, seats_available, seats_booked, arrival_gate, baggage_claim_no, boading_time, gate, waitlist, checked_bags, movie, meal)
SELECT
upper(left(md5(i::text), 6)),
--generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-30 00:00','1 days 15 hours 12min'),
'2020-12-25 08:00',
'2020-12-25 12:00',
--generate_series('2020-12-2 00:00'::timestamp WITH time zone,'2021-1-31 00:00','1 days 18 hours 12min'),
'MIA',
CASE WHEN RANDOM() < 0.25 THEN 'HOU' WHEN RANDOM() < 0.5 THEN 'JFK' WHEN RANDOM() < 0.75 THEN 'LAX' ELSE 'ORD' END,
'Scheduled',
CASE WHEN RANDOM() < 0.2 THEN '773' WHEN RANDOM() < 0.4 THEN '763' WHEN RANDOM() < 0.6 THEN 'SU9' WHEN RANDOM() < 0.8 THEN '320' ELSE '321' END,
50,
0,
CASE WHEN RANDOM() < 0.2 THEN 'A1' WHEN RANDOM() < 0.5 THEN 'A2' WHEN RANDOM() < 0.7 THEN 'A3' ELSE 'A4' END,
upper(left(md5(i::text), 7)),
-- generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-31 00:00','1 days 16 hours 12min'),
'2020-12-25 09:00',
CASE WHEN RANDOM() < 0.2 THEN 'D4' WHEN RANDOM() < 0.5 THEN 'D3' WHEN RANDOM() < 0.7 THEN 'D2' ELSE 'D1' END,
10,
100,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END
FROM generate_series(1, 4) s(i);


INSERT INTO flights(flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, STATUS, 
aircraft_code, seats_available, seats_booked, arrival_gate, baggage_claim_no, boading_time, gate, waitlist, checked_bags, movie, meal)
SELECT
upper(left(md5(i::text), 6)),
--generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-30 00:00','1 days 15 hours 12min'),
'2020-12-30 08:00',
'2020-12-30 12:00',
--generate_series('2020-12-2 00:00'::timestamp WITH time zone,'2021-1-31 00:00','1 days 18 hours 12min'),
'MIA',
CASE WHEN RANDOM() < 0.25 THEN 'HOU' WHEN RANDOM() < 0.5 THEN 'JFK' WHEN RANDOM() < 0.75 THEN 'LAX' ELSE 'ORD' END,
'Scheduled',
CASE WHEN RANDOM() < 0.2 THEN '773' WHEN RANDOM() < 0.4 THEN '763' WHEN RANDOM() < 0.6 THEN 'SU9' WHEN RANDOM() < 0.8 THEN '320' ELSE '321' END,
50,
0,
CASE WHEN RANDOM() < 0.2 THEN 'A1' WHEN RANDOM() < 0.5 THEN 'A2' WHEN RANDOM() < 0.7 THEN 'A3' ELSE 'A4' END,
upper(left(md5(i::text), 7)),
-- generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-31 00:00','1 days 16 hours 12min'),
'2020-12-30 09:00',
CASE WHEN RANDOM() < 0.2 THEN 'D4' WHEN RANDOM() < 0.5 THEN 'D3' WHEN RANDOM() < 0.7 THEN 'D2' ELSE 'D1' END,
10,
100,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END
FROM generate_series(1, 4) s(i);

INSERT INTO flights(flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, STATUS, 
aircraft_code, seats_available, seats_booked, arrival_gate, baggage_claim_no, boading_time, gate, waitlist, checked_bags, movie, meal)
SELECT
upper(left(md5(i::text), 6)),
--generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-30 00:00','1 days 15 hours 12min'),
'2021-1-6 08:00',
'2021-1-6 12:00',
--generate_series('2020-12-2 00:00'::timestamp WITH time zone,'2021-1-31 00:00','1 days 18 hours 12min'),
'MIA',
CASE WHEN RANDOM() < 0.25 THEN 'HOU' WHEN RANDOM() < 0.5 THEN 'JFK' WHEN RANDOM() < 0.75 THEN 'LAX' ELSE 'ORD' END,
'Scheduled',
CASE WHEN RANDOM() < 0.2 THEN '773' WHEN RANDOM() < 0.4 THEN '763' WHEN RANDOM() < 0.6 THEN 'SU9' WHEN RANDOM() < 0.8 THEN '320' ELSE '321' END,
50,
0,
CASE WHEN RANDOM() < 0.2 THEN 'A1' WHEN RANDOM() < 0.5 THEN 'A2' WHEN RANDOM() < 0.7 THEN 'A3' ELSE 'A4' END,
upper(left(md5(i::text), 7)),
-- generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-31 00:00','1 days 16 hours 12min'),
'2021-1-6 09:00',
CASE WHEN RANDOM() < 0.2 THEN 'D4' WHEN RANDOM() < 0.5 THEN 'D3' WHEN RANDOM() < 0.7 THEN 'D2' ELSE 'D1' END,
10,
100,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END
FROM generate_series(1, 4) s(i);

INSERT INTO flights(flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, STATUS, 
aircraft_code, seats_available, seats_booked, arrival_gate, baggage_claim_no, boading_time, gate, waitlist, checked_bags, movie, meal)
SELECT
upper(left(md5(i::text), 6)),
--generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-30 00:00','1 days 15 hours 12min'),
'2021-1-13 08:00',
'2021-1-13 12:00',
--generate_series('2020-12-2 00:00'::timestamp WITH time zone,'2021-1-31 00:00','1 days 18 hours 12min'),
'MIA',
CASE WHEN RANDOM() < 0.25 THEN 'HOU' WHEN RANDOM() < 0.5 THEN 'JFK' WHEN RANDOM() < 0.75 THEN 'LAX' ELSE 'ORD' END,
'Scheduled',
CASE WHEN RANDOM() < 0.2 THEN '773' WHEN RANDOM() < 0.4 THEN '763' WHEN RANDOM() < 0.6 THEN 'SU9' WHEN RANDOM() < 0.8 THEN '320' ELSE '321' END,
50,
0,
CASE WHEN RANDOM() < 0.2 THEN 'A1' WHEN RANDOM() < 0.5 THEN 'A2' WHEN RANDOM() < 0.7 THEN 'A3' ELSE 'A4' END,
upper(left(md5(i::text), 7)),
-- generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-31 00:00','1 days 16 hours 12min'),
'2021-1-13 09:00',
CASE WHEN RANDOM() < 0.2 THEN 'D4' WHEN RANDOM() < 0.5 THEN 'D3' WHEN RANDOM() < 0.7 THEN 'D2' ELSE 'D1' END,
10,
100,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END
FROM generate_series(1, 4) s(i);

INSERT INTO flights(flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, STATUS, 
aircraft_code, seats_available, seats_booked, arrival_gate, baggage_claim_no, boading_time, gate, waitlist, checked_bags, movie, meal)
SELECT
upper(left(md5(i::text), 6)),
--generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-30 00:00','1 days 15 hours 12min'),
'2021-1-18 08:00',
'2021-1-18 12:00',
--generate_series('2020-12-2 00:00'::timestamp WITH time zone,'2021-1-31 00:00','1 days 18 hours 12min'),
'MIA',
CASE WHEN RANDOM() < 0.25 THEN 'HOU' WHEN RANDOM() < 0.5 THEN 'JFK' WHEN RANDOM() < 0.75 THEN 'LAX' ELSE 'ORD' END,
'Scheduled',
CASE WHEN RANDOM() < 0.2 THEN '773' WHEN RANDOM() < 0.4 THEN '763' WHEN RANDOM() < 0.6 THEN 'SU9' WHEN RANDOM() < 0.8 THEN '320' ELSE '321' END,
50,
0,
CASE WHEN RANDOM() < 0.2 THEN 'A1' WHEN RANDOM() < 0.5 THEN 'A2' WHEN RANDOM() < 0.7 THEN 'A3' ELSE 'A4' END,
upper(left(md5(i::text), 7)),
-- generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-31 00:00','1 days 16 hours 12min'),
'2021-1-18 09:00',
CASE WHEN RANDOM() < 0.2 THEN 'D4' WHEN RANDOM() < 0.5 THEN 'D3' WHEN RANDOM() < 0.7 THEN 'D2' ELSE 'D1' END,
10,
100,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END
FROM generate_series(1, 4) s(i);



INSERT INTO flights(flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, STATUS, 
aircraft_code, seats_available, seats_booked, arrival_gate, baggage_claim_no, boading_time, gate, waitlist, checked_bags, movie, meal)
SELECT
upper(left(md5(i::text), 6)),
--generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-30 00:00','1 days 15 hours 12min'),
'2021-1-31 08:00',
'2021-1-31 12:00',
--generate_series('2020-12-2 00:00'::timestamp WITH time zone,'2021-1-31 00:00','1 days 18 hours 12min'),
'MIA',
CASE WHEN RANDOM() < 0.25 THEN 'HOU' WHEN RANDOM() < 0.5 THEN 'JFK' WHEN RANDOM() < 0.75 THEN 'LAX' ELSE 'ORD' END,
'Scheduled',
CASE WHEN RANDOM() < 0.2 THEN '773' WHEN RANDOM() < 0.4 THEN '763' WHEN RANDOM() < 0.6 THEN 'SU9' WHEN RANDOM() < 0.8 THEN '320' ELSE '321' END,
50,
0,
CASE WHEN RANDOM() < 0.2 THEN 'A1' WHEN RANDOM() < 0.5 THEN 'A2' WHEN RANDOM() < 0.7 THEN 'A3' ELSE 'A4' END,
upper(left(md5(i::text), 7)),
-- generate_series(CURRENT_TIMESTAMP::timestamp WITH time zone,'2021-1-31 00:00','1 days 16 hours 12min'),
'2021-1-31 09:00',
CASE WHEN RANDOM() < 0.2 THEN 'D4' WHEN RANDOM() < 0.5 THEN 'D3' WHEN RANDOM() < 0.7 THEN 'D2' ELSE 'D1' END,
10,
100,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END,
CASE WHEN RANDOM() < 0.5 THEN 'No' ELSE 'Yes' END
FROM generate_series(1, 4) s(i);





-- /*flights table*/
-- INSERT INTO flights
-- VALUES (
--         1001,
--         'PG0010',
--         '2020-12-10 09:50:00+03',
--         '2020-12-10 14:55:00+03',
--         'HOU',
--         'LAX',
--         'Scheduled',
--         '773',
--         50,
--         0,
--         -- Extended
--         'A1',
--         'B152376',
--         '2020-12-10 08:50:00+03',
--         'D4',
--         10,
--         100,
--         'No',
--         'No'
        
--     );


-- INSERT INTO flights
-- VALUES (
--         1002,
--         'PG0020',
--         '2020-12-12 09:50:00+03',
--         '2020-12-12 15:55:00+03',
--         'HOU',
--         'JFK',
--         'Scheduled',
--         '763',
--         50,
--         0,
--         -- Extended
--         'A1',
--         'B123612',
--         '2020-12-10 08:50:00+03',
--         'D3',
--         10,
--         100,
--         'No',
--         'No'
--     );

-- INSERT INTO flights
-- VALUES (
--         1003,
--         'PG0030',
--         '2020-12-12 09:50:00+03',
--         '2020-12-12 16:55:00+03',
--         'HOU',
--         'ORD',
--         'Scheduled',
--         'SU9',
--         50,
--         0,
--         -- Extended
--         'A1',
--         'B514235',
--         '2020-12-10 08:50:00+03',
--         'D2',
--         10,
--         100,
--         'No',
--         'Yes'
--     );


-- INSERT INTO flights
-- VALUES (
--         1004,
--         'PG0040',
--         '2020-12-12 09:50:00+03',
--         '2020-12-12 12:55:00+03',
--         'HOU',
--         'MIA',
--         'Scheduled',
--         '320',
--         50,
--         0,
--         -- Extended
--         'A1',
--         'B824585',
--         '2020-12-10 08:50:00+03',
--         'D1',
--         10,
--         100,
--         'Yes',
--         'No'
--     );

-- INSERT INTO flights
-- VALUES (
--         1005,
--         'PG0050',
--         '2020-12-10 09:50:00+03',
--         '2020-12-10 14:55:00+03',
--         'JFK',
--         'LAX',
--         'Scheduled',
--         '773',
--         50,
--         0,
--         -- Extended
--         'A2',
--         'B047184',
--         '2020-12-10 08:50:00+03',
--         'D4',
--         10,
--         100,
--         'No',
--         'No'
        
--     );

-- INSERT INTO flights
-- VALUES (
--         1006,
--         'PG0060',
--         '2020-12-12 09:50:00+03',
--         '2020-12-12 15:55:00+03',
--         'JFK',
--         'HOU',
--         'Scheduled',
--         '763',
--         50,
--         0,
--         -- Extended
--         'A1',
--         'B019376',
--         '2020-12-10 08:50:00+03',
--         'D3',
--         10,
--         100,
--         'No',
--         'No'
--     );

-- INSERT INTO flights
-- VALUES (
--         1007,
--         'PG0070',
--         '2020-12-12 09:50:00+03',
--         '2020-12-12 16:55:00+03',
--         'JFK',
--         'ORD',
--         'Scheduled',
--         'SU9',
--         50,
--         0,
--         -- Extended
--         'A2',
--         'B093761',
--         '2020-12-10 08:50:00+03',
--         'D2',
--         10,
--         100,
--         'No',
--         'Yes'
--     );


-- INSERT INTO flights
-- VALUES (
--         1008,
--         'PG0080',
--         '2020-12-12 09:50:00+03',
--         '2020-12-12 12:55:00+03',
--         'JFK',
--         'MIA',
--         'Scheduled',
--         '320',
--         50,
--         0,
--         -- Extended
--         'A2',
--         'B691875',
--         '2020-12-10 08:50:00+03',
--         'D1',
--         10,
--         100,
--         'Yes',
--         'No'
--     );

-- INSERT INTO flights
-- VALUES (
--         1009,
--         'PG0090',
--         '2020-12-10 09:50:00+03',
--         '2020-12-10 14:55:00+03',
--         'LAX',
--         'JFK',
--         'Scheduled',
--         '773',
--         50,
--         0,
--         -- Extended
--         'A2',
--         'B017594',
--         '2020-12-10 08:50:00+03',
--         'D4',
--         10,
--         100,
--         'No',
--         'No'
        
--     );

-- INSERT INTO flights
-- VALUES (
--         1010,
--         'PG0100',
--         '2020-12-12 09:50:00+03',
--         '2020-12-12 15:55:00+03',
--         'LAX',
--         'HOU',
--         'Scheduled',
--         '763',
--         50,
--         0,
--         -- Extended
--         'A2',
--         'B518726',
--         '2020-12-10 08:50:00+03',
--         'D3',
--         10,
--         100,
--         'No',
--         'No'
--     );

-- INSERT INTO flights
-- VALUES (
--         1011,
--         'PG0110',
--         '2020-12-12 09:50:00+03',
--         '2020-12-12 16:55:00+03',
--         'LAX',
--         'ORD',
--         'Scheduled',
--         'SU9',
--         50,
--         0,
--         -- Extended
--         'A3',
--         'B301957',
--         '2020-12-10 08:50:00+03',
--         'D2',
--         10,
--         100,
--         'No',
--         'Yes'
--     );


-- INSERT INTO flights
-- VALUES (
--         1012,
--         'PG0120',
--         '2020-12-12 09:50:00+03',
--         '2020-12-12 12:55:00+03',
--         'LAX',
--         'MIA',
--         'Scheduled',
--         '320',
--         50,
--         0,
--         -- Extended
--         'A3',
--         'B052627',
--         '2020-12-10 08:50:00+03',
--         'D1',
--         10,
--         100,
--         'Yes',
--         'No'
--     );
    
-- INSERT INTO flights
-- VALUES (
--         1013,
--         'PG0130',
--         '2020-12-10 09:50:00+03',
--         '2020-12-10 14:55:00+03',
--         'ORD',
--         'JFK',
--         'Scheduled',
--         '773',
--         50,
--         0,
--         -- Extended
--         'A3',
--         'B449296',
--         '2020-12-10 08:50:00+03',
--         'D4',
--         10,
--         100,
--         'No',
--         'No'
        
--     );

-- INSERT INTO flights
-- VALUES (
--         1014,
--         'PG0140',
--         '2020-12-12 09:50:00+03',
--         '2020-12-12 15:55:00+03',
--         'ORD',
--         'HOU',
--         'Scheduled',
--         '763',
--         50,
--         0,
--         -- Extended
--         'A3',
--         'B522364',
--         '2020-12-10 08:50:00+03',
--         'D3',
--         10,
--         100,
--         'No',
--         'No'
--     );

-- INSERT INTO flights
-- VALUES (
--         1015,
--         'PG0150',
--         '2020-12-12 09:50:00+03',
--         '2020-12-12 16:55:00+03',
--         'ORD',
--         'LAX',
--         'Scheduled',
--         'SU9',
--         50,
--         0,
--         -- Extended
--         'A3',
--         'B097594',
--         '2020-12-10 08:50:00+03',
--         'D2',
--         10,
--         100,
--         'No',
--         'Yes'
--     );


-- INSERT INTO flights
-- VALUES (
--         1016,
--         'PG0160',
--         '2020-12-12 09:50:00+03',
--         '2020-12-12 12:55:00+03',
--         'ORD',
--         'MIA',
--         'Scheduled',
--         '320',
--         50,
--         0,
--         -- Extended
--         'A4',
--         'B502937',
--         '2020-12-10 08:50:00+03',
--         'D1',
--         10,
--         100,
--         'Yes',
--         'No'
--     );
    
-- INSERT INTO flights
-- VALUES (
--         1017,
--         'PG0170',
--         '2020-12-10 09:50:00+03',
--         '2020-12-10 14:55:00+03',
--         'MIA',
--         'JFK',
--         'Scheduled',
--         '773',
--         50,
--         0,
--         -- Extended
--         'A4',
--         'B619837',
--         '2020-12-10 08:50:00+03',
--         'D4',
--         10,
--         100,
--         'No',
--         'No'
        
--     );

-- INSERT INTO flights
-- VALUES (
--         1018,
--         'PG0180',
--         '2020-12-12 09:50:00+03',
--         '2020-12-12 15:55:00+03',
--         'MIA',
--         'HOU',
--         'Scheduled',
--         '763',
--         50,
--         0,
--         -- Extended
--         'A4',
--         'B471093',
--         '2020-12-10 08:50:00+03',
--         'D3',
--         10,
--         100,
--         'No',
--         'No'
--     );

-- INSERT INTO flights
-- VALUES (
--         1019,
--         'PG0190',
--         '2020-12-12 09:50:00+03',
--         '2020-12-12 16:55:00+03',
--         'MIA',
--         'LAX',
--         'Scheduled',
--         'SU9',
--         50,
--         0,
--         -- Extended
--         'A4',
--         'B409209',
--         '2020-12-10 08:50:00+03',
--         'D2',
--         10,
--         100,
--         'No',
--         'Yes'
--     );


-- INSERT INTO flights
-- VALUES (
--         1020,
--         'PG0200',
--         '2020-12-12 09:50:00+03',
--         '2020-12-12 12:55:00+03',
--         'MIA',
--         'ORD',
--         'Scheduled',
--         '320',
--         50,
--         0,
--         -- Extended
--         'A4',
--         'B152362',
--         '2020-12-10 08:50:00+03',
--         'D1',
--         10,
--         100,
--         'Yes',
--         'No'
--     );




INSERT INTO seats (aircraft_code, seat_no, fare_conditions) VALUES
('320',	'1A', 'Business'),
('320',	'1C', 'Business'),
('320',	'1D', 'Business'),
('320',	'1F', 'Business'),
('320',	'2A', 'Business'),
('320',	'2C', 'Business'),
('320',	'2D', 'Business'),
('320',	'2F', 'Business'),
('320',	'3A', 'Business'),
('320',	'3C', 'Business'),
('320',	'3D', 'Comfort'),
('320',	'3F', 'Comfort'),
('320',	'4A', 'Comfort'),
('320',	'4C', 'Comfort'),
('320',	'4D', 'Comfort'),
('320',	'4F', 'Comfort'),
('320',	'5A', 'Comfort'),
('320',	'5C', 'Comfort'),
('320',	'5D', 'Comfort'),
('320',	'5F', 'Comfort'),
('320',	'6A', 'Economy'),
('320',	'6B', 'Economy'),
('320',	'6C', 'Economy'),
('320',	'6D', 'Economy'),
('320',	'6E', 'Economy'),
('320',	'6F', 'Economy'),
('320',	'7A', 'Economy'),
('320',	'7B', 'Economy'),
('320',	'7C', 'Economy'),
('320',	'7D', 'Economy'),
('320',	'7E', 'Economy'),
('320',	'7F', 'Economy'),
('320',	'8A', 'Economy'),
('320',	'8B', 'Economy'),
('320',	'8C', 'Economy'),
('320',	'8D', 'Economy'),
('320',	'8E', 'Economy'),
('320',	'8F', 'Economy'),
('320',	'9A', 'Economy'),
('320',	'9B', 'Economy'),
('320',	'9C', 'Economy'),
('320',	'9D', 'Economy'),
('320',	'9E', 'Economy'),
('320',	'9F', 'Economy'),
('320',	'10A', 'Economy'),
('320',	'10B', 'Economy'),
('320',	'10C', 'Economy'),
('320',	'10D', 'Economy'),
('320',	'10E', 'Economy'),
('320',	'10F', 'Economy'),
('773',	'1A', 'Business'),
('773',	'1C', 'Business'),
('773',	'1D', 'Business'),
('773',	'1F', 'Business'),
('773',	'2A', 'Business'),
('773',	'2C', 'Business'),
('773',	'2D', 'Business'),
('773',	'2F', 'Business'),
('773',	'3A', 'Business'),
('773',	'3C', 'Business'),
('773',	'3D', 'Comfort'),
('773',	'3F', 'Comfort'),
('773',	'4A', 'Comfort'),
('773',	'4C', 'Comfort'),
('773',	'4D', 'Comfort'),
('773',	'4F', 'Comfort'),
('773',	'5A', 'Comfort'),
('773',	'5C', 'Comfort'),
('773',	'5D', 'Comfort'),
('773',	'5F', 'Comfort'),
('773',	'6A', 'Economy'),
('773',	'6B', 'Economy'),
('773',	'6C', 'Economy'),
('773',	'6D', 'Economy'),
('773',	'6E', 'Economy'),
('773',	'6F', 'Economy'),
('773',	'7A', 'Economy'),
('773',	'7B', 'Economy'),
('773',	'7C', 'Economy'),
('773',	'7D', 'Economy'),
('773',	'7E', 'Economy'),
('773',	'7F', 'Economy'),
('773',	'8A', 'Economy'),
('773',	'8B', 'Economy'),
('773',	'8C', 'Economy'),
('773',	'8D', 'Economy'),
('773',	'8E', 'Economy'),
('773',	'8F', 'Economy'),
('773',	'9A', 'Economy'),
('773',	'9B', 'Economy'),
('773',	'9C', 'Economy'),
('773',	'9D', 'Economy'),
('773',	'9E', 'Economy'),
('773',	'9F', 'Economy'),
('773',	'10A', 'Economy'),
('773',	'10B', 'Economy'),
('773',	'10C', 'Economy'),
('773',	'10D', 'Economy'),
('773',	'10E', 'Economy'),
('773',	'10F', 'Economy'),
('763',	'1A', 'Business'),
('763',	'1C', 'Business'),
('763',	'1D', 'Business'),
('763',	'1F', 'Business'),
('763',	'2A', 'Business'),
('763',	'2C', 'Business'),
('763',	'2D', 'Business'),
('763',	'2F', 'Business'),
('763',	'3A', 'Business'),
('763',	'3C', 'Business'),
('763',	'3D', 'Comfort'),
('763',	'3F', 'Comfort'),
('763',	'4A', 'Comfort'),
('763',	'4C', 'Comfort'),
('763',	'4D', 'Comfort'),
('763',	'4F', 'Comfort'),
('763',	'5A', 'Comfort'),
('763',	'5C', 'Comfort'),
('763',	'5D', 'Comfort'),
('763',	'5F', 'Comfort'),
('763',	'6A', 'Economy'),
('763',	'6B', 'Economy'),
('763',	'6C', 'Economy'),
('763',	'6D', 'Economy'),
('763',	'6E', 'Economy'),
('763',	'6F', 'Economy'),
('763',	'7A', 'Economy'),
('763',	'7B', 'Economy'),
('763',	'7C', 'Economy'),
('763',	'7D', 'Economy'),
('763',	'7E', 'Economy'),
('763',	'7F', 'Economy'),
('763',	'8A', 'Economy'),
('763',	'8B', 'Economy'),
('763',	'8C', 'Economy'),
('763',	'8D', 'Economy'),
('763',	'8E', 'Economy'),
('763',	'8F', 'Economy'),
('763',	'9A', 'Economy'),
('763',	'9B', 'Economy'),
('763',	'9C', 'Economy'),
('763',	'9D', 'Economy'),
('763',	'9E', 'Economy'),
('763',	'9F', 'Economy'),
('763',	'10A', 'Economy'),
('763',	'10B', 'Economy'),
('763',	'10C', 'Economy'),
('763',	'10D', 'Economy'),
('763',	'10E', 'Economy'),
('763',	'10F', 'Economy'),
('SU9',	'1A', 'Business'),
('SU9',	'1C', 'Business'),
('SU9',	'1D', 'Business'),
('SU9',	'1F', 'Business'),
('SU9',	'2A', 'Business'),
('SU9',	'2C', 'Business'),
('SU9',	'2D', 'Business'),
('SU9',	'2F', 'Business'),
('SU9',	'3A', 'Business'),
('SU9',	'3C', 'Business'),
('SU9',	'3D', 'Comfort'),
('SU9',	'3F', 'Comfort'),
('SU9',	'4A', 'Comfort'),
('SU9',	'4C', 'Comfort'),
('SU9',	'4D', 'Comfort'),
('SU9',	'4F', 'Comfort'),
('SU9',	'5A', 'Comfort'),
('SU9',	'5C', 'Comfort'),
('SU9',	'5D', 'Comfort'),
('SU9',	'5F', 'Comfort'),
('SU9',	'6A', 'Economy'),
('SU9',	'6B', 'Economy'),
('SU9',	'6C', 'Economy'),
('SU9',	'6D', 'Economy'),
('SU9',	'6E', 'Economy'),
('SU9',	'6F', 'Economy'),
('SU9',	'7A', 'Economy'),
('SU9',	'7B', 'Economy'),
('SU9',	'7C', 'Economy'),
('SU9',	'7D', 'Economy'),
('SU9',	'7E', 'Economy'),
('SU9',	'7F', 'Economy'),
('SU9',	'8A', 'Economy'),
('SU9',	'8B', 'Economy'),
('SU9',	'8C', 'Economy'),
('SU9',	'8D', 'Economy'),
('SU9',	'8E', 'Economy'),
('SU9',	'8F', 'Economy'),
('SU9',	'9A', 'Economy'),
('SU9',	'9B', 'Economy'),
('SU9',	'9C', 'Economy'),
('SU9',	'9D', 'Economy'),
('SU9',	'9E', 'Economy'),
('SU9',	'9F', 'Economy'),
('SU9',	'10A', 'Economy'),
('SU9',	'10B', 'Economy'),
('SU9',	'10C', 'Economy'),
('SU9',	'10D', 'Economy'),
('SU9',	'10E', 'Economy'),
('SU9',	'10F', 'Economy'),
('321',	'1A', 'Business'),
('321',	'1C', 'Business'),
('321',	'1D', 'Business'),
('321',	'1F', 'Business'),
('321',	'2A', 'Business'),
('321',	'2C', 'Business'),
('321',	'2D', 'Business'),
('321',	'2F', 'Business'),
('321',	'3A', 'Business'),
('321',	'3C', 'Business'),
('321',	'3D', 'Comfort'),
('321',	'3F', 'Comfort'),
('321',	'4A', 'Comfort'),
('321',	'4C', 'Comfort'),
('321',	'4D', 'Comfort'),
('321',	'4F', 'Comfort'),
('321',	'5A', 'Comfort'),
('321',	'5C', 'Comfort'),
('321',	'5D', 'Comfort'),
('321',	'5F', 'Comfort'),
('321',	'6A', 'Economy'),
('321',	'6B', 'Economy'),
('321',	'6C', 'Economy'),
('321',	'6D', 'Economy'),
('321',	'6E', 'Economy'),
('321',	'6F', 'Economy'),
('321',	'7A', 'Economy'),
('321',	'7B', 'Economy'),
('321',	'7C', 'Economy'),
('321',	'7D', 'Economy'),
('321',	'7E', 'Economy'),
('321',	'7F', 'Economy'),
('321',	'8A', 'Economy'),
('321',	'8B', 'Economy'),
('321',	'8C', 'Economy'),
('321',	'8D', 'Economy'),
('321',	'8E', 'Economy'),
('321',	'8F', 'Economy'),
('321',	'9A', 'Economy'),
('321',	'9B', 'Economy'),
('321',	'9C', 'Economy'),
('321',	'9D', 'Economy'),
('321',	'9E', 'Economy'),
('321',	'9F', 'Economy'),
('321',	'10A', 'Economy'),
('321',	'10B', 'Economy'),
('321',	'10C', 'Economy'),
('321',	'10D', 'Economy'),
('321',	'10E', 'Economy'),
('321',	'10F', 'Economy');