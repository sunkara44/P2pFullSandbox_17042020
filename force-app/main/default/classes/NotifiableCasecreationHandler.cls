public class NotifiableCasecreationHandler {
    private Map<Id, Case> newCases;
    // private Map<Id, Case> oldCases;
    public NotifiableCasecreationHandler(Map<Id, Case> newCases){
        
        this.newCases = newCases;
        // this.oldCases = oldCases;
    }
    public void  PostNotifiableCasecreationAutomation() {  
        for(Case c : newCases.values()) {
            
            //check if Billing Address has been updated
            Boolean addressChangedFlag = false;
            if(Trigger.OldMap!=null) {
                Case oldCase = (Case)Trigger.OldMap.get(c.id);
                //case oldCase = oldCases.get(c.Id);
                if((c.Street_Address_Line_1__c != oldCase.Street_Address_Line_1__c) || (c.City__c!= oldCase.City__c) || (c.State__c!= oldCase.State__c) ||(c.Postcode__c!= oldCase.Postcode__c)) {
                    
                    addressChangedFlag = true;
                    
                    System.debug(LoggingLevel.DEBUG, '***Address changed for - ' +
                                 oldCase.Id);
                }
                // if address is null or has been changed, geocode it
                if((c.Notifiable__Latitude__s == null) || (addressChangedFlag == true)) {
                    System.debug(LoggingLevel.DEBUG,
                                 '***Geocoding Account - ' + c.Id);
                    NotifiableCaseGeocodeAddress.DoAddressGeocode(c.id);
                }
            }
            // NotifiableCaseGeocodeAddress.DoAddressGeocode(c.id);
        }
    } 
    public void  PostNotifiableCasecreationAutomation2() {  
        for(Case c : newCases.values()) {
         
            // if address is null or has been changed, geocode it
            if((c.Notifiable__Latitude__s == null)) {
                System.debug(LoggingLevel.DEBUG,
                             '***Geocoding Account - ' + c.Id);
                NotifiableCaseGeocodeAddress.DoAddressGeocode(c.id);
            }
        }
        // NotifiableCaseGeocodeAddress.DoAddressGeocode(c.id);
    }
}