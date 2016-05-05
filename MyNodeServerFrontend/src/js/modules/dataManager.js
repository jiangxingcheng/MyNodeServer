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
        var url = EnvConfig.api.baseUrl + 'users/:username';
      return $resource(url,{},
            {
                update: {method: 'PUT', params: {name: '@username'}},
                getSingle: {method: 'GET', params: {name: '@username'}}


            }

            );
}]);

app.factory('Category', ['$resource', 'EnvConfig', function($resource, EnvConfig) {
    var url = EnvConfig.api.baseUrl + 'categories/:categoryname';
    return $resource(url,{},
                     {
                         update: {method: 'PUT', params: {name: '@categoryname'}},
                         getSingle: {method: 'GET', params: {name: '@categoryname'}}

                     }

                    );
}]);
