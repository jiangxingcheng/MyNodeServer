app.controller('ForumCtrl', ['$scope','$location','$log','sqlService','$timeout', function ($scope,$location, $log,sqlService,$timeout)
{
    $scope.categories = [];
    sqlService.getCategories(function(data){
        $scope.categories = data;
    });

}]);
