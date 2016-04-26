app.controller('UserCtrl', ['$scope','$location','$log','sqlService', function ($scope,$location, $log,sqlService)
                            {
    $scope.searchuser = "";
    $scope.user = "";
    $scope.onClick = function(){
        sqlService.getUserByUsername({"username" : $scope.searchuser}, function(data){
            $scope.user = data;
        });
    }

    //$scope.elements = Useraccount.init();
}]);
