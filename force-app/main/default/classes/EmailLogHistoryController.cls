/* 
Created Date : 18 Oct 2019
Created By : Venkatesh Kumar Sakthivel
Requirement : P2PSUPPORT-249 : Email Audit Log - available under 'Account' and in chronological order
Referred By : EmailLogHistory.cmp
Test Class : EmailLogHistoryControllerTest 

*/

global with sharing class EmailLogHistoryController {
    
    @AuraEnabled
    global static List<EmailMessage> getEmailMessages(String RecId){
        
        system.debug('>>>>>>>>>>Id>>>'+ RecId);
        String ObjectName='';
        List <ID> relatedToIDs = new List <ID>();
        List<String> myFilter = new List<String>();  
        
        if(RecId.startsWith('001')){
            
            ObjectName='RelatedToId';
            relatedToIDs.add(RecId);
            for(case cas : [select ID from case where accountID = :RecId ]){
                relatedToIDs.add(cas.ID); 
            }
            for(Contact con : [select ID from contact where accountID = :RecId ]){
                relatedToIDs.add(con.ID); 
            }
            for(Authorisation__c auth : [select ID from Authorisation__c where Service_Provider__c = :RecId ]){
                relatedToIDs.add(auth.ID); 
            } 
            for(Assessment__c assmt : [select ID from Assessment__c where Account__c = :RecId ]){
                relatedToIDs.add(assmt.ID); 
            } 
            myFilter.add('RelatedToId IN: relatedToIDs');
        }
        
        System.debug('@@@@@relatedToIDs@@'+relatedToIDs);
        System.debug('@@@@@relatedToIDs@@'+relatedToIDs.Size());
        System.debug('@@@@@Obejct NAme@@'+ObjectName);
        System.debug('@@@@@REcord Id@@'+RecId);
        
        String  queryString='SELECT Id,CreatedDate ,Subject,Status,TextBody,Incoming,HtmlBody,Headers,FromName,ToAddress ,FromAddress,MessageDate,RelatedToId FROM EmailMessage';
        
        if(myFilter.size()>0){
            queryString += ' WHERE ' + myFilter[0];
        }
        else {
            string ss = 'No Emails';
        }
        
        queryString += ' ORDER BY createddate desc LIMIT 49000'; 
        system.debug('Structured Query>>>'+queryString);
        List<EmailMessage> allEmailMessages= database.query(queryString);
        system.debug('>>>>>>>>>>All Records>>>'+allEmailMessages);
        return allEmailMessages;
        
    }
   
}