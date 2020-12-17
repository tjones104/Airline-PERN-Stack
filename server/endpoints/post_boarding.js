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
      writeTransactions.appendFile('transactions.sql', `START TRANSACTION\n\n`, function (err) {
        if (err) throw err;
        console.log('Saved!');
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
                    //console.log(ticket_no[i], flight_id, seat_no[i])
                      connection.query(`SAVEPOINT '${i}';`,
                      (err, res, fields) => {})
                      writeTransactions.appendFile('transactions.sql',`SAVEPOINT '${i}'\n\n`, function(err){
                        if (err) throw err;
                      });
                      connection.query(
                        `INSERT INTO boarding_passes (ticket_no, flight_id, seat_no) VALUES ('${ticket_no[i]}','${flight_id}','${seat_no[i]}')`,
                        (err, res, fields) => {
                        if (err) {
                            console.log("Error: Cannot Post");
                            //console.log(err)
                        }});
                        writeTransactions.appendFile('transactions.sql',`INSERT INTO \nboarding_passes (ticket_no, flight_id, seat_no) \nVALUES ('${ticket_no[i]}','${flight_id}','${seat_no[i]}')\n\n`,function (err){
                          if (err) throw err;
                          console.log('Saved transaction!');
                        });
                      connection.query(`RELEASE SAVEPOINT '${i}';`,
                      (err, res, fields) => {})
                      writeTransactions.appendFile('transactions.sql',`RELEASE SAVEPOINT '${i}'\n\n`, function(err){
                        if (err) throw err;
                      });
                    }
                    connection.query(
                      `COMMIT`,
                      (err, res, fields) => {  
                        writeTransactions.appendFile('transactions.sql', `COMMIT\n\n`, function (err) {
                          if (err) throw err;
                          console.log('Saved!');
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

          
};






module.exports = endpoint;