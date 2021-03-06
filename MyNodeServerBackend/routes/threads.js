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
    .post(function(req,res){

        var threadtitle = req.body.threadtitle;
        var username = req.body.username;
        var threadcategory = req.body.category;
        var textbody = req.body.textbody;
        console.log("Thread title " + threadtitle + " username: " + username);
        console.log("Thread category " + threadcategory + " textbody: " + textbody);
        var params = [threadtitle,username,threadcategory,textbody];
        db.createthread(params,function(err,results){
            if(err){
                console.log('Create thread error');
                console.log(err);
                res.status(600).send('Thread could not be created');
            }else{
                console.log('Create thread results');
                res.status(200).send();
            }
        });
    });
router.route('/delete') // workaround for cors error
    .post(function(req,res){
        var threadtitle = req.body.threadtitle;
        db.deletethread(threadtitle,function(err,results){
            if(err){
                console.log('Delete thread error');
                console.log(err);
                res.status(600).send('Thread could not be deleted');
            }else{
                console.log('Delete thread results');
                res.status(200).send();
            }
        });


    });
router.route('/deletecomment') // workaround for cors error
    .post(function(req,res){
        var username = req.body.username;
        var timeofcreation = req.body.timeofcreation;
        console.log('Username is ' + username);
        console.log('Timeofcreation is ' + timeofcreation);
        var params = [username,timeofcreation];
        db.deletethreadcomment(params,function(err,results){
            if(err){
                console.log('Delete thread comment error');
                console.log(err);
                res.status(600).send('Thread comment could not be deleted');
            }else{
                console.log('Delete thread comment results');
                res.status(200).send();
            }
        });


    });

module.exports = router;
