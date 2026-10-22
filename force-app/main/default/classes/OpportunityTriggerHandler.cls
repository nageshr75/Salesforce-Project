public class OpportunityTriggerHandler {

    public static void recentOpportunityAmount(List<Opportunity> newOppList,Map<Id, Opportunity> oldMap) {

        Set<Id> accountIds = new Set<Id>();

        for (Opportunity opp : newOppList) {

            // Insert
            if (oldMap == null) {
                if (opp.AccountId != null) {
                    accountIds.add(opp.AccountId);
                }
            }
            // Update
            else {
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
        }

        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate.values();
        }
    }
}