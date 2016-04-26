var app = angular.module('DataManager', []);

    app.factory('EnvConfig', ['environment', function(environment){
        var staging = {
            api: {
                baseUrl: 'http://localhost:3000/',
                suffix: ''
            }
        };
        var prod = {
            api: {
                baseUrl: 'http://localhost:3000/',
                suffix: ''
            }
        };
        var configs = {staging: staging, prod: prod};
        return configs[environment];
    }]);

app.factory('Useraccount', ['$resource', 'EnvConfig', function($resource, EnvConfig) {
        var url = EnvConfig.api.baseUrl + 'users/:name';
        // var posturl = EnvConfig.api.baseUrl + 'coursespost/:id' + EnvConfig.api.suffix;
        return $resource(url,
            {},
            {
                update: {method: 'PUT', params: {name: '@name'}},
                getSingle: {method: 'GET', params: {name: '@name'}}
            }

            );
}]);
