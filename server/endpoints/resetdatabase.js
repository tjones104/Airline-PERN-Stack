var fs = require('fs');
let connection = require("../database");
var sql = fs.readFileSync('../make_airline_sql.sql').toString();

const endpoint = async function (request, response) {
    console.log("Database Reset")
    connection.connect(function(err, client, done){
        if(err){
            console.log('error: ', err);
        }
        client.query(sql, function(err, result){
            done();
            if(err){
                console.log('error: ', err);  
            }
        });
    });
};

module.exports = endpoint;