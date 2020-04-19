public class NotifiableCaseGeocodeAddress {
    
    // static variable to determine if geocoding has already occurred
    
    private static Boolean geocodingCalled = false;
    // wrapper method to prevent calling future methods from an existing future context
    public static void DoAddressGeocode(id caseId) {
        if(geocodingCalled || System.isFuture()) {
            System.debug(LoggingLevel.WARN,
                         '***Address Geocoding Future Method Already Called - Aborting...');
            return;
        }
        // ifnot being called from future context, geocode the address
        geocodingCalled = true;
       
//        geocodeAddress(caseId);
       
    }
    
    // we need a future method to call Google Geocoding API from Salesforce
    @future (callout=true)
    static public void geocodeAddress(id caseId)
    { 
        // Key for Google Maps Geocoding API:  AIzaSyBJkgEAaLXfcCuEQLE_sLXjqVXkGlkpUAk
        String geocodingKey = system.label.GeoCodeAPIKey;
        // get the passed in address 
        Case NotifiableCase = [SELECT Street_Address_Line_1__c,City__c,State__c,Postcode__c FROM Case WHERE id = :caseId];
        
        //check that we have enough information to geocode the address
        //if((NotifiableCase.Street_Address_Line_1__c == null) || (NotifiableCase.Street_Address_Line_1__c == null)) {
        // System.debug(LoggingLevel.WARN,
        //'Insufficient Data to Geocode Address');
        //  return;
        // }
        //create a string for the address to pass to Google Geocoding API
        String geoAddress = '';
        if(NotifiableCase.Street_Address_Line_1__c != null)
            geoAddress+= NotifiableCase.Street_Address_Line_1__c + ', ';
        if(NotifiableCase.City__c != null)
            geoAddress+= NotifiableCase.City__c + ', ';
        if(NotifiableCase.State__c != null)
            geoAddress+= NotifiableCase.State__c + ', ';
        //if(geoAccount.BillingCountry != null)
        // geoAddress+= geoAccount.BillingCountry + ', ';
        if(NotifiableCase.Postcode__c != null)
            geoAddress+= NotifiableCase.Postcode__c;
        
        //encode the string so we can pass it as part of URL 
        geoAddress= EncodingUtil.urlEncode(geoAddress, 'UTF-8');
        //build and make the callout to the Geocoding API
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://maps.googleapis.com/maps/api/geocode/json?address='+geoAddress + '&key=' + geocodingKey+ '&sensor=false');
        request.setMethod('GET');
        request.setTimeout(60000);
        try {
            //make the http callout
         
            HttpResponse response = http.send(request);
            
            //parse JSON to extract co-ordinates
            JSONParser responseParser = JSON.createParser(response.getBody());
            system.debug(response.getBody());
            //initialize co-ordinates
            String latitude = '';
            String longitude = '';
            while(responseParser.nextToken() != null) {
                if((responseParser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                   (responseParser.getText()== 'location')) {
                       responseParser.nextToken();
                       while(responseParser.nextToken() != JSONToken.END_OBJECT) {
                           String locationText = responseParser.getText();
                           responseParser.nextToken();
                           if (locationText == 'lat'){
                               latitude = responseParser.getText();
                               system.debug(latitude);
                           }
                           else if (locationText == 'lng')
                               longitude = responseParser.getText();
                           system.debug(longitude);
                       }
                   }
            }
            //update co-ordinates on address if we get them back
            if(latitude!= null) {
                //Notifiable__Latitude__s
                NotifiableCase.Notifiable__Latitude__s= decimal.valueof(latitude);
                NotifiableCase.Notifiable__Longitude__s= decimal.valueof(longitude);
                update NotifiableCase;
            }
        } catch
            (Exception e) {
                System.debug(LoggingLevel.ERROR,
                             'Error Geocoding Address - ' + e.getMessage());
            }
    }   
    
}