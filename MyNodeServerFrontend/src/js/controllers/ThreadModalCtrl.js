app.controller('ThreadModalCtrl',['$scope','$uibModalInstance','loginService','sqlService','$log','Threads', function ($scope,$uibModalInstance,loginService,sqlService,$log,Threads) {

    $scope.ok = function () {
        $uibModalInstance.close('Close');
    };

    $scope.cancel = function () {
        $uibModalInstance.dismiss('cancel');
    };
    $scope.submitComment = function(){
        $log.log('Submit comment pressed');
        var usertext = $scope.usertext;
        $scope.usertext = '';
        $log.log(usertext);
        if(loginService.userlevel != "None"){
            $log.log('username is : ' + sqlService.username);
            sqlService.createThreadComment(sqlService.username,$scope.modalThread.title,usertext,function(){
                //console.log('create thread callback ran');
                sqlService.getThreadCommentsByTitle($scope.categoryTitle, $scope.modalThread.title ,function(data){
                    $scope.threadComments = data;
                });

            });
        }else{
            $log.log('You must be logged in to comment ');
        }
    };
    $scope.deleteComment = function(comment){
        if(loginService.usertext == 'Admin' ||loginService.usertext == 'Mod'){
            $log.log('Comment to be deleted is');
            var username = comment.username;
            var timeofcreation = comment.timeofcreation;
            $log.log('Delete username : ' + username + ' timeofcreation : ' + timeofcreation);
            sqlService.deleteThreadComment(username,timeofcreation,function(res){
                $log.log('Comment succesfully deleted');
                sqlService.getThreadCommentsByTitle($scope.categoryTitle, $scope.modalThread.title ,function(data){
                    $scope.threadComments = data;
                    $log.log('Updated threadcomments is');
                    $log.log($scope.threadComments);
                });
            },function(err){
                $log.log('Comment not succesfully deleted');
            });
        }else{
            $log.log('Cannot run delete comment because of permission level');
        }
    };

}]);
