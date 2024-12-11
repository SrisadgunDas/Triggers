trigger AccountTrigger on Account (before insert) {
    if(Trigger.isInsert && Trigger.isBefore){
        system.debug('just Checking Trigger');
    }
}