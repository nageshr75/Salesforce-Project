//Account Trigger Handler
public class AccountTriggerHandler {
    public static void preventDuplicateAccountName(List<Account> newList) {

    Set<String> accountNames = new Set<String>();

    // Get names from new Accounts
    for (Account acc : newList) {
        if (acc.Name != null) {
            accountNames.add(acc.Name.trim().toLowerCase());
        }
    }

    // Find existing Accounts
    Map<String, Id> existingAccounts = new Map<String, Id>();

    for (Account acc : [
        SELECT Id, Name
        FROM Account
        WHERE Name IN :accountNames
    ]) {
        existingAccounts.put(
            acc.Name.trim().toLowerCase(),
            acc.Id
        );
    }

    // Check duplicates
    Set<String> checkedNames = new Set<String>();

    for (Account acc : newList) {

        if (acc.Name == null) {
            continue;
        }

        String name = acc.Name.trim().toLowerCase();

        // Duplicate within same transaction
        if (checkedNames.contains(name)) {
            acc.addError(
                'Duplicate Account name. Please enter a unique name.'
            );
        }

        checkedNames.add(name);

        // Duplicate with existing Account
        if (existingAccounts.containsKey(name)) {

            Id existingAccountId = existingAccounts.get(name);

            // Make sure it is not the same Account
            if (existingAccountId != acc.Id) {
                acc.addError(
                    'Account name already exists. Please enter a unique name.'
                );
            }
        }
    }
}

        
    
    public static void preventAccountModification(List<Account> newList,Map<Id,Account> oldMap){
        for(Account acc: newList){
            System.debug('on line 4 of handler class');
            Account oldAcc = oldMap.get(acc.Id);
            System.debug('oldAcc.LastModifiedDate +1: '+oldAcc.LastModifiedDate.addHours(1));
            if(oldAcc.LastModifiedDate != null && oldAcc.LastModifiedDate.addHours(1) > System.now()){
                acc.addError('You can not modify account within 1 hour of last modification');
            }
        }
        
    }
    public static void preventAccountDeletion(List<Account> oldList){
        //collect ids to be deleted
        Set<Id> accIds = new Set<Id>();
        for(Account acc: oldList){
            accIds.add(acc.id);
        }
        System.debug('accIds: '+accIds);
        //create list based on Ids
        List<Account> accList = [SELECT Id,(SELECT Id,Name FROM Contacts) FROM Account WHERE Id IN: accIds];
        System.debug('accList: '+accList);
        //iterate over accList and get the related contacts size
        for(Account accTrigger: oldList){
			for(Account acc: accList){
            System.debug('acc.contacts.size(): '+acc.contacts.size());
            if(acc.contacts.size() >=1){
                accTrigger.addError('Can not delete the records.This accounts having associated contacts.......');
            }
        		}
            
        }
        
        
        
    }
    public static void updateRelatedContact(List<Account> newAccList,Map<Id,Account> accoldMap){
        //create a map of account on which phone is changed
        Map<Id,Account> accMap = new Map<Id,Account>();
        if(!newAccList.isEmpty()){
            for(Account acc:newAccList){
                Account oldValue = accoldMap.get(acc.id);
            if(acc.Phone!=oldValue.Phone){
                accMap.put(acc.Id,acc);
            }
        }
      }
      system.debug('accMap: '+accMap);
        
   
    
    //fetch the list of contact where id is in account map
    List<Contact> conList = [select Id,Phone,AccountId from Contact Where AccountId IN: accMap.keySet()];
    system.debug('conList:' +conList);
    List<Contact> conList1 = new List<Contact>();
    //update all phone field of related contact 
    for(Contact con : conList){
        con.Phone = accMap.get(con.AccountId).Phone;
        conList1.add(con);
        
    }
    if(!conList1.isEmpty()){
        update conList1;
        system.debug('conList1:' +conList1);
        
    }
    
}
    public static void createRelatedContacts(List<Account> newAccList, Map<Id,Account> oldMap){
        Set<Id> accId = new Set<Id>();
        for(Account acc: newAccList){
            accId.add(acc.Id);
        }
        //create list based on set
        List<Account> accList = [select id,ContactsToBeCreated__c from Account where Id IN :accId];
        
        //getting ready contacts
        List<Contact> conList = new List<Contact>();
        for(Account acc: accList){
            
        }
    }
    
}
