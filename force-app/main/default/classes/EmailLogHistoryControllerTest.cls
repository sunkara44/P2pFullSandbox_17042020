@isTest
public class EmailLogHistoryControllerTest {
    
    @testSetup 
    static void createASPUserAndAccount(){
        Id ownerid = GlobalUtility.getOwnerId();
        Account ac = new Account(name ='testAcc', BillingStreet='Castlereagh Street', BillingCity='Sydney', BillingState='NSW', BillingPostalCode='2000',OwnerId=ownerid) ;
        insert ac;
        // Insert Contact
        Contact con = new Contact(LastName ='testCon',AccountId = ac.Id, Email='test@contest.com');
        insert con;
        // Insert Case
        Id rtIdforSPA = Schema.SObjectType.Case.getRecordTypeInfosByName().get(GlobalConstants.SERVICE_PROVIDER_ADMINISTRATION_CASE_RECORD_TYPE_NAME).getRecordTypeId();
        Case c1 = new Case(Family_name__c = 'Family Name 1',Birthdate__c= Date.parse('01/01/1985'),Contact_Type__c = 'Nominated Director/Manager',
                           Email__c='Test@test.com',First_given_name__c='First Name 1',Residential_Address_City__c='Test City',
                           Residential_Address_Country__c='Test Country',Residential_Address_State__c='Test state',Residential_Address_Street__c='Test street',
                           Residential_Address_Postal_Code__c='4554',Access_Level__c ='DVD User',AccountId = ac.Id, Service_Type__c = 'Taxi', Status = GlobalConstants.CASE_STATUS_REVIEW_PENDING,
                           Sub_Status__c = GlobalConstants.CASE_SUB_STATUS_DECISION_PENDING, Type = GlobalConstants.CASE_SERVICE_PROVIDER_TYPE,
                           Sub_Type__c = GlobalConstants.CASE_SUB_TYPE_MAINTAIN_AUTHORISATION,RecordTypeId = rtIdforSPA);
        
        insert c1;
        // Insert Authorisation
        Authorisation__c taxiAuth = new Authorisation__c(Service_Provider__c = ac.Id,Licence_Class__c = 'TX08',Licence_Type__c='Annual', Licence_Fee__c = 100, 
                                                         Contact__c = con.Id, Status__c = 'Suspended', Authorisation_Type__c = GlobalConstants.AUTHORISATION_TYPE_TAXI_LICENCE  );
        
        insert taxiAuth;
        taxiAuth.Start_Date__c = Date.parse('10/12/2017');
        taxiAuth.End_Date__c = Date.parse('10/1/2018');
        update taxiAuth ;  
        taxiAuth.Application__c =c1.Id;
        update taxiAuth;

         // Insert Assesment

          /* Account with Company RecordType */
        Id rtIdForCorporation = Schema.SObjectType.Account.getRecordTypeInfosByName().get(GlobalConstants.ACCOUNT_RECORDTYPE_DEV_NAME_CORPORATION).getRecordTypeId();
        Account ac1 = new Account(ACN__c = '1234567898',ABN__c = '123456789', Name = 'testAcc',  Notice_Email__c = 's@r.com', Notice_Address_City__c = 'Sydney',
                                 Notice_Address_Postal_Code__c = '1234', Notice_Address_Country__c ='Australia', Notice_Address_State__c = 'NSW',
                                 Notice_Address_Street__c = 'castle', BillingCity = 'Sydney', BillingState = 'NSW', BillingCountry = 'Australia', BillingStreet = 'Castlereagh',
                                 BillingPostalCode='1234',ShippingCity = 'Sydney', ShippingState = 'NSW', ShippingCountry = 'Australia', ShippingStreet = 'Castlereagh',
                                 ShippingPostalCode = '1234', Registered_Business_Name__c ='Sample Business Name',RecordTypeId = rtIdForCorporation);
        insert ac1;
        
        /* Contact Related to company account */
        Contact con1 = new Contact(Title='Mr.',LastName ='testCon', AccountId = ac1.Id,Birthdate = Date.parse('01/01/1992'), Email='test@contest.com',FirstName = 'Name',Phone='11111111111');
        insert con1;


          /* Authorisation__c Related to company account */
        Authorisation__c tspauth = new Authorisation__c(Service_Provider__c = ac1.Id,Licence_Class__c = 'TX-08',Licence_Type__c='Annual',Licence_Fee__c = 100, 
                                                        Contact__c = con1.Id,Status__c = GlobalConstants.GRANTED_UNCONDITIONALLY, Authorisation_Type__c = 'TSP');
        insert tspauth;
        
        tspauth.Start_Date__c = Date.parse('10/12/2017');
        update tspauth;  
        
        /* Authorisation__c Related to Individual account */
        Authorisation__c bspauth = new Authorisation__c(Service_Provider__c = ac1.Id,Licence_Class__c = 'TX-08',Licence_Type__c='Annual',Licence_Fee__c = 100, 
                                                        Contact__c = con1.Id,Status__c = GlobalConstants.GRANTED_UNCONDITIONALLY, Authorisation_Type__c = 'BSP');
        insert bspauth;
        
        bspauth.Start_Date__c = Date.parse('2/2/2018');
        update bspauth;  
        
        /* Lookup to TSP and BSP both */
        Tax_Payer_Registration__c taxpayerRegistrationRecord = new Tax_Payer_Registration__c(Service_Provider_Name__c = ac1.Id,Levy_Contact__c = con1.Id,ABN__c='123456789',Sub_Status__c = GlobalConstants.SUB_STATUS_COMPLETED,
                                                                                             Status__c = GlobalConstants.STATUS_ACTIVE,Revenue_NSW_Status__c = GlobalConstants.REVENUE_NSW_STATUS_SUCCESS,
                                                                                             Taxi_Service_Provider_Number__c = tspauth.Id, Booking_Service_Provider_Number__c = bspAuth.Id,
                                                                                             BSB__c = '012-003', Bank_Account_Number__c = '122222222', Bank_Account_Holder_s_Name__c = 'Sample',
                                                                                             Levy_Notification_Address_City__c='Sydney', Levy_Notification_Address_Country__c ='Australia',
                                                                                             Levy_Notification_Address_Postal_Code__c ='1234', Levy_Notification_Address_State__c ='NSW',
                                                                                             Levy_Notification_Address_Street__c = 'castle');
        insert taxpayerRegistrationRecord;
        
        Date firstDateOfPreviousMonth = Date.newInstance(2018, 01, 01);
        Date lastDateOfPreviousMonth = Date.newInstance(2018, 01, 31);
        
        Assessment__c assessmentRecord = new Assessment__c();
        assessmentRecord.Account__c = taxpayerRegistrationRecord.Service_Provider_Name__c;
        assessmentRecord.Taxpayer_Registration__c = taxpayerRegistrationRecord.Id;
        assessmentRecord.Status__c = 'Open';
        assessmentRecord.Assessment_Type__c = 'Assessment';
        assessmentRecord.Period_End_Date__c = lastDateOfPreviousMonth;
        assessmentRecord.Levy__c = Decimal.valueOf(System.Label.Levy_Amount_Per_Trip);
        insert assessmentRecord;

        // Email Message for Case
        EmailMessage emailCase = new EmailMessage();
        emailCase.FromAddress = '1234ab@abc.org';
        emailCase.Incoming = True;
        emailCase.ToAddress= 'test@xyz.org';
        emailCase.Subject = 'Test email';
        emailCase.HtmlBody = 'Test email body';
        emailCase.RelatedToId= c1.Id;
        
        insert emailCase;

        // Email Message for Account
        EmailMessage emailAccount = new EmailMessage();
        emailAccount.FromAddress = '5678ab@abc.org';
        emailAccount.Incoming = True;
        emailAccount.ToAddress= 'test@xyz.org';
        emailAccount.Subject = 'Test email';
        emailAccount.HtmlBody = 'Test email body';
        emailAccount.RelatedToId= ac.Id;
     
        insert emailAccount;

        /*
        // Email Message for Contact
        EmailMessage emailContact = new EmailMessage();
        emailContact.FromAddress = 'test@abc.org';
        emailContact.Incoming = True;
        emailContact.ToAddress= 'test@xyz.org';
        emailContact.Subject = 'Test email';
        emailContact.HtmlBody = 'Test email body';
        emailContact.RelatedToId= con.Id; 
       
        insert emailContact;
        */

        // Email Message for Authorisation
        EmailMessage emailAuthorisation = new EmailMessage();
        emailAuthorisation.FromAddress = '1011ab@abc.org';
        emailAuthorisation.Incoming = True;
        emailAuthorisation.ToAddress= 'test@xyz.org';
        emailAuthorisation.Subject = 'Test email';
        emailAuthorisation.HtmlBody = 'Test email body';
        emailAuthorisation.RelatedToId= taxiAuth.Id;
        
        insert emailAuthorisation;

    }
        
    
   
