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
        //var passedCategory = {title : category.title, username: category.username};

        $state.go('forum.threads', {category : category });
    };
}]);
