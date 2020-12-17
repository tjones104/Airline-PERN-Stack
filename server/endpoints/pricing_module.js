let connection = require("../database");
const writeQueries = require("../write_Queries");


const endpoint = async function (request, response) {
    let total_price = 0;
    connection.query(`SELECT * FROM user_history ORDER BY history_id DESC LIMIT 1`,
        function (error, rows, fields) {
            writeQueries.appendFile('query.sql',`SELECT * \nFROM user_history \nORDER BY history_id \nDESC LIMIT 1\n\n`,function (err){
                if (err) throw err;
                console.log('Saved query!');
               });
            if (!!error) {
            console.log("Error in Query");
            } else {
                if(rows.rows[0].fair_conditions == "Economy")
                {
                    total_price = 100 * rows.rows[0].travelers * 1.075
                }
                else if(rows.rows[0].fair_conditions == "Comfort")
                {
                    total_price = 200 * rows.rows[0].travelers * 1.075
                }
                else if(rows.rows[0].fair_conditions == "Business")
                {
                    total_price = 300 * rows.rows[0].travelers * 1.075
                }
                //console.log(typeof rows.rows[0].travelers);
                console.log("Successful Query");
                response.contentType("application/json");
                response.json(total_price);
                //console.log(total_price);
            }
        }
    );  
};

module.exports = endpoint;
