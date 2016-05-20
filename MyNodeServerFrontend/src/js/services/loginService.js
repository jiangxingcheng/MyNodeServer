app.service('loginService', ['$http','$log' ,'Useraccount','sqlService',function ($http,$log,Useraccount,sqlService) {
    var self = this;
    self.userlevel = 'None';
    self.loggedIn = false;
    self.hasAccount = false;
    self.createUserAccount = function(username,password,messagecallback,errormessagecallback){
        sqlService.createUserAccount(username,password,function(data){
            var registerSuccessMessage = 'User Successfully Created';
            messagecallback(registerSuccessMessage);
        },function(error){
            //$log.log('Login Service');
            //$log.log(error);
            $log.log('Error');
            $log.log(error);
            var registerFailedMessage = 'Error Message';

            if(error.status==600){
                //$log.log('Password not long enough');
                $log.log(error);
                registerFailedMessage = 'Password not long enough';
            }else if(error.status==601){
                //$log.log('User already exists so cannot be created');
                registerFailedMessage = 'User already exists so cannot be created';
            }else if(error.status==602){
                //$log.log('Unhandled error creating user');
                registerFailedMessage = 'Unhandled error creating user';
            }else{
                $log.log('Response undeteremined');
                $log.log(error);
            }
            errormessagecallback(registerFailedMessage);
        });
    };

    self.changeLoggedInStatus = function() {
        self.loggedIn = !self.loggedIn;
    };
    self.getLoggedInStatus = function() {
        return self.loggedIn;
    };
    self.getHasAccountStatus = function() {
        return self.hasAccount;
    }
}]);
