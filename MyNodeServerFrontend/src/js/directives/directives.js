app.directive('navigator', ['$location', function($location)
                            {
    return {
        replace:true,
        link: function(scope, element, attrs){
            scope.goTo = function(args){
                var location = args.viewLoc;
                console.log("going to "+args.viewLoc);
                window.scrollTo(0,0);
                $location.url(location);

            };
        }
    };
}]);
app.directive('webpage', ['$timeout','$log','ngProgressFactory', function($timeout,$log,ngProgressFactory)
                            {
    return {
        replace:false,
        link: function(scope, element, attrs){
            scope.isPageCollapsed = true;
            scope.init = function () {
                element.removeClass("page-body-collapse");
            };
            //Wait short period of time to let the page start as collapsed then open
            element.addClass("page-body-collapse");
            scope.progressbar = ngProgressFactory.createInstance();
            scope.progressbar.setColor('#0069ee');
            scope.progressbar.setHeight('4px');
            scope.progressbar.start();
            $timeout(scope.init,20);

            scope.progressbar.complete();
            //$timeout(scope.progressbar.complete,100);

        }
    };
}]);
app.directive('navBar', ['$location', function(location)
                         {
    return {
        restrict: 'E',
        templateUrl: 'views/topbar.html',
        replace: true
    };

}]);
