var writeQueries = require('fs');


writeQueries.open('query.sql', 'w', function (err, file) {
    if (err) throw err;
});

// writeQueries.appendFile('query.sql', '', function (err) {
//     if (err) throw err;
// });

module.exports = writeQueries;