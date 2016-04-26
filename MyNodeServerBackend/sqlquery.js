var massive = require("massive");
var app = require('./app');
var db = app.get('db');
var logresults = function(err,results){
    if(err){
        console.log("Error returned");
        console.log(err);
    }else{
        console.log("Successfully executed returned");
        console.log(results);
    }
}

exports.massivequery = function(){
    db.querytest(function(err,results){
        logresults(err,results);
    });
}
exports.createDatabaseRun = function(callback){
    console.log("Create Database");
    db.createdb(function(err,results){
        logresults(err,results);
        callback();
    });
}
exports.createDatabase = function(){
    exports.createDatabaseRun();
}
exports.populateDatabase = function(){
    console.log("Populate Database");
    db.populatedb(function(err,results){
        logresults(err,results);

    });
}
exports.destroyDatabaseAndRun = function(callback){
    db.deletedb(function(err,results){
        //products is a results array
        callback();
    });
}
exports.destroyDatabase = function(){
    console.log("Destroy Database");
    db.deletedb(function(err,results){
        //products is a results array
        if(err){
            console.log("Error returned");
            console.log(err);
        }else{
            console.log("Successfully executed returned");
            console.log(results);
        }

    });
}
