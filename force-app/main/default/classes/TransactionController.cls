public with sharing class TransactionController {

    // Create Transaction
    @AuraEnabled
    public static String createTransaction(
        Decimal amount,
        String receiver
    ) {
        try {

            Transaction__c tr = new Transaction__c(
                Amount__c = amount,
                Receive__c = receiver,
                Status__c = 'Draft',
                Payment_Status__c = 'Pending'
            );

            insert tr;

            return 'Transaction Created Successfully';

        } catch(Exception e) {

            throw new AuraHandledException(e.getMessage());
        }
    }


    // Get All Transactions
    @AuraEnabled(cacheable=true)
    public static List<Transaction__c> getTransactions() {

        return [
            SELECT Id,
                   Name,
                   Amount__c,
                   Receive__c,
                   Status__c,
                   Risk_Level__c,
                   Payment_Status__c,
                   CreatedDate
            FROM Transaction__c
            ORDER BY CreatedDate DESC
        ];
    }


    // Approve Transaction
    @AuraEnabled
    public static String approveTransaction(Id transactionId) {

        try {

            Transaction__c tr = [
                SELECT Id,
                       Status__c
                FROM Transaction__c
                WHERE Id = :transactionId
                LIMIT 1
            ];

            tr.Status__c = 'Approved';

            update tr;

            return 'Transaction Approved';

        } catch(Exception e) {

            throw new AuraHandledException(e.getMessage());
        }
    }


    // Reject Transaction
    @AuraEnabled
    public static String rejectTransaction(Id transactionId) {

        try {

            Transaction__c tr = [
                SELECT Id,
                       Status__c
                FROM Transaction__c
                WHERE Id = :transactionId
                LIMIT 1
            ];

            tr.Status__c = 'Rejected';

            update tr;

            return 'Transaction Rejected';

        } catch(Exception e) {

            throw new AuraHandledException(e.getMessage());
        }
    }


    // Process Payment
    @AuraEnabled
    public static String processPayment(Id transactionId) {

        try {

            Transaction__c tr = [
                SELECT Id,
                       Status__c,
                       Payment_Status__c
                FROM Transaction__c
                WHERE Id = :transactionId
                LIMIT 1
            ];

            if(tr.Status__c != 'Approved') {

                return 'Transaction must be approved first';
            }

            tr.Payment_Status__c = 'Success';
            tr.Status__c = 'Paid';

            update tr;

            return 'Payment Processed Successfully';

        } catch(Exception e) {

            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
public static List<Transaction__c> getPendingTransactions() {

    return [
        SELECT Id,
               Name,
               Amount__c,
               Receive__c,
               Risk_Level__c,
               Status__c
        FROM Transaction__c
        WHERE Status__c = 'Pending'
        ORDER BY CreatedDate DESC
    ];
}

@AuraEnabled(cacheable=true)
public static Map<String, Integer> getDashboardStats() {

    Map<String, Integer> stats = new Map<String, Integer>();

    stats.put(
        'total',
        [SELECT Count() FROM Transaction__c]
    );

    stats.put(
        'pending',
        [SELECT Count() FROM Transaction__c
         WHERE Status__c = 'Pending']
    );

    stats.put(
        'approved',
        [SELECT Count() FROM Transaction__c
         WHERE Status__c = 'Approved']
    );

    stats.put(
        'paid',
        [SELECT Count() FROM Transaction__c
         WHERE Status__c = 'Paid']
    );

    return stats;
}
}