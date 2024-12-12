trigger opportunityTrigger on Opportunity (after update,after insert) {
    if(Trigger.isUpdate && Trigger.isAfter){
        OpportunityHandler.AfterUpdateOpportunity(Trigger.newMap,Trigger.oldMap);
    }else if(Trigger.isInsert && Trigger.isAfter){
        OpportunityHandler.CreateOpportunityLineItem(Trigger.new[0].id);
    }
}