var massive = require("massive");
var app = require('./app');
var db = app.get('db');
var logresults = function(err,results){
    if(err){
        console.log("Error returned");
        console.log(err);
    }else{
        console.log("Successfully executed Statement");
        console.log(results);
    }
};

exports.massivequery = function(){
    db.querytest(function(err,results){
        logresults(err,results);
    });
};
exports.createDatabase = function(callback){
    callback = callback || function(){};
    console.log("Create Database");
    db.createdb(function(err,results){
        logresults(err,results);
        callback();
    });
};
exports.createStoredProcedures = function(callback){
    callback = callback || function(){};
    console.log("Create Stored Procedures");
    db.createStoredProcedures(function(err,results){
        logresults(err,results);
        callback();
    });
};

exports.populateDatabase = function(callback){
    callback = callback || function(){};
    console.log("Populate Database");
    db.populatedb(function(err,results){
        logresults(err,results);
        callback();

    });
};

exports.destroyDatabase = function(callback){
    callback = callback || function(){};
    console.log("Destroy Database");
    db.deletedb(function(err,results){
        //products is a results array
        logresults(err,results);
        callback();

    });
};
exports.queryDatabase = function(){

    db.querydb(function(err,results){
        console.log('Query Database');
        logresults(err,results);
    });
};
exports.getUsers = function(callback){
    db.querydb(function(err,results){
        console.log('Query Database');
        console.log(results);
        if(err){
            callback(err);
        }else{
            callback(results);
        };

    });
};
exports.findUserByUsername = function(username, callback){
    db.finduserbyid([username],function(err,results){
        console.log('Find user by username: '+ username);
        //console.log(results);
        if(err){
            callback(err);
        }else{
            callback(err,results);
        };

    });
};
exports.getCategories = function(callback){
    db.getcategories(function(err,results){
        console.log('Get all Categories');
        if(err){
            callback(err);
        }else{
            callback(err,results);
        }
    });
};

exports.getThreadsFromCategory = function(categorytitle, callback){
    db.getthreadsfromcategory([categorytitle],function(err,results){
        console.log('Get threads with category title');
        if(err){
            callback(err);
        }else{
            callback(err,results);
        }
    });
};
exports.createUser = function(parameters, callback){
    db.createuser(parameters,function(err,results){
        console.log('Create user ' + parameters[0]);
        if(err){
            console.log('Create user error');
            callback(err);
        }else{
            console.log('Create user results');
            callback(err,results);
        }
    });
};
exports.checkIfAuthenticated = function(username, password, callback){
    db.checkIfAuthenticated([username,password],function(err,results){
        console.log('Check if user: ' + username + ' is authenticated');
        if(err){
            callback(err);
        }else{
            var authenticationResponseMessage = results[0].loginuser;
            console.log('Results of authentication is ' + authenticationResponseMessage);
            if(authenticationResponseMessage === "Login Success: U"){
                console.log('Login Success: User status');
                callback(err,"user");
            }else if(authenticationResponseMessage === "Login Success: M"){
                console.log('Login Success: Mod status');
                callback(err,"mod");
            }else if(authenticationResponseMessage === "Login Success: A"){
                console.log('Login Success: Admin status');
                callback(err,"admin");
            }else if(authenticationResponseMessage === "Login Failure"){
                console.log('Login Failure');
                callback(err,false);
            }else{
                console.log('Login Not understood');
                callback(err,false);
            }
            //loginuser the name of the function the result is returned from



        }
    });
};

exports.getThreadCommentsFromThreadTitle = function(threadtitle, callback){

    db.getthreadcommentsfromthread(threadtitle,function(err,results){
        console.log('get thread comments');
        if(err){
            console.log('Couldnt retrieve thread comments');
            callback(err);
        }else{
            console.log('thread title returned');
            callback(err,results);
        }
    });
};
exports.createThreadComment = function(parameters, callback){
    db.createThreadComment(parameters,function(err,results){
        if(err){
            console.log('Create comment error');
            callback(err);
        }else{
            console.log('Create comment results');
            callback(err,results);
        }
    });
};
exports.removeUser = function(username, callback){
    db.removeUser(username,function(err,results){
        if(err){
            console.log('Delete user error');
            callback(err);
        }else{
            console.log('Delete user ' + username + ' succesful');
            callback(err,results);
        }
    });
};

exports.ls = function(parameters, callback){
    //paremeters[0] is parentdir
    //parameters[1] is username

    db.ls(parameters,function(err,results){
        if(err){
            console.log('list files error');
            callback(err);
        }else{
            console.log('list files success');
            callback(err,results);
        }
    });

};

exports.getFileComments = function(path, callback){
    db.getFileComments(path,function(err,results){
        if(err){
            console.log('get file comments error');
            callback(err);
        }else{
            console.log('get file comments');
            callback(err,results);
        }
    });

};
exports.createFileComment = function(parameters, callback){
    //parameters[0] is username
    //parameters[1] is filepath
    //parameters[2] is the text of the comment
    db.createFileComment(parameters,function(err,results){
        if(err){
            console.log('create file comment error');
            callback(err);
        }else{
            console.log('file comment created');
            callback(err,results);
        }
    });

};

exports.mkdir = function(parameters, callback){
    //parameters[0] is  dirpath
    //parameters[1] is username
    db.mkdir(parameters,function(err,results){
        if(err){
            console.log('create directory error');
            callback(err);
        }else{
            console.log('create directory success');
            callback(err,results);
        }
    });

}
exports.touch = function(parameters, callback){
    db.touch(parameters,function(err,results){
        if(err){
            console.log('touch file error');
            callback(err);
        }else{
            console.log('touch file success');
            callback(err,results);
        }
    });
};
exports.rm = function(filepath, callback){
    db.rm(filepath,function(err,results){
        if(err){
            console.log('rm file error');
            callback(err);
        }else{
            console.log('rm file success');
            callback(err,results);
        }
    });
};
