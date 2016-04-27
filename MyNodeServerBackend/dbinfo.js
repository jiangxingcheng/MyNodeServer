var massive = require("massive");
var connectionString = "postgres://nodeserver:change@localhost:5432/mynodeserver";
var massiveInstance = massive.connectSync({connectionString : connectionString});
exports.dbInstance = massiveInstance;
