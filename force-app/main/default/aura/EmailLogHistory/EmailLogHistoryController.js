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
        },
    // common reusable function for toggle sections
    toggleSection : function(component, event, helper) {
        // dynamically get aura:id name from 'data-auraId' attribute
        var sectionAuraId = event.target.getAttribute("data-auraId");
        // get section Div element using aura:id
        var sectionDiv = component.find(sectionAuraId).getElement();
        /* The search() method searches for 'slds-is-open' class, and returns the position of the match.
         * This method returns -1 if no match is found.
        */
        var sectionState = sectionDiv.getAttribute('class').search('slds-is-open'); 
        
        console.log(sectionAuraId);
        console.log(sectionDiv)
        console.log(sectionState);
        
        // -1 if 'slds-is-open' class is missing...then set 'slds-is-open' class else set slds-is-close class to element
        if(sectionState == -1){
            sectionDiv.setAttribute('class' , 'slds-section slds-is-open');
        }else{
            sectionDiv.setAttribute('class' , 'slds-section slds-is-close');
        }
    }
    

})