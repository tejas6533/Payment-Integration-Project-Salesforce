trigger FraudLogTrigger on Transaction__c (after insert,after update) {
    
    List<Fraud_Log__c>fraudLogs = new List<Fraud_Log__c>();
    
    for(Transaction__c t:trigger.new){
        if(t.Risk_Level__c == 'High' || t.Risk_Level__c == 'Critical'){
            
            Fraud_Log__c log = new Fraud_Log__c();
            log.Transaction__c = t.Id;
            log.Reason__c = 'High value transaction detected';
            log.Severity__c = t.Risk_Level__c == 'Critical' ? 'High' : 'Medium';
            
            fraudLogs.add(log);
        }
    }
    
    if(!fraudLogs.isEmpty()){
        insert fraudLogs;
    }
}