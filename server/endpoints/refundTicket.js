let connection = require("../database");
const writeQueries = require("../write_Queries");
const writeTransactions = require("../write_Transactions");

const endpoint = async function (request, response) {
            connection.query(
                `START TRANSACTION`,
                (err, res, fields) => {
                  connection.query(`SELECT * FROM payment WHERE book_ref = '${request.body.book_ref}' AND card_number = '${request.body.card_no}'`,
                    function (error, rows, fields) {
                      //console.log(rows.rows[0].amount_in_dollars)
                      amount = -(rows.rows[0].amount_in_dollars)
                      //console.log(amount)
                      writeQueries.appendFile('query.sql',`SELECT * FROM payment WHERE book_ref = '${request.body.book_ref}' AND card_number = '${request.body.card_no}'\n\n`,function(err){
                          if (err) throw err;
                          console.log('Saved query!');
                      writeTransactions.appendFile('transactions.sql','START TRANSACTION\n\n', function(err){
                        if (err) throw err;
                        console.log('Saved transaction!');
                      });
                      connection.query(`SAVEPOINT 1;`,
                      (err, res, fields) => {})
                      writeTransactions.appendFile('transactions.sql',`SAVEPOINT 1\n\n`, function(err){
                        if (err) throw err;
                      });
                      connection.query(`INSERT INTO payment (book_ref, card_number, taxes, amount_in_dollars) VALUES ('${request.body.book_ref}' , '${request.body.card_no}', '0', '${amount}')`,
                        (err, res, fields) => {
                          if (err) {
                            console.log("Error: Cannot Post");
                            console.log(err)
                          }
                          connection.query(`RELEASE SAVEPOINT 1;`,
                          (err, res, fields) => {})
                          writeTransactions.appendFile('transactions.sql',`RELEASE SAVEPOINT 1\n\n`, function(err){
                            if (err) throw err;
                          });
                          writeTransactions.appendFile('transactions.sql',`INSERT INTO payment (book_ref, card_number, taxes, amount_in_dollars) VALUES ('${request.body.book_ref}' , '${request.body.card_no}', 0, '${amount}')\n\n`,function(err){
                            if (err) throw err;
                            console.log('Saved transaction!');
                          });
                          connection.query(`COMMIT`,
                            (err, res, fields) => {
                              writeTransactions.appendFile('transactions.sql',`COMMIT\n\n`, function(err){
                                if (err) throw err;
                              });
                              connection.query(
                                `START TRANSACTION`,
                                (err, res, fields) => {
                                    
                                  writeTransactions.appendFile('transactions.sql','START TRANSACTION\n\n', function(err){
                                    if (err) throw err;
                                    console.log('Saved transaction!');
                                  });
                                  writeTransactions.appendFile('transactions.sql',`SELECT ticket_no FROM ticket WHERE book_ref = '${request.body.book_ref}'\n\n`, function(err){
                                    if (err) throw err;
                                    console.log('Saved transaction!');
                                  });
                          connection.query(`SELECT ticket_no FROM ticket WHERE book_ref = '${request.body.book_ref}'`,
                            function (error, rows, fields) {
                                //console.log(rows.rows);
                                writeQueries.appendFile('query.sql',`SELECT flight_id FROM ticket_flights WHERE ticket_no = '${rows.rows[0].ticket_no}'\n\n`,function(err){
                                  if (err) throw err;
                                  console.log('Saved query!')})
                                connection.query(`SELECT flight_id FROM ticket_flights WHERE ticket_no = '${rows.rows[0].ticket_no}'`,
                                  function (error, row, fields) {

                              var i;
                              for (i = 0; i < rows.rows.length; i++) 
                                {
                                  connection.query(`SAVEPOINT '${i}';`,
                                  (err, res, fields) => {})
                                  writeTransactions.appendFile('transactions.sql',`SAVEPOINT '${i}'\n\n`, function(err){
                                    if (err) throw err;
                                  });
                                  //console.log(rows.rows[i].ticket_no);
                                  connection.query(`DELETE FROM boarding_passes WHERE ticket_no = '${rows.rows[i].ticket_no}'`,
                                  (err, res, fields) => {
                                
                                  });
                                  writeTransactions.appendFile('transactions.sql',`DELETE FROM boarding_passes WHERE ticket_no = '${rows.rows[i].ticket_no}'\n\n`, function(err){
                                    if (err) throw err;
                                  });
                                  connection.query(`RELEASE SAVEPOINT '${i}';`,
                                  (err, res, fields) => {})
                                  writeTransactions.appendFile('transactions.sql',`RELEASE SAVEPOINT '${i}'\n\n`, function(err){
                                    if (err) throw err;
                                  });
                                }
                                connection.query(`COMMIT`,
                                (err, res, fields) => {
                                  writeTransactions.appendFile('transactions.sql','COMMIT\n\n', function(err){
                                    if (err) throw err;
                                    console.log('Saved transaction!');
                                  });
                                  connection.query(
                                    `START TRANSACTION`,
                                    (err, res, fields) => {
                                      writeTransactions.appendFile('transactions.sql','START TRANSACTION\n\n', function(err){
                                        if (err) throw err;
                                        console.log('Saved transaction!');
                                      });
                                for (i = 0; i < rows.rows.length; i++) 
                                {
                                  connection.query(`SAVEPOINT '${i}';`,
                                  (err, res, fields) => {})
                                  writeTransactions.appendFile('transactions.sql',`SAVEPOINT '${i}'\n\n`, function(err){
                                    if (err) throw err;
                                  });
                                  //console.log(rows.rows[i].ticket_no);
                                   connection.query(`DELETE FROM ticket_flights WHERE ticket_no = '${rows.rows[i].ticket_no}'`,
                                  (err, res, fields) => {
                                      
                                  });
                                  writeTransactions.appendFile('transactions.sql',`DELETE FROM ticket_flights WHERE ticket_no = '${rows.rows[i].ticket_no}'\n\n`, function(err){
                                    if (err) throw err;
                                  });
                                  connection.query(`RELEASE SAVEPOINT '${i}';`,
                                  (err, res, fields) => {})
                                  writeTransactions.appendFile('transactions.sql',`RELEASE SAVEPOINT '${i}'\n\n`, function(err){
                                    if (err) throw err;
                                  });
                                }
                                connection.query(`COMMIT`,
                                (err, res, fields) => {
                                  connection.query(
                                    `START TRANSACTION`,
                                    (err, res, fields) => {
                                for (i = 0; i < rows.rows.length; i++) 
                                {
                                  connection.query(`SAVEPOINT '${i}';`,
                                  (err, res, fields) => {})
                                  writeTransactions.appendFile('transactions.sql',`SAVEPOINT '${i}'\n\n`, function(err){
                                    if (err) throw err;
                                  });
                                  //console.log(rows.rows[i].ticket_no);
                                  connection.query(`DELETE FROM ticket WHERE ticket_no = '${rows.rows[i].ticket_no}'`,
                                  (err, res, fields) => {
                                    
                                  });
                                  writeTransactions.appendFile('transactions.sql',`DELETE FROM ticket WHERE ticket_no = '${rows.rows[i].ticket_no}'\n\n`, function(err){
                                    if (err) throw err;
                                  });
                                  connection.query(`RELEASE SAVEPOINT '${i}';`,
                                  (err, res, fields) => {})
                                  writeTransactions.appendFile('transactions.sql',`RELEASE SAVEPOINT '${i}'\n\n`, function(err){
                                    if (err) throw err;
                                  });
                                }
                                connection.query(
                                    `UPDATE flights SET seats_booked = seats_booked - '${rows.rows.length}' WHERE flight_id = '${row.rows[0].flight_id}'`,
                                    (err, res, fields) => {
                                      writeTransactions.appendFile('transactions.sql',`UPDATE flights \nSET seats_booked = seats_booked - '${rows.rows.length}' \nWHERE flight_id = '${row.rows[0].flight_id}'\n\n`,function (err){
                                        if (err) throw err;
                                        console.log('Saved transaction!');
                                      });
                                      connection.query(
                                        `UPDATE flights SET seats_available = seats_available + '${rows.rows.length}' WHERE flight_id = '${row.rows[0].flight_id}'`,
                                        (err, res, fields) => {
                                          writeTransactions.appendFile('transactions.sql',`UPDATE flights \nSET seats_available = seats_available + '${rows.rows.length}' \nWHERE flight_id = '${row.rows[0].flight_id}'\n\n`,function (err){
                                            if (err) throw err;
                                            console.log('Saved transaction!');
                                          });
                                        });
                                    });
                          connection.query(`COMMIT`,
                            (err, res, fields) => {
                              writeTransactions.appendFile('transactions.sql','COMMIT\n\n', function(err){
                                if (err) throw err;
                                    });
                                if (!!error) {
                                    console.log("Error: Cannot Post");
                                    } else {
                                      console.log("Post Successful");
                                      return response.send(
                                        JSON.stringify({
                                          success: true,
                                          data: null,
                                          })
                                        );
                                      }
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


module.exports = endpoint;