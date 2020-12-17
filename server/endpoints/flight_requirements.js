let connection = require("../database");
var writeTransactions = require("../write_Transactions");

const endpoint = async function (request, response) {
    let { departing_airport, arrival_airport, date, travelers, fair_conditions} = request.body;
    //console.log(departing_airport, arrival_airport, date, travelers, fair_conditions)
        connection.query(
          `START TRANSACTION`,
          (err, res, fields) => {
            writeTransactions.appendFile('transactions.sql', `START TRANSACTION\n\n`, function (err) {
              if (err) throw err;
              console.log('Saved!');
            });
            connection.query(
              `INSERT INTO user_history (departure_airport, arrival_airport, date, travelers, fair_conditions, flight_id) VALUES ('${departing_airport}','${arrival_airport}','${date}','${travelers}','${fair_conditions}','1001')`,
              (err, res, fields) => {
                writeTransactions.appendFile('transactions.sql',`INSERT INTO user_history \n(departure_airport, arrival_airport, date, travelers, fair_conditions, flight_id) \nVALUES ('${departing_airport}','${arrival_airport}','${date}','${travelers}','${fair_conditions}','1001')\n\n`, function(err) {
                  if (err) throw err;
                  console.log('Saved transaction!');
                });
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
};

module.exports = endpoint;
