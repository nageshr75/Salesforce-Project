public class OpportunityTriggerHandler {

    public static void recentOpportunityAmount(List<Opportunity> newOppList,Map<Id, Opportunity> oldMap) {

        Set<Id> accountIds = new Set<Id>();
        System.debug('newOppList: '+newOppList);
        System.debug('oldMap: '+oldMap);

        for (Opportunity opp : newOppList) {

            // Insert
            if (oldMap == null) {
                if (opp.AccountId != null) {
                    accountIds.add(opp.AccountId);
                }
            }
            // Update
            else {
                System.debug('in else block');
                Opportunity oldOpp = oldMap.get(opp.Id);

                if (opp.Amount != oldOpp.Amount &&
                    opp.AccountId != null) {

                    accountIds.add(opp.AccountId);
                }
            }
        }

        if (accountIds.isEmpty()) {
            return;
        }

        Map<Id, Account> accountsToUpdate = new Map<Id, Account>();

        List<Opportunity> oppList = [
            SELECT AccountId, Amount
            FROM Opportunity
            WHERE AccountId IN :accountIds
            ORDER BY CreatedDate ASC
        ];

        for (Opportunity opp : oppList) {
            accountsToUpdate.put(
                opp.AccountId,
                new Account(
                    Id = opp.AccountId,
                    RecentOpportunityAmount__c = opp.Amount
                )
            );
            System.debug('accountsToUpdate: '+accountsToUpdate);
        }

        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate.values();
        }
    }
}