app.controller('FileModalCtrl',['$scope','$uibModalInstance','loginService','sqlService','$log','Files', function ($scope,$uibModalInstance,loginService,sqlService,$log,Files) {

    $scope.submitComment = function(){
        $log.log('Submit comment ran when it wasnt supposed to');
        Files.saveFileComment({"username":$scope.username,"path":$scope.currentfilepath,"usertext":$scope.usertext},function(data){
            $scope.usertext = '';
            Files.getFileComments({"path":$scope.currentfilepath},function(data){
                $scope.filecomments = data;
            });
        });
    };
    $scope.deletecomment = function(comment){
        $log.log('Delete comment with title');

    };
    $scope.ok = function () {
        $uibModalInstance.close('Close');
    };
    $scope.rm = function () {
        $uibModalInstance.close({rm:true});
    };

    $scope.cancel = function () {
        $uibModalInstance.dismiss('cancel');
    };

}]);
