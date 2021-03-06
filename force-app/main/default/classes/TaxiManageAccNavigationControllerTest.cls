@isTest
private class TaxiManageAccNavigationControllerTest {
    @testSetup 
    static void setup(){
        Id rtIdforIndividual = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Partnership').getRecordTypeId();
        Id rtIdforCompany = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
        Id ownerid = GlobalUtility.getOwnerId();
        Account ac = new Account(name ='testAcc',RecordTypeId = rtIdforIndividual, BillingStreet='Castlereagh Street', BillingCity='Sydney', BillingState='NSW', BillingPostalCode='2000',OwnerId=ownerid);
        insert ac;
        Account ac2 = new Account(name ='testAcc2',RecordTypeId = rtIdforCompany, BillingStreet='Castlereagh Street', BillingCity='Sydney', BillingState='NSW', BillingPostalCode='2000',OwnerId=ownerid);
        insert ac2;
        
        Contact con = new Contact(LastName ='testCon',AccountId = ac.Id, Email='test@contest.com');
        insert con;
        Contact con2 = new Contact(LastName ='testCon2',AccountId = ac2.Id, Email='test2@contest.com');
        insert con2; 
    }
    
    @isTest
    private static void validateIsPartnerAccountTrueTest(){
        Id accountId = [select id from Account where name = 'testAcc' LIMIT 1].id; 
        Id conId = [select id from contact where AccountId =:accountId LIMIT 1].id;
        
        Id p = GlobalUtility.getASPProfile().id;
        
        User user = new User(alias = 'test123', email='test123@noemail.com',
                             emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                             localesidkey='en_US', profileid = p, country='United States', IsActive =true,
                             contactId = conId,
                             timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
        
        insert user;
        test.startTest();
        system.runAs(user){
            Boolean b = TaxiManageAccountNavigationController.validateIsPartnerAccount(accountId);
            system.assertEquals(true, b);
        }
        test.stopTest();
    }
    
    @isTest
    private static void validateIsPartnerAccountFalseTest(){
        
        Id accountId = [select id from Account where name = 'testAcc2' LIMIT 1].id; 
        
        Id conId = [select id from contact where AccountId =:accountId LIMIT 1].id;
        
        Id p = GlobalUtility.getASPProfile().id;
        
        User user = new User(alias = 'test123', email='test123@noemail.com',
                             emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                             localesidkey='en_US', profileid = p, country='United States', IsActive =true,
                             contactId = conId,
                             timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
        
        insert user;
        test.startTest();
        system.runAs(user){
            Boolean b = TaxiManageAccountNavigationController.validateIsPartnerAccount(accountId);
            system.assertEquals(false, b);
        }
        test.stopTest();
    }
    
    @isTest
    private static void validateIsPartnerAccountExceptionTest(){
        
        Id p = GlobalUtility.getASPProfile().id;
        Id accountId = [select id from Account where name = 'testAcc2' LIMIT 1].id; 
        
        User user = new User(alias = 'test123', email='test123@noemail.com',
                             emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                             localesidkey='en_US', profileid = p, country='United States', IsActive =true,
                             timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
        
        Boolean b = TaxiManageAccountNavigationController.validateIsPartnerAccount('');
        system.assertEquals(false, b);
    }
    
    @isTest
    private static void validateIfAgentHasAccessTest(){
        
        Id accountId = [select id from Account where name = 'testAcc2' LIMIT 1].id; 
        Boolean b = TaxiManageAccountNavigationController.validateIfAgentHasAccess(accountId);
        system.assertEquals(false, b);
    }
}