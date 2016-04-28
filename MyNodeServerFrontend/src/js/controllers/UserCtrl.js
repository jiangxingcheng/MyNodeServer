app.controller('UserCtrl', ['$scope', '$location', '$log', 'sqlService','$timeout', function ($scope, $location, $log, sqlService,$timeout) {
    $scope.searchuser = "";
    $scope.user = "";
    $scope.onClick = function () {
        sqlService.getUserByUsername($scope.searchuser, function (data) {
            $scope.user = data;
        });
    };
    $scope.myInterval = 3000;
    $scope.slides = [
        {
            image: 'http://lorempixel.com/400/200/'
        },
        {
            image: 'http://lorempixel.com/400/200/food'
        },
        {
            image: 'http://lorempixel.com/400/200/sports'
        },
        {
            image: 'http://lorempixel.com/400/200/people'
        }
    ];
    $scope.users = sqlService.users;
    sqlService.getUsers(function(data){
        $scope.users = data;
    });
    $scope.count = 0;
    $scope.isPageCollapsed = true;
    $scope.init = function () {
        //Set the page to uncollapsed when we present it
        $scope.isPageCollapsed = false;
    };
    //Wait short period of time to let the page start as collapsed then open
    $timeout($scope.init,20);
    //$scope.elements = Useraccount.init();
    //$scope.elements = Useraccount.init();
}]);
