app.controller('HomeCtrl', ['$scope','$location','$log','sqlService', function ($scope,$location, $log,sqlService)
{
    $scope.users = sqlService.users;
    sqlService.getUsers(function(data){
        $scope.users = data;
    });
    $scope.count = 0;
    $scope.onClick = function(){
        $location.url('/user');
    };
    //$scope.elements = Useraccount.init();
}]);
