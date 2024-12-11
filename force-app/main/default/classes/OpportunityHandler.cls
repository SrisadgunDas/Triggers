public class OpportunityHandler {
    //Add a filed Multi select Pick list on Account And Opportunity as well and add values A,B,C,D,F Now 
    //***if we update an Opportunity with this multi select value Account should also update with same picklist values***
    //added opportunity object ==> Picklist_Opportunity__c
    //added Account object ===> Picklist_Account__c
    public static void AfterUpdateOpportunity(Map<id,opportunity> newOpportunity,Map<id,opportunity> oldOpportunity){
        List<Account> accounts = new List<Account>();
        Set<id> accountids =new Set<id>();
        for(opportunity opps : newOpportunity.values()){
                accountids.add(opps.AccountId);
        }
        Map<id,Account> queryAccount = new Map<id,Account>([SELECT id,Picklist_Account__c,Client_contact__c 
                                                            FROM Account 
                                                            WHERE (Picklist_Account__c= null or Picklist_Account__c != null) and id =: accountids ]);
        try{
            for(opportunity opp : newOpportunity.values()){
                accountids.add(opp.AccountId);
                if(newOpportunity.get(opp.id).Picklist_Opportunity__c != oldOpportunity.get(opp.id).Picklist_Opportunity__c){
                    system.debug('==> '+newOpportunity.get(opp.id).Picklist_Opportunity__c);
                    if(!queryAccount.Values().isEmpty() && queryAccount.Values().size() > 0){
                    for(Account acc : queryAccount.Values()){
                       system.debug('executing==> ');
                        acc.Picklist_Account__c = newOpportunity.get(opp.id).Picklist_Opportunity__c;
                        accounts.add(acc);
                       
                    }
                }
                }
                /**************
                 * Create a fields on Opportunity Client Contact, 
                 * Once an Opportunity client Contact update 
                 * then update Account client contact with same on Opportunity Client Contact
				***************/
                if(newOpportunity.get(opp.id).Client_contact__c != oldOpportunity.get(opp.id).Client_contact__c){
                    if(!queryAccount.Values().isEmpty() && queryAccount.Values().size() > 0){
                    for(Account acc : queryAccount.Values()){
                       system.debug('executing==> Client_contact__c');
                        acc.Client_contact__c = newOpportunity.get(opp.id).Client_contact__c;
                        accounts.add(acc);
                       
                    }
                    }
                }
                Update accounts;
            }
        }
        catch(Exception e){
            system.debug('exception Exc ==> '+e.getmessage());
            Exception_Log__c excp = new Exception_Log__c ();
            excp.message__c = e.getmessage();
            excp.Stack_Trace__c = e.getStackTraceString();
            insert excp;
        }
        
    }
  
}