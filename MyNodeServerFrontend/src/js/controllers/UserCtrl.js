app.controller('UserCtrl', ['$scope', '$location', '$log', 'sqlService', function ($scope, $location, $log, sqlService) {
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

    //$scope.elements = Useraccount.init();
    //$scope.elements = Useraccount.init();
}]);
