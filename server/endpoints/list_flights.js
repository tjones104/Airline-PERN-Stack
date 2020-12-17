let connection = require("../database");
var writeQueries = require("../write_Queries")

const endpoint = async function (request, response) {
  //let { departing_airport, arrival_airport, date, travelers, fair_conditions} = request.body;
  //console.log(departing_airport, arrival_airport, date, travelers, fair_conditions);
  //console.log(typeof departing_airport)
  //request.departing_airport = departing_airport;
  connection.query(
    `SELECT * FROM user_history ORDER BY history_id DESC LIMIT 1`,
    function (error, rows, fields) {
      writeQueries.appendFile('query.sql', `SELECT * \nFROM user_history \nORDER BY history_id DESC \nLIMIT 1\n\n`, function (err) {
        if (err) throw err;
        console.log('Saved query!');
      });
      //console.log(rows.rows[0].date);

      writeQueries.appendFile('query.sql',`SELECT * \nFROM flights \nWHERE departure_airport = ('${rows.rows[0].departure_airport}') \nAND arrival_airport = ('${rows.rows[0].arrival_airport}') \nAND scheduled_departure >= ('${rows.rows[0].date}') \nORDER BY flight_id\n\n`, function(err){
        if (err) throw err;
        console.log('Saved query!')
      });
      connection.query(
        `SELECT * FROM flights WHERE departure_airport = ('${rows.rows[0].departure_airport}') AND arrival_airport = ('${rows.rows[0].arrival_airport}') AND scheduled_departure >= ('${rows.rows[0].date}') ORDER BY flight_id`,
        function (error, rows, fields) {
          if (!!error) {
            console.log("Error in Query");
          } else {
           
            console.log("Successful Query");
            response.contentType("application/json");
            response.json(rows.rows);
            //console.log(rows.rows);
          }
        }
      );
    }
  );
  
};

module.exports = endpoint;
