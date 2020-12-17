const express = require('express');
const cors = require('cors');
const bodyparser = require("body-parser");
const path = require('path');
const {list_flights, selected_flight, customer_info, payment, flight_requirements, listall_flights, get_currentuser,
        pricing_module, list_seats, selected_seat, post_boarding, listall_passengers, list_generated, list_passengerflight, 
        list_ticket, list_booking, list_ticketflight, resetdatabase, populatetables, refundTicket, get_payments,get_bookings, search_flights} = require('./endpoints');
var writeQueries = require('fs');
var writeTransactions = require('fs');

writeTransactions.writeFile('transactions.sql', '', function (err) {
    if (err) throw err;
    console.log('Writing to transactions.sql');
  });

writeQueries.writeFile('query.sql', '', function (err) {
    if (err) throw err;
    console.log('Writing to query.sql');
    });


let app = express();

app.use(cors({
    origin: true,
    credentials: true
}));


app.use(bodyparser.json());
app.use(bodyparser.urlencoded({ extended: true }));



app.post('/api/selected_flight', selected_flight);
app.post('/api/customer_info', customer_info);
app.post('/api/flight_requirements', flight_requirements);
app.post('/api/payment', payment)
app.post('/api/list_flights', list_flights);
app.post('/api/selected_seat', selected_seat);
app.post('/api/post_boarding', post_boarding);
app.post('/api/list_ticket', list_ticket);
app.post('/api/list_booking', list_booking);
app.post('/api/list_ticketflight', list_ticketflight);
app.post('/api/resetdatabase', resetdatabase);
app.post('/api/populatetables', populatetables);
app.post('/api/refundTicket', refundTicket);
app.post('/api/search_flights', search_flights);



app.get('/api/pricing_module', pricing_module);
app.get('/api/pricing_module', pricing_module);
app.get('/api/get_currentuser', get_currentuser);
app.get('/api/list_flights', list_flights);
app.get('/api/listall_flights', listall_flights);
app.get('/api/list_seats', list_seats);
app.get('/api/listall_passengers', listall_passengers);
app.get('/api/list_generated', list_generated);
app.get('/api/list_passengerflight', list_passengerflight);
app.get('/api/get_payments', get_payments);
app.get('/api/get_bookings', get_bookings);

app.use(express.static(`client/build`));

app.get('*', (req, res) => {
    res.sendFile(path.resolve(__dirname, 'client', 'build', 'index.html'));
    });

app.listen(8080);
