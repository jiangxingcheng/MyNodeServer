app.controller('ThreadModalCtrl',['$scope','$uibModalInstance','loginService','sqlService','$log', function ($scope,$uibModalInstance,loginService,sqlService,$log) {

    $scope.ok = function () {
        $uibModalInstance.close('Close');
    };

    $scope.cancel = function () {
        $uibModalInstance.dismiss('cancel');
    };
    $scope.submitComment = function(){
        $log.log('Submit comment pressed');
        $log.log($scope.usertext);
        if(loginService.userlevel != "None"){
            $log.log('username is : ' + sqlService.username);
            sqlService.createThreadComment(sqlService.username,$scope.modalThread.title,$scope.usertext,function(){
                //console.log('create thread callback ran');
                sqlService.getThreadCommentsByTitle($scope.categoryTitle, $scope.modalThread.title ,function(data){
                    $scope.threadComments = data;
                });

            });
        }else{
            $log.log('You must be logged in to comment ');
        }
    };

}]);
