var fs = require('fs');
var sql = fs.readFileSync('./make_airline_sql.sql').toString();
const Pool = require('pg').Pool;
var content = fs.readFileSync('password.txt', 'utf8');

var list = content.split('\n');
console.log(list)

const connection = new Pool({
  host: 'code.cs.uh.edu',
  user: list[0],
  password: list[1],
  port: 5432,
  database: 'COSC3380'
});


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

connection.end()