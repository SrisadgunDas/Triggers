trigger UserTrigger on User (After Update) {
    if(Trigger.isUpdate && Trigger.isAfter){
        UserHandler.ContactsCount(Trigger.newMap,Trigger.oldMap);
    }
}