app.controller('ForumThreadCtrl', ['$scope','$state','$stateParams','sqlService','$log','$uibModal', function ($scope,$state,$stateParams,sqlService,$log,$uibModal)
                             {
    $scope.categoryTitle = $stateParams.categoryTitle;
    $scope.threads = [];
    sqlService.getCategoryByTitle($scope.categoryTitle,function(data){
        $scope.threads = [];
        $scope.threads = data;
        $log.log('Recieved data');
        $log.log(data);

    });

    $scope.openModal = function (size,thread) {
        $scope.modalThread = thread;
        $log.log('Modals thread');
        $log.log(thread);


        var modalInstance = $uibModal.open({
            animation: true,
            templateUrl: 'views/modalview.html',
            scope: $scope,
            size: size,
            controller: 'ThreadModalCtrl'
        });

        modalInstance.result.then(function (result) {
            $log.log('Result is: ' + result);
        }, function () {
            $log.info('Modal dismissed at: ' + new Date());
        });
    };
}]);
