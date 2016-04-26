var express = require('express');
var router = express.Router();
var sqlquery = require('../sqlquery.js');
console.log("Sql query run");

sqlquery.destroyDatabase();
sqlquery.createDatabaseRun(sqlquery.populateDatabase);
//sqlquery.createDatabase();


/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express' });
});

module.exports = router;
