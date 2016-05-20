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

// app.factory('Category', ['$resource', 'EnvConfig', function($resource, EnvConfig) {
//     var url = EnvConfig.api.baseUrl + 'categories/:categorytitle/:threadtitle';
//     return $resource(url,{},{params : {
//                          categorytitle:'@categorytitle',
//                          threadtitle:'@threadtitle'
//     }}

//                     );
// }]);
app.factory('Category', ['$resource', 'EnvConfig', function($resource, EnvConfig) {
    var url = EnvConfig.api.baseUrl + 'categories/:categorytitle/:threadtitle';
    return $resource(url,{},{
        queryCategory: {method: 'GET', isArray : true, params : {categorytitle:'@categorytitle'}},
        queryComments: {method: 'GET',isArray: true,params : {categorytitle:'@categorytitle',threadtitle:'@threadtitle'}},
        saveComment: {method: 'POST', params: {username:'@username',threadtitle:'@threadtitle',usertext:'@usertext'}}

    });
}

]);

app.factory('AuthenticateLogin', ['$resource', 'EnvConfig', function($resource, EnvConfig) {
    var url = EnvConfig.api.baseUrl + 'authenticatelogin/:username/:password';
    return $resource(url,{},
                     {
                         //not currently implemented
                         update: {method: 'PUT', params: {username: '@username',password:"@password"}},
                         getSingle: {method: 'GET', params: {username: '@username',password:"@password"}}

                     }

                    );
}]);

app.factory('Files', ['$resource', 'EnvConfig', function($resource, EnvConfig) {
    var url = EnvConfig.api.baseUrl + 'files/';
    return $resource(url,{},
                     {
                         ls: {method: "GET",isArray:true ,params: {username:'@username',path:'@path'}}
                     }

                    );
}]);
