public class OpportunityHandler {
    //Add a filed Multi select Pick list on Account And Opportunity as well and add values A,B,C,D,F Now 
    //***if we update an Opportunity with this multi select value Account should also update with same picklist values***
    //added opportunity object ==> Picklist_Opportunity__c
    //added Account object ===> Picklist_Account__c
    public static void AfterUpdateOpportunity(Map<id,opportunity> newOpportunity,Map<id,opportunity> oldOpportunity){
        List<Account> accounts = new List<Account>();
        Set<id> accountids =new Set<id>();
        Set<id> opportunityIds =new Set<id>();
        
        for(opportunity opps : newOpportunity.values()){
            accountids.add(opps.AccountId);
            opportunityIds.add(opps.Id);
        }
        Map<id,Account> queryAccount = new Map<id,Account>([SELECT id,Picklist_Account__c,Client_contact__c,Total_Products_qun__c  
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
                if(newOpportunity.get(opp.id).NextStep != oldOpportunity.get(opp.id).NextStep){
                    accounts = queryCollected(opportunityIds,queryAccount.Values());
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
    /**************
* Collect All Line Item Quantities and 
* Populate the total on Account Level (Total Quantity)
**********************/
    public static List<Account> queryCollected(set<id> opportunityIds,List<Account> Accounts){
        List<Account> ListAccount =new List<Account>();
        decimal totalquanties = 0.0;
        List<opportunity>  query = [SELECT id,
                                    (SELECT quantity from OpportunityLineItems) 
                                    FROM Opportunity 
                                    WHERE id =: opportunityIds ];
        if((!query.isEmpty() && query.size() > 0) && (!Accounts.isEmpty() && Accounts.size() > 0)){
            
            for(opportunity opp : query){
                for(OpportunityLineItem item : opp.OpportunityLineItems){
                    totalquanties =    totalquanties + item.Quantity;
                }
                
            }
            for(Account acc : Accounts){
                acc.Total_Products_qun__c = totalquanties;
                ListAccount.add(acc);
                
            }
            
        }
        return ListAccount;
    }
    /***************
     * Write a trigger on Opportunity, when an Opportunity will be insert an Opportunity Line Item 
     * should be insert by default with any of the Product associated with Opportunity. 
	*****************************/
    public static void CreateOpportunityLineItem(id opportunityID){
       List<PricebookEntry> priceBook = [SELECT
                                         Id, Product2Id  
                                         FROM PricebookEntry 
                                         WHERE Name = 'GenWatt Diesel 200kW' 
                                         LIMIT 1];
       id PriceBookEntryId =  priceBook[0].id;
        id Product2Id = priceBook[0].Product2Id;
        OpportunityLineItem newObj = new OpportunityLineItem();
        newObj.OpportunityId  = opportunityID;
        newobj.PricebookEntryId = PriceBookEntryId;
        newobj.Product2Id  = Product2Id;
        newobj.Quantity  = 2;
        newobj.UnitPrice = 2000;
        try{
            insert newobj;
        }catch(exception e){
            system.debug('e===> '+e.getmessage());
        }
    }
    
    
    
    
    
    
}