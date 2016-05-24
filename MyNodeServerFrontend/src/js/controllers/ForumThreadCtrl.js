app.controller('ForumThreadCtrl', ['$scope','$state','$stateParams','sqlService','$log','$uibModal','loginService', function ($scope,$state,$stateParams,sqlService,$log,$uibModal,loginService)
                             {
    $scope.category = $stateParams.category;
    $log.log('Category');
    $log.log($stateParams.category);
    $scope.categoryTitle = $scope.category.title;
    $scope.threads = [];
    $scope.username = sqlService.username;
    sqlService.getCategoryByTitle($scope.categoryTitle,function(data){
        $scope.threads = [];
        $scope.threads = data;
        $log.log('Received data');
        $log.log(data);

    });
    $scope.deleteThread = function(thread){
        console.log(thread);
        if(loginService.userlevel == 'Admin' || loginService.userlevel == 'Mod'){
            var threadtitle = thread.title;
            sqlService.deleteThread(threadtitle,function(response){
                $log.log('Delete thread was succesful');
                $log.log(response);
                sqlService.getCategoryByTitle($scope.categoryTitle,function(data){
                    $scope.threads = [];
                    $scope.threads = data;
                });
            },function(err){
                $log.log('Error deleting thread');
                $log.log(err);
            });
        }
    };
    $scope.createthreadmodal =function(){
        self.createthreadmodal = $uibModal.open({
            animation: true,
            templateUrl: 'views/newthread.html',
            size: 'lg',
            scope: $scope,
            controller : function($scope,sqlService){
                $scope.submit = function () {
                    var threadtitle = $scope.threadtitle;
                    var category = $scope.category.title;
                    var username = $scope.username;
                    var textbody = '';
                    sqlService.createThread(threadtitle,username,category,textbody,function(status){
                        sqlService.getCategoryByTitle($scope.categoryTitle,function(data){
                            $scope.threads = data;
                        });
                        console.log("Create thread status");
                        console.log(status);
                    });
                    self.createthreadmodal.close('Close');
                };

                $scope.cancel = function () {
                    self.createthreadmodal.dismiss('cancel');
                };
            }
        });
        self.createthreadmodal.result.then(function(data){
            sqlService.getCategoryByTitle($scope.categoryTitle,function(data){
                $scope.threads = [];
                $scope.threads = data;
            });
        });
    };

    $scope.openModal = function (size,thread) {
        $scope.modalThread = thread;

        //$scope.comments
        $log.log('Modals thread');
        $log.log(thread);
        sqlService.getThreadCommentsByTitle($scope.categoryTitle, thread.title,function(data){
            //once this is loaded open the modal
            $log.log('Data returned was');
            $log.log(data);
            $scope.threadComments = data;
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
        });
    };
}]);
