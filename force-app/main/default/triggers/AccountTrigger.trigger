trigger AccountTrigger on Account (before update,after update,before insert,before delete) {
    if(Trigger.isBefore && Trigger.isInsert || Trigger.isUpdate){
        AccountTriggerHandler.preventDuplicateAccountName(Trigger.new);
    }
    if(Trigger.isBefore && Trigger.isUpdate){
        AccountTriggerHandler.preventAccountModification(Trigger.new,Trigger.oldMap);
    }
    if(Trigger.isBefore && Trigger.isDelete){
        AccountTriggerHandler.preventAccountDeletion(Trigger.old);
    }
    if(Trigger.isafter && Trigger.isUpdate){
        AccountTriggerHandler.updateRelatedContact(Trigger.new,Trigger.oldMap);
        
    }
    if(Trigger.isAfter){
        if(Trigger.isInsert || Trigger.isUpdate){
            AccountTriggerHandler.createRelatedContacts(Trigger.new,Trigger.oldMap);
            
        }
    }
}