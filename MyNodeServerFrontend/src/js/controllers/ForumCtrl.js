app.controller('ForumCtrl', ['$scope','$location','$log','sqlService','$timeout','$state','$uibModal', function ($scope,$location, $log,sqlService,$timeout,$state,$uibModal)
{
    $scope.categories = [];
    $scope.thread = {threadOpen : false};
    $scope.parentvalue = "blah";
    sqlService.getCategories(function(data){
        $scope.categories = data;
    });
    $scope.display = function(){
        $log.log('display thread');
        $scope.thread.threadOpen = !$scope.thread.threadOpen;
    };
    $scope.openCategory = function(category){
        $log.log('Category');
        $log.log(category);
        var title = category.title;
        $state.go('forum.threads', {categoryTitle : title });
    };

    $scope.openModal = function (size) {


        var modalInstance = $uibModal.open({
            animation: true,
            templateUrl: 'views/modalview.html',
            scope: $scope,
            size: size,
            controller: 'ThreadModalCtrl'
        });

        modalInstance.result.then(function (result) {
            $log.log('Result is: ' + result);
        }, function () {
            $log.info('Modal dismissed at: ' + new Date());
        });
    };

}]);
