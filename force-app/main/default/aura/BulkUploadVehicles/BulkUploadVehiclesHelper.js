({
    showToast : function(component, event, message, title, msgType) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": msgType,
            "duration":10000
        });
        toastEvent.fire();
    },
    
    destroyComponent : function(component, event){
        $A.util.removeClass(component.find("modalDiv"), "slds-fade-in-open");
        $A.util.removeClass(component.find("backdrop"),  "slds-backdrop--open");
    },
    
    fireErrorEvent : function(component, event){
        var errorEvent = component.getEvent('createFleetEntity');
        errorEvent.setParams({
            "fleetRecordType": 'Vehicle',
            "status": "Error"
        });
        console.log('Firing Error Event for Create Fleet Entity');
        errorEvent.fire();
    },
    
    fireSuccessEvent : function(component, event){
        var successEvent = component.getEvent('createFleetEntity');
        successEvent.setParams({
            "fleetRecordType": 'Vehicle',
            "status": "Success"
        });
        console.log('Firing create Fleet Entity Success Event');
        successEvent.fire();
    },
    
    callServerSideAction : function(component, event, fileContent){
        event.getSource().set("v.disabled",true);
        var action = component.get("c.addVehiclesFromCSV");
        
        action.setParams({
            "fileContent" : fileContent
        });
        
        action.setCallback(this, function(response){
            console.log('Inside setCallback');
            var  status = response.getState();
            this.hideSpinner(component,event);
            if(status === 'SUCCESS'){
                //console.log(response);
                component.set("{!v.successUploads}",response.getReturnValue());
                component.set("{!v.isSuccess}",true);
                console.log(response.getReturnValue());
                if(response.getReturnValue() > 0){
                    var message = response.getReturnValue()+' '+$A.get("$Label.c.SUCCESSMSG_VEHICLE_INSERTED");
                    this.showToast(component,
                                   event,
                                   message, 
                                   $A.get("$Label.c.SUCCESS_MESSAGE"), 
                                   $A.get("$Label.c.SUCCESS_MESSAGE_TOAST"));
                    
                    this.fireSuccessEvent(component,event);
                    this.destroyComponent(component, event);
                }else{
                    event.getSource().set("v.disabled",false);
                    this.fireErrorEvent(component, event);
                    this.showToast(component, 
                                   event, 
                                   $A.get("$Label.c.ERRMSG_NO_RECORDS_UPLOADED"),
                                   $A.get("$Label.c.ERROR_MESSAGE"), 
                                   $A.get("$Label.c.ERROR_MESSAGE_TOAST"));
                }
            }else{
                event.getSource().set("v.disabled",false);
                this.fireErrorEvent(component, event);
            }
        });
        
        
        $A.enqueueAction(action); 
        
    },
    showSpinner : function(component, event){
        var spinner = component.find("spinner");
        $A.util.addClass(spinner, "slds-show");
        $A.util.removeClass(spinner, "slds-hide");
    },   
    hideSpinner : function(component, event){
        var spinner = component.find("spinner");
        $A.util.addClass(spinner, "slds-hide");
        $A.util.removeClass(spinner, "slds-show");
    },
})