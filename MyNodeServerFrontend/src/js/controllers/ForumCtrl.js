app.controller('ForumCtrl', ['$scope','$location','$log','sqlService','$timeout', function ($scope,$location, $log,sqlService,$timeout)
{
    $scope.threadnames = ["General","Help","NSFW","/b/"];
    //we turn this into a function to make it more easy to generalize laster
    $scope.isPageCollapsed = true;
    $scope.init = function () {
        //Set the page to uncollapsed when we present it
        $scope.isPageCollapsed = false;
    };
    //Wait short period of time to let the page start as collapsed then open
    $timeout($scope.init,20);
}]);
