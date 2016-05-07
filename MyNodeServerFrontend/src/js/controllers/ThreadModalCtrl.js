app.controller('ThreadModalCtrl', function ($scope,$uibModalInstance) {
    $scope.ok = function () {
        $uibModalInstance.close('Close');
    };

    $scope.cancel = function () {
        $uibModalInstance.dismiss('cancel');
    };
});
