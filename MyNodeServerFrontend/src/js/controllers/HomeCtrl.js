app.controller('HomeCtrl', ['$scope', '$location', '$log', 'sqlService', function ($scope, $location, $log, sqlService) {
    $scope.init = function () {
        // check if there is query in url
        // and fire search in case its value is not empty
        $('.page-body').removeClass('page-body-collapse');

    };
}]);
