app.controller('LoginCtrl', ['$scope', '$log', 'loginService','$location', function ($scope, $log, loginService,$location) {
    var self = this;
    self.registerFailedMessage = "Register Failed";
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
                loginService.checkIfAuthenticated(username,password,'',function(isAuthenticated){
                    if(isAuthenticated){
                        $log.log('Is Authenticated');
                        window.scrollTo(0,0);
                        $location.url('/home');
                    }else{
                        $log.log('Is Not Authenticated');
                        $scope.vm.loginAttempted = true;
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
                    $scope.registerFailedMessage = responsemessage;

                },function(errorMessage){ //error;
                    $scope.vm.dataLoading = false;
                    $scope.registerFailedMessage = errorMessage;
                });
            };
            attemptRegister();
        }
    };
}]);
