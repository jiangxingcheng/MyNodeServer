app.service('loginService', ['$http','$log' ,'Useraccount',function ($http,$log,Useraccount) {
    var self = this;
    self.userlevel = 'User';
    self.isAuthenticated = function(username,password,salt){
        if(username == 'schafezp' || username == 'zamanmm'){
            // for now only permit two users
            return true;
        }else{
            return false;
        };

    };
}]);
