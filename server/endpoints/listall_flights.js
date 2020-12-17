let connection = require("../database");
const writeQueries = require("../write_Queries");


const endpoint = async function (request, response) {
        
    connection.query(`SELECT * FROM flights ORDER BY seats_booked DESC`,
        function (error, rows, fields) {
            writeQueries.appendFile('query.sql',`SELECT * \nFROM flights \nORDER BY seats_booked DESC\n\n`,function(err){
                if (err) throw err;
                console.log('Saved query!');
            });
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
