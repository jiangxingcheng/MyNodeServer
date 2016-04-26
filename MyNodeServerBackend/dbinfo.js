var massive = require("massive");
var connectionString = "postgres://server:change@localhost:5432/mynodeserver";
var massiveInstance = massive.connectSync({connectionString : connectionString});
exports.dbInstance = massiveInstance;
