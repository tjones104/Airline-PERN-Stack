let connection = require("../database");
const writeQueries = require("../write_Queries");


const endpoint = async function (request, response) {
    connection.query(
        `SELECT * FROM user_history ORDER BY history_id DESC LIMIT 1`,
        function (error, rows, fields) {
            writeQueries.appendFile('query.sql',`SELECT * \nFROM user_history \nORDER BY history_id \nDESC LIMIT 1\n\n`,function(err){
                if (err) throw err;
                console.log('Saved query!');
            });
            fair_conditions = rows.rows[0].fair_conditions
            flight_id = rows.rows[0].flight_id
            travelers = rows.rows[0].travelers
            // console.log(fair_conditions);
            connection.query(`SELECT * FROM flights WHERE flight_id = '${flight_id}'`,
                function (error, rows, fields) {
                    writeQueries.appendFile('query.sql',`SELECT * \nFROM flights \nWHERE flight_id = '${flight_id}'\n\n`, function(err){
                        if (err) throw err;
                        console.log('Saved query!');
                    });
                    code = rows.rows[0].aircraft_code
                    //console.log(code);
                    connection.query(`SELECT count(*) FROM (SELECT 1 FROM boarding_passes WHERE flight_id = '${flight_id}' LIMIT 1) AS t;`,
                    function (error, rows, fields) {
                    writeQueries.appendFile('query.sql',`SELECT count(*) FROM \n(SELECT 1 FROM boarding_passes WHERE flight_id = '${flight_id}' LIMIT 1) \nAS t;\n\n`,function(err){
                        if (err) throw err;
                        console.log('Saved query!');
                    });
                    if(rows.rows[0].count == 0)
                    {
                        connection.query(`SELECT * FROM seats WHERE fare_conditions = '${fair_conditions}' AND aircraft_code = '${code}'`,
                                function (error, rows, fields) {
                                    writeQueries.appendFile('query.sql',`SELECT * \nFROM seats WHERE fare_conditions = '${fair_conditions}' \nAND aircraft_code = '${code}'\n\n`, function(err){
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
                    }
                    else
                    {
                            connection.query(`SELECT * FROM seats WHERE fare_conditions = '${fair_conditions}' AND aircraft_code = '${code}' AND seat_no NOT IN (SELECT seat_no FROM boarding_passes WHERE flight_id = '${flight_id}' ORDER BY boarding_no DESC LIMIT '${travelers}') `,
                                function (error, rows, fields) {
                                    writeQueries.appendFile('query.sql',`SELECT * \nFROM seats WHERE fare_conditions = '${fair_conditions}' \nAND aircraft_code = '${code}' \nAND seat_no NOT IN (SELECT seat_no FROM boarding_passes WHERE flight_id = '${flight_id}' \nORDER BY boarding_no DESC LIMIT '${travelers}') \n\n`,function(err){
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
                        }
                }
            ); 
        }
    ); 
    }
); 
};




module.exports = endpoint;
