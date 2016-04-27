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
app.directive('navBar', ['$location', function(location)
                         {
    return {
        restrict: 'E',
        templateUrl: 'views/topbar.html',
        replace: true
    };

}]);
