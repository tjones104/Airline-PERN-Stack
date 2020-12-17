let connection = require("../database");
const writeQueries = require("../write_Queries");


const endpoint = async function (request, response) {
        
    connection.query(`SELECT * FROM payment`,
        function (error, rows, fields) {
            if (!!error) {
            console.log("Error in Query");
            } else {
            writeQueries.appendFile('query.sql',`SELECT * \nFROM payment\n\n`, function(err){
                if (err) throw err;
                console.log('Saved query!');
            });
            console.log("Successful Query");
            response.contentType("application/json");
            response.json(rows.rows);
            //console.log(rows.rows);
            }
        }
    );  
};

module.exports = endpoint;
