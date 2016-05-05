app.controller('LoginCtrl', ['$scope', '$log', 'loginService','$location', function ($scope, $log, loginService,$location) {
    var self = this;
    $scope.vm = {
        dataLoading : false,
        loginAttempted : false,
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
        }
    };
}]);
