let connection = require("../database");
const writeQueries = require("../write_Queries");
const writeTransactions = require("../write_Transactions");

const endpoint = async function (request, response) {
    let { name, email, phone } = request.body;
    //console.log(name, email, phone);
    // console.log(typeof email)
    // console.log(typeof phone)
    connection.query(
      `START TRANSACTION`,
      (err, res, fields) => {
        writeTransactions.appendFile('transactions.sql','START TRANSACTION\n\n', function(err){
          if (err) throw err;
        });
        connection.query(
          `INSERT INTO customer_information (customer_name, email, phone) VALUES ('${name}','${email}','${phone}') `,
          (err, res, fields) => {
            writeTransactions.appendFile('transactions.sql',`INSERT INTO customer_information \n(customer_name, email, phone) \nVALUES ('${name}','${email}','${phone}') \n\n`, function(err) {
              if (err) throw err;
              console.log('Saved transaction!');
            });
          connection.query(
                    `COMMIT`,
                    (err, res, fields) => {  
                      writeTransactions.appendFile('transactions.sql','COMMIT\n\n', function(err){
                        if (err) throw err;
                      });
                  if (err) {
                      console.log("Error: Cannot Post");
                      return response.send(err);
                    }
                    console.log("Post Successful");
                    return response.send(
                      JSON.stringify({
                        success: true,
                        data: null,
                })
              );
            }
          );
        }
      );
    }
  );
};


// const endpoint = async function (request, response) {
//   connection.query(`SELECT * FROM user_history ORDER BY history_id DESC LIMIT 1`,
//         function (error, rows, fields) {
//           travelers = rows.rows[0].travelers
//           connection.query(
//             `START TRANSACTION`,
//             (err, res, fields) => {
//           var i;
//           for (i = 0; i < travelers; i++) {  
//             let { name, email, phone } = request.body.travelers[i];
//            console.log(name, email, phone);
//           // console.log(typeof email)
//           // console.log(typeof phone)

//               connection.query(
//                 `INSERT INTO customer_information (customer_name, email, phone) VALUES ('${name}','${email}','${phone}') RETURNING *`,
//                 (err, res, fields) => {
//                   console.log(res.rows);
//                 }
//                 )
//           }
          
//                 connection.query(
//                           `COMMIT`,
//                           (err, res, fields) => {  
//                         if (err) {
//                             console.log("Error: Cannot Post");
//                             return response.send(err);
//                           }
//                           console.log("Post Successful");
//                           return response.send(
//                             JSON.stringify({
//                               success: true,
//                               data: null,
//                       })
//                     );
//                   }
//                 );
              
//           }
//         );
//     }
//   );
// };


module.exports = endpoint;
