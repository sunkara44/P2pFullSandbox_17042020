({
    validatePhoneNumber : function(component, event, onSave) {
        var phone = component.get("v.phoneNumber");
        var isInitComplete = component.get('v.isInitComplete');
        var numberExpression = /^[0-1][0-9]{0,9}$/; 
        
        var isMobile = component.get('v.isMobile');
        if(phone && isMobile == true && phone.length > 1){
        	numberExpression = /^[0][4][0-9]{0,8}$/;     
        }
        if(onSave == true && isMobile == false){
            numberExpression = /^[0-1][0-9]{0,9}$/; 
        } else if(onSave == true && isMobile == true){
            numberExpression = /^[0][4][0-9]{8}$/; 
        }
        if(phone && !phone.match(numberExpression) && isInitComplete){            
            console.log('Invalid phone number');
            //component.set("v.phoneNumber", "");
            component.set('v.isValid', false);
            this.displayErrorMessage(component, event, $A.get("$Label.c.Phone_Number_Error_Msg"));
        }
        else
            this.resetErrorMessage(component, event);
    },
    resetErrorMessage : function(component, event){
        var identifier = component.get('v.uniqueIdentifier');
        var contentElem = document.getElementsByClassName(identifier + 'Content')[0];
        var errorElem = document.getElementsByClassName(identifier + 'Error')[0]; 
        
        if(contentElem != undefined)
         contentElem.className = contentElem.className.replace('slds-has-error', '');
        
        if(errorElem != undefined)
         errorElem.innerText = "";
    },
    displayErrorMessage : function(component, event, msg){
        var identifier = component.get('v.uniqueIdentifier');
        var contentElem = document.getElementsByClassName(identifier + 'Content')[0];
        var errorElem = document.getElementsByClassName(identifier + 'Error')[0]; 
        if(contentElem != undefined) contentElem.className += ' slds-has-error';            
        if(errorElem != undefined) errorElem.innerText = msg;
    },
    isPhoneRequired : function(component, event){
        var isRequired = component.get('v.isRequired');
        if(isRequired == true){
            var phone = component.get("v.phoneNumber");
            if(!phone){
                console.log('phone is not provided');
                component.set('v.isValid', false);
                var identifier = component.get('v.uniqueIdentifier');
                var contentElem = document.getElementsByClassName(identifier + 'Content')[0];
                var errorElem = document.getElementsByClassName(identifier + 'Error')[0]; 
                contentElem.className += ' slds-has-error';            
                errorElem.innerText = $A.get("$Label.c.Error_Message_Required_Input");
            }
        }
    }
})