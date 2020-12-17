let connection = require("../database");
const writeQueries = require("../write_Queries");
const writeTransactions = require("../write_Transactions");

const endpoint = async function (request, response) {
  let {card_number, taxes, total_price} = request.body;
  let customer_id = []
  let passenger_name = []
  let email = []
  let phone = []
  let ticket_no = []
  //console.log(request.body.current_user[0].travelers);
  connection.query(
    `SELECT * FROM customer_information ORDER BY customer_id DESC LIMIT '${request.body.current_user[0].travelers}'`,
    function (error, rows, fields) {
      writeQueries.appendFile('query.sql',`SELECT * \nFROM customer_information \nORDER BY customer_id DESC LIMIT '${request.body.current_user[0].travelers}'\n\n`,function(err){
        if (err) throw err;
        console.log('Saved query!');
      });
        for (var i = 0; i < request.body.current_user[0].travelers; i++) 
        { 
          customer_id.push(rows.rows[i].customer_id)
          //console.log(rows.rows[i].customer_id)
          passenger_name.push(rows.rows[i].customer_name)
          email.push(rows.rows[i].email)
          phone.push(rows.rows[i].phone)
          ticket_no.push(Math.floor(Math.random() * 9999999999999) + 0000000000001)
        }
      book_ref = Math.floor(Math.random() * 999999) + 000001;
      connection.query(
        `START TRANSACTION`,
        (err, res, fields) => {
          writeTransactions.appendFile('transactions.sql','START TRANSACTION\n\n', function(err){
            if (err) throw err;
          });
          writeTransactions.appendFile('transactions.sql',`INSERT INTO \nbookings(book_ref, customer_id, book_date, total_amount) \nVALUES ('${book_ref}','${customer_id[0]}', CURRENT_TIMESTAMP,'${total_price}')\n\n`,function(err){
            if (err) throw err;
            console.log('Saved transaction!');
          });
          connection.query(
            `INSERT INTO bookings(book_ref, customer_id, book_date, total_amount) VALUES ('${book_ref}','${customer_id[0]}', CURRENT_TIMESTAMP,'${total_price}')`,
            (err, res, fields) => {
              writeTransactions.appendFile('transactions.sql',`INSERT INTO \npayment(book_ref, card_number, taxes, amount_in_dollars) \nVALUES ('${book_ref}','${card_number}','${taxes}','${total_price}')\n\n`,function(err){
                if (err) throw err;
                console.log('Saved transaction!');
              });
              connection.query(
                `INSERT INTO payment(book_ref, card_number, taxes, amount_in_dollars) VALUES ('${book_ref}','${card_number}','${taxes}','${total_price}')`,
                (err, res, fields) => {
                  connection.query(`COMMIT`,
                    (err, res, fields) => {
                      writeTransactions.appendFile('transactions.sql','COMMIT\n\n', function(err){
                        if (err) throw err;
                      });
                      connection.query(
                        `START TRANSACTION`,
                        (err, res, fields) => {
                          writeTransactions.appendFile('transactions.sql','START TRANSACTION\n\n', function(err){
                            if (err) throw err;
                          });
                            for (var i = 0; i < request.body.current_user[0].travelers; i++) 
                            {
                              writeTransactions.appendFile('transactions.sql',`SAVEPOINT '${i}'\n\n`, function(err){
                                if (err) throw err;
                              });
                              connection.query(`SAVEPOINT '${i}'`,
                                (err, res, fields) => {
                                })                         
                                connection.query(
                                  `INSERT INTO ticket(ticket_no, book_ref, passenger_name, email, phone) VALUES ('${ticket_no[i]}','${book_ref}','${passenger_name[i]}','${email[i]}','${phone[i]}')`,
                                  (err, res, fields) => { 
                                }
                                )
                                writeTransactions.appendFile('transactions.sql',`INSERT INTO \nticket(ticket_no, book_ref, passenger_name, email, phone) \nVALUES ('${ticket_no[i]}','${book_ref}','${passenger_name[i]}','${email[i]}','${phone[i]}')\n\n`,function(err){
                                  if (err) throw err;
                                  console.log('Saved transaction!');
                                });
                                connection.query(`RELEASE SAVEPOINT '${i}'`,
                                (err, res, fields) => {
                                  
                                })
                                writeTransactions.appendFile('transactions.sql',`RELEASE SAVEPOINT '${i}'\n\n`, function(err){
                                  if (err) throw err;
                                });
                            }
                              connection.query(`COMMIT`,
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
};

module.exports = endpoint;