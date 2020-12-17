let connection = require("../database");
const writeQueries = require("../write_Queries");
const writeTransactions = require("../write_Transactions");

const endpoint = async function (request, response) {
  //console.log(request.body.flight_id);
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
              connection.query(
             `UPDATE user_history SET flight_id = '${request.body.flight_id}' WHERE history_id = '${rows.rows[0].history_id}'`,
             (err, res, fields) => {
               writeTransactions.appendFile('transactions.sql',`UPDATE user_history \nSET flight_id = '${request.body.flight_id}' \nWHERE history_id = '${rows.rows[0].history_id}'\n\n`,function (err){
                if (err) throw err;
                console.log('Saved transaction!');
               });
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
};

module.exports = endpoint;