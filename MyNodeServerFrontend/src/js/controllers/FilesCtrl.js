app.controller('FilesCtrl', ['$scope', '$location', '$log', 'sqlService', '$timeout','Files', function ($scope, $location, $log, sqlService, $timeout,Files) {
    $scope.contents = [];
    $scope.username = sqlService.username;
    sqlService.ls($scope.username,'/home/'+ $scope.username + '/',function(data){
        $scope.contents = data;
    });

    $scope.openContent = function(element){
        $log.log('Element');
        $log.log(element);
    };
}]);
