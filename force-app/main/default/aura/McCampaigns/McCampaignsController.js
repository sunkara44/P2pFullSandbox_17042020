({
	getMyObjects : function(component, event, helper) {
        
 var action = component.get("c.getMCCampaign");
  
  action.setCallback(this, function(response){
  var state = response.getState();
  if (state === "SUCCESS") {
     component.set("v.MCActivity", response.getReturnValue());
   }
      else{
          
          console.log("Error");
      }
 });
 $A.enqueueAction(action);
		
	}
})