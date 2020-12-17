var fs = require('fs');
let connection = require("../database");
var sql = fs.readFileSync('../preload.sql').toString();

const endpoint = async function (request, response) {
    console.log("Tables Populated")
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