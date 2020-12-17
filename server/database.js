const Pool = require('pg').Pool;

var fs = require('fs');
var content = fs.readFileSync('password.txt', 'utf8');

var list = content.split('\n');
//console.log(list)
const connection = new Pool({
  host: 'code.cs.uh.edu',
  user: list[0],
  password: list[1],
  port: 5432,
  database: 'COSC3380'
});

connection.connect(function (error) {
  if (!!error) {
    console.log("Error: Cannot connect to database");
  } else {
    console.log("Connected to database");
  }
});

module.exports = connection;