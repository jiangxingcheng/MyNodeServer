var massive = require("massive");
// Uncomment this and change your information. This will be in the .gitignore
var connectionString = "postgres://person:assword@localhost:5432/mynodeserver";
var massiveInstance = massive.connectSync({connectionString : connectionString});
exports.dbInstance = massiveInstance;
