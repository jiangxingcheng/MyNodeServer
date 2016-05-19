var express = require('express'); sqlquery = require('../sqlquery.js');
var router = express.Router(),
    bodyParser = require('body-parser'), // parses info from post
    methodOverride = require('method-override'); // used to manipulate post data
router.use(bodyParser.urlencoded({extended: true}));
router.use(methodOverride(function(req, res){
    if(req.body && typeof req.body == 'object' && '_method' in req.body){
        // look in urlencoded POST bodies and delete it
        var method = req.body._method;
        delete req.body._method;
        return method;
    }
}));

router.param('username',function(req,res,next,id){
    console.log('Validate parameter username');
    console.log(id);
    sqlquery.findUserByUsername(id,function(err,data){
        if(err || data === []){
            console.log('Username not validated');
            res.status(404);
            err = new Error('Not Found');
            err.status = 404;
            res.format({
                // html: function(){
                //     next(err);
                // },
                json: function(){
                    res.json({message: err.status + ' ' + err});
                }
            });
        }else{//once validated save the id as the req id.
            console.log('Username validated');
            console.log(data);
            req.id = id;
            next();
        }
    });
});
router.route('/')
    .post(function(req,res){
        var username = req.body.username;
        var password = req.body.password;
        sqlquery.checkIfAuthenticated(username,password,function(err,loginStatus){
            if(loginStatus ==  "user"){
                res.status(200).send("U");
            }else if(loginStatus ==  "mod"){
                res.status(200).send("M");
            }else if(loginStatus ==  "admin"){
                res.status(200).send("A");
            }else{
                res.status(603).send();//invalid login
            }
        });
        });

// router.route('/:username/:password')
//     .get(function(req,res){
//         //console.log('req from the route is');
//         //console.log(req);
//         sqlquery.checkIfAuthenticated(req.params['username'],req.params['password'],function(err,loginIsSucessful){
//             if(loginIsSucessful){
//                 res.status(200).send();
//             }else{
//                 res.status(603).send();//invalid login
//             }
//         });

//     });
/* GET list of users . */

/* GET users listing. */
/* Respond with HTML
router.get('/', function(req, res, next) {
  res.send('respond with a resource');
});
*/

module.exports = router;
