# MyNodeServer
## CS333 Final Project
### Installing
To run the project run the following commands in both MyNodeServerBackend and MyNodeServerFrontend
```javascript
npm install
```
First make sure that you have bower installed,
```javascript
npm install -g bower
```

Then install all the bower dependencies from bower.json in MyNodeserverBackend
```javascript
bower install
```
Then change the connection string in MyNodeServerBackend/dbinfo.js to be appropriate for your instance of postgres.

### Running

Then run
```javascript
npm start
```
in each and connect to the frontend at localhost:9000
