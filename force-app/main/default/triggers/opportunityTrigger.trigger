trigger opportunityTrigger on Opportunity (after update) {
    if(Trigger.isUpdate && Trigger.isAfter){
        OpportunityHandler.AfterUpdateOpportunity(Trigger.newMap,Trigger.oldMap);
    }
}