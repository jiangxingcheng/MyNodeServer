app.controller('HomeCtrl', ['$scope', '$location', '$log', 'sqlService','$timeout', function ($scope, $location, $log, sqlService,$timeout) {
    $scope.isPageCollapsed = true;
    $scope.init = function () {
        //Set the page to uncollapsed when we present it
        $scope.isPageCollapsed = false;
        //console.log('Print');
    };
    //Wait short period of time to let the page start as collapsed then open
    $timeout($scope.init,20);
}]);
