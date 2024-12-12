public class OpportunityLineItemHandler {
    public static void createAsset(Map<id,OpportunityLineItem> newMapOpportunityLineItem){
        /****************
         * 2. Create an asset when creating an OpportunityLineItem with associated Account.
		************************/
        List<Asset> listAsset = new List<Asset>();
        id opportunityId;
        id opportunityLineitem;
         for(OpportunityLineItem item : newMapOpportunityLineItem.values()){
             opportunityId = item.OpportunityId;
             opportunityLineitem = item.id;
         }
    Map<id,OpportunityLineItem> MapIdOppItem =new map<id,OpportunityLineItem>([Select id,Opportunity.AccountId from OpportunityLineItem where OpportunityId =:opportunityId]) ;
       
        for(OpportunityLineItem item : newMapOpportunityLineItem.values()){
            Asset asse = new asset();
          asse.AccountId = MapIdOppItem.get(opportunityLineitem).Opportunity.AccountId;
            asse.Name = 'Test asset ';
            listAsset.add(asse);
        }
        try{
            insert listAsset;
        }catch(exception e){
            system.debug('exception  ==> '+e.getMessage());
        }
    }
}