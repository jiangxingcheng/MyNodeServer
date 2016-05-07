app.controller('ThreadModalCtrl', function ($scope,$uibModalInstance) {
    $scope.ok = function () {
        var result = 'example result.';
        $uibModalInstance.close(result);
    };

    $scope.cancel = function () {
        $uibModalInstance.dismiss('cancel');
    };
});
