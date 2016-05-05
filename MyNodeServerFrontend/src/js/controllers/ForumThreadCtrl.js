app.controller('ForumThreadCtrl', ['$scope','$state','$stateParams', function ($scope,$state,$stateParams)
                             {
    $scope.categoryTitle = $stateParams.categoryTitle;

}]);
