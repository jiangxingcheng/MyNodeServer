var massive = require("massive");
var connectionString = "postgres://dbusername:dbpassword@ipaddress:port/dbname";
var massiveInstance = massive.connectSync({connectionString : connectionString});
exports.dbInstance = massiveInstance;
