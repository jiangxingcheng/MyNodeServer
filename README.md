# MyNodeServer
## CS333 Final Project
### Installing
Create a database in Postgres called "mynodeserver" and then run the following command (in Postgres) as a database superuser
```javascript
CREATE EXTENSION pgcrypto;
```

To run the project run the following commands in both MyNodeServerBackend and MyNodeServerFrontend
```javascript
npm install
```
First make sure that you have bower and nodemon installed,
```javascript
npm install -g bower nodemon
```

Then install all the bower dependencies from bower.json in MyNodeServerFrontend
```javascript
bower install
```
Then create a connection string in MyNodeServerBackend/dbinfo.js that is of the following format

```javascript
module.exports = {
    'database' :'postgres://DBUSERNAME:DBPASSWORD@localhost:5432/MyNodeServer' 
}

```
### Running

Then run
```javascript
npm start
```
in each and connect to the frontend at localhost:9000
