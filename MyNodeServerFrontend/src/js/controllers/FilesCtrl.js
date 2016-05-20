app.controller('FilesCtrl', ['$scope', '$location', '$log', 'sqlService', '$timeout','Files', function ($scope, $location, $log, sqlService, $timeout,Files) {
    $scope.results = [];
    sqlService.ls('schafezp','/home/schafezp/',function(data){
        $scope.results = data;
    });
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
