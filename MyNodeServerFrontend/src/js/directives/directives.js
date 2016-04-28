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
app.directive('webpage', ['$timeout','$log', function($timeout,$log)
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
            $timeout(scope.init,20);

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
