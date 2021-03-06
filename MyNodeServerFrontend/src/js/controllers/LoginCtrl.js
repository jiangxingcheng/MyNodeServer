app.controller('LoginCtrl', ['$scope', '$log','loginService', 'sqlService','$location', function ($scope, $log,loginService,sqlService,$location) {
    var self = this;
    self.registerFailedMessage = "Register Failed";
    $scope.username = sqlService.getUserName();
    $scope.loggedIn = loginService.getLoggedInStatus();
    $scope.hasAccount = loginService.getHasAccountStatus();
    $scope.setHasAccountFalse = function() {
        $scope.hasAccount = false
        loginService.hasAccount = false;
    };
    $scope.setHasAccountTrue = function() {
        $scope.hasAccount = true;
        loginService.hasAccount = true;
    };
    
    $scope.vm = {
        dataLoading : false,
        loginAttempted : false,
        registerAttempted : false,
        login : function(){
            var username = $scope.vm.username;
            var password = $scope.vm.password;
            $scope.vm.dataLoading = false;
            var attemptLogin = function(){
                $scope.vm.dataLoading = true;
                $log.log(sqlService);
                sqlService.checkIfAuthenticated(username,password,function(isAuthenticated){
                    $log.log('Result of authentication is');
                    $log.log(isAuthenticated);
                    if(isAuthenticated == "A"){
                        loginService.userlevel = 'Admin';
                        loginService.changeLoggedInStatus();
                        window.scrollTo(0,0);
                        $location.url('/user');
                    }else if(isAuthenticated == "M"){
                        loginService.userlevel = 'Mod';
                        loginService.changeLoggedInStatus();
                        window.scrollTo(0,0);
                        $location.url('/home');
                    }else if(isAuthenticated == "U"){
                        loginService.userlevel = 'User';
                        loginService.changeLoggedInStatus();
                        window.scrollTo(0,0);
                        $location.url('/home');
                    }else if(!isAuthenticated){
                        $scope.vm.loginAttempted = true;
                        loginService.userlevel = 'None';
                    }else{
                        $log.log('Login Message not understood in LoginCtrl');
                        $log.log(isAuthenticated);
                    }
                    $scope.vm.dataLoading = false;
                    $scope.vm.username = '';
                    $scope.vm.password = '';
                });
            };
            attemptLogin();
        },
        register :  function(){
            var username = $scope.vm.user.username;
            var password = $scope.vm.user.password;
            $scope.vm.dataLoading = false;
            var clearDisplay = function(){
                $scope.vm.dataLoading = false;
                $scope.vm.user.username = '';
                $scope.vm.user.password = '';
            };
            var attemptRegister = function(){
                $scope.vm.dataLoading = true;
                $scope.vm.registerAttempted = true;
                $scope.registerFailedMessage = '';
                loginService.createUserAccount(username,password,function(responsemessage){
                    $scope.vm.dataLoading = false;
                    //$log.log('Response');
                    //$log.log(response);
                    $scope.registerFailedMessage = responsemessage; //succeded
                    loginService.userlevel = 'User';
                    loginService.changeLoggedInStatus();
                    sqlService.username = username;
                    window.scrollTo(0,0);
                    $location.url('/home');


                },function(errorMessage){ //error;
                    $scope.vm.dataLoading = false;
                    $log.log('Error message is ' + errorMessage);
                    $scope.registerFailedMessage = errorMessage;
                });
            };
            attemptRegister();
        },
        logout: function(){
            loginService.userlevel = 'None';
            sqlService.blankUserName();
            loginService.changeLoggedInStatus();
            window.scrollTo(0,0);
            $location.url('/home');
            $log.log("logging out");
        }
    }
}]);
