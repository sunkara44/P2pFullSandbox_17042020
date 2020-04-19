({
    doInit : function(component, event, helper) {
        var currentRec = component.get("v.recordId");
        console.log('>>>>>>'+currentRec);
        helper.getEmailMessages(component,event,currentRec);		
    },
    

 	 navigateToRecord : function(component, event, helper) {
        console.log( 'naviteToCaseRecord' );

    var recordId = event.target.dataset.caseid;
console.log( recordId );

    var event = $A.get( 'e.force:navigateToSObject' );

    if ( event ) {


        event.setParams({
            'recordId' : recordId
        }).fire();

    }
    },
    getID: function(component, event, helper) {
        var Ide = event.srcElement.id;
        console.log(Ide);
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": Ide
        });
        navEvt.fire();
        }
   
    

})