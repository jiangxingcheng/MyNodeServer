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
    .get(function(req,res){
        var username = req.query.username;
        console.log('Username is ' + username);
        var path = req.query.path;
        console.log('Path is ' + path);
        sqlquery.ls([path,username],function(err,data){
            if(err){
                console.log('error');
                console.log(err);
                res.format({
                    json: function(){
                        res.json(err);
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


    });
router.param('username',function(req,res,next,id){
    console.log('Validate parameter username');
    console.log(id);
    sqlquery.findUserByUsername(id,function(err,data){
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
            console.log('Username validated');
            console.log(data);
            req.id = id;
            next();
        }
    });
});


module.exports = router;
