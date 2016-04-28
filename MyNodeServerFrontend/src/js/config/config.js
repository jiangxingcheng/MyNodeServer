app.config(function ($routeProvider, $locationProvider) {
    $routeProvider
        .when('/home', {
            templateUrl: 'views/home.html',
            controller: 'HomeCtrl'
        })
        .when('/user', {
            templateUrl: 'views/usersearch.html',
            controller: 'UserCtrl'
        })
        .when('/forum', {
            templateUrl: 'views/forum.html',
            controller: 'ForumCtrl'
        })
        .when('/about', {
            templateUrl: 'views/about.html',
            controller: 'AboutCtrl'
        })
        .otherwise({
            redirectTo: '/home'
        });
    //use HTML5 history API
    $locationProvider.html5Mode(true);
});
