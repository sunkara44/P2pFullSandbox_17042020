({
    getEmailMessages : function(component,event,currentRec) {
        console.log('###helper record id##'+currentRec);        
        var action = component.get("c.getEmailMessages");
        action.setParams({
            "RecId": currentRec             
        });
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                component.set("v.EmailMsgs", response.getReturnValue());
                
            }  else if (state === "INCOMPLETE") {
                console.log("No response from server or client is offline.")
                var myErrMsg='No response from server or client is offline.';
                
            } else if (state === "ERROR") {                
                console.log("Error: ");
            }
        });
        $A.enqueueAction(action);        
    }
})