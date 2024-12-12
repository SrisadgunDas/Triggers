trigger OpportunityLineItemTrigger on OpportunityLineItem (after insert) {
    if(Trigger.isInsert && Trigger.isAfter){
        OpportunityLineItemHandler.createAsset(Trigger.newMap);
    }
}