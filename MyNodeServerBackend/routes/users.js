var express = require('express');
var sqlquery = require('../sqlquery.js');
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
        var users = sqlquery.getUsers(function(data){
            res.format({
                json: function(){
                    res.json(data);
                }
            });
        });

    })
    .post(function(req,res){
        var username = req.body.username;
        var password = req.body.password;
        var UserLevel = 'User';
        var lastAccessDate = "2016-04-8 04:23:00";
        var TimeOfCreation = "2013-04-1 04:20:00";
        //res.send('Post request recieved username: ' + username );
        var params = [username,password,UserLevel, lastAccessDate, TimeOfCreation];
        sqlquery.createUser(params,function(data){
            if(data == null){
                console.log("Created succesfully");
                res.status(200).send(); //means ok
            }
            else if(data.constraint =='user_account_password_check'){
                console.log('Password not sufficient length');
                res.status(600).send('Password not sufficient length');
            }
            else if(data.constraint =='user_account_pkey'){
                console.log('User already exists');
                res.status(601).send('User already exists');
            }
            else if(data.severity == 'ERROR'){
                //console.log('Error Creating User : ' + data.message);
                console.log(data);
                res.status(602).send();
            }else{
                res.status(603).send();
            }

        });
    });

router.param('username',function(req,res,next,id){
    console.log('Validate parameter username');
    console.log(id);
    sqlquery.findUserByUsername(id,function(err,data){
        if(err || data === []){
            console.log('Username not validated');
            res.stat(404);
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
router.route('/:username')
    .get(function(req,res){
        sqlquery.findUserByUsername(req.id,function(err,data){
            if(err || data === []){
                console.log('Username not validated');
                res.stat(404);
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
