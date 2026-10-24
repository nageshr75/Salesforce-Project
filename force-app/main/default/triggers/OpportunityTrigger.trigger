Trigger OpportunityTrigger on Opportunity(after insert, after update){
    OpportunityTriggerHandler.recentOpportunityAmount(Trigger.new, Trigger.oldMap);
}