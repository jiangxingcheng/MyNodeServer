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
router.route('/filecomments')
    .get(function(req,res){
        var path = req.query.path;
        console.log('Path is ' + path);
        sqlquery.getFileComments(path,function(err,data){
            if(err){
                console.log('error');
                console.log(err);
                res.format({
                    json: function(){
                        res.json(err);
                    }
                });
            }else{
                console.log('File comments returned');
                console.log(data);
                res.format({
                    json: function(){
                        res.json(data);
                    }
                });
            }

        });


    }).post(function(req,res){
        var username = req.query.username;
        var filepath = req.query.path;
        var usertext = req.query.usertext;
        console.log('Username : ' + username);
        console.log('filepath : ' + filepath);
        console.log('usertext : ' + usertext);
        var parameters = [username,filepath,usertext];
        sqlquery.createFileComment(parameters,function(err,result){
            if(err){
                console.log(err);
                res.status(604).send();
            }else{
                res.status(200).send();
            }
        });
    });
router.route('/filecommentsdelete')
    .post(function(req,res){
        var username = req.body.username;
        var timeofcreation = req.body.timeofcreation;
        db.deletefilecomment([username,timeofcreation],function(err,result){
            if(err){
                console.log('delete filecomments error');
                console.log(err);
                res.status(600).send();
            }else{
                console.log('delete filecomments success');
                res.status(200).send();
            }
        });

    });
router.route('/filedelete')
    .get(function(req,res){
        //var filepath = req.body.filepath;
        var filepath = req.query.filepath;
        console.log('filepath');
        console.log(filepath);
        sqlquery.rm(filepath,function(err,data){
            if(err){
                console.log(err);
                res.status(601).send(err);
            }else{
                res.status(200).send("");
            }
        });

    });
router.route('/mkdir')
    .post(function(req,res){
        var dirpath = req.body.dirpath;
        var username = req.body.username;

        console.log('Username : ' + username);
        console.log('dirpath : ' + dirpath);
        var parameters = [dirpath,username];
        sqlquery.mkdir(parameters,function(err,result){
            if(err){
                console.log(err);
                res.status(604).send();
            }else{
                res.status(200).send();
            }
        });
    });
router.route('/touch')
    .post(function(req,res){
        var filepath = req.body.filepath;
        var username = req.body.username;

        console.log('Username : ' + username);
        console.log('filepath : ' + filepath);
        var parameters = [filepath,username];
        sqlquery.touch(parameters,function(err,result){
            if(err){
                console.log(err);
                res.status(604).send();
            }else{
                res.status(200).send();
            }
        });
    });
module.exports = router;
