app.controller('ForumThreadCtrl', ['$scope','$state','$stateParams','sqlService','$log', function ($scope,$state,$stateParams,sqlService,$log)
                             {
    $scope.categoryTitle = $stateParams.categoryTitle;
    $scope.threads = [];
    sqlService.getCategoryByTitle($scope.categoryTitle,function(data){
        $scope.threads = [];
        $scope.threads = data;
        $log.log('Recieved data');
        $log.log(data);

    });

}]);
