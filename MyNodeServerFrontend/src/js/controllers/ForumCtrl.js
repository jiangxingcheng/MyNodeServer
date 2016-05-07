app.controller('ForumCtrl', ['$scope','$location','$log','sqlService','$timeout','$state', function ($scope,$location, $log,sqlService,$timeout,$state)
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



}]);
