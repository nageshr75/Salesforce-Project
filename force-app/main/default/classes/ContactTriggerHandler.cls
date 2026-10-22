public class ContactTriggerHandler {
    public static void updateNumberOfContacts(Set<Id> accountIds) {
        System.debug('accountIds: '+accountIds);
        // 1. Guard clause: Stop immediately if the set is null or empty
        if (accountIds == null || accountIds.isEmpty()) {
            return;
        }

        // 2. Track all accounts that need an update. 
        // We initialize them with a count of 0 to catch accounts whose last contact was deleted.
        Map<Id, Account> accountsToUpdate = new Map<Id, Account>();
        for (Id accId : accountIds) {
            accountsToUpdate.put(accId, new Account(Id = accId, Number_of_Contacts__c = 0));
        }
        System.debug('accountsToUpdate: '+accountsToUpdate);

        // 3. Aggregate query using a SOQL For-Loop to save heap memory
        for (AggregateResult ar : [SELECT AccountId accId, COUNT(Id) totalCons 
                                  FROM Contact 
                                  WHERE AccountId IN :accountIds 
                                  GROUP BY AccountId]) {
            
            Id accountId = (Id) ar.get('accId');
            Integer totalContacts = (Integer) ar.get('totalCons');
            
            // 4. Overwrite the default 0 with the actual database count
            accountsToUpdate.put(accountId, new Account(
                Id = accountId, 
                Number_of_Contacts__c = totalContacts
            ));
        }
        System.debug('accountsToUpdate on line 32: '+accountsToUpdate);

        // 5. Fire a single, secure DML operation
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate.values();
        }
    }
    public static void preventDuplicateEmails(List<Contact> newCon){
        //collect all the new emails in a set
        Set<String> emailSet = new Set<String>();
            for(Contact con: newCon){
                if(String.isNotBlank(con.Email)){
                    emailSet.add(con.email);
                }
             }
        if(emailSet.isEmpty()){
            return;
        }
        //create list of contacts based on set
        List<Contact> conList = [SELECT id,email from Contact WHERE email IN: emailSet];
        System.debug('conList: '+conList);
        //create Map based on list
        //Map<String,Contact> conMap = new Map<String,Contact>();
        Set<String> finalEmailSet = new Set<String>();
        for(Contact con: conList){
            //conMap.put(con.email,con);
            finalEmailSet.add(con.Email);
        }
        System.debug('finalEmailSet: '+finalEmailSet);
        
        
        //validate list against all new contacts which are going to be inserted
        for(Contact con: newCon){
            if(finalEmailSet.contains(con.Email)){
                con.addError('This email id already associated with existing contact.');
            }
        }
        
        
    }

}