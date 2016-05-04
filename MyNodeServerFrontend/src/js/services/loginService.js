app.service('loginService', ['$http','$log' ,'Useraccount','sqlService',function ($http,$log,Useraccount,sqlService) {
    var self = this;
    self.userlevel = 'User';
    self.isAuthenticated = function(username,password,salt,callback){
        sqlService.getUserByUsername(username,function(data){
            if(data.length == 1){
                callback(true);
            }else{
                callback(false);
            }
        });
    };
}]);
