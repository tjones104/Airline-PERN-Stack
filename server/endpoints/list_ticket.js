let connection = require("../database");
const writeQueries = require("../write_Queries");

const endpoint = async function (request, response) {
    //console.log(request.body.ticket_no)
    connection.query(`SELECT * FROM ticket NATURAL JOIN boarding_passes WHERE ticket_no = '${request.body.ticket_no}'`,
                function (error, rows, fields) {
                    if (!!error) {
                    console.log("Error in Query");
                    } else {
                        writeQueries.appendFile('query.sql',`SELECT * \nFROM ticket \nNATURAL JOIN boarding_passes \nWHERE ticket_no = '${request.body.ticket_no}'\n\n`,function(err){
                            if (err) throw err;
                            console.log('Saved query!');
                        });
                        console.log("Successful Query");
                        response.contentType("application/json");
                        response.json(rows.rows);
                        //console.log(rows.rows)
                    }
                }
            );

};

module.exports = endpoint;