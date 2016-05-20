app.controller('FileModalCtrl',['$scope','$uibModalInstance','loginService','sqlService','$log','Files', function ($scope,$uibModalInstance,loginService,sqlService,$log,Files) {

    $scope.submitComment = function(){
        Files.saveFileComment({"username":$scope.username,"path":$scope.currentfilepath,"usertext":$scope.usertext},function(data){
            $scope.usertext = '';
            Files.getFileComments({"path":$scope.currentfilepath},function(data){
                $scope.filecomments = data;
            });
        });
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
