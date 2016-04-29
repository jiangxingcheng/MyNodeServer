app.controller('UserCtrl', ['$scope', '$location', '$log', 'sqlService', '$timeout', function ($scope, $location, $log, sqlService, $timeout) {
    $scope.searchuser = "";
    $scope.user = "";
    $scope.users = [];
    $scope.onClick = function () {
        $scope.users = [];
        if ($scope.searchuser != "") {//sending no parameter means all users and we only want one
            sqlService.getUserByUsername($scope.searchuser, function (data) {
                $scope.users = data;
                $scope.user = data[0];
            });
        }

    };
    $scope.displayAllUsers = false;
    $scope.toggleDisplayAllUsers = function () {
        $scope.displayAllUsers = !$scope.displayAllUsers;
    }
    $scope.allUsers = sqlService.users;
    sqlService.getUsers(function (data) {
        $scope.allUsers = data;
    });
}]);
