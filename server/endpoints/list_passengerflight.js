  
let connection = require("../database");
const writeQueries = require("../write_Queries");

const endpoint = async function (request, response) {
    connection.query(`SELECT * FROM user_history ORDER BY history_id DESC LIMIT 1`,
                function (error, rows, fields) {
                    writeQueries.appendFile('query.sql',`SELECT * \nFROM user_history \nORDER BY history_id \nDESC LIMIT 1\n\n`,function(err){
                        if (err) throw err;
                        console.log('Saved query!');
                    });
                    //console.log(rows.rows[0].travelers)
                    connection.query(`SELECT * FROM flights WHERE flight_id = '${rows.rows[0].flight_id}'`,
                                function (error, rows, fields) {
                                    if (!!error) {
                                    console.log("Error in Query");
                                    } else {
                                        writeQueries.appendFile('query.sql',`SELECT * \nFROM flights \nWHERE flight_id = '${rows.rows[0].flight_id}'\n\n`,function(err){
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
                        }
        );
};

module.exports = endpoint;