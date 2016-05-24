app.controller('FilesCtrl', ['$scope', '$location', '$log', 'sqlService', '$timeout','Files','$filter','$uibModal', function ($scope, $location, $log, sqlService, $timeout,Files,$filter,$uibModal) {
    var self = this;
    $log.log('Rerun controller');
    $scope.contents = [];
    $scope.username = sqlService.username;
    $scope.homepath = '/home/'+ $scope.username + '/';
    $scope.currentpatharray = ['home',$scope.username];
    $scope.mkdirname = "";
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
    $scope.allButLastTwo = function(arr){
        var returnarr = [];
        if(arr.length <= 2){
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
        //var updir = $scope.allButLast($scope.currentpatharray);
        var updir = $scope.allButLastTwo($scope.currentpatharray);
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
    $scope.touch = function(){
        self.touchmodalInstance = $uibModal.open({
            animation: true,
            templateUrl: 'views/touch.html',
            size: 'lg',
            controller : function($scope){
                $scope.mkdirname = '';
                $scope.savefile = function(){
                    self.touchmodalInstance.close({filename:$scope.filename,isfile:true});
                };
            }
        });
        self.touchmodalInstance.result.then(function(data){
            if(data.isfile){
                $log.log('Result filename : ' + data.filename);
                $log.log($scope.currentpath);
                $log.log(data.filename);
                sqlService.touch($scope.username, $scope.currentpath + data.filename,function(reponse){
                    sqlService.ls($scope.username,$scope.currentpath,function(data){
                        $scope.contents = data;
                        $log.log('data is');
                        $log.log(data);
                    });
                });
            };
        });
    };

    $scope.mkdir = function(){
        self.mkdirmodalInstance = $uibModal.open({
            animation: true,
            templateUrl: 'views/mkdir.html',
            size: 'lg',
            controller : function($scope){
                $scope.mkdirname = '';
                $scope.savedir = function(){
                    self.mkdirmodalInstance.close({mkdirname:$scope.mkdirname,isdir:true});
                };
            }
        });
        self.mkdirmodalInstance.result.then(function(data){
            $log.log('Result is : ' + data);
            $log.log($scope.currentpath);
            if(data.isdir){
                $log.log('Make dir');
                sqlService.mkdir($scope.username, $scope.currentpath + data.mkdirname + '/',function(reponse){
                    sqlService.ls($scope.username,$scope.currentpath,function(data){
                        $scope.contents = data;
                        $log.log('data is');
                        $log.log(data);
                    });
                });
            };
        });
    };
    $scope.openFile = function(file){
        $scope.currentFile = file;
        //var filepath =  $filter('pathArrayToString')(file.filepath[file.filepath.length -1]);
        //$log.log('File path is : ' + file.filepath);
        var filepath =  $filter('pathArrayToString')(file.filepath);
        //var filepath =  file.filepath[file.filepath.length -1];
        //$log.log('File path is : ' + filepath);
        $scope.currentfilepath = filepath.substring(0,filepath.length -1);
        $log.log('File path is : ' + $scope.currentfilepath);
        Files.getFileComments({"path":$scope.currentfilepath},function(data){
            $scope.filecomments = data;
            self.filemodalInstance = $uibModal.open({
                animation: true,
                templateUrl: 'views/filemodalview.html',
                scope: $scope,
                size: 'lg',
                controller: 'FileModalCtrl'
            });
            self.filemodalInstance.result.then(function (result) {
                if(result.rm){
                    $log.log('Run rm');
                    $log.log('Current path: ' + $scope.currentfilepath);
                    sqlService.rm($scope.currentfilepath,function(response){
                        $log.log('response');
                        $log.log(response);
                        sqlService.ls($scope.username,$scope.currentpath,function(data){

                            $scope.contents = data;
                        });
                    });
                }else{
                    $log.log('exit from flemodal withoutrm');
                }

            }, function () {
                $log.info('Modal dismissed at: ' + new Date());
            });
        });

    };
}]);
