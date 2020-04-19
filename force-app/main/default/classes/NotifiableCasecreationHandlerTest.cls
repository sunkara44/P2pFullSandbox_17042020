@isTest
public class NotifiableCasecreationHandlerTest {
    
    @isTest
    private static void postAuditCaseCreationAutomationTest() {
   
        RecordType caseNotifiableRecordType = [SELECT id, Name FROM RecordType WHERE DeveloperName = 'Notifiable_Occurrence' AND SobjectType = 'Case'];
        
        Test.setMock(HttpCalloutMock.class, new GeocodeAddressCalloutMock());
        Test.startTest();
        Case notifiableCase = new Case();
        notifiableCase.RecordTypeId= caseNotifiableRecordType.Id;
        notifiableCase.A__c=true;
        notifiableCase.City__c ='Epping';
        notifiableCase.State__c='NSW';
        notifiableCase.Postcode__c= '2121';
        insert notifiableCase;
       // NotifiableCaseGeocodeAddress.geocodeAddress(notifiableCase.Id);
        Test.stopTest();
        
       
    }

}