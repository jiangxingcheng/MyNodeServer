app.controller('UserCtrl', ['$scope', '$location', '$log', 'sqlService', function ($scope, $location, $log, sqlService) {
    $scope.searchuser = "";
    $scope.user = "";
    $scope.onClick = function () {
        sqlService.getUserByUsername({"username": $scope.searchuser}, function (data) {
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

    //$scope.elements = Useraccount.init();
}]);
