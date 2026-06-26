trigger TransactionTrigger on Transaction__c (
    before insert,
    before update,
    after insert,
    after update
) {

    if(Trigger.isBefore){

        if(Trigger.isInsert || Trigger.isUpdate){
            TransactionTriggerHandler.setRiskLevel(Trigger.new);
        }
    }

    if(Trigger.isAfter){

        if(Trigger.isInsert){

            TransactionTriggerHandler.createFraudLogs(
                Trigger.new
            );

            TransactionTriggerHandler.createAuditLogs(
                Trigger.new,
                null,
                true
            );
        }

        if(Trigger.isUpdate){

            TransactionTriggerHandler.createAuditLogs(
                Trigger.new,
                Trigger.oldMap,
                false
            );
        }
    }
}