public class OpportunityLineItemHandler {
    public static void createAsset(Map<id,OpportunityLineItem> newMapOpportunityLineItem){
        /****************
         * 2. Create an asset when creating an OpportunityLineItem with associated Account.
		************************/
        List<Asset> listAsset = new List<Asset>();
        id opportunityId;
         for(OpportunityLineItem item : newMapOpportunityLineItem.values()){
             opportunityId = item.OpportunityId;
         }
        List<OpportunityLineItem> listItems = [Select id,Opportunity.AccountId from OpportunityLineItem where OpportunityId =:opportunityId  ] ;
        for(OpportunityLineItem item : newMapOpportunityLineItem.values()){
            Asset asse = new asset();
            asse.AccountId = listItems[0].Opportunity.AccountId;
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