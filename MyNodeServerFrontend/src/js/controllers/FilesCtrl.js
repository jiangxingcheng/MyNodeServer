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
            type: 'file',
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
            type: 'file',
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
            type: 'file',
            name: 'lots of penis'
        },
        {
            type: 'dir',
            name: 'lots of penis'
        }
    ];
    $scope.openContent = function(element){
        $log.log('Element');
        $log.log(element);
    };
    $log.log($scope.contents[0].type);
}]);
