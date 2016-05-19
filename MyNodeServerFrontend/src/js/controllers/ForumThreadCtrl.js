app.controller('ForumThreadCtrl', ['$scope','$state','$stateParams','sqlService','$log','$uibModal', function ($scope,$state,$stateParams,sqlService,$log,$uibModal)
                             {
    $scope.category = $stateParams.category;
    $log.log('Category');
    $log.log($stateParams.category);
    $scope.categoryTitle = $scope.category.title;
    $scope.threads = [];
    sqlService.getCategoryByTitle($scope.categoryTitle,function(data){
        $scope.threads = [];
        $scope.threads = data;
        $log.log('Recieved data');
        $log.log(data);

    });

    $scope.openModal = function (size,thread) {
        $scope.modalThread = thread;

        //$scope.comments
        $log.log('Modals thread');
        $log.log(thread);
        sqlService.getThreadCommentsByTitle($scope.categoryTitle, thread.title,function(data){
            //once this is loaded open the modal
            $log.log('Data returned was');
            $log.log(data);
            $scope.threadComments = data;
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
        });
    };
}]);
