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

app.factory('Threads', ['$resource', 'EnvConfig', function($resource, EnvConfig) {
    var url = EnvConfig.api.baseUrl + 'threads/';
    var rmurl = url + 'delete/';
    var rmcommenturl = url + 'deletecomment/';
    return $resource(url,{},
                     {
                         //not currently implemented
                         createThread: {method: 'POST', params: {threadtitle: '@threadtitle',username:"@username",category : '@category',textbody : '@textbody'}},
                         deleteThread: {method: 'POST', url:rmurl,params: {threadtitle: '@threadtitle'}},
                         deleteThreadComment: {method: 'POST', url:rmcommenturl,params: {username: '@username',timeofcreation:'@timeofcreation'}}

                     }

                    );
}]);

app.factory('Files', ['$resource', 'EnvConfig', function($resource, EnvConfig) {
    var url = EnvConfig.api.baseUrl + 'files/';
    var filecommenturl = EnvConfig.api.baseUrl + 'files/filecomments/';
    var filecommentdeleteurl = EnvConfig.api.baseUrl + 'files/filecommentsdelete/';
    var filedeleteurl = url + 'filedelete/';
    var mkdirurl = EnvConfig.api.baseUrl + 'files/mkdir/';
    var touchurl = EnvConfig.api.baseUrl + 'files/touch/';
    return $resource(url,{},
                     {
                         ls: {method: "GET",isArray:true ,params: {username:'@username',path:'@path'}},
                         getFileComments: {method: "GET",isArray:true ,url:filecommenturl,params: {path:'@path'}},
                         saveFileComment: {method: "POST", url:filecommenturl, params:{username:'@username',path:'@path',usertext:'@usertext'}},
                         deleteFileComment: {METHOD: "POST",url:filecommentdeleteurl,params:{username:'@username',timeofcreation:'@timeofcreation'}},
                         deleteFile: {METHOD: "POST",url:filedeleteurl,params:{filepath:'@filepath'}},
                         mkdir: {method: "POST", url:mkdirurl, params:{username:'@username',dirpath:'@dirpath'}},
                         touch: {method: "POST", url:touchurl, params:{username:'@username',filepath:'@filepath'}}
                     }

                    );
}]);
