app.filter('formatDate', function()
{
    return function(datestring)
    {
        var dateObject = new Date(datestring);
        return dateObject.toString();
    };
});

app.filter('pathArrayToString', function(){
    return function(arr)
    {
        var path = '/';
        for(var i=0; i<arr.length; i++){
            path = path + arr[i] + '/';
        }
        return path;
    };
});
