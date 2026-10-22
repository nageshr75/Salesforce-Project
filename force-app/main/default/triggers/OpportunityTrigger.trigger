trigger OpportunityTrigger on Opportunity (after insert, after update) {

    if (Trigger.isInsert) {
        OpportunityTriggerHandler.recentOpportunityAmount(Trigger.new, null);
    }

    if (Trigger.isUpdate) {
        OpportunityTriggerHandler.recentOpportunityAmount(
            Trigger.new,
            Trigger.oldMap
        );
    }
}