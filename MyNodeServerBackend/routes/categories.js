var express = require('express');
var sqlquery = require('../sqlquery.js');
var app = require('./../app');
var db = app.get('db');
var router = express.Router(),
    bodyParser = require('body-parser'), // parses info from post
    methodOverride = require('method-override'); // used to manipulate post data
router.use(bodyParser.urlencoded({extended: true}));
router.use(methodOverride(function(req, res){
    if(req.body && typeof req.body == 'object' && '_method' in req.body){
        // look in urlencoded POST bodies and delete it
        var method = req.body._method;
        delete req.body._method;
        return method;
    }
}));

router.route('/')
    .get(function(req,res,next){
        var categories = db.getcategories(function(err,data){
            if(err || data === []){
                console.log('No Category information');
                res.status(404);
                err = new Error('Not Found');
                err.status = 404;
                res.format({
                    // html: function(){
                    //     next(err);
                    // },
                    json: function(){
                        res.json({message: err.status + ' ' + err});
                    }
                });
            }else{
                res.format({
                    json: function(){
                        res.json(data);
                    }
                });
            }

        });

    })
.post(function(req,res){
    var username = req.body.username;
    var threadtitle = req.body.threadtitle;
    var usertext = req.body.usertext;
    //res.send('Post request recieved username: ' + username );
    var params = [username,threadtitle,usertext];
    sqlquery.createThreadComment(params,function(err, result){
        if(err){
            console.log('creating thread comment created an error');
            console.log(err);
        }else{
            res.status(200).send('');
        }


    });
});
      router.param('categorytitle',function(req,res,next,id){
          console.log('Validate parameter username');
          console.log(id);
          sqlquery.getThreadsFromCategory(id,function(err,data){
              if(err || data === []){
                  console.log('Category not validated');
                  res.status(404);
                  err = new Error('Not Found');
                  err.status = 404;
                  res.format({
                // html: function(){
                //     next(err);
                // },
                json: function(){
                    res.json({message: err.status + ' ' + err});
                }
            });
        }else{//once validated save the id as the req id.
            console.log('Username validated');
            console.log(data);
            req.id = id;
            next();
        }
    });
});
router.route('/:categorytitle')
    .get(function(req,res){
        sqlquery.getThreadsFromCategory(req.id,function(err,data){
            if(err || data === []){
                console.log('Username not validated');
                res.status(404);
                err = new Error('Not Found');
                err.status = 404;
                res.format({
                    // html: function(){
                    //     next(err);
                    // },
                    json: function(){
                        res.json({message: err.status + ' ' + err});
                    }
                });
            }else{//once validated save the id as the req id.
                res.format({
                    json: function(){
                        res.json(data);
                    }
                })
            }
        });

    })
router.route('/:categorytitle/:threadtitle')
    .get(function(req,res){
        console.log('req id is');
        //console.log(req);
        var ctitle = req.params.categorytitle;
        var ttitle = req.params.threadtitle;
        //var ttitle = 'Internet stuff';
        console.log('ttitle : ' + ttitle);
        sqlquery.getThreadCommentsFromThreadTitle(ttitle,function(err,data){
            if(err){
                console.log('Category is not validated');
                res.status(404);
                err = new Error('Not Found');
                err.status = 404;
                res.format({
                    // html: function(){
                    //     next(err);
                    // },
                    json: function(){
                        res.json({message: err.status + ' ' + err});
                    }
                });
            }else{//once validated save the id as the req id.
                res.format({
                    json: function(){
                        res.json(data);
                    }
                })
            }
        });

    })
/* GET list of users . */

/* GET users listing. */
/* Respond with HTML
router.get('/', function(req, res, next) {
  res.send('respond with a resource');
});
*/

module.exports = router;
