public class MCCampaign {
    
        
  	@AuraEnabled
	public static Map<Id, Contact> getcontactemail(String email){

    Map<Id, Contact> contactemail =  new Map<Id, Contact> ([SELECT Id,Email
                                      FROM Contact
                                     Where Email =:email]);

		return contactemail;
}     
    
       
  	@AuraEnabled
	public static List<MC4SF__MC_Subscriber_Activity__c> getMCCampaign(){

     List<MC4SF__MC_Subscriber_Activity__c> mccamp =  [SELECT Id,First_Name__c,Last_Name__c,MC4SF__MC_Campaign__r.Name,
                                                       MC4SF__MC_Campaign__r.MC4SF__Archive_URL__c,MC4SF__MC_Subscriber__r.MC4SF__Email2__c
                                                       FROM MC4SF__MC_Subscriber_Activity__c limit 10];

		return mccamp;
}     
       
}