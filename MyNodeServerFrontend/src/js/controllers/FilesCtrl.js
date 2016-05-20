app.controller('FilesCtrl', ['$scope', '$location', '$log', 'sqlService', '$timeout','Files', function ($scope, $location, $log, sqlService, $timeout,Files) {
    $scope.contents = [];
    $scope.username = sqlService.username;
    $scope.homepath = '/home/'+ $scope.username + '/';
    $log.log($scope.homepath);
    $scope.currentpath = $scope.homepath;
    sqlService.ls($scope.username,$scope.currentpath,function(data){
        $scope.contents = data;
    });

    $scope.openContent = function(element){
        $log.log('Element');
        $log.log(element);
        $scope.currentpath = $scope.currentpath + element.filepath[element.filepath.length-1] + '/';
        $log.log($scope.currentpath);
        sqlService.ls($scope.username,$scope.currentpath,function(data){
            $scope.contents = data;
            $log.log('contents is');
            $log.log($scope.contents);
        });
    };
}]);
