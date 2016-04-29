app.controller('ForumCtrl', ['$scope','$location','$log','sqlService','$timeout', function ($scope,$location, $log,sqlService,$timeout)
{
    $scope.threads = [];
    sqlService.getThreads(function(data){
        $scope.threads = data;
    });

}]);
