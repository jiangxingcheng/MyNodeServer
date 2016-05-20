app.controller('FileModalCtrl',['$scope','$uibModalInstance','loginService','sqlService','$log', function ($scope,$uibModalInstance,loginService,sqlService,$log) {

    $scope.ok = function () {
        $uibModalInstance.close('Close');
    };

    $scope.cancel = function () {
        $uibModalInstance.dismiss('cancel');
    };

}]);
