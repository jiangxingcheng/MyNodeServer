app.filter('unglueArray', function()
{
    return function(input)
    {
        var in2 = [].concat(input);
        var out = ''; 
        var glueStuff = function(element, index, array){
            out = out + " " + element;
        };
        in2.forEach(glueStuff);
        return out;
    };
});
app.filter('workStudyFilter',function(){
   return function(input) {
       if(input){
           return 'This student is workstudy';
       }else{
           return 'This student is not workstudy';
       }
   };
});
app.filter('appliedFilter',function(){
    return function(AppliedCourses) {
        var trueStatement = "This student has applied";
        var falseStatement = 'This student has not applied';
        if(AppliedCourses.length == 0){
            return falseStatement;
        }else{
            for(var i = 0; i < AppliedCourses.length ; i++) {
                var courseApplied = AppliedCourses[i];
                if(courseApplied.Accepted){
                    return trueStatement;
                };
            };
            return falseStatement;
        }
        
    };
});
app.filter('studentDataFilter',function(){
    return function(student) {
        return student.taStudent.Name;
    };
});

//provides a filter for major
app.filter('majorFilter',function(){
   return function(input) {
       if(input === ["",""]){
         return "";
     }else if(input.length == 0){
         return "";
     }else{
         input = input[0];
     }
     if(input == "ME"){
         return "Mechanical Engineering";
     }else if(input == "EE"){
         return "Electrical Engineering";
     }else if(input == "CPE"){
         return "Computer Engineering";
     }else if(input == "MA"){
         return "Mathematics";
     }else if(input == "CHE"){
         return "Chemical Engineer";
     }else if(input == "CS"){
         return "Computer Science";
     }else if(input == "SE"){
         return "Software Engineering";
     }else if(input == "BE"){
         return "Bio Engineer";
     }else if(input == "EP"){
         return "Engineering Physics";
     }else if(input == "CE"){
         return "Civil Engineer";
     }else if(input == "OE"){
         return "Optical Engineer";
     }else if(input == "PH"){
         return "Physics";
     }else if(majorFilter == "ICS"){
         return "International Computer Science";
     }else{
         return "";
     }
   };
});
