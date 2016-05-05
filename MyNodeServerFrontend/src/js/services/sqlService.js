app.service('sqlService', ['$http','$log' ,'Useraccount','Category',function ($http,$log,Useraccount,Category) {
    var self = this;

    self.users = ["One things","two things","three things"];
    self.CSSEclasses = [];
    self.init = function(){
        Useraccount.query(function(data){
            self.users = data;
        });
    };
    self.getUsers = function(callback){
        Useraccount.query(function(data){
            $log.log(data);
            self.users = data;
            callback(data);
        });
    };
    self.getUserByUsername = function(username, callback){
       Useraccount.query({"username":username},function(data){
            self.users = data;
            callback(data);
        });
    };
    self.getCategories = function(callback){
        Category.query(function(data){
            self.categories = data;
            callback(data);
        });
    };
    self.getCategoryByTitle = function(categorytitle,callback){
        Category.query({"categorytitle":categorytitle},function(data){
            //self.categories = data;
            callback(data);
        });
    };
    self.createUserAccount = function(username,password,callback,errorcallback){
        Useraccount.save({"username":username,"password":password},function(data){
            callback(data);
        },function(error){
            //$log.log('Error in sqlservice');
            //$log.log(error);
            errorcallback(error); //error handling
        });
    };
    /**
     * Returns a random integer between min (inclusive) and max (inclusive)
     * Using Math.round() will give you a non-uniform distribution!
     * Found from mozilla developer network
     */
    self.getRandomInt = function(min, max) {
        return Math.floor(Math.random() * (max - min + 1)) + min;
    };
}]);
