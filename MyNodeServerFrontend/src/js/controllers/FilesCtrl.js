app.controller('FilesCtrl', ['$scope', '$location', '$log', 'sqlService', '$timeout','Files','$filter','$uibModal', function ($scope, $location, $log, sqlService, $timeout,Files,$filter,$uibModal) {
    $scope.contents = [];
    $scope.username = sqlService.username;
    $scope.homepath = '/home/'+ $scope.username + '/';
    $scope.currentpatharray = ['home',$scope.username];
    $log.log($scope.currentpatharray);

    $scope.setCurrentPath = function(currentpatharray){
        $scope.currentpatharray = currentpatharray;
        $scope.currentpath = $filter('pathArrayToString')(currentpatharray);
    };

    $scope.setCurrentPath($scope.currentpatharray);

    sqlService.ls($scope.username,$scope.currentpath,function(data){
        $scope.contents = data;
    });
    $scope.allButLast = function(arr){
        var returnarr = [];
        if(arr.length == 1){
            return arr;
        }
        for(var i=0; i<arr.length; i++){
            if(i != arr.length -1){
                returnarr[i] = arr[i];
            }
        }
        return returnarr;
    };


    $scope.goUpDir = function(){
        $log.log('Show current path before we go up dir');
        $log.log($scope.currentpatharray);
        var updir = $scope.allButLast($scope.currentpatharray);
        $scope.setCurrentPath(updir);
        $log.log('Updir is ');
        $log.log(updir);
        sqlService.ls($scope.username,$scope.currentpath,function(data){
            $scope.contents = data;
        });
    };
    $scope.navigateToDir = function(dir){
        $log.log('Dir');
        $log.log(dir);
        var downdir = dir.filepath[dir.filepath.length-1];
        $scope.currentpatharray.push(downdir);
        $scope.setCurrentPath($scope.currentpatharray);

        $log.log('open content current path');
        $log.log($scope.currentpath);
        sqlService.ls($scope.username,$scope.currentpath,function(data){
            $scope.contents = data;
            $log.log('data is');
            $log.log(data);
        });
    };
    $scope.openFile = function(file){
        $scope.currentFile = file;
        var modalInstance = $uibModal.open({
            animation: true,
            templateUrl: 'views/filemodalview.html',
            scope: $scope,
            size: 'lg',
            controller: 'FileModalCtrl'
        });
        modalInstance.result.then(function (result) {
            $log.log('Result is: ' + result);
        }, function () {
            $log.info('Modal dismissed at: ' + new Date());
        });
    };
}]);