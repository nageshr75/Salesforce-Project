trigger ContactTrigger on Contact (Before insert,After insert,after update,after delete,after undelete) {
    {

    Set<Id> accountIds = new Set<Id>();

    if (Trigger.isInsert || Trigger.isUndelete) {

        for (Contact con : Trigger.new) {
            if (con.AccountId != null) {
                accountIds.add(con.AccountId);
            }
        }
    }

    if (Trigger.isDelete) {

        for (Contact con : Trigger.old) {
            if (con.AccountId != null) {
                accountIds.add(con.AccountId);
            }
        }
    }

    if (Trigger.isUpdate) {

    for (Contact con : Trigger.new) {

        Contact oldCon = Trigger.oldMap.get(con.Id);

        if (con.AccountId != oldCon.AccountId) {

            if (con.AccountId != null) {
                accountIds.add(con.AccountId);
            }

            if (oldCon.AccountId != null) {
                accountIds.add(oldCon.AccountId);
            }
        }
    }
}

    if (!accountIds.isEmpty()) {
        ContactTriggerHandler.updateNumberOfContacts(accountIds);
    }
}
    if(Trigger.isBefore){
        if(Trigger.isBefore && Trigger.isInsert){
            ContactTriggerHandler.preventDuplicateEmails(trigger.new);
        }
    }
}