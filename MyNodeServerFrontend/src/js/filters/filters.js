app.filter('formatDate', function()
{
    return function(datestring)
    {
        var dateObject = new Date(datestring);
        return dateObject.toString();
    };
});