    //This method vefies all the data is cottectly stored or not in backend
    @isTest
    public static void testgetEmailMessages(){
        Id accountId = [select id from Account where name = 'testAcc' LIMIT 1].id; 
        Id conId = [select id from contact where AccountId =:accountId LIMIT 1].id;
        Id p = [select id from profile where name='Authorised Service Provider'].id;
        Case cas = [SELECT Id FROM Case];
        Authorisation__c Auth = [SELECT Id FROM Authorisation__c where Service_Provider__c =: accountId];
        Assessment__c Assmt = [SELECT Id FROM Assessment__c limit 1];

        List<ID> lstAllID = new List<ID> {accountId,conId,(id)cas.ID,(id)Auth.ID};
        List<EmailMessage> getListEmailMessage = [SELECT Id FROM EmailMessage where relatedtoID IN : lstAllID];

        System.debug('getListEmailMessage'+getListEmailMessage.size());

        List<EmailMessage> lstEmailMessage = new List<EmailMessage>();
        
        User user = new User(alias = 'test123', email='test123@noemail.com',
                             emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                             localesidkey='en_US', profileid = p, country='United States', IsActive =true,
                             contactId = conId,
                             timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
        
        insert user;
        Account acc = [SELECT Id, BillingStreet, BillingCity, BillingState, BillingPostalCode FROM Account WHERE name = 'testAcc' LIMIT 1];
        
        test.startTest();
      system.runAs(user){
        lstEmailMessage = EmailLogHistoryController.getEmailMessages(accountId);
        }
        
        test.stopTest();
        System.debug('outside test');
        System.debug(lstEmailMessage.size());
        
        // Sharing SETTING in place, equating to one Email message
        System.assertEquals(lstEmailMessage.size(),1);
    }

}