var writeTransactions = require('fs');


writeTransactions.open('transactions.sql', 'w', function (err, file) {
    if (err) throw err;
});

// writeTransactions.appendFile('transactions.sql', '', function (err) {
//     if (err) throw err;
// });

module.exports = writeTransactions;