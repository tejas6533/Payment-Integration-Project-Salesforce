public class TransactionTriggerHandler {

    // Risk Level Logic
    public static void setRiskLevel(List<Transaction__c> transactions){

        for(Transaction__c t : transactions){

            if(t.Amount__c >= 100000){
                t.Risk_Level__c = 'Critical';
            }
            else if(t.Amount__c >= 50000){
                t.Risk_Level__c = 'High';
            }
            else if(t.Amount__c >= 10000){
                t.Risk_Level__c = 'Medium';
            }
            else{
                t.Risk_Level__c = 'Low';
            }
        }
    }

    // Fraud Log Creation
    public static void createFraudLogs(List<Transaction__c> transactions){

        List<Fraud_Log__c> fraudLogs = new List<Fraud_Log__c>();

        for(Transaction__c t : transactions){

            if(t.Risk_Level__c == 'High' ||
               t.Risk_Level__c == 'Critical'){

                Fraud_Log__c log = new Fraud_Log__c();

                log.Transaction__c = t.Id;
                log.Reason__c = 'High value transaction detected';

                if(t.Risk_Level__c == 'Critical'){
                    log.Severity__c = 'High';
                }
                else{
                    log.Severity__c = 'Medium';
                }

                fraudLogs.add(log);
            }
        }

        if(!fraudLogs.isEmpty()){
            insert fraudLogs;
        }
    }

    // Audit Log Creation
    public static void createAuditLogs(
        List<Transaction__c> newTransactions,
        Map<Id, Transaction__c> oldMap,
        Boolean isInsert
    ){

        List<Audit_Log__c> auditLogs = new List<Audit_Log__c>();

        for(Transaction__c t : newTransactions){

            Audit_Log__c log = new Audit_Log__c();

            log.User__c = UserInfo.getUserId();
            log.Transaction__c = t.Id;
            log.Timestamp__c = System.now();

            if(isInsert){

                log.Action__c = 'Created Transaction';

            }else{

                Transaction__c oldRecord = oldMap.get(t.Id);

                if(oldRecord.Status__c != t.Status__c){

                    if(t.Status__c == 'Approved'){
                        log.Action__c = 'Approved Transaction';
                    }
                    else if(t.Status__c == 'Rejected'){
                        log.Action__c = 'Rejected Transaction';
                    }
                    else if(t.Status__c == 'Paid'){
                        log.Action__c = 'Triggered Payment';
                    }
                    else{
                        log.Action__c = 'Updated Transaction';
                    }

                }else{

                    log.Action__c = 'Updated Transaction';
                }
            }

            auditLogs.add(log);
        }

        if(!auditLogs.isEmpty()){
            insert auditLogs;
        }
    }
}