app.controller('FilesCtrl', ['$scope', '$location', '$log', 'sqlService', '$timeout', function ($scope, $location, $log, sqlService, $timeout) {
    $scope.contents = [
        {
            type: 'file',
            name: 'penis'
        },
        {
            type: 'dir',
            name: 'lots of penis'
        },
        {
            type: 'dir',
            name: 'gay sex'
        },
        {
            type: 'dir',
            name: 'lots of penis'
        },
        {
            type: 'dir',
            name: 'lots of penis'
        },
        {
            type: 'dir',
            name: 'lots of penis'
        },
        {
            type: 'dir',
            name: 'lots of penis'
        },
        {
            type: 'dir',
            name: 'lots of penis'
        },
        {
            type: 'dir',
            name: 'lots of penis'
        },
        {
            type: 'dir',
            name: 'lots of penis'
        },
        {
            type: 'dir',
            name: 'lots of penis'
        },
        {
            type: 'dir',
            name: 'lots of penis'
        },
        {
            type: 'dir',
            name: 'lots of penis'
        },
        {
            type: 'dir',
            name: 'lots of penis'
        },
        {
            type: 'dir',
            name: 'lots of penis'
        },
        {
            type: 'dir',
            name: 'lots of penis'
        },
        {
            type: 'dir',
            name: 'lots of penis'
        },
        {
            type: 'dir',
            name: 'lots of penis'
        },
        {
            type: 'dir',
            name: 'lots of penis'
        }
    ];

    $log.log($scope.contents[0].type);
}]);
