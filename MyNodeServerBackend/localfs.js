
var http = require("http");
 
var fs = require("fs");
var url = require("url");

exports.writeFile = function(url,text){
	fs.writeFile("test.txt", text, function(err) {
  if (err)
    console.log("Failed to write file:", err);
  else
    console.log("File written.");
	});
}

exports.writeFile('','test text');


 exports.readFile = function(url,text){
 	fs.readFile("test.txt", function(err, buffer) {
  if (err)
    throw err;
  console.log("The file contained", buffer.length, "bytes.",
              "The first byte is:", buffer[0]);
	});
 }
		
