({
    loadSectionData : function(component, event){
        
        this.showSpinner(component, event);
        var caseid = component.get("v.caseId");
        var action = component.get("c.getSectionData");
        action.setParams({
            "caseId": caseid
        });
        
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var sectionData = JSON.parse(response.getReturnValue());
                component.set('v.aspCase', sectionData);
                
                if(sectionData["Is_Privacy_Statement_Declared__c"])
                    component.set('v.isPrivecyStatementAccepted', true);
                
                if(sectionData["Is_Privacy_Statement_Declared__c"] == false)
                    component.set('v.isPrivecyStatementAccepted', false);
                
                if(sectionData["Information_Declaration__c"])
                    component.set('v.isInformationDeclared', true);
                
                if(sectionData["Information_Declaration__c"] == false)
                    component.set('v.isInformationDeclared', false);
                
                if(sectionData["Authorise_On_Behalf_Of_Partnership__c"])
                    component.set('v.authoriseOnBehalf', true);
                
                if(sectionData["Authorise_On_Behalf_Of_Partnership__c"] == false)
                    component.set('v.authoriseOnBehalf', false);
            }
            else{
                
            }
        });
        if(caseid != "")
            $A.enqueueAction(action);
        
        this.hideSpinner(component, event); 
    },
    savePrivacyStatement : function(component, event, finishLater, reviewSave){
        
        this.showSpinner(component, event);
        
        var sectionData = component.get('v.aspCase');
        
        sectionData["Id"] = component.get('v.caseId');
        sectionData["Is_Privacy_Statement_Declared__c"] = component.get('v.isPrivecyStatementAccepted');
        sectionData["Information_Declaration__c"] = component.get('v.isInformationDeclared');
        sectionData["Authorise_On_Behalf_Of_Partnership__c"] = component.get('v.authoriseOnBehalf');
        
        var action = component.get("c.saveSectionData");
        action.setParams({
            "caseData": JSON.stringify(sectionData)
        });
        
        action.setCallback(this,function(response){
            
            var state = response.getState();
            if(state === "SUCCESS"){
                
                this.hideSpinner(component, event); 
                
                var returnedEntityType = response.getReturnValue();
                
                console.log('Entity Type: '+returnedEntityType);
                
                var result = returnedEntityType.split("-");
                
                if(finishLater == false && reviewSave == false) {
                    
                    component.set("v.entityType", result[0]);
                    var nextSectionEvent = component.getEvent("loadSection");
                    nextSectionEvent.setParams({"sectionName": "review", "caseId" : component.get('v.caseId'), "entityType" : result[0]});
                    nextSectionEvent.fire();
                }
                
                if(reviewSave) {
                    
                    component.set("v.readOnly", true);
                    component.set("v.reviewEdit", false);
                }
                
                if(finishLater) {
                    
                    var toastEvent = $A.get("e.force:showToast");           	
                    toastEvent.setParams({
                        "title": "Success",
                        "message": "Application saved successfully.",
                        "type": "success",
                        "duration":10000,
                        "mode": "sticky" 
                    });
                    toastEvent.fire();
                    
                    if(component.get("v.accountId") != undefined && component.get("v.accountId") != "") {
                        
                        component.getEvent("closeApplication").fire();
                    }else {
                        
                        window.setTimeout(function() { 
                            
                            window.location = "/industryportal/s/secure-portal-home?src=homeMenuPSP";
                        }, 3000);
                    }
                    
                }
            }
            else {
                this.hideSpinner(component, event); 
            }
        });
        
        $A.enqueueAction(action);
    },
    performBlankInputCheck : function(component, event){
        
        var hasRequiredInputsMissing = false;
        
        this.resetErrorMessages(component, event);
        
        if(this.validateBlankRadioInputs(component, event, "privacyDeclaredError", "isInformationDeclared", $A.get("$Label.c.Privacy_Declaration_Error_Message")))
            hasRequiredInputsMissing = true;
        
        if(this.validateBlankRadioInputs(component, event, "privacyAcceptedError", "isPrivecyStatementAccepted", $A.get("$Label.c.Privacy_Statement_Error_Message")))
            hasRequiredInputsMissing = true;
        
        if(component.get('v.entityType') == 'Company Partner'
           || component.get('v.entityType') == 'Individual Partner') {
            
         if(this.validateBlankRadioInputs(component, event, "isAuthorisedonBehalfError", "authoriseOnBehalf", $A.get("$Label.c.Privacy_Onbehalf_Of_Error")))
            hasRequiredInputsMissing = true;
        }
        
        return hasRequiredInputsMissing;
    },
    validateBlankInputs : function(component, event, inputId, attributeName) {
        
        var inputValue = component.get('v.'+attributeName);
        console.log('Got Input Value: '+inputValue);
        if(inputValue == undefined || inputValue === "" || inputValue === null) {
            
            component.find(""+inputId).set("v.errors", [{message: $A.get("$Label.c.Error_Message_Required_Input")}]);
            return true;
        }
        else {
            
            component.find(""+inputId).set("v.errors", null);
        }
        
        return false;
    },
    validateBlankRadioInputs : function(component, event, inputId, attributeName, msg){
        
        var inputValue = component.get('v.'+attributeName);
        if(inputValue == undefined || inputValue == false){
            
            document.getElementById(inputId).innerHTML = msg;
            document.getElementById(inputId).style.display = 'block';
            return true;
        }
        else if(inputValue == true){
            
            document.getElementById(inputId).innerHTML = '';
            document.getElementById(inputId).style.display = 'none';
        }
        return false;
    },
    resetErrorMessages : function(component, event) {
        
        document.getElementById("privacyDeclaredError").innerHTML = '';
        document.getElementById("privacyAcceptedError").innerHTML = '';
        
        if(component.get('v.entityType') == 'Company Partner'
           || component.get('v.entityType') == 'Individual Partner')
            document.getElementById("isAuthorisedonBehalfError").innerHTML = '';
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
    }
})