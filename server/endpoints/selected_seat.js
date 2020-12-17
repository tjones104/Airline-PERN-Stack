let connection = require("../database");
const writeQueries = require("../write_Queries");
const writeTransactions = require("../write_Transactions");

const endpoint = async function (request, response) {
  //console.log(request.body.travelers[0].seat_no);
  let ticket_no = []
  let seat_no = []
  var i;
   connection.query(
    `START TRANSACTION`,
    (err, res, fields) => {
      writeTransactions.appendFile('transactions.sql','START TRANSACTION\n\n', function(err){
        if (err) throw err;
      });
       connection.query(
        `SELECT * FROM user_history ORDER BY history_id DESC LIMIT 1`,
         function (error, rows, fields) {
          writeQueries.appendFile('query.sql',`SELECT * \nFROM user_history \nORDER BY history_id \nDESC LIMIT 1\n\n`,function (err){
            if (err) throw err;
            console.log('Saved query!');
           });
            flight_id = rows.rows[0].flight_id
            fair_conditions = rows.rows[0].fair_conditions
             connection.query(
              `SELECT * FROM bookings ORDER BY customer_id DESC LIMIT 1`,
               function (error, rows, fields) {
                writeQueries.appendFile('query.sql',`SELECT * \nFROM bookings \nORDER BY customer_id \nDESC LIMIT 1\n\n`,function (err){
                  if (err) throw err;
                  console.log('Saved query!');
                 });
                total_amount = rows.rows[0].total_amount
                total_amount = total_amount / request.body.current_user[0].travelers
                //console.log(total_amount)
                 connection.query(
                  `SELECT * FROM ticket ORDER BY passenger_id DESC LIMIT '${request.body.current_user[0].travelers}'`,
                   function (error, rows, fields) {
                    writeQueries.appendFile('query.sql',`SELECT * \nFROM ticket \nORDER BY passenger_id \nDESC LIMIT '${request.body.current_user[0].travelers}'\n\n`,function (err){
                      if (err) throw err;
                      console.log('Saved query!');
                     });
                    for (i = 0; i < request.body.current_user[0].travelers; i++) 
                    {
                      ticket_no.push(rows.rows[i].ticket_no)
                      seat_no.push(request.body.travelers[i].seat_no)
                    }
                    //console.log(ticket_no)
                    for (i = 0; i < request.body.current_user[0].travelers; i++) 
                    {
                      connection.query(`SAVEPOINT '${i}';`,
                      (err, res, fields) => {})
                      writeTransactions.appendFile('transactions.sql',`SAVEPOINT '${i}'\n\n`, function(err){
                        if (err) throw err;
                      });
                      connection.query(
                        `INSERT INTO ticket_flights (ticket_no, flight_id, fare_conditions, amount) VALUES ('${ticket_no[i]}','${flight_id}','${fair_conditions}', '${total_amount}')`,
                        (err, res, fields) => {
                          
                        }
                        );
                        writeTransactions.appendFile('transactions.sql',`INSERT INTO \nticket_flights (ticket_no, flight_id, fare_conditions, amount) \nVALUES ('${ticket_no[i]}','${flight_id}','${fair_conditions}', '${total_amount}')\n\n`,function (err){
                          if (err) throw err;
                          console.log('Saved transaction!');
                        })
                      connection.query(`RELEASE SAVEPOINT '${i}';`,
                      (err, res, fields) => {})
                      writeTransactions.appendFile('transactions.sql',`RELEASE SAVEPOINT '${i}'\n\n`, function(err){
                        if (err) throw err;
                      });
                    }
                        connection.query(
                        `UPDATE flights SET seats_booked = seats_booked + '${request.body.current_user[0].travelers}' WHERE flight_id = '${flight_id}'`,
                        (err, res, fields) => {
                          writeTransactions.appendFile('transactions.sql',`UPDATE flights \nSET seats_booked = seats_booked + '${request.body.current_user[0].travelers}' \nWHERE flight_id = '${flight_id}'\n\n`,function (err){
                            if (err) throw err;
                            console.log('Saved transaction!');
                          });
                          connection.query(
                            `UPDATE flights SET seats_available = seats_available - '${request.body.current_user[0].travelers}' WHERE flight_id = '${flight_id}'`,
                            (err, res, fields) => {
                              writeTransactions.appendFile('transactions.sql',`UPDATE flights \nSET seats_available = seats_available - '${request.body.current_user[0].travelers}' \nWHERE flight_id = '${flight_id}'\n\n`,function (err){
                                if (err) throw err;
                                console.log('Saved transaction!');
                              });
                              connection.query(
                                `SELECT seats_available FROM flights WHERE flight_id = '${flight_id}'`,
                                function (err, rows, fields) {
                                  writeQueries.appendFile('query.sql',`SELECT seats_available \nFROM flights \nWHERE flight_id = '${flight_id}'\n\n`,function (err){
                                    if (err) throw err;
                                    console.log('Saved query!');
                                   });
                                  if (rows.rows[0].seats_available < 0)
                                  {
                                    //console.log(rows.rows[0].seats_available)
                                    connection.query(
                                      `UPDATE flights SET seats_available = '0' WHERE flight_id = '${flight_id}'`,
                                      (err, res, fields) => {
                                        writeTransactions.appendFile('transactions.sql',`UPDATE flights \nSET seats_available = seats_available - '0' \nWHERE flight_id = '${flight_id}'\n\n`,function (err){
                                          if (err) throw err;
                                          console.log('Saved transaction!');
                                    });
                                    })
                                    connection.query(
                                      `UPDATE flights SET waitlist = waitlist - '${-(rows.rows[0].seats_available)}' WHERE flight_id = '${flight_id}'`,
                                      (err, res, fields) => {
                                        writeTransactions.appendFile('transactions.sql',`UPDATE flights \nSET waitlist = waitlist - '${-(rows.rows[0].seats_available)}' \nWHERE flight_id = '${flight_id}'\n\n`,function (err){
                                          if (err) throw err;
                                          console.log('Saved transaction!');
                                    });
                                    })
                                    connection.query(
                                      `UPDATE flights SET seats_booked = seats_booked - '${-(rows.rows[0].seats_available)}' WHERE flight_id = '${flight_id}'`,
                                      (err, res, fields) => {
                                        writeTransactions.appendFile('transactions.sql',`UPDATE flights \nSET seats_booked = seats_booked - '${-(rows.rows[0].seats_available)}' \nWHERE flight_id = '${flight_id}'\n\n`,function (err){
                                          if (err) throw err;
                                          console.log('Saved transaction!');
                                        });
                                      })
                                  }
                                  
                              //request.body.current_user[0].travelers
                              connection.query(
                                `COMMIT`,
                                (err, res, fields) => {  
                                  writeTransactions.appendFile('transactions.sql','COMMIT\n\n', function(err){
                                    if (err) throw err;
                                  });
                              if (err) {
                                  console.log("Error: Cannot Post");
                                  return response.send(err);
                                }
                                console.log("Post Successful");
                                return response.send(
                                  JSON.stringify({
                                    success: true,
                                    data: null,
                                    })
                                  );
                                }
                              );           
                            }
                          ); 
                          }
                        ); 
                      }
                    ); 
                   }
                 ); 
                }
              ); 
            }
          );
        }
        ); 
};





// for (i = 0; i < request.body.current_user[0].travelers; i++) 
// {
// console.log(ticket_no[i], flight_id, seat_no[i])

// connection.query(
//     `INSERT INTO boarding_passes (ticket_no, flight_id, seat_no) VALUES ('${ticket_no[i]}','${flight_id}','${seat_no[i]}')`,
//     (err, res, fields) => {
//       if (err) {
//         console.log("Error: Cannot Post");
//         console.log(err)
//       }
//     }

                
//     );
//   }
module.exports = endpoint;
