START TRANSACTION;

INSERT INTO user_history 
(departure_airport, arrival_airport, date, travelers, fair_conditions, flight_id) 
VALUES ('HOU','LAX','2020-12-15','1','Economy','1016');

INSERT INTO customer_information 
(customer_name, email, phone) 
VALUES ('Jordan Jaimes','HoustonFan231@yahoo.com','7132123539');

INSERT INTO 
bookings(book_ref, customer_id, book_date, total_amount) 
VALUES ('641284','1',CURRENT_TIMESTAMP,'107.5');

INSERT INTO 
payment(book_ref, card_number, taxes, amount_in_dollars) 
VALUES ('641284','284719252410','7.5','107.5');

INSERT INTO 
ticket(ticket_no, book_ref, passenger_name, email, phone) 
VALUES ('6129843782931','641284','Jordan Jaimes','HoustonFan231@yahoo.com','7132123539');

INSERT INTO 
ticket_flights (ticket_no, flight_id, fare_conditions, amount) 
VALUES ('6129843782931','1016','Economy', '107.5');

INSERT INTO 
boarding_passes (ticket_no, flight_id, seat_no) 
VALUES ('6129843782931','1016','6C');

UPDATE flights 
SET seats_booked = seats_booked + '1' 
WHERE flight_id = '1016';

UPDATE flights 
SET seats_available = seats_available - '1' 
WHERE flight_id = '1016';


INSERT INTO user_history 
(departure_airport, arrival_airport, date, travelers, fair_conditions, flight_id) 
VALUES ('JFK','LAX','2020-12-25','1','Economy','1058');

INSERT INTO customer_information 
(customer_name, email, phone) 
VALUES ('Chad Sanders','ChadSanders623@gmail.com','8325312902');

INSERT INTO 
bookings(book_ref, customer_id, book_date, total_amount) 
VALUES ('975428','2',CURRENT_TIMESTAMP,'107.5');

INSERT INTO 
payment(book_ref, card_number, taxes, amount_in_dollars) 
VALUES ('975428','612402782591','7.5','107.5');

INSERT INTO 
ticket(ticket_no, book_ref, passenger_name, email, phone) 
VALUES ('9825582791232','975428','Chad Sanders','ChadSanders623@gmail.com','8325312902');

INSERT INTO 
ticket_flights (ticket_no, flight_id, fare_conditions, amount) 
VALUES ('9825582791232','1058','Economy', '107.5');

INSERT INTO 
boarding_passes (ticket_no, flight_id, seat_no) 
VALUES ('9825582791232','1058','6C');

UPDATE flights 
SET seats_booked = seats_booked + '1' 
WHERE flight_id = '1058';

UPDATE flights 
SET seats_available = seats_available - '1' 
WHERE flight_id = '1058';

INSERT INTO user_history 
(departure_airport, arrival_airport, date, travelers, fair_conditions, flight_id) 
VALUES ('LAX','JFK','2020-12-15','1','Economy','1094');

INSERT INTO customer_information 
(customer_name, email, phone) 
VALUES ('Carol Estrada','caro1123@yahoo.com','8321235723');

INSERT INTO 
bookings(book_ref, customer_id, book_date, total_amount) 
VALUES ('173167','3',CURRENT_TIMESTAMP,'107.5');

INSERT INTO 
payment(book_ref, card_number, taxes, amount_in_dollars) 
VALUES ('173167','533179927482','7.5','107.5');

INSERT INTO 
ticket(ticket_no, book_ref, passenger_name, email, phone) 
VALUES ('1162935782534','173167','Carol Estrada','caro1123@yahoo.com','8321235723');

INSERT INTO 
ticket_flights (ticket_no, flight_id, fare_conditions, amount) 
VALUES ('1162935782534','1094','Economy', '107.5');

INSERT INTO 
boarding_passes (ticket_no, flight_id, seat_no) 
VALUES ('1162935782534','1094','6C');

UPDATE flights 
SET seats_booked = seats_booked + '1' 
WHERE flight_id = '1094';

UPDATE flights 
SET seats_available = seats_available - '1' 
WHERE flight_id = '1094';

INSERT INTO user_history 
(departure_airport, arrival_airport, date, travelers, fair_conditions, flight_id) 
VALUES ('ORD','LAX','2020-12-30','1','Economy','1142');

INSERT INTO customer_information 
(customer_name, email, phone) 
VALUES ('Mike Rodriguez','MikeyMike2@aol.com','8321284652');

INSERT INTO 
bookings(book_ref, customer_id, book_date, total_amount) 
VALUES ('631723','4',CURRENT_TIMESTAMP,'107.5');

INSERT INTO 
payment(book_ref, card_number, taxes, amount_in_dollars) 
VALUES ('631723','612896276729','7.5','107.5');

INSERT INTO 
ticket(ticket_no, book_ref, passenger_name, email, phone) 
VALUES ('6429858821542','631723','Mike Rodriguez','MikeyMike2@aol.com','8321284652');

INSERT INTO 
ticket_flights (ticket_no, flight_id, fare_conditions, amount) 
VALUES ('6429858821542','1142','Economy', '107.5');

INSERT INTO 
boarding_passes (ticket_no, flight_id, seat_no) 
VALUES ('6429858821542','1142','6C');

UPDATE flights 
SET seats_booked = seats_booked + '1' 
WHERE flight_id = '1142';

UPDATE flights 
SET seats_available = seats_available - '1' 
WHERE flight_id = '1142';

INSERT INTO user_history 
(departure_airport, arrival_airport, date, travelers, fair_conditions, flight_id) 
VALUES ('LAX','HOU','2020-01-06','1','Economy','1105');

INSERT INTO customer_information 
(customer_name, email, phone) 
VALUES ('Miranda James','MJames532@yahoo.com','7132662998');

INSERT INTO 
bookings(book_ref, customer_id, book_date, total_amount) 
VALUES ('091631','5',CURRENT_TIMESTAMP,'107.5');

INSERT INTO 
payment(book_ref, card_number, taxes, amount_in_dollars) 
VALUES ('091631','531097267832','7.5','107.5');

INSERT INTO 
ticket(ticket_no, book_ref, passenger_name, email, phone) 
VALUES ('1633467123654','091631','Miranda James','MJames532@yahoo.com','7132662998');

INSERT INTO 
ticket_flights (ticket_no, flight_id, fare_conditions, amount) 
VALUES ('1633467123654','1105','Economy', '107.5');

INSERT INTO 
boarding_passes (ticket_no, flight_id, seat_no) 
VALUES ('1633467123654','1105','6C');

UPDATE flights 
SET seats_booked = seats_booked + '1' 
WHERE flight_id = '1105';

UPDATE flights 
SET seats_available = seats_available - '1' 
WHERE flight_id = '1105';

UPDATE flights 
SET seats_available = seats_available - '49' 
WHERE flight_id = '1001';

UPDATE flights 
SET waitlist = waitlist - '9' 
WHERE flight_id = '1001';

COMMIT;