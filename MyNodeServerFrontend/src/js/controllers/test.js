var path = '/home/schafezp/test/';
var indexes = [];
var ind = 0;
for(var i = 0; i<path.length; i++){
    if(path[i] == '/'){
        indexes[ind] = i;
        ind++;
    }
}
var allButLast = function(arr){
    var returnarr = [];
    for(var i=0; i<arr.length; i++){
        if(i != arr.length -1){
            returnarr[i] = arr[i];
        }
    }
    return returnarr;
};
var ps = [1,2,3];
console.log(allButLast(ps));
