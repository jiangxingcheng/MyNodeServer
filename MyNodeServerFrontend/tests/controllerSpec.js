describe('Unit: Overall',function(){
    beforeEach(module('mynodeserver'));
    var ctrl,scope;
    beforeEach(inject(function($controller, $rootScope){
        scope = $rootScope.$new();

    }));
    describe('It should not fail',function(){
        it('should not fail',function(){
        });
    });
});
