let connection = require("../database");
var writeQueries = require("../write_Queries")

const endpoint = async function (request, response) {
      writeQueries.appendFile('query.sql',`SELECT * FROM flights WHERE flight_id = ('${request.body.flight_id}') ORDER BY flight_id\n\n`, function(err){
        if (err) throw err;
        console.log('Saved query!')
      });
      connection.query(
        `SELECT * FROM flights WHERE flight_id = ('${request.body.flight_id}') ORDER BY flight_id`,
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
  
};

module.exports = endpoint;
