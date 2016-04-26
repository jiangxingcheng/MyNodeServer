var express = require('express');
var router = express.Router();
var sqlquery = require('../sqlquery.js');
console.log("Sql query run");
sqlquery.destroyDatabase(function(){
    sqlquery.createDatabase(function(){
        sqlquery.populateDatabase(function(){
            //sqlquery.queryDatabase();
            sqlquery.findUserByUsername("schafezp",function(err,data){
                console.log(data);
            });
        });
    });
});


/* GET home page. */
/*
router.route('/')
    .get(function(req,res,next){})
*/

router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express' });
});

module.exports = router;
